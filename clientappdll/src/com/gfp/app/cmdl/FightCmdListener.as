package com.gfp.app.cmdl
{
   import com.gfp.app.cityWar.CityWarPkController;
   import com.gfp.app.fight.CustomDataEvent;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.FightWaitPanel;
   import com.gfp.app.fight.PvpEntry;
   import com.gfp.app.fight.SinglePkManager;
   import com.gfp.app.manager.ChallengeSummonManager;
   import com.gfp.app.manager.CityWarManager;
   import com.gfp.app.manager.DataProxy;
   import com.gfp.app.manager.DpsManager;
   import com.gfp.app.manager.EgoisticManager;
   import com.gfp.app.manager.EliminationFightManager;
   import com.gfp.app.manager.FightGroupManager;
   import com.gfp.app.manager.GroupViolenceMatchManager;
   import com.gfp.app.manager.TeamPvp3PeopleFightManager;
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.app.user.UserInfoController;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.TollgateXMLInfo;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.info.fight.FightAnswerInfo;
   import com.gfp.core.info.fight.FightInviteInfo;
   import com.gfp.core.info.fight.FightReadyInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.SystemMessageManager;
   import com.gfp.core.manager.alert.AlertInfo;
   import com.gfp.core.manager.alert.AlertType;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.popup.ModalType;
   import com.gfp.core.utils.FightMode;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.net.SharedObject;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class FightCmdListener extends BaseBean
   {
      
      private var _getSummonTime:int;
      
      public function FightCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.FIGHT_INVITE_INFORM,this.onInviteInform);
         SocketConnection.addCmdListener(CommandID.FIGHT_INVITE_ANSWER,this.onInviteAnswer);
         SocketConnection.addCmdListener(CommandID.FIGHT_READY,this.onReady);
         SocketConnection.addCmdListener(CommandID.AI_FIGHT_READY,this.onAIReady);
         SocketConnection.addCmdListener(CommandID.STAGE_QUIT,this.onQuit);
         SocketConnection.addCmdListener(CommandID.STAGE_SUMMON_CALL_ENABLED,this.onSummonEnabled);
         this.resetKey();
         finish();
      }
      
      private function resetKey() : void
      {
         KeyManager.reset();
         KeyManager.upDateSkillQuickKeys(MainManager.actorInfo.skills);
         KeyManager.upDateItemQuickKeys(MainManager.actorInfo.items);
         ChallengeSummonManager.instance.setup();
      }
      
      private function onInviteInform(param1:SocketEvent) : void
      {
         var _loc2_:FightInviteInfo = param1.data as FightInviteInfo;
         FightManager.instance.add(_loc2_);
      }
      
      private function onInviteAnswer(param1:SocketEvent) : void
      {
         var data:FightAnswerInfo = null;
         var aInfo:AlertInfo = null;
         var e:SocketEvent = param1;
         data = e.data as FightAnswerInfo;
         if(data.result == 0)
         {
            if(data.userID != MainManager.actorID)
            {
               aInfo = new AlertInfo();
               aInfo.type = AlertType.ALARM;
               aInfo.str = TextFormatUtil.getEventText(TextFormatUtil.getRedText(data.nickName),data.userID.toString()) + "拒绝了你的邀请";
               aInfo.linkFun = function():void
               {
                  UserInfoController.showForID(data.userID);
               };
               AlertManager.showForInfo(aInfo);
            }
         }
         else if(data.result != 1)
         {
            if(data.result == 2)
            {
               AlertManager.showSimpleAlarm(AppLanguageDefine.TIME_CHARACTER_COLLECTION[0]);
            }
            else if(data.result == 4)
            {
               AlertManager.showSimpleAlarm(AppLanguageDefine.ACTOR_STATUS_COLLECTION[0]);
            }
         }
         FightWaitPanel.hideSelectPanel();
         FightWaitPanel.hideWaitPanel();
      }
      
      private function onReady(param1:SocketEvent) : void
      {
         var info:FightReadyInfo = null;
         var timer:uint = 0;
         var e:SocketEvent = param1;
         PvpEntry.againEntry = false;
         FightWaitPanel.hideWaitPanel();
         SinglePkManager.instance.clearInviteBattery();
         if(FightReadyInfo(e.data).mapID == GroupViolenceMatchManager.VIOLENCE_MAP_ID)
         {
            GroupViolenceMatchManager.instance.operateWaitFiveSecond(e.data as FightReadyInfo);
         }
         else
         {
            info = e.data as FightReadyInfo;
            if(Boolean(info) && info.mapID == 1102001)
            {
               timer = setTimeout(function():void
               {
                  clearTimeout(timer);
                  FightManager.setup(info);
               },5000);
               TeamPvp3PeopleFightManager.getInstance().dispatchEvent(new CustomDataEvent(CustomDataEvent.FIGHT_TEAM_THREE_START));
            }
            else
            {
               FightManager.setup(info);
            }
         }
      }
      
      private function onAIReady(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         PvpEntry.againEntry = false;
         FightWaitPanel.hideWaitPanel();
         SinglePkManager.instance.clearInviteBattery();
         FightManager.fightMode = FightMode.PVAI;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         FightManager.setup(new FightReadyInfo(_loc2_));
      }
      
      private function onQuit(param1:SocketEvent) : void
      {
         var so:SharedObject = null;
         var e:SocketEvent = param1;
         var data:ByteArray = e.data as ByteArray;
         var reason:uint = data.readUnsignedByte();
         var fightResult:uint = data.readUnsignedInt();
         var punish:uint = data.readUnsignedInt();
         var doubleExpTimeLeft:uint = data.readUnsignedInt();
         var fumoPointsTotal:uint = data.readUnsignedInt();
         MainManager.doubleExpTimeLeft = doubleExpTimeLeft;
         MainManager.actorInfo.huntAward = fumoPointsTotal;
         if(reason != 0)
         {
            AlertManager.show(AlertType.ALARM,AppLanguageDefine.SYSTEM_ERROR_COLLECTION[0],AppLanguageDefine.VOID,LayerManager.topLevel);
         }
         if(CityWarManager.isInCityWar())
         {
            if(FightManager.fightMode == FightMode.PVP)
            {
               if(fightResult != 0 && fightResult != 1)
               {
                  CityWarPkController.instance.backHome();
               }
            }
            else if(fightResult != 0)
            {
               CityWarPkController.instance.backHome();
            }
         }
         if(fightResult != 0 && fightResult != 1)
         {
            if(EgoisticManager.instance.startFlag)
            {
               EgoisticManager.instance.backHome();
            }
            if(Boolean(DataProxy.fightPetVo) && DataProxy.fightPetVo.startFlag)
            {
               DataProxy.fightPetVo.backHome();
            }
            if(EliminationFightManager.instance.startFlag)
            {
               EliminationFightManager.instance.backHome();
            }
         }
         if(FightManager.fightMode == FightMode.PVP)
         {
            if(PvpEntry.pvpID == PvpTypeConstantUtil.PVP_MATERIAL_PK)
            {
               ClientTempState.materialPvpWin = fightResult == 0;
            }
         }
         if(TollgateXMLInfo.LEGEND_SPECIAL.indexOf(MainManager.pveTollgateId) != -1 && FightManager.isWinTheFight)
         {
            MapManager.setMapEndAction("open:OpenCansPanel");
         }
         if(MainManager.actorInfo.isVip == false && ActivityExchangeTimesManager.getTimes(8789) <= 0 && MainManager.actorInfo.lv <= 45 && int(TollgateXMLInfo.getMinLv(MainManager.pveTollgateId)) > 10)
         {
            ActivityExchangeTimesManager.updataTimesByOnce(8789);
         }
         if(MainManager.pveTollgateId > 0 && FightManager.actorDiedCount > 0 && FightManager.isWinTheFight == false && TollgateXMLInfo.getMapIDByTollgateID(MainManager.pveTollgateId) > 0)
         {
            so = SharedObject.getLocal("gf_" + MainManager.actorID + "_" + MainManager.actorInfo.createTime + "_powerless");
            if(Boolean(so.data.notAlertAgain) == false)
            {
               if(MainManager.actorInfo.lv >= 60)
               {
                  AlertManager.showSimpleAlert("小侠士，你的战斗力还有很大的提升空间哦~是否前往提升？",function(param1:Boolean):void
                  {
                     if(param1)
                     {
                        so.data.notAlertAgain = true;
                        so.flush();
                     }
                     ModuleManager.turnAppModule("TurnStrongPanel","正在加载...",{"modalType":ModalType.DARK});
                  },function(param1:Boolean):void
                  {
                     if(param1)
                     {
                        so.data.notAlertAgain = true;
                        so.flush();
                     }
                  },true);
               }
            }
         }
         FightManager.destroy();
         SummonManager.updateActorSummonVisible();
         SummonManager.clearFightInfo();
         SystemMessageManager.removeEquipRepair();
         MainManager.actorModel.buffManager.clear();
         MainManager.actorModel.speed = MainManager.actorSpeed;
         if(MainManager.actorInfo.monsterID != 0)
         {
            MainManager.actorModel.changeRoleView(MainManager.actorInfo.monsterID);
         }
         DpsManager.getInstance().clear();
         if(PvpEntry.againEntry)
         {
            SinglePkManager.instance.isApplyPvP = true;
         }
         if(punish == 1)
         {
            ActivityExchangeTimesManager.addEventListeners([2499,9032],this.hintPunish);
            ActivityExchangeTimesManager.getActivitesTimeInfo([2499,9032]);
            return;
         }
         if(FightGroupManager.instance.fightAgain)
         {
            FightGroupManager.instance.groupFightAgain();
         }
         clearTimeout(this._getSummonTime);
         this._getSummonTime = setTimeout(this.getSummonInfo,2000);
      }
      
      private function getSummonInfo() : void
      {
         if(SummonManager.getActorSummonInfo().currentSummonInfo)
         {
            SummonManager.requestListProp();
         }
      }
      
      private function onSummonEnabled(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:Boolean = _loc2_.readUnsignedInt() > 0;
         FightManager.summonCallEnabled = _loc3_;
         FightManager.instance.dispatchEvent(new FightEvent(FightEvent.SUMMON_CALL_ENABLED,_loc3_));
      }
      
      private function hintPunish(param1:DataEvent) : void
      {
         var num:int;
         var str:String = null;
         var e:DataEvent = param1;
         ActivityExchangeTimesManager.removeEventListeners([2499,9032],this.hintPunish);
         num = ActivityExchangeTimesManager.getTimes(2499) - ActivityExchangeTimesManager.getTimes(9032);
         if(num > 0)
         {
            str = "大会组委会裁定本次比武因违反公平竞赛原则被判无效，侠士需去海振兴处缴纳罚金,将无法继续参加比武！";
            AlertManager.showSimpleAlert(str,function():void
            {
               ModuleManager.closeAllModule();
               CityMap.instance.tranToNpc(10123);
            });
         }
      }
   }
}

