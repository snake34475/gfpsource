package com.gfp.app.manager
{
   import com.gfp.app.catchGhost.CatchGhostWaitPanel;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.FightWaitPanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.CommEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.info.GroupUserInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.language.ModuleLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MessageManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.FightMode;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import org.taomee.net.SocketEvent;
   
   public class FightGroupManager
   {
      
      private static var _instance:FightGroupManager;
      
      public static const FIGHT_GROUP_CREATE:String = "FIGHT_GROUP_CREATE";
      
      public static const FIGHT_GROUP_ENTER:String = "FIGHT_GROUP_ENTER";
      
      public static const FIGHT_GROUP_CHANGE:String = "FIGHT_GROUP_CHANGE";
      
      public static const FIGHT_GROUP_QUIT:String = "FIGHT_GROUP_QUIT";
      
      public static const FIGHT_GROUP_WAIT_UPDATE:String = "FIGHT_GROUP_WAIT_UPDATE";
      
      public static const FIGHT_GROUP_WAIT_DESTORY:String = "FIGHT_GROUP_WAIT_DESTORY";
      
      public static const FIGHT_GROUP_USER_INFO_CHANGE:String = "FIGHT_GROUP_USER_INFO_CHANGE";
      
      public var groupId:uint;
      
      public var groupUserList:Vector.<GroupUserInfo>;
      
      public var groupLeaderId:uint = 0;
      
      public var groupLeaderRoleId:uint;
      
      private var waitStateMap:Dictionary;
      
      public var ed:EventDispatcher;
      
      public var groupBtlId:uint;
      
      public var fightAgain:Boolean;
      
      private var _pvpTypeIndex:uint;
      
      public var senderID:uint;
      
      public var senderRoleID:uint;
      
      public function FightGroupManager()
      {
         super();
         this.groupUserList = new Vector.<GroupUserInfo>();
         this.waitStateMap = new Dictionary();
         this.ed = new EventDispatcher();
         SocketConnection.addCmdListener(CommandID.REC_GROUP_INVITE,this.groupInviteRequestHandler);
         SocketConnection.addCmdListener(CommandID.REC_GROUP_INVITE_RESPONSE,this.groupInviteResponseHandler);
         SocketConnection.addCmdListener(CommandID.REC_GROUP_FIGHT_APPLY_INVITE_RESPONSE,this.responseInviteErrorBackHandler);
         SocketConnection.addCmdListener(CommandID.REC_GROUP_CHANGE,this.groupInfoChangeHandler);
         SocketConnection.addCmdListener(CommandID.GROUP_LEAVE,this.groupInfoLeaveHandler);
      }
      
      public static function get instance() : FightGroupManager
      {
         if(!_instance)
         {
            _instance = new FightGroupManager();
         }
         return _instance;
      }
      
      private function initGroupFightWaitEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.REC_GROUP_FIGHT_WAIT_REQUEST,this.groupFightWaitRequestHandler);
         SocketConnection.addCmdListener(CommandID.REC_GROUP_FIGHT_WAIT_RESPONSE,this.groupFightWaitResponseHandler);
         SocketConnection.addCmdListener(CommandID.GROUP_FIGHT_START_MATCH,this.groupFightStartFightHandler);
      }
      
      private function removeGroupFightWaitEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.REC_GROUP_FIGHT_WAIT_REQUEST,this.groupFightWaitRequestHandler);
         SocketConnection.removeCmdListener(CommandID.REC_GROUP_FIGHT_WAIT_RESPONSE,this.groupFightWaitResponseHandler);
         SocketConnection.removeCmdListener(CommandID.GROUP_FIGHT_START_MATCH,this.groupFightStartFightHandler);
      }
      
      public function setup() : void
      {
      }
      
      public function inviteEnterGroup(param1:uint, param2:uint) : void
      {
         if(FunctionManager.disabledFightGroup)
         {
            return;
         }
         if(this.groupUserList.length >= 5)
         {
            AlertManager.showSimpleAlarm(ModuleLanguageDefine.FIGHT_GROUP_MSG[19]);
         }
         SocketConnection.addCmdListener(CommandID.GROUP_INVITE_REQUEST,this.inviteEnterGroupBack);
         SocketConnection.send(CommandID.GROUP_INVITE_REQUEST,param1,param2);
      }
      
      private function inviteEnterGroupBack(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GROUP_INVITE_REQUEST,this.inviteEnterGroupBack);
         var _loc2_:ByteArray = param1.data as ByteArray;
         if(this.groupId == 0)
         {
            this.groupId = _loc2_.readUnsignedInt();
            this.groupUserList = new Vector.<GroupUserInfo>();
            this.groupLeaderId = MainManager.actorID;
            this.groupLeaderRoleId = MainManager.actorInfo.createTime;
            this.initGroupFightWaitEvent();
            this.ed.dispatchEvent(new CommEvent(FIGHT_GROUP_CREATE));
         }
      }
      
      private function groupInviteRequestHandler(param1:SocketEvent) : void
      {
         if(FunctionManager.disabledFightGroup)
         {
            return;
         }
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:Object = {};
         _loc3_.userId = _loc2_.readUnsignedInt();
         _loc3_.roleId = _loc2_.readUnsignedInt();
         _loc3_.userName = _loc2_.readUTFBytes(16);
         _loc3_.groupId = _loc2_.readUnsignedInt();
         _loc3_.lv = _loc2_.readUnsignedInt();
         MessageManager.addFightGroupInviteRequest(_loc3_);
      }
      
      private function groupInviteResponseHandler(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         var _loc7_:String = _loc2_.readUTFBytes(16);
         var _loc8_:uint = _loc2_.readUnsignedInt();
         switch(_loc8_)
         {
            case 0:
               if(this.pvpTypeIndex == PvpTypeConstantUtil.MULTI_PVP_COMM && this.groupUserList.length >= 2)
               {
                  this.leaveGroup(_loc4_,_loc5_);
                  return;
               }
               TextAlert.show(TextFormatUtil.substitute(ModuleLanguageDefine.FIGHT_GROUP_MSG[1],_loc7_));
               break;
            case 1:
               TextAlert.show(TextFormatUtil.substitute(ModuleLanguageDefine.FIGHT_GROUP_MSG[2],_loc7_));
               break;
            case 2:
               TextAlert.show(TextFormatUtil.substitute(ModuleLanguageDefine.FIGHT_GROUP_MSG[3],_loc7_));
               break;
            case 3:
               TextAlert.show(TextFormatUtil.substitute(ModuleLanguageDefine.FIGHT_GROUP_MSG[4],_loc7_));
               break;
            case 4:
               TextAlert.show(TextFormatUtil.substitute(ModuleLanguageDefine.FIGHT_GROUP_MSG[5],_loc7_));
               break;
            case 5:
               TextAlert.show(TextFormatUtil.substitute(ModuleLanguageDefine.FIGHT_GROUP_MSG[12],_loc7_));
         }
      }
      
      private function responseInviteErrorBackHandler(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         switch(_loc4_)
         {
            case 0:
               break;
            case 1:
               TextAlert.show(ModuleLanguageDefine.FIGHT_GROUP_MSG[17]);
               break;
            case 2:
               TextAlert.show(ModuleLanguageDefine.FIGHT_GROUP_MSG[18]);
         }
      }
      
      private function groupInfoChangeHandler(param1:SocketEvent) : void
      {
         var _loc7_:GroupUserInfo = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:UserInfo = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:Boolean = this.groupLeaderId == 0;
         var _loc6_:Vector.<GroupUserInfo> = new Vector.<GroupUserInfo>();
         var _loc8_:int = 0;
         while(_loc8_ < _loc4_)
         {
            _loc9_ = _loc2_.readUnsignedInt();
            _loc10_ = _loc2_.readUnsignedInt();
            _loc11_ = _loc2_.readUnsignedInt();
            _loc12_ = _loc2_.readUnsignedInt();
            _loc7_ = this.getGroupUserInfo(_loc9_,_loc10_);
            if(!_loc7_)
            {
               _loc7_ = new GroupUserInfo();
               _loc13_ = new UserInfo();
               _loc7_.userInfo = _loc13_;
            }
            if(_loc9_ == MainManager.actorID && _loc10_ == MainManager.actorInfo.createTime)
            {
               _loc7_.userInfo.userID = MainManager.actorID;
               _loc7_.userInfo.createTime = MainManager.actorInfo.createTime;
               _loc7_.userInfo.lv = MainManager.actorInfo.lv;
               _loc7_.userInfo.hp = MainManager.actorInfo.hp;
               _loc7_.userInfo.mp = MainManager.actorInfo.mp;
               _loc7_.userInfo.nick = MainManager.actorInfo.nick;
               _loc7_.userInfo.roleType = MainManager.actorInfo.roleType;
            }
            else
            {
               _loc7_.userInfo.userID = _loc9_;
               _loc7_.userInfo.createTime = _loc10_;
               _loc7_.userInfo.lv = _loc11_;
            }
            _loc7_.type = _loc12_;
            if(_loc7_.type == 1)
            {
               this.groupLeaderId = _loc9_;
               this.groupLeaderRoleId = _loc10_;
            }
            _loc6_.push(_loc7_);
            _loc8_++;
         }
         this.groupUserList = _loc6_;
         if(_loc5_)
         {
            this.initGroupFightWaitEvent();
            this.groupId = _loc3_;
            this.ed.dispatchEvent(new CommEvent(FIGHT_GROUP_ENTER));
            MessageManager.removeMsgByType(MessageManager.FIGHT_GROUP_APPLY_REQUEST);
         }
         else
         {
            this.ed.dispatchEvent(new CommEvent(FIGHT_GROUP_CHANGE));
         }
      }
      
      public function refreshMemberListInfo() : void
      {
         this.ed.dispatchEvent(new CommEvent(FIGHT_GROUP_USER_INFO_CHANGE));
      }
      
      private function groupInfoLeaveHandler(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ != this.groupId)
         {
            return;
         }
         var _loc6_:uint = _loc2_.readUnsignedInt();
         switch(_loc6_)
         {
            case 0:
               TextAlert.show(ModuleLanguageDefine.FIGHT_GROUP_MSG[9]);
               break;
            case 1:
               TextAlert.show(ModuleLanguageDefine.FIGHT_GROUP_MSG[10]);
               break;
            case 2:
               TextAlert.show(ModuleLanguageDefine.FIGHT_GROUP_MSG[11]);
         }
         this.groupId = 0;
         this.pvpTypeIndex = 0;
         this.groupUserList.length = 0;
         this.groupLeaderId = 0;
         this.groupLeaderRoleId = 0;
         this.waitStateMap = new Dictionary();
         this.removeGroupFightWaitEvent();
         this.ed.dispatchEvent(new CommEvent(FIGHT_GROUP_QUIT));
      }
      
      private function getGroupInfo(param1:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.GET_GROUP_INFO,this.getGroupInfoBackHandler);
         SocketConnection.send(CommandID.GET_GROUP_INFO,param1);
      }
      
      private function getGroupInfoBackHandler(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GET_GROUP_INFO,this.getGroupInfoBackHandler);
         var _loc2_:ByteArray = param1.data as ByteArray;
      }
      
      private function removeGroupUser(param1:uint, param2:uint) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < this.groupUserList.length)
         {
            if(this.groupUserList[_loc3_].userInfo.userID == param1 && this.groupUserList[_loc3_].userInfo.createTime == param2)
            {
               this.groupUserList.splice(_loc3_,1);
               return;
            }
            _loc3_++;
         }
      }
      
      public function responseGroupInvite(param1:uint, param2:uint, param3:uint, param4:uint) : void
      {
         SocketConnection.send(CommandID.SEND_GROUP_INVITE_RESPONSE,param1,param2,param3,param4);
      }
      
      public function leaveGroup(param1:uint, param2:uint) : void
      {
         SocketConnection.send(CommandID.GROUP_LEAVE,param1,param2);
      }
      
      public function groupFightAgain() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         this.groupSignUp(this.pvpTypeIndex);
      }
      
      public function groupSignUp(param1:uint = 22) : void
      {
         if(MainManager.actorInfo.wulinID != 0)
         {
            AlertManager.showSimpleAlarm("小侠士，您当前已经报名武林盛典，不能参与组队PVP战斗！");
            return;
         }
         this.pvpTypeIndex = param1;
         SocketConnection.addCmdListener(CommandID.GROUP_FIGHT_WAIT_REQUEST,this.signUpBackHandler);
         var _loc2_:uint = 0;
         if(this.pvpTypeIndex == PvpTypeConstantUtil.GROUP_CATCH_TURTLE)
         {
            _loc2_ = CatchBigGhostManager.instance.currentItem;
         }
         SocketConnection.send(CommandID.GROUP_FIGHT_WAIT_REQUEST,0,0,this.pvpTypeIndex,_loc2_);
         this.senderID = MainManager.actorID;
         this.senderRoleID = MainManager.actorInfo.createTime;
      }
      
      private function signUpBackHandler(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GROUP_FIGHT_WAIT_REQUEST,this.signUpBackHandler);
         switch(this.pvpTypeIndex)
         {
            case PvpTypeConstantUtil.CITY_WAR_GROUP_PVP:
               ModuleManager.turnAppModule("CityWarGroupWaitPanel","正在加载准备界面");
               break;
            case PvpTypeConstantUtil.GROUP_CATCH_GHOST:
            case PvpTypeConstantUtil.GROUP_CATCH_TURTLE:
               CatchGhostWaitPanel.instance.show();
               break;
            case PvpTypeConstantUtil.GROUP_QUICK_PVP:
            case PvpTypeConstantUtil.BLACK_GROUP_PVP:
               break;
            default:
               ModuleManager.turnAppModule("MultiPvpWaitPanel","正在加载准备界面");
         }
      }
      
      public function sendFightGroupWait(param1:uint, param2:uint, param3:uint = 0) : void
      {
         SocketConnection.send(CommandID.GROUP_FIGHT_WAIT_REQUEST,param1,param2,this.pvpTypeIndex,param3);
      }
      
      public function groupFightWaitResoponse(param1:uint, param2:uint) : void
      {
         SocketConnection.send(CommandID.SEND_GROUP_FIGHT_WAIT_RESPONSE,param1,param2);
      }
      
      public function groupFightWaitRequestHandler(param1:SocketEvent) : void
      {
         var _loc7_:Object = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         this.senderID = _loc2_.readUnsignedInt();
         this.senderRoleID = _loc2_.readUnsignedInt();
         if(this.myIsTheSender)
         {
            return;
         }
         this.pvpTypeIndex = _loc4_;
         var _loc6_:GroupUserInfo = this.getGroupUserInfo(MainManager.actorID,MainManager.actorInfo.createTime);
         if(!_loc6_.isReady)
         {
            switch(this.pvpTypeIndex)
            {
               case PvpTypeConstantUtil.BLACK_GROUP_PVP:
               case PvpTypeConstantUtil.GROUP_QUICK_PVP:
                  this.groupFightWaitResoponse(_loc3_,1);
                  return;
               default:
                  _loc7_ = {
                     "group":_loc3_,
                     "type":_loc4_,
                     "itemID":_loc5_
                  };
                  MessageManager.addFIghtGroupWaitRequest(_loc7_);
            }
         }
      }
      
      private function groupFightWaitResponseHandler(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         var _loc7_:GroupUserInfo = this.getGroupUserInfo(_loc4_,_loc5_);
         if(_loc6_ < 2)
         {
            if(_loc3_ == this.groupId)
            {
               if(_loc4_ == this.senderID && _loc5_ == this.senderRoleID)
               {
                  for each(_loc7_ in this.groupUserList)
                  {
                     _loc7_.isReady = false;
                     this.waitStateMap = new Dictionary();
                  }
                  MessageManager.removeFightGroupWaitMsg(this._pvpTypeIndex);
                  this.ed.dispatchEvent(new CommEvent(FIGHT_GROUP_WAIT_DESTORY));
                  return;
               }
               _loc7_ = this.getGroupUserInfo(_loc4_,_loc5_);
               if(_loc7_)
               {
                  _loc7_.isReady = _loc6_ == 1;
                  this.waitStateMap[_loc4_ + "_" + _loc5_] = _loc7_.isReady;
                  this.ed.dispatchEvent(new CommEvent(FIGHT_GROUP_WAIT_UPDATE));
               }
            }
         }
         else if(_loc6_ == 2)
         {
            TextAlert.show(TextFormatUtil.substitute(ModuleLanguageDefine.FIGHT_GROUP_MSG[14],_loc7_.userInfo.nick));
         }
         else if(_loc6_ == 3)
         {
            TextAlert.show(TextFormatUtil.substitute(ModuleLanguageDefine.FIGHT_GROUP_MSG[15],_loc7_.userInfo.nick));
         }
         else if(_loc6_ == 4)
         {
            TextAlert.show(TextFormatUtil.substitute(ModuleLanguageDefine.FIGHT_GROUP_MSG[16],_loc7_.userInfo.nick));
         }
         else if(_loc6_ == 5)
         {
            TextAlert.show(TextFormatUtil.substitute(ModuleLanguageDefine.FIGHT_GROUP_MSG[20],_loc7_.userInfo.nick));
         }
         else if(_loc6_ == 6)
         {
            if(_loc4_ == MainManager.actorID)
            {
               TextAlert.show("小侠士，你的队长邀请你去参加黑暗武斗场，请迅速前往。");
            }
            else
            {
               TextAlert.show(TextFormatUtil.substitute(ModuleLanguageDefine.FIGHT_GROUP_MSG[21],_loc7_.userInfo.nick));
            }
         }
         else if(_loc6_ == 7)
         {
            if(MainManager.actorInfo.coins < 500000)
            {
               TextAlert.show("小侠士，您身上的功夫豆不足50w哦。");
            }
            else
            {
               TextAlert.show("小侠士，您的队员身上的功夫豆不足50w哦。");
            }
         }
         if(_loc6_ == 1 && _loc4_ == MainManager.actorID && _loc5_ == MainManager.actorInfo.createTime)
         {
            switch(this.pvpTypeIndex)
            {
               case PvpTypeConstantUtil.CITY_WAR_GROUP_PVP:
                  ModuleManager.turnAppModule("CityWarGroupWaitPanel","正在加载准备界面");
                  break;
               case PvpTypeConstantUtil.GROUP_CATCH_TURTLE:
               case PvpTypeConstantUtil.GROUP_QUICK_PVP:
               case PvpTypeConstantUtil.BLACK_GROUP_PVP:
                  break;
               default:
                  ModuleManager.turnAppModule("MultiPvpWaitPanel","正在加载准备界面");
            }
            MessageManager.removeMsgByType(MessageManager.FIGHT_GROUP_WAIT_REQUEST);
         }
      }
      
      public function matchGroupFight() : void
      {
         if(this.pvpTypeIndex == PvpTypeConstantUtil.MULTI_PVP_KING_FIGHT_0 || this.pvpTypeIndex == PvpTypeConstantUtil.MULTI_PVP_KING_FIGHT_1 || this.pvpTypeIndex == PvpTypeConstantUtil.MULTI_PVP_KING_FIGHT_2)
         {
            SocketConnection.send(CommandID.KING_FIGHT_FAKE_ENTER);
            return;
         }
         SocketConnection.send(CommandID.GROUP_FIGHT_START_MATCH,this.pvpTypeIndex);
      }
      
      public function matchGroupCityWar() : void
      {
         CityWarManager.instance.setup();
         CityWarManager.instance.signCityWar();
      }
      
      private function groupFightStartFightHandler(param1:SocketEvent) : void
      {
         GroupViolenceMatchManager.instance.ed.dispatchEvent(new CommEvent(GroupViolenceMatchManager.KING_FIGHT_HIDE_WAIT_EVENT));
         this.ed.dispatchEvent(new CommEvent(FIGHT_GROUP_WAIT_DESTORY));
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ != this.groupId)
         {
            return;
         }
         this.groupBtlId = _loc2_.readUnsignedInt();
         FightManager.fightMode = FightMode.PVP;
         FightWaitPanel.showWaitPanel(true,this.pvpTypeIndex);
      }
      
      public function getGroupUserInfo(param1:uint, param2:uint) : GroupUserInfo
      {
         var _loc3_:GroupUserInfo = null;
         for each(_loc3_ in this.groupUserList)
         {
            if(_loc3_.userInfo.userID == param1 && _loc3_.userInfo.createTime == param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function getGroupUserInfoByUserId(param1:uint) : GroupUserInfo
      {
         var _loc2_:GroupUserInfo = null;
         for each(_loc2_ in this.groupUserList)
         {
            if(_loc2_.userInfo.userID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function get myIsTheLeader() : Boolean
      {
         return this.groupLeaderId == MainManager.actorID && this.groupLeaderRoleId == MainManager.actorInfo.createTime;
      }
      
      public function isLeader(param1:UserInfo) : Boolean
      {
         return this.groupLeaderId == param1.userID && this.groupLeaderRoleId == param1.createTime;
      }
      
      public function get myIsTheSender() : Boolean
      {
         return this.senderID == MainManager.actorID && this.senderRoleID == MainManager.actorInfo.createTime;
      }
      
      public function isSender(param1:UserInfo) : Boolean
      {
         return this.senderID == param1.userID && this.senderRoleID == param1.createTime;
      }
      
      public function allMemberIsReady() : Boolean
      {
         var _loc1_:GroupUserInfo = null;
         for each(_loc1_ in this.groupUserList)
         {
            if(!this.isSender(_loc1_.userInfo) && !_loc1_.isReady)
            {
               return false;
            }
         }
         return true;
      }
      
      public function groupFightOver() : void
      {
         var _loc1_:GroupUserInfo = null;
         this.groupBtlId = 0;
         this.refreshMemberListInfo();
         for each(_loc1_ in this.groupUserList)
         {
            _loc1_.isReady = false;
            this.waitStateMap = new Dictionary();
         }
      }
      
      public function hasFightGroup() : Boolean
      {
         return this.groupId != 0;
      }
      
      public function set pvpTypeIndex(param1:uint) : void
      {
         this._pvpTypeIndex = param1;
      }
      
      public function get pvpTypeIndex() : uint
      {
         return this._pvpTypeIndex;
      }
   }
}

