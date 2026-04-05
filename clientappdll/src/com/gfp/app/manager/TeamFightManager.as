package com.gfp.app.manager
{
   import com.gfp.app.fight.CustomDataEvent;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.info.SummonInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class TeamFightManager extends EventDispatcher
   {
      
      private static var _instance:TeamFightManager;
      
      public static const QUICK_ENTER_TRUE:uint = 0;
      
      public static const QUICK_ENTER_FALSE:uint = 1;
      
      private var _stageID:uint;
      
      private var _difficult:uint;
      
      private var _roomId:uint;
      
      private var _teamNum:uint;
      
      private var _users:Vector.<UserInfo>;
      
      private var _prepareUsers:Vector.<int>;
      
      private var _inviteIds:Vector.<int>;
      
      public function TeamFightManager()
      {
         super();
      }
      
      public static function getInstance() : TeamFightManager
      {
         if(_instance == null)
         {
            _instance = new TeamFightManager();
         }
         return _instance;
      }
      
      public static function setup() : void
      {
      }
      
      public function sendInviteRequest(param1:int) : void
      {
         if(this._inviteIds == null)
         {
            this._inviteIds = new Vector.<int>();
         }
         this._inviteIds.push(param1);
         SocketConnection.send(CommandID.TEAM_INVITE_FRIEND,1,param1,this._roomId,this._stageID,this._difficult);
      }
      
      public function isUserInvited(param1:int) : Boolean
      {
         if(Boolean(this._inviteIds) && this._inviteIds.indexOf(param1) != -1)
         {
            return true;
         }
         return false;
      }
      
      public function quickEnter(param1:int, param2:int, param3:int) : void
      {
         this._stageID = param1;
         this._difficult = param2;
         this._teamNum = param3;
         SocketConnection.addCmdListener(CommandID.TEAM_QUICK_JOIN,this.onQuickJoinRoom);
         SocketConnection.send(CommandID.TEAM_QUICK_JOIN,this._stageID,this._difficult);
      }
      
      public function friendJoin(param1:int, param2:int, param3:int) : void
      {
         this._stageID = param1;
         this._difficult = param2;
         this._teamNum = param3;
         this.createRoom(false);
      }
      
      private function onQuickJoinRoom(param1:SocketEvent) : void
      {
         this.join(param1.data as ByteArray);
         SocketConnection.send(CommandID.TEAM_READY);
      }
      
      private function addUser(param1:UserInfo) : void
      {
         this._users.push(param1);
         dispatchEvent(new CustomDataEvent(CustomDataEvent.ROOM_USER_ADD,false,false,param1));
      }
      
      public function join(param1:ByteArray) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:UserInfo = null;
         var _loc6_:uint = 0;
         var _loc7_:SummonInfo = null;
         param1.position = 0;
         var _loc2_:int = int(param1.readUnsignedInt());
         if(_loc2_ == 0)
         {
            this.createRoom(true);
         }
         else
         {
            FightManager.isTeamFight = true;
            this.initRoom();
            this._roomId = _loc2_;
            this._stageID = param1.readUnsignedInt();
            this._difficult = param1.readUnsignedInt();
            _loc3_ = param1.readUnsignedInt();
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = UserInfoManager.creatInfo();
               UserInfo.setForStageInfo(_loc5_,param1);
               _loc5_.serverID = MainManager.serverID;
               _loc6_ = param1.readUnsignedShort();
               if(_loc6_ == 1)
               {
                  _loc7_ = new SummonInfo();
                  _loc7_.readForStage(param1);
                  SummonManager.setupForStage(_loc5_.userID,_loc7_);
               }
               if(_loc4_ == 0)
               {
                  MainManager.leaderID = _loc5_.userID;
               }
               this.addUser(_loc5_);
               this._prepareUsers.push(_loc5_.userID);
               _loc4_++;
            }
            this.addUser(MainManager.actorInfo);
            this._prepareUsers.push(MainManager.actorInfo.userID);
            this.checkNeedToStart();
         }
      }
      
      private function checkNeedToStart() : void
      {
         if(this._prepareUsers.length == this._teamNum)
         {
            PveEntry.enterTollgateTeam(this._stageID,this._difficult);
            this.destoryRoom();
         }
      }
      
      private function createRoom(param1:Boolean) : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_CREATE_ROOM,this.onCreateRoom);
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUnsignedInt(this._stageID);
         _loc2_.writeUnsignedInt(this._difficult);
         _loc2_.writeUnsignedInt(this._teamNum);
         _loc2_.writeUnsignedInt(param1 ? QUICK_ENTER_TRUE : QUICK_ENTER_FALSE);
         SocketConnection.send(CommandID.TEAM_CREATE_ROOM,_loc2_);
      }
      
      private function onCreateRoom(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TEAM_CREATE_ROOM,this.onCreateRoom);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         this._roomId = _loc2_.readUnsignedInt();
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         MainManager.leaderID = MainManager.actorID;
         this.initRoom();
         this.addUser(MainManager.actorInfo);
         this._prepareUsers.push(MainManager.actorInfo.userID);
      }
      
      private function initRoom() : void
      {
         this._users = new Vector.<UserInfo>();
         this._prepareUsers = new Vector.<int>();
         this._inviteIds = new Vector.<int>();
         SocketConnection.addCmdListener(CommandID.TEAM_ENTER_TOOM,this.onTeamEnterRoom);
         SocketConnection.addCmdListener(CommandID.TEAM_SETOUT,this.onTeamSetOut);
         SocketConnection.addCmdListener(CommandID.TEAM_MEMBER_LEAVE,this.onTeamLeaveRoom);
      }
      
      public function destoryRoom() : void
      {
         SocketConnection.removeCmdListener(CommandID.TEAM_ENTER_TOOM,this.onTeamEnterRoom);
         SocketConnection.removeCmdListener(CommandID.TEAM_SETOUT,this.onTeamSetOut);
         SocketConnection.removeCmdListener(CommandID.TEAM_MEMBER_LEAVE,this.onTeamLeaveRoom);
         MainManager.leaderID = 0;
         this._roomId = 0;
         this._stageID = 0;
         this._difficult = 0;
         this._teamNum = 0;
         this._users = null;
         this._prepareUsers = null;
         this._inviteIds = null;
      }
      
      private function onTeamEnterRoom(param1:SocketEvent) : void
      {
         var _loc5_:SummonInfo = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
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
         this.addUser(_loc3_);
      }
      
      private function onTeamLeaveRoom(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         this.removeUser(_loc3_);
         if(this._users.length == 0 || MainManager.leaderID == _loc3_)
         {
            if(MainManager.leaderID == _loc3_)
            {
               TextAlert.show("队长离开队伍，队伍解散。");
               dispatchEvent(new CustomDataEvent(CustomDataEvent.ROOM_LEADER_LEAVE,false,false,_loc3_));
            }
            this.destoryRoom();
            FightManager.isTeamFight = false;
         }
      }
      
      private function removeUser(param1:int) : void
      {
         var _loc4_:UserInfo = null;
         var _loc2_:* = int(this._users.length);
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._users[_loc3_];
            if(_loc4_.userID == param1)
            {
               _loc3_--;
               _loc2_--;
               this._users.splice(_loc3_,1);
               dispatchEvent(new CustomDataEvent(CustomDataEvent.ROOM_USER_REMOVE,false,false,_loc4_));
               break;
            }
            _loc3_++;
         }
         this.removePrepareUser(param1);
      }
      
      private function removePrepareUser(param1:int) : void
      {
         var _loc2_:int = this._prepareUsers.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._prepareUsers.splice(_loc2_,1);
         }
      }
      
      private function onTeamSetOut(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         if(_loc4_ == 0)
         {
            this._prepareUsers.push(_loc3_);
         }
         else if(_loc4_ == 1)
         {
            this.removePrepareUser(_loc3_);
         }
         if(this._prepareUsers.length >= this._teamNum)
         {
            FightManager.isTeamFight = true;
            PveEntry.enterTollgateTeam(this._stageID,this._difficult);
            if(MainManager.isLeader)
            {
               SocketConnection.send(CommandID.TEAM_START_FIGHT);
            }
            this.destoryRoom();
         }
      }
      
      public function get roomId() : uint
      {
         return this._roomId;
      }
      
      public function set roomId(param1:uint) : void
      {
         this._roomId = param1;
      }
      
      public function get users() : Vector.<UserInfo>
      {
         return this._users;
      }
   }
}

