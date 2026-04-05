package com.gfp.app.manager
{
   import com.gfp.app.control.SystemTimeController;
   import com.gfp.app.fight.FightWaitPanel;
   import com.gfp.app.info.KingFightTeamInfo;
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.KeyController;
   import com.gfp.core.events.CommEvent;
   import com.gfp.core.events.TimeEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.fight.FightReadyInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.language.ModuleLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MessageManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import com.gfp.core.utils.TextFormatUtil;
   import com.gfp.core.utils.TimerManager;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import org.taomee.net.SocketEvent;
   
   public class GroupViolenceMatchManager
   {
      
      private static var _instance:GroupViolenceMatchManager;
      
      public static const GET_GROUP_VIOLENCE_INFO_EVENT:String = "GET_GROUP_VIOLENCE_INFO_EVENT";
      
      public static const SIGN_UP_GROUP_VIOLENCE_EVENT:String = "SIGN_UP_GROUP_VIOLENCE_EVENT";
      
      public static const DISSOLVE_GROUP_VIOLENCE_EVENT:String = "DISSOLVE_GROUP_VIOLENCE_EVENT";
      
      public static const GET_KING_FIGHT_LIST_EVENT:String = "GET_KING_FIGHT_LIST_EVENT";
      
      public static const KING_FIGHT_HIDE_WAIT_EVENT:String = "KING_FIGHT_HIDE_WAIT_EVENT";
      
      public static const KING_FIGHT_GUESS_BACK_EVENT:String = "KING_FIGHT_GUESS_BACK_EVENT";
      
      public static const VIOLENCE_MAP_ID:uint = 1100201;
      
      public static const GUESS_COIN:uint = 1000000;
      
      private var _ed:EventDispatcher;
      
      public var groupViolenceId:uint;
      
      public var leaderUserInfo:UserInfo;
      
      public var memberUserInfo:UserInfo;
      
      public var campIndex:uint;
      
      public var groupCount:uint;
      
      private var fightReaderInfo:FightReadyInfo;
      
      private var fiveSecondTm:Timer;
      
      public var kingFightTeamList:Vector.<Vector.<KingFightTeamInfo>>;
      
      private var _signUp:Boolean;
      
      private var fightTypeArr:Array = [];
      
      public var kingFightWaitShow:Boolean;
      
      public function GroupViolenceMatchManager()
      {
         super();
         this.fightTypeArr = [PvpTypeConstantUtil.MULTI_PVP_KING_FIGHT_0,PvpTypeConstantUtil.MULTI_PVP_KING_FIGHT_1,PvpTypeConstantUtil.MULTI_PVP_KING_FIGHT_2];
         this.kingFightTeamList = new Vector.<Vector.<KingFightTeamInfo>>();
         SocketConnection.addCmdListener(CommandID.SIGN_UP_GROUP_VIOLENCE,this.signUpGroupViolenceBack);
         SocketConnection.addCmdListener(CommandID.DISSOLVE_GROUP_VIOLENCE,this.dissolveGroupBack);
         SocketConnection.addCmdListener(CommandID.KING_FIGHT_STATE_NOTIFY,this.stateNotifyHandler);
         SocketConnection.addCmdListener(CommandID.KING_FIGHT_FAKE_ENTER,this.fakeEnterHandler);
         SocketConnection.addCmdListener(CommandID.KING_FIGHT_RESULT,this.kingFightResultHandler);
         TimerManager.ed.addEventListener(TimeEvent.TIMER_EVERY_FORTY_FIVE_MINUTE,this.showKingFightNotifyHandler);
      }
      
      public static function get instance() : GroupViolenceMatchManager
      {
         if(!_instance)
         {
            _instance = new GroupViolenceMatchManager();
         }
         return _instance;
      }
      
      public function getGroupViolenceInfo() : void
      {
         SocketConnection.addCmdListener(CommandID.GET_GROUP_VIOLENCE_INFO,this.getGroupViolenceInfoBack);
         SocketConnection.send(CommandID.GET_GROUP_VIOLENCE_INFO);
      }
      
      private function getGroupViolenceInfoBack(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GET_GROUP_VIOLENCE_INFO,this.getGroupViolenceInfoBack);
         var _loc2_:ByteArray = param1.data as ByteArray;
         this.groupViolenceId = _loc2_.readUnsignedInt();
         this.campIndex = _loc2_.readUnsignedInt();
         this.groupCount = _loc2_.readUnsignedInt();
         this.leaderUserInfo = new UserInfo();
         this.leaderUserInfo.userID = _loc2_.readUnsignedInt();
         this.leaderUserInfo.createTime = _loc2_.readUnsignedInt();
         this.memberUserInfo = new UserInfo();
         this.memberUserInfo.userID = _loc2_.readUnsignedInt();
         this.memberUserInfo.createTime = _loc2_.readUnsignedInt();
         this.ed.dispatchEvent(new CommEvent(GET_GROUP_VIOLENCE_INFO_EVENT));
      }
      
      public function signUpGroupViolence(param1:uint) : void
      {
         SocketConnection.send(CommandID.SIGN_UP_GROUP_VIOLENCE,param1);
      }
      
      private function signUpGroupViolenceBack(param1:SocketEvent) : void
      {
         var _loc4_:Array = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == 0)
         {
            this.groupViolenceId = _loc2_.readUnsignedInt();
            this.campIndex = _loc2_.readUnsignedInt();
            this.leaderUserInfo = new UserInfo();
            this.leaderUserInfo.userID = _loc2_.readUnsignedInt();
            this.leaderUserInfo.createTime = _loc2_.readUnsignedInt();
            this.memberUserInfo = new UserInfo();
            this.memberUserInfo.userID = _loc2_.readUnsignedInt();
            this.memberUserInfo.createTime = _loc2_.readUnsignedInt();
            _loc4_ = AppLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[4];
            AlertManager.showSimpleAlarm(TextFormatUtil.substitute(AppLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[3],_loc4_[this.campIndex]));
         }
         else if(_loc3_ == 1)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[2]);
         }
         else if(_loc3_ == 2)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[1]);
         }
         this.ed.dispatchEvent(new CommEvent(SIGN_UP_GROUP_VIOLENCE_EVENT));
      }
      
      public function operateWaitFiveSecond(param1:FightReadyInfo) : void
      {
         this.fightReaderInfo = param1;
         ModuleManager.turnAppModule("GroupViolenceMatchTimerPanel","正在加载......",this.fightReaderInfo);
      }
      
      public function dissolveGroup() : void
      {
         SocketConnection.send(CommandID.DISSOLVE_GROUP_VIOLENCE);
      }
      
      private function dissolveGroupBack(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ != MainManager.actorID)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[5]);
         }
         this.groupViolenceId = 0;
         this.leaderUserInfo = null;
         this.memberUserInfo = null;
         this.groupCount = 0;
         this.campIndex = 0;
         this.ed.dispatchEvent(new CommEvent(DISSOLVE_GROUP_VIOLENCE_EVENT));
      }
      
      public function getMemberInfo() : UserInfo
      {
         if(MainManager.actorID == this.leaderUserInfo.userID)
         {
            return this.memberUserInfo;
         }
         return this.leaderUserInfo;
      }
      
      public function checkCurGroupIsSignGroup() : Boolean
      {
         return Boolean(FightGroupManager.instance.getGroupUserInfo(this.leaderUserInfo.userID,this.leaderUserInfo.createTime)) && Boolean(FightGroupManager.instance.getGroupUserInfo(this.memberUserInfo.userID,this.memberUserInfo.createTime));
      }
      
      public function get ed() : EventDispatcher
      {
         if(!this._ed)
         {
            this._ed = new EventDispatcher();
         }
         return this._ed;
      }
      
      public function getKingFightMatrix() : void
      {
         SocketConnection.addCmdListener(CommandID.GET_KING_FIGHT_MATRIX,this.getKingFightMatrixBackHandler);
         SocketConnection.send(CommandID.GET_KING_FIGHT_MATRIX);
      }
      
      private function getKingFightMatrixBackHandler(param1:SocketEvent) : void
      {
         var _loc4_:Vector.<KingFightTeamInfo> = null;
         SocketConnection.removeCmdListener(CommandID.GET_KING_FIGHT_MATRIX,this.getKingFightMatrixBackHandler);
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         this.kingFightTeamList.length = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = new Vector.<KingFightTeamInfo>();
            _loc4_.push(new KingFightTeamInfo(_loc2_));
            _loc4_.push(new KingFightTeamInfo(_loc2_));
            this.kingFightTeamList.push(_loc4_);
            _loc5_++;
         }
         this.ed.dispatchEvent(new CommEvent(GET_KING_FIGHT_LIST_EVENT));
         if(this._signUp)
         {
            this.signUpCheck();
         }
      }
      
      public function signUpKingFight() : void
      {
         this._signUp = true;
         MainManager.closeOperate(true);
         KeyController.instance.clear();
         this.getKingFightMatrix();
      }
      
      private function signUpCheck() : void
      {
         MainManager.openOperate();
         KeyController.instance.init();
         this._signUp = false;
         var _loc1_:int = -1;
         if(this.kingFightTeamList[2][0].teamId == 0 || this.kingFightTeamList[2][1].teamId == 0)
         {
            if(this.kingFightTeamList[2][0].teamId == 0)
            {
               if(this.kingFightTeamList[0][0].userInTeam(MainManager.actorInfo) || this.kingFightTeamList[0][1].userInTeam(MainManager.actorInfo))
               {
                  _loc1_ = 0;
               }
            }
            if(this.kingFightTeamList[2][1].teamId == 0)
            {
               if(this.kingFightTeamList[1][0].userInTeam(MainManager.actorInfo) || this.kingFightTeamList[1][1].userInTeam(MainManager.actorInfo))
               {
                  _loc1_ = 1;
               }
            }
         }
         else if(this.kingFightTeamList[2][0].userInTeam(MainManager.actorInfo) || this.kingFightTeamList[2][1].userInTeam(MainManager.actorInfo))
         {
            _loc1_ = 2;
         }
         if(_loc1_ == -1)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[6]);
            return;
         }
         if(FightGroupManager.instance.groupId == 0)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[1]);
            return;
         }
         if(FightGroupManager.instance.myIsTheLeader)
         {
            if(Boolean(FightGroupManager.instance.getGroupUserInfo(this.kingFightTeamList[_loc1_][0].user2Id,this.kingFightTeamList[_loc1_][0].user2RoleId)) || Boolean(FightGroupManager.instance.getGroupUserInfo(this.kingFightTeamList[_loc1_][1].user2Id,this.kingFightTeamList[_loc1_][1].user2RoleId)))
            {
               FightGroupManager.instance.groupSignUp(this.fightTypeArr[_loc1_]);
            }
            else
            {
               AlertManager.showSimpleAlarm(AppLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[11]);
            }
         }
         else
         {
            AlertManager.showSimpleAlarm(ModuleLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[1]);
         }
      }
      
      private function stateNotifyHandler(param1:SocketEvent) : void
      {
         var evt:SocketEvent = param1;
         var recData:ByteArray = evt.data as ByteArray;
         var state:uint = recData.readUnsignedInt();
         switch(state)
         {
            case 0:
               if((this.kingFightWaitShow || FightWaitPanel.isFightWaitPanelShow()) && FightGroupManager.instance.groupId != 0 && FightGroupManager.instance.myIsTheLeader)
               {
                  SocketConnection.send(CommandID.GROUP_FIGHT_START_MATCH,FightGroupManager.instance.pvpTypeIndex);
               }
               break;
            case 180:
               MessageManager.addGroupKingFightNotify(AppLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[7] + AppLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[9]);
               TextAlert.show(AppLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[7]);
               break;
            case 60:
               MessageManager.addGroupKingFightNotify(AppLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[8] + AppLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[9]);
               TextAlert.show(AppLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[8]);
               if(FightGroupManager.instance.groupId != 0 && MapManager.currentMap.info.id == 38)
               {
                  if(FightWaitPanel.isFightWaitPanelShow())
                  {
                     FightWaitPanel.onCloseWaitPanel();
                  }
                  if(!this.kingFightWaitShow && FightGroupManager.instance.myIsTheLeader && !MapManager.isFightMap)
                  {
                     AlertManager.showSimpleAlert("组队武斗大会天王战将于1分钟后匹配,是否现在报名？",function():void
                     {
                        if(SystemTimeController.instance.checkSysTimeAchieve(33))
                        {
                           GroupViolenceMatchManager.instance.signUpKingFight();
                        }
                        else
                        {
                           SystemTimeController.instance.showOutTimeAlert(33);
                        }
                     });
                  }
               }
         }
      }
      
      private function fakeEnterHandler(param1:SocketEvent) : void
      {
         this.kingFightWaitShow = true;
         ModuleManager.turnAppModule("KingFightWaitPanel","加载中......");
      }
      
      private function kingFightResultHandler(param1:SocketEvent) : void
      {
         var _loc8_:String = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:Vector.<KingFightTeamInfo> = this.getCurFightTeamInfo();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:int = _loc3_[0].userInTeam(MainManager.actorInfo) ? 0 : 1;
         var _loc6_:KingFightTeamInfo = _loc3_[_loc5_];
         var _loc7_:KingFightTeamInfo = _loc3_[_loc5_ ^ 1];
         if(_loc4_ == 0)
         {
            _loc7_.winCount += 1;
            _loc8_ = AppLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[12];
            _loc8_ = _loc8_ + (AppLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[14] + _loc6_.winCount + "/" + _loc7_.winCount);
            if(_loc7_.winCount >= 3)
            {
               _loc8_ += AppLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[17];
            }
            else
            {
               _loc8_ += AppLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[15];
            }
            TextAlert.show(_loc8_);
         }
         else
         {
            _loc6_.winCount += 1;
            _loc8_ = AppLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[13];
            _loc8_ = _loc8_ + (AppLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[14] + _loc6_.winCount + "/" + _loc7_.winCount);
            if(_loc6_.winCount >= 3)
            {
               _loc8_ += AppLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[16];
            }
            else
            {
               _loc8_ += AppLanguageDefine.GROUP_VIOLENCE_MATCH_MSG[15];
            }
            TextAlert.show(_loc8_);
         }
         this.ed.dispatchEvent(new CommEvent(KING_FIGHT_HIDE_WAIT_EVENT));
      }
      
      public function supportCamp(param1:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.KING_FIGHT_SUPPORT,this.supportBackHandler);
         SocketConnection.send(CommandID.KING_FIGHT_SUPPORT,param1);
      }
      
      private function supportBackHandler(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         SocketConnection.removeCmdListener(CommandID.KING_FIGHT_SUPPORT,this.supportBackHandler);
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         MainManager.actorInfo.coins -= GUESS_COIN;
         this.ed.dispatchEvent(new CommEvent(KING_FIGHT_GUESS_BACK_EVENT,_loc4_));
      }
      
      private function showKingFightNotifyHandler(param1:TimeEvent) : void
      {
      }
      
      private function getTeamInfo() : Vector.<KingFightTeamInfo>
      {
         var _loc1_:Vector.<KingFightTeamInfo> = null;
         if(this.kingFightTeamList[0][0].userInTeam(MainManager.actorInfo))
         {
            _loc1_ = this.kingFightTeamList[0];
         }
         if(this.kingFightTeamList[0][1].userInTeam(MainManager.actorInfo))
         {
            _loc1_ = this.kingFightTeamList[0];
         }
         if(this.kingFightTeamList[1][0].userInTeam(MainManager.actorInfo))
         {
            _loc1_ = this.kingFightTeamList[1];
         }
         if(this.kingFightTeamList[1][1].userInTeam(MainManager.actorInfo))
         {
            _loc1_ = this.kingFightTeamList[1];
         }
         return null;
      }
      
      private function getCurFightTeamInfo() : Vector.<KingFightTeamInfo>
      {
         if(this.kingFightTeamList[2][0].teamId == 0 || this.kingFightTeamList[2][1].teamId == 0)
         {
            return this.getTeamInfo();
         }
         return this.kingFightTeamList[2];
      }
   }
}

