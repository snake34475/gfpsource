package com.gfp.app.manager
{
   import com.gfp.app.fight.CustomDataEvent;
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.SocketSendController;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.FightMode;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class TeamPvp3PeopleFightManager extends EventDispatcher
   {
      
      private static var _instance:TeamPvp3PeopleFightManager;
      
      private var _team1:Vector.<UserInfo>;
      
      private var _team2:Vector.<UserInfo>;
      
      private var _teams:Vector.<Vector.<UserInfo>>;
      
      private var _isStart:Boolean;
      
      public function TeamPvp3PeopleFightManager()
      {
         super();
      }
      
      public static function getInstance() : TeamPvp3PeopleFightManager
      {
         if(_instance == null)
         {
            _instance = new TeamPvp3PeopleFightManager();
         }
         return _instance;
      }
      
      private function init() : void
      {
         this._isStart = true;
         this._teams = new Vector.<Vector.<UserInfo>>();
         this._team1 = new Vector.<UserInfo>();
         this._team2 = new Vector.<UserInfo>();
         this._teams.push(this._team1);
         this._teams.push(this._team2);
         this.addEvent();
      }
      
      public function startRandomJoin(param1:int = 63) : void
      {
         if(!this._isStart)
         {
            this.init();
            FightManager.fightMode = FightMode.PVP;
            SocketSendController.sendPvpInviteCMD(false,param1,0,0);
         }
      }
      
      public function cancelFight() : void
      {
         if(this._isStart)
         {
            SocketConnection.send(CommandID.FIGHT_CANCEL);
         }
      }
      
      private function addUser(param1:UserInfo, param2:int) : void
      {
         if(param1.userID == MainManager.actorInfo.userID)
         {
            this._teams[param2].unshift(MainManager.actorInfo);
         }
         else
         {
            this._teams[param2].push(param1);
         }
      }
      
      private function removeUser(param1:UserInfo, param2:int) : void
      {
         this.removeUserById(param1.userID,param2);
      }
      
      private function checkToDestory() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Vector.<UserInfo> = null;
         if(this._teams)
         {
            for each(_loc2_ in this._teams)
            {
               if(_loc2_.length > 0)
               {
                  _loc1_ = true;
                  break;
               }
            }
            if(!_loc1_)
            {
               this.destory();
            }
         }
      }
      
      private function removeUserById(param1:int, param2:int) : void
      {
         var _loc6_:UserInfo = null;
         var _loc3_:Vector.<UserInfo> = this._teams[param2];
         var _loc4_:* = int(_loc3_.length);
         var _loc5_:* = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            if(_loc6_.userID == param1)
            {
               _loc5_--;
               _loc4_--;
               _loc3_.splice(_loc5_,1);
               dispatchEvent(new CustomDataEvent(CustomDataEvent.ROOM_PVP_USER_REMOVE,false,false,{
                  "teamId":param2,
                  "info":_loc6_
               }));
            }
            _loc5_++;
         }
         this.checkToDestory();
      }
      
      public function destory() : void
      {
         MainManager.openOperate();
         this.removeEvent();
         this._teams = null;
         this._team1 = null;
         this._team2 = null;
         this._isStart = false;
      }
      
      private function onEnterInvite(param1:SocketEvent) : void
      {
         MainManager.closeOperate();
         MainManager.actorModel.execStandAction();
      }
      
      private function onUserEnter(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:Object = this.readATeamUser(_loc2_);
         dispatchEvent(new CustomDataEvent(CustomDataEvent.ROOM_PVP_USER_ADD,false,false,_loc3_));
      }
      
      private function readATeamUser(param1:ByteArray) : Object
      {
         var _loc2_:UserInfo = new UserInfo();
         _loc2_.userID = param1.readUnsignedInt();
         _loc2_.createTime = param1.readUnsignedInt();
         _loc2_.roleType = param1.readUnsignedInt();
         var _loc3_:int = param1.readByte();
         _loc2_.nick = param1.readUTFBytes(16);
         this.addUser(_loc2_,_loc3_ - 1);
         return {
            "teamId":_loc3_ - 1,
            "info":_loc2_
         };
      }
      
      private function onMultiUserJoin(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            this.readATeamUser(_loc2_);
            _loc4_++;
         }
         dispatchEvent(new CustomDataEvent(CustomDataEvent.ROOM_MULTI_PVP_USER_ADD,false,false,null));
      }
      
      private function addEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.FIGHT_ENTER,this.onEnterInvite);
         SocketConnection.addCmdListener(CommandID.PVP_TEAM_JOIN,this.onUserEnter);
         SocketConnection.addCmdListener(CommandID.PVP_MULTI_TEAM_JOIN,this.onMultiUserJoin);
         SocketConnection.addCmdListener(CommandID.TEAM_MEMBER_LEAVE,this.onTeamLeaveRoom);
      }
      
      private function removeEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.FIGHT_ENTER,this.onEnterInvite);
         SocketConnection.removeCmdListener(CommandID.PVP_TEAM_JOIN,this.onUserEnter);
         SocketConnection.removeCmdListener(CommandID.PVP_MULTI_TEAM_JOIN,this.onMultiUserJoin);
         SocketConnection.removeCmdListener(CommandID.TEAM_MEMBER_LEAVE,this.onTeamLeaveRoom);
      }
      
      private function onTeamLeaveRoom(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = this.getUserTeamId(_loc3_);
         if(_loc4_ >= 0)
         {
            this.removeUserById(_loc3_,_loc4_);
         }
      }
      
      private function getUserTeamId(param1:int) : int
      {
         var _loc4_:Vector.<UserInfo> = null;
         var _loc5_:UserInfo = null;
         var _loc2_:int = int(this._teams.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._teams[_loc3_];
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_.userID == param1)
               {
                  return _loc3_;
               }
            }
            _loc3_++;
         }
         return -1;
      }
      
      public function get teams() : Vector.<Vector.<UserInfo>>
      {
         return this._teams;
      }
      
      public function set teams(param1:Vector.<Vector.<UserInfo>>) : void
      {
         this._teams = param1;
      }
      
      public function getMyTeamId() : int
      {
         return this.getUserTeamId(MainManager.actorID);
      }
   }
}

