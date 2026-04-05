package com.gfp.app.fight
{
   import com.gfp.app.control.WuLinFightControl;
   import com.gfp.app.manager.FightGroupManager;
   import com.gfp.app.systems.WallowRemindChild;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.BaseAction;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskCommonEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.fight.FightReadyInfo;
   import com.gfp.core.language.CoreLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.FightMode;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import com.gfp.core.utils.StringConstants;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class PvpEntry extends FightEntry
   {
      
      private static var _againEntry:Boolean;
      
      private static var _pvpID:uint;
      
      private static var _instance:PvpEntry;
      
      public static const PVP_ID_HEROMEET_KING:int = 8;
      
      public static const PVP_CONSUMED_COIN:int = 200;
      
      private var _pvpAwardInfo:ByteArray;
      
      private var timeInteval:int = 0;
      
      private var _pkResultMc:MovieClip;
      
      public function PvpEntry()
      {
         super();
      }
      
      public static function get instance() : PvpEntry
      {
         if(_instance == null)
         {
            _instance = new PvpEntry();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      public static function fightWithEnter(param1:uint = 0) : void
      {
         instance.fightWithEnter(param1);
      }
      
      public static function onReason() : void
      {
         if(_instance)
         {
            _instance.onReason();
         }
      }
      
      public static function onWinner() : void
      {
         if(_instance)
         {
            _instance.onWinner();
         }
      }
      
      public static function onActorRevive() : void
      {
         if(_instance)
         {
            _instance.onActorRevive();
         }
      }
      
      public static function set againEntry(param1:Boolean) : void
      {
         _againEntry = param1;
         if(_againEntry)
         {
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapSwitchComplete);
         }
      }
      
      public static function get againEntry() : Boolean
      {
         return _againEntry;
      }
      
      private static function onMapSwitchComplete(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapSwitchComplete);
         instance.fightWithEnter(_pvpID);
      }
      
      public static function get pvpID() : uint
      {
         return _pvpID;
      }
      
      override public function setup(param1:FightReadyInfo) : void
      {
         if(param1.roles.length < 2)
         {
            return;
         }
         _mapType = MapType.PVP;
         super.setup(param1);
         _resLoader.loadPvP(_readyInfo.roles,_readyInfo.ogres);
         SocketConnection.addCmdListener(CommandID.PVP_AWARD,this.onPvpAward);
         SocketConnection.addCmdListener(CommandID.FIGHT_COUNT_DOWN,this.onCountDown);
      }
      
      override public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.PVP_AWARD,this.onPvpAward);
         SocketConnection.removeCmdListener(CommandID.FIGHT_COUNT_DOWN,this.onCountDown);
         super.destroy();
         if(!_againEntry)
         {
            WallowRemindChild.instance.showBlockMsg();
         }
         if(this._pkResultMc)
         {
            DisplayUtil.removeForParent(this._pkResultMc);
            this._pkResultMc = null;
         }
         SinglePkManager.instance.destroy();
      }
      
      public function fightWithEnter(param1:uint = 0, param2:int = 0, param3:int = 0, param4:Array = null) : void
      {
         if(MainManager.actorModel.isZhengGued)
         {
            AlertManager.showSimpleAlarm("小侠士，你正处于被整蛊状态，不能进入战斗");
         }
         if(MapManager.isFightMap)
         {
            Logger.error(this,"已战斗中，不能参加战斗");
            return;
         }
         if(MainManager.actorInfo.wulinID != 0 && param1 != 9)
         {
            AlertManager.showSimpleAlarm(CoreLanguageDefine.WULIN_MSG_ARR[1]);
            return;
         }
         _mapType = MapType.PVP;
         FightManager.fightMode = FightMode.PVP;
         FightWaitPanel.enterWaitPanel(param1,param2,param3,param4);
         _pvpID = param1;
      }
      
      override protected function onBegin(param1:SocketEvent) : void
      {
         var _loc2_:WuLinFightControl = null;
         super.onBegin(param1);
         MainManager.openOperate();
         if(_pvpID == 9)
         {
            _loc2_ = WuLinFightControl.instance;
            if(_loc2_.round > 0)
            {
               ModuleManager.turnAppModule("WuLinAwardInfoPanel","",_loc2_.applyBadge + "|" + _loc2_.winBadge + "|" + _loc2_.failBadge + "|" + _loc2_.luckyBadge);
            }
         }
         if(_pvpID == 13)
         {
            ActivityExchangeTimesManager.updataTimesByOnce(1419);
         }
         initSkillCD();
         FightManager.instance.dispatchEvent(new FightEvent(FightEvent.BEGIN));
      }
      
      override protected function winnerFun(param1:uint, param2:uint) : void
      {
         super.winnerFun(param1,param2);
      }
      
      override protected function reasonFun(param1:uint, param2:uint) : void
      {
         super.reasonFun(param1,param2);
         MainManager.actorModel.execAction(new BaseAction(ActionXMLInfo.getInfo(10009),false));
         var _loc3_:UserModel = UserManager.getModel(param1);
         if(_loc3_)
         {
            _loc3_.actionManager.clear();
            _loc3_.execAction(new BaseAction(ActionXMLInfo.getInfo(10008),false));
         }
      }
      
      private function specialHandleForPvp3(param1:ByteArray) : void
      {
         var _loc10_:String = null;
         var _loc11_:int = 0;
         param1.position = 0;
         var _loc2_:int = int(this._pvpAwardInfo.readUnsignedInt());
         var _loc3_:int = int(this._pvpAwardInfo.readUnsignedInt());
         var _loc4_:int = int(this._pvpAwardInfo.readUnsignedInt());
         var _loc5_:int = this._pvpAwardInfo.readInt();
         var _loc6_:int = int(this._pvpAwardInfo.readUnsignedInt());
         var _loc7_:int = int(this._pvpAwardInfo.readUnsignedInt());
         var _loc8_:int = this._pvpAwardInfo.readInt();
         var _loc9_:int = this._pvpAwardInfo.readInt();
         if(_loc9_ == 1)
         {
            _loc10_ = "恭喜你，获得了本场乱武的胜利。<br/>";
            _loc11_ = 5;
         }
         else if(_loc9_ == 2)
         {
            _loc10_ = "很遗憾，你在本场乱武中失败了。<br/>";
            _loc11_ = 1;
         }
         else
         {
            _loc10_ = "时间到，本场比赛以平局告终。<br/>";
            _loc11_ = 3;
         }
         _loc10_ += "<font color=\'#FF0000\'>经验+" + _loc6_ + "<br/>";
         _loc10_ = _loc10_ + ("功夫豆+" + _loc4_ + "<br/>");
         if(_loc9_ == 1)
         {
            _loc10_ += "功勋*10<br/>";
         }
         _loc10_ += "乱武勋章*" + _loc11_ + "</font>";
         AlertManager.showSimpleAlarm(_loc10_);
      }
      
      override public function onWinner() : void
      {
         var element:UserInfo = null;
         var state:uint = 0;
         var pvpType:int = 0;
         for each(element in _readyInfo.roles)
         {
            if(element.userID != MainManager.actorID && element.troop == MainManager.actorInfo.troop)
            {
               if(ItemManager.getItemCount(1410037) > 0 && element.taskTeamFightItemID == 1410035)
               {
                  TasksManager.dispatchActionEvent(TaskActionEvent.TASK_MAPCOLLECT,"TaskTeamFight");
               }
               else if(ItemManager.getItemCount(1410035) > 0 && element.taskTeamFightItemID == 1410037)
               {
                  TasksManager.dispatchActionEvent(TaskActionEvent.TASK_MAPCOLLECT,"TaskTeamFight");
               }
            }
         }
         super.onWinner();
         if(this.checkUnNomalFightEnd())
         {
            if(this._pvpAwardInfo.length >= 28)
            {
               this._pvpAwardInfo.position = 0;
               pvpType = int(this._pvpAwardInfo.readUnsignedInt());
               state = this._pvpAwardInfo.readUnsignedInt();
               if(pvpType == PvpTypeConstantUtil.PVP_MULTI_GROUP_THREE)
               {
                  this.specialHandleForPvp3(this._pvpAwardInfo);
               }
               else if(pvpType == PvpTypeConstantUtil.PVP_MULIT_GROUP_CITY)
               {
                  AlertManager.showSimpleAlarm("恭喜你，获得了本场乱武的胜利。<br/>获得了2点积分。");
               }
               else if(pvpType == PvpTypeConstantUtil.PVP_SAN_GUO_CHI_BI)
               {
                  AlertManager.showSimpleAlarm("恭喜小侠士赢的了此次赤壁之战，获得了20功勋！");
               }
            }
            else
            {
               state = this._pvpAwardInfo.readUnsignedInt();
            }
            this._pkResultMc = UIManager.getMovieClip("UI_resultPKFight");
            LayerManager.topLevel.addChild(this._pkResultMc);
            DisplayUtil.align(this._pkResultMc,null,AlignType.MIDDLE_CENTER);
            this.updateStatus(state);
            this.timeInteval = setTimeout(function():void
            {
               clearTimeout(timeInteval);
               timeInteval = 0;
               DisplayUtil.removeForParent(_pkResultMc);
               _pkResultMc = null;
            },50000);
         }
         else
         {
            this.showAwardPanel();
         }
         FightOperatePanel.instance.onShow();
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_PVP_WIN,_pvpID + StringConstants.SIGN + MapManager.currentMap.info.id);
         if(TasksManager.hasActionListener(TaskActionEvent.TASK_PVP_WIN,0 + StringConstants.SIGN + MapManager.currentMap.info.id))
         {
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_PVP_WIN,0 + StringConstants.SIGN + MapManager.currentMap.info.id);
         }
         if(TasksManager.hasActionListener(TaskActionEvent.TASK_PVP_WIN,0 + StringConstants.SIGN + 0))
         {
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_PVP_WIN,0 + StringConstants.SIGN + 0);
         }
         if(_pvpID == 9)
         {
            ModuleManager.destroy("WuLinAwardInfoPanel");
            FightManager.quit();
         }
      }
      
      override public function onReason(param1:uint = 0) : void
      {
         var pvpType:int = 0;
         var reason:uint = param1;
         super.onReason(reason);
         TasksManager.dispatchParamsEvent(TaskActionEvent.TASK_PVP_UNWIN,_pvpID + StringConstants.SIGN + MapManager.currentMap.info.id);
         if(this.checkUnNomalFightEnd())
         {
            this._pkResultMc = UIManager.getMovieClip("UI_resultPKFight");
            this._pkResultMc.gotoAndStop(5);
            LayerManager.topLevel.addChild(this._pkResultMc);
            DisplayUtil.align(this._pkResultMc,null,AlignType.MIDDLE_CENTER);
            if(Boolean(this._pvpAwardInfo) && this._pvpAwardInfo.length >= 28)
            {
               this._pvpAwardInfo.position = 0;
               pvpType = int(this._pvpAwardInfo.readUnsignedInt());
               if(pvpType == PvpTypeConstantUtil.PVP_MULTI_GROUP_THREE)
               {
                  this.specialHandleForPvp3(this._pvpAwardInfo);
               }
               else if(pvpType == PvpTypeConstantUtil.PVP_MULIT_GROUP_CITY)
               {
                  AlertManager.showSimpleAlarm("很遗憾，你在本场乱武中失败了。<br/>获得了1点积分。");
               }
            }
            this.timeInteval = setTimeout(function():void
            {
               clearTimeout(timeInteval);
               timeInteval = 0;
               DisplayUtil.removeForParent(_pkResultMc);
               _pkResultMc = null;
            },50000);
         }
         else
         {
            this.showAwardPanel();
         }
         if(_pvpID == 9)
         {
            ModuleManager.destroy("WuLinAwardInfoPanel");
            FightManager.quit();
         }
      }
      
      private function showAwardPanel() : void
      {
         if(FightGroupManager.instance.groupId == 0 || FightGroupManager.instance.pvpTypeIndex != PvpTypeConstantUtil.GROUP_QUICK_PVP)
         {
            if(FightGroupManager.instance.pvpTypeIndex != PvpTypeConstantUtil.FIGHT_TOGETHER_PVP_TEAM && _pvpID != PvpTypeConstantUtil.BOX_HUNT_PVP && FightGroupManager.instance.pvpTypeIndex != PvpTypeConstantUtil.MULTI_PVP_VIOLENCE_QL && FightGroupManager.instance.pvpTypeIndex != PvpTypeConstantUtil.MULTI_PVP_VIOLENCE_BH && FightGroupManager.instance.pvpTypeIndex != PvpTypeConstantUtil.MULTI_PVP_VIOLENCE_XW && FightGroupManager.instance.pvpTypeIndex != PvpTypeConstantUtil.MULTI_PVP_VIOLENCE_ZQ)
            {
               ModuleManager.turnModule(ClientConfig.getAppModule("PvpAwardPanel"),"正在加载计分面板...",this._pvpAwardInfo);
            }
         }
      }
      
      private function onPvpAward(param1:SocketEvent) : void
      {
         this._pvpAwardInfo = param1.data as ByteArray;
      }
      
      private function updateStatus(param1:uint) : void
      {
         var _loc2_:ByteArray = null;
         this._pkResultMc.gotoAndStop(param1);
         if(param1 < 5)
         {
            this._pkResultMc.gotoAndStop(1);
            if(TasksManager.hasCommonListener(TaskCommonEvent.TASK_PVP_STATUS))
            {
               _loc2_ = new ByteArray();
               _loc2_.writeUnsignedInt(param1);
               _loc2_.writeUnsignedInt(_pvpID);
               TasksManager.dispatchCommonEvent(TaskCommonEvent.TASK_PVP_STATUS,_loc2_);
            }
            TasksManager.dispatchCommonEvent(TaskCommonEvent.TASK_FIGHTPVP_WIN,_pvpID);
         }
         else
         {
            this._pkResultMc.gotoAndStop(2);
         }
         if(param1 == 1)
         {
            TasksManager.dispatchCommonEvent(TaskCommonEvent.TASK_FIGHTPVP_PERFECT_WIN,_pvpID);
         }
      }
      
      private function checkUnNomalFightEnd() : Boolean
      {
         if(SinglePkManager.instance.roomID != 0 && SinglePkManager.instance.isApplyPvP == false)
         {
            return true;
         }
         if(MapManager.currentMap.info.id == 1093901)
         {
            return true;
         }
         if(MapManager.currentMap.info.id == 1094101)
         {
            return true;
         }
         return false;
      }
      
      private function onCountDown(param1:SocketEvent) : void
      {
         resLoader.destroyPvpTransition();
         fightInit();
         FightCountDown.play();
      }
   }
}

