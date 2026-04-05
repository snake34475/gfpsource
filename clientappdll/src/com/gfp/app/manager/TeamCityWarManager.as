package com.gfp.app.manager
{
   import com.gfp.app.cityWar.CityWarType;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.CommEvent;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MessageManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.TeamsRelationManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class TeamCityWarManager
   {
      
      private static var _instance:TeamCityWarManager;
      
      public static const TEAM_FIGHT_WAIT_UPDATE:String = "TEAM_WAIT_UPDATE_";
      
      public static const TEAM_FIGHT_WAIT_DESTORY:String = "TEAM_WAIT_DESTORY";
      
      private var _ed:EventDispatcher;
      
      private var _pvpTypeIndex:uint;
      
      private var _itemID:uint;
      
      private var _senderID:uint;
      
      private var _isReady:Boolean;
      
      private var _readyList:Array;
      
      public function TeamCityWarManager()
      {
         super();
      }
      
      public static function get instance() : TeamCityWarManager
      {
         if(_instance == null)
         {
            _instance = new TeamCityWarManager();
         }
         return _instance;
      }
      
      public static function addUserEventListner(param1:String, param2:uint, param3:Function) : void
      {
         addEventListner(param1 + param2.toString(),param3);
      }
      
      public static function removeUserEventListner(param1:String, param2:uint, param3:Function) : void
      {
         removeEventListner(param1 + param2.toString(),param3);
      }
      
      public static function addEventListner(param1:String, param2:Function) : void
      {
         instance.addEventListner(param1,param2);
      }
      
      public static function dispatchEvent(param1:Event) : void
      {
         instance.dispatchEvent(param1);
      }
      
      public static function removeEventListner(param1:String, param2:Function) : void
      {
         instance.removeEventListner(param1,param2);
      }
      
      public static function destory() : void
      {
         if(_instance)
         {
            _instance.destory();
         }
         _instance = null;
      }
      
      public function setup() : void
      {
         this._readyList = new Array();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.REC_TEAM_FIGHT_WAIT_REQUEST,this.groupFightWaitRequestHandler);
         SocketConnection.addCmdListener(CommandID.REC_TEAM_FIGHT_WAIT_RESPONSE,this.groupFightWaitResponseHandler);
      }
      
      private function removeEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.REC_TEAM_FIGHT_WAIT_REQUEST,this.groupFightWaitRequestHandler);
         SocketConnection.removeCmdListener(CommandID.REC_TEAM_FIGHT_WAIT_RESPONSE,this.groupFightWaitResponseHandler);
      }
      
      public function teamSignUp(param1:uint) : void
      {
         if(MainManager.actorInfo.wulinID != 0)
         {
            AlertManager.showSimpleAlarm("小侠士，您当前已经报名武林盛典，不能参与团队战斗！");
            return;
         }
         this._pvpTypeIndex = param1;
         SocketConnection.addCmdListener(CommandID.TEAM_FIGHT_WAIT_REQUEST,this.signUpBackHandler);
         SocketConnection.send(CommandID.TEAM_FIGHT_WAIT_REQUEST,this._pvpTypeIndex,0);
      }
      
      private function signUpBackHandler(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TEAM_FIGHT_WAIT_REQUEST,this.signUpBackHandler);
         switch(this._pvpTypeIndex)
         {
            case PvpTypeConstantUtil.TEAM_CITY_WAR:
               ModuleManager.turnAppModule("TeamCityWarWaitPanel");
         }
      }
      
      public function sendTeamFightWait(param1:uint = 0) : void
      {
         SocketConnection.send(CommandID.TEAM_FIGHT_WAIT_REQUEST,this._pvpTypeIndex,param1);
      }
      
      public function teamFightWaitResoponse(param1:uint, param2:uint, param3:uint, param4:uint) : void
      {
         var _loc5_:ByteArray = new ByteArray();
         _loc5_.writeUnsignedInt(MainManager.actorInfo.fightTeamId);
         _loc5_.writeUnsignedInt(param1);
         _loc5_.writeUnsignedInt(param2);
         _loc5_.writeUnsignedInt(param3);
         _loc5_.writeUnsignedInt(param4);
         SocketConnection.send(CommandID.SEND_TEAM_FIGHT_WAIT_RESPONSE,_loc5_);
      }
      
      public function groupFightWaitRequestHandler(param1:SocketEvent) : void
      {
         var _loc9_:Object = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         var _loc7_:uint = _loc2_.readUnsignedInt();
         var _loc8_:String = _loc2_.readUTFBytes(16);
         if(!this._isReady && _loc3_ == MainManager.actorInfo.fightTeamId)
         {
            this._pvpTypeIndex = _loc4_;
            this._itemID = _loc5_;
            this._senderID = _loc6_;
            _loc9_ = {
               "senderID":_loc6_,
               "type":_loc4_,
               "itemID":_loc5_
            };
            MessageManager.addTeamFightWaitRequest(_loc9_);
         }
      }
      
      private function groupFightWaitResponseHandler(param1:SocketEvent) : void
      {
         var userId:uint = 0;
         var evt:SocketEvent = param1;
         var recData:ByteArray = evt.data as ByteArray;
         var teamID:uint = recData.readUnsignedInt();
         var multiType:uint = recData.readUnsignedInt();
         var itemID:uint = recData.readUnsignedInt();
         userId = recData.readUnsignedInt();
         var roleId:uint = recData.readUnsignedInt();
         var nick:String = recData.readUTFBytes(16);
         var flag:uint = recData.readUnsignedInt();
         if(teamID != MainManager.actorInfo.fightTeamId)
         {
            return;
         }
         if(flag < 2)
         {
            if(TeamsRelationManager.instance.checkTeamLeader(userId,roleId))
            {
               this.dispatchEvent(new CommEvent(TEAM_FIGHT_WAIT_DESTORY));
               this._readyList.length = 0;
               return;
            }
            this.dispatchEvent(new CommEvent(TEAM_FIGHT_WAIT_UPDATE + userId.toString(),{
               "userID":userId,
               "roleID":roleId,
               "flag":flag
            }));
            if(flag == 1)
            {
               this._readyList.push(userId);
            }
            else if(this._readyList.indexOf(userId) != -1)
            {
               this._readyList.forEach(function(param1:uint, param2:int, param3:Array):void
               {
                  if(param1 == userId)
                  {
                     _readyList.splice(param2,1);
                  }
               });
            }
         }
         else if(flag == 2)
         {
            TextAlert.show("小侠士，" + nick + "当前正在战斗中，无法接受您的战斗邀请!");
         }
         else if(flag == 3)
         {
            TextAlert.show("小侠士，" + nick + "当前正在交易中，无法接受您的战斗邀请!");
         }
         if(!this._isReady && flag == 1 && userId == MainManager.actorID && roleId == MainManager.actorInfo.createTime)
         {
            this._pvpTypeIndex = multiType;
            this._itemID = itemID;
            switch(multiType)
            {
               case PvpTypeConstantUtil.TEAM_CITY_WAR:
                  ModuleManager.turnAppModule("TeamCityWarWaitPanel","正在加载准备界面");
            }
            MessageManager.removeMsgByType(MessageManager.TEAM_FIGHT_WAIT_REQUEST);
         }
      }
      
      public function matchTeamCityWar() : void
      {
         CityWarManager.instance.setup(CityWarType.TEAM_TYPE);
         CityWarManager.instance.signCityWar(CityWarType.TEAM_TYPE);
         this._readyList.length = 0;
      }
      
      public function addEventListner(param1:String, param2:Function) : void
      {
         this.ed.addEventListener(param1,param2);
      }
      
      public function removeEventListner(param1:String, param2:Function) : void
      {
         this.ed.removeEventListener(param1,param2);
      }
      
      public function dispatchEvent(param1:Event) : void
      {
         this.ed.dispatchEvent(param1);
      }
      
      private function get ed() : EventDispatcher
      {
         if(this._ed == null)
         {
            this._ed = new EventDispatcher();
         }
         return this._ed;
      }
      
      public function get pvpTypeIndex() : uint
      {
         return this._pvpTypeIndex;
      }
      
      public function set pvpTypeIndex(param1:uint) : void
      {
         this._pvpTypeIndex = param1;
      }
      
      public function get itemID() : uint
      {
         return this._itemID;
      }
      
      public function get senderID() : uint
      {
         return this._senderID;
      }
      
      public function get isReady() : Boolean
      {
         return this._isReady;
      }
      
      public function set isReady(param1:Boolean) : void
      {
         this._isReady = param1;
      }
      
      public function get readyList() : Array
      {
         return this._readyList;
      }
      
      public function destory() : void
      {
         this.removeEvent();
      }
   }
}

