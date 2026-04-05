package com.gfp.app.fight.pvai
{
   import com.gfp.app.control.WuLinFightControl;
   import com.gfp.app.fight.FightCountDown;
   import com.gfp.app.fight.FightEntry;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.FightOperatePanel;
   import com.gfp.app.fight.PvpEntry;
   import com.gfp.app.fight.SinglePkManager;
   import com.gfp.app.manager.FightGroupManager;
   import com.gfp.app.xmlConfig.PlayerNameXmlInfo;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.BaseAction;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.config.xml.PlayerOrgeXMLInfo;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskCommonEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.fight.FightReadyInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.SpriteModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import com.gfp.core.utils.SpriteType;
   import com.gfp.core.utils.StringConstants;
   import com.gfp.core.utils.TroopType;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class PvaiEntry extends FightEntry
   {
      
      private static var _instance:PvaiEntry;
      
      private var _pvpAwardInfo:ByteArray;
      
      private var timeInteval:int = 0;
      
      private var _pkResultMc:MovieClip;
      
      public function PvaiEntry()
      {
         super();
      }
      
      public static function get instance() : PvaiEntry
      {
         if(_instance == null)
         {
            _instance = new PvaiEntry();
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
      
      override public function setup(param1:FightReadyInfo) : void
      {
         var _loc4_:UserInfo = null;
         var _loc5_:UserInfo = null;
         _mapType = MapType.PVAI;
         super.setup(param1);
         var _loc2_:Array = _readyInfo.ogres;
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            if(SpriteModel.getSpriteType(_loc4_.roleType) == SpriteType.PLAYER_OGRE)
            {
               _loc2_.splice(_loc3_,1);
               _loc3_--;
               if(!_loc4_.nick)
               {
                  _loc4_.nick = PlayerNameXmlInfo.getRandName();
               }
               _loc4_.userID = _loc4_.roleType;
               _loc4_.roleType = PlayerOrgeXMLInfo.getPlayerType(_loc4_.userID);
               _loc5_ = PlayerOrgeXMLInfo.getPlayerOrgeInfo(_loc4_.userID);
               _loc4_.isAdvanced = _loc5_.quality >= 1;
               _loc4_.isSuperAdvc = _loc5_.quality >= 2;
               _loc4_.isTurnBack = _loc5_.quality >= 3;
               _loc4_.troop = TroopType.PLAYER_PvP;
               _readyInfo.roles.push(_loc4_);
            }
            _loc3_++;
         }
         _resLoader.loadPvP(_readyInfo.roles,_readyInfo.ogres);
         SocketConnection.addCmdListener(CommandID.PVP_AWARD,this.onPvpAward);
         SocketConnection.addCmdListener(CommandID.FIGHT_COUNT_DOWN,this.onCountDown);
      }
      
      override protected function onBegin(param1:SocketEvent) : void
      {
         var _loc2_:WuLinFightControl = null;
         super.onBegin(param1);
         MainManager.openOperate();
         if(this.pvpID == 9)
         {
            _loc2_ = WuLinFightControl.instance;
            if(_loc2_.round > 0)
            {
               ModuleManager.turnAppModule("WuLinAwardInfoPanel","",_loc2_.applyBadge + "|" + _loc2_.winBadge + "|" + _loc2_.failBadge + "|" + _loc2_.luckyBadge);
            }
         }
         if(this.pvpID == 13)
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
      
      override public function onWinner() : void
      {
         var element:UserInfo = null;
         var state:uint = 0;
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
            state = this._pvpAwardInfo.readUnsignedInt();
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
            },5000);
         }
         else
         {
            this.showAwardPanel();
         }
         FightOperatePanel.instance.onShow();
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_PVP_WIN,this.pvpID + StringConstants.SIGN + 0);
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_PVP_WIN,this.pvpID + StringConstants.SIGN + MapManager.currentMap.info.id);
         if(TasksManager.hasActionListener(TaskActionEvent.TASK_PVP_WIN,0 + StringConstants.SIGN + MapManager.currentMap.info.id))
         {
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_PVP_WIN,0 + StringConstants.SIGN + MapManager.currentMap.info.id);
         }
         if(TasksManager.hasActionListener(TaskActionEvent.TASK_PVP_WIN,0 + StringConstants.SIGN + 0))
         {
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_PVP_WIN,0 + StringConstants.SIGN + 0);
         }
         if(this.pvpID == 9)
         {
            ModuleManager.destroy("WuLinAwardInfoPanel");
            FightManager.quit();
         }
      }
      
      override public function onReason(param1:uint = 0) : void
      {
         var reason:uint = param1;
         super.onReason(reason);
         TasksManager.dispatchParamsEvent(TaskActionEvent.TASK_PVP_UNWIN,this.pvpID + StringConstants.SIGN + MapManager.currentMap.info.id);
         if(this.checkUnNomalFightEnd())
         {
            this._pkResultMc = UIManager.getMovieClip("UI_resultPKFight");
            this._pkResultMc.gotoAndStop(5);
            LayerManager.topLevel.addChild(this._pkResultMc);
            DisplayUtil.align(this._pkResultMc,null,AlignType.MIDDLE_CENTER);
            this.timeInteval = setTimeout(function():void
            {
               clearTimeout(timeInteval);
               timeInteval = 0;
               DisplayUtil.removeForParent(_pkResultMc);
               _pkResultMc = null;
            },5000);
         }
         else
         {
            this.showAwardPanel();
         }
         if(this.pvpID == 9)
         {
            ModuleManager.destroy("WuLinAwardInfoPanel");
            FightManager.quit();
         }
      }
      
      private function showAwardPanel() : void
      {
         if(FightGroupManager.instance.groupId == 0 || FightGroupManager.instance.pvpTypeIndex != PvpTypeConstantUtil.GROUP_QUICK_PVP)
         {
            if(FightGroupManager.instance.pvpTypeIndex != PvpTypeConstantUtil.FIGHT_TOGETHER_PVP_TEAM && this.pvpID != PvpTypeConstantUtil.BOX_HUNT_PVP && FightGroupManager.instance.pvpTypeIndex != PvpTypeConstantUtil.MULTI_PVP_VIOLENCE_QL && FightGroupManager.instance.pvpTypeIndex != PvpTypeConstantUtil.MULTI_PVP_VIOLENCE_BH && FightGroupManager.instance.pvpTypeIndex != PvpTypeConstantUtil.MULTI_PVP_VIOLENCE_XW && FightGroupManager.instance.pvpTypeIndex != PvpTypeConstantUtil.MULTI_PVP_VIOLENCE_ZQ)
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
               _loc2_.writeUnsignedInt(this.pvpID);
               TasksManager.dispatchCommonEvent(TaskCommonEvent.TASK_PVP_STATUS,_loc2_);
            }
            TasksManager.dispatchCommonEvent(TaskCommonEvent.TASK_FIGHTPVP_WIN,this.pvpID);
         }
         else
         {
            this._pkResultMc.gotoAndStop(2);
         }
         if(param1 == 1)
         {
            TasksManager.dispatchCommonEvent(TaskCommonEvent.TASK_FIGHTPVP_PERFECT_WIN,this.pvpID);
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
      
      private function get pvpID() : uint
      {
         return PvpEntry.pvpID;
      }
      
      override public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.PVP_AWARD,this.onPvpAward);
         SocketConnection.removeCmdListener(CommandID.FIGHT_COUNT_DOWN,this.onCountDown);
         super.destroy();
         if(this._pkResultMc)
         {
            DisplayUtil.removeForParent(this._pkResultMc);
            this._pkResultMc = null;
         }
         SinglePkManager.instance.destroy();
      }
   }
}

