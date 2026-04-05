package com.gfp.app.manager
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.CommEvent;
   import com.gfp.core.info.FriendInviteInfo;
   import com.gfp.core.info.GroupUserInfo;
   import com.gfp.core.info.SummonInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.net.SocketConnection;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class TeamAutoFightManager
   {
      
      private static var _instance:TeamAutoFightManager;
      
      public static const MEMBER_LEAVE_PVE:String = "member_leave_pve";
      
      private var _stageID:uint;
      
      private var _difficult:uint;
      
      private var _roomID:uint;
      
      private var _teamNum:uint;
      
      private var _pvpAutoType:uint;
      
      private var _ed:EventDispatcher;
      
      public function TeamAutoFightManager()
      {
         super();
      }
      
      public static function get instance() : TeamAutoFightManager
      {
         if(_instance == null)
         {
            _instance = new TeamAutoFightManager();
         }
         return _instance;
      }
      
      public static function addEventListener(param1:String, param2:Function) : void
      {
         instance.addEventListener(param1,param2);
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void
      {
         instance.removeEventListener(param1,param2);
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
         }
         _instance = null;
      }
      
      public function signPVE(param1:uint, param2:uint = 1, param3:uint = 2) : void
      {
         this._stageID = param1;
         this._difficult = param2;
         this._teamNum = param3;
         SocketConnection.addCmdListener(CommandID.TEAM_CREATE_ROOM,this.onCreateRoom);
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeUnsignedInt(this._stageID);
         _loc4_.writeUnsignedInt(this._difficult);
         _loc4_.writeUnsignedInt(param3);
         _loc4_.writeUnsignedInt(1);
         SocketConnection.send(CommandID.TEAM_CREATE_ROOM,_loc4_);
      }
      
      private function onCreateRoom(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TEAM_CREATE_ROOM,this.onCreateRoom);
         SocketConnection.addCmdListener(CommandID.TEAM_ENTER_TOOM,this.onTeamEnterRoom);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         this._roomID = _loc2_.readUnsignedInt();
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         MainManager.leaderID = MainManager.actorID;
         SocketConnection.send(CommandID.TEAM_INVITE_FRIEND,FriendInviteInfo.GROUP_QUICK_PVE,this.getAnotherUserID(),this._roomID,this._stageID,this._difficult);
      }
      
      private function getAnotherUserID() : uint
      {
         var _loc4_:uint = 0;
         var _loc1_:Vector.<GroupUserInfo> = FightGroupManager.instance.groupUserList;
         var _loc2_:uint = _loc1_.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = uint(_loc1_[_loc3_].userInfo.userID);
            if(_loc4_ != MainManager.actorID)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return 0;
      }
      
      private function onTeamEnterRoom(param1:SocketEvent) : void
      {
         var _loc5_:SummonInfo = null;
         SocketConnection.removeCmdListener(CommandID.TEAM_ENTER_TOOM,this.onTeamEnterRoom);
         SocketConnection.addCmdListener(CommandID.TEAM_SETOUT,this.onTeamSetOut);
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:UserInfo = UserInfoManager.creatInfo();
         UserInfo.setForStageInfo(_loc3_,_loc2_,true);
         _loc3_.serverID = MainManager.serverID;
         var _loc4_:uint = _loc2_.readUnsignedShort();
         if(_loc4_ == 1)
         {
            _loc5_ = new SummonInfo();
            _loc5_.readForStage(_loc2_);
            SummonManager.setupForStage(_loc3_.userID,_loc5_);
         }
      }
      
      private function onTeamSetOut(param1:SocketEvent) : void
      {
         if(MainManager.isLeader)
         {
            SocketConnection.removeCmdListener(CommandID.TEAM_SETOUT,this.onTeamSetOut);
            FightManager.isTeamFight = true;
            PveEntry.enterTollgateTeam(this._stageID,this._difficult);
            SocketConnection.send(CommandID.TEAM_START_FIGHT);
            this._roomID = 0;
         }
      }
      
      private function removePveEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.TEAM_CREATE_ROOM,this.onCreateRoom);
         SocketConnection.removeCmdListener(CommandID.TEAM_ENTER_TOOM,this.onTeamEnterRoom);
         SocketConnection.removeCmdListener(CommandID.TEAM_SETOUT,this.onTeamSetOut);
      }
      
      public function get roomID() : uint
      {
         return this._roomID;
      }
      
      public function set roomID(param1:uint) : void
      {
         if(this._roomID == param1)
         {
            return;
         }
         this._roomID = param1;
         if(this._roomID == 0)
         {
            this.removePveEvent();
            SocketConnection.send(CommandID.TEAM_QUIT);
            this.dispatchEvent(new Event(MEMBER_LEAVE_PVE));
         }
      }
      
      public function signPVP(param1:uint = 40) : void
      {
         this._pvpAutoType = param1;
         FightGroupManager.instance.groupSignUp(this._pvpAutoType);
         FightGroupManager.instance.ed.addEventListener(FightGroupManager.FIGHT_GROUP_WAIT_UPDATE,this.groupWaitUpdateHandler);
      }
      
      private function groupWaitUpdateHandler(param1:CommEvent) : void
      {
         if(FightGroupManager.instance.pvpTypeIndex == this._pvpAutoType)
         {
            if(FightGroupManager.instance.allMemberIsReady())
            {
               FightGroupManager.instance.ed.removeEventListener(FightGroupManager.FIGHT_GROUP_WAIT_UPDATE,this.groupWaitUpdateHandler);
               FightGroupManager.instance.matchGroupFight();
            }
            else
            {
               AlertManager.showSimpleAlarm("小侠士，你的队员没有满足2v2条件。");
            }
            this._pvpAutoType = 0;
         }
      }
      
      private function removePvpEvent() : void
      {
         FightGroupManager.instance.ed.removeEventListener(FightGroupManager.FIGHT_GROUP_WAIT_UPDATE,this.groupWaitUpdateHandler);
      }
      
      public function get pvpAutoType() : uint
      {
         return this._pvpAutoType;
      }
      
      public function set pvpAutoType(param1:uint) : void
      {
         if(this._pvpAutoType == param1)
         {
            return;
         }
         this._pvpAutoType = param1;
         if(this._pvpAutoType == 0)
         {
            this.removePvpEvent();
         }
      }
      
      public function dispatchEvent(param1:Event) : void
      {
         this.ed.dispatchEvent(param1);
      }
      
      public function addEventListener(param1:String, param2:Function) : void
      {
         this.ed.addEventListener(param1,param2);
      }
      
      public function removeEventListener(param1:String, param2:Function) : void
      {
         this.ed.removeEventListener(param1,param2);
      }
      
      private function get ed() : EventDispatcher
      {
         if(this._ed == null)
         {
            this._ed = new EventDispatcher();
         }
         return this._ed;
      }
      
      public function destroy() : void
      {
      }
   }
}

