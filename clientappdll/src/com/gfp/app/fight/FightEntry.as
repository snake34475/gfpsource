package com.gfp.app.fight
{
   import com.gfp.app.feature.LeftTimeUI;
   import com.gfp.app.fight.pvai.PvaiLoader;
   import com.gfp.app.manager.FightGroupManager;
   import com.gfp.app.miniMap.MiniMap;
   import com.gfp.app.time.TimerComponents;
   import com.gfp.app.toolBar.CityToolBar;
   import com.gfp.app.toolBar.FightToolBar;
   import com.gfp.app.toolBar.GroupHeadInfoEntry;
   import com.gfp.app.toolBar.HeadHeroSoulPanel;
   import com.gfp.app.toolBar.HeadOgrePanel;
   import com.gfp.app.toolBar.HeadSelfPanel;
   import com.gfp.app.toolBar.HeadSummonPanel;
   import com.gfp.app.toolBar.TootalExpBar;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.keyboard.KeyFuncProcess;
   import com.gfp.core.buff.ActorOperateBuffManager;
   import com.gfp.core.cache.CommonCache;
   import com.gfp.core.cache.EffectBitmapCache;
   import com.gfp.core.cache.EffectCache;
   import com.gfp.core.cache.SoundCache;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.SkillXMLInfo;
   import com.gfp.core.config.xml.TollgateXMLInfo;
   import com.gfp.core.events.ActivitySuggestionEvents;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.CDInfo;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.info.SummonShenTongInfo;
   import com.gfp.core.info.SummonShenTongStepInfo;
   import com.gfp.core.info.TollgateInfo;
   import com.gfp.core.info.fight.FightAwardInfo;
   import com.gfp.core.info.fight.FightReadyInfo;
   import com.gfp.core.info.fight.SkillLevelInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.CDManager;
   import com.gfp.core.manager.ConvertMovieClipManager;
   import com.gfp.core.manager.GodManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.SummonShenTongManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.FightMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.SummonModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.sound.SoundManager;
   import com.gfp.core.ui.FightBloodBar;
   import com.gfp.core.ui.loading.LoadingType;
   import com.gfp.core.utils.FightMode;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.ds.HashMap;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.Tick;
   
   public class FightEntry
   {
      
      public static var rebotFightTypes:Array = [PvpTypeConstantUtil.PVP_CONQUER_LAND1,PvpTypeConstantUtil.PVP_CONQUER_LAND2,PvpTypeConstantUtil.PVP_CONQUER_LAND3,PvpTypeConstantUtil.PVP_CONQUER_LAND4,PvpTypeConstantUtil.PVP_CONQUER_LAND5,PvpTypeConstantUtil.PVP_WU_LING_FENG_YUN_FIGHT,PvpTypeConstantUtil.PVP_SIDE_YABIAO,PvpTypeConstantUtil.PVP_JIE_BIAO,PvpTypeConstantUtil.PVP_KILL_POINT,PvpTypeConstantUtil.GET_PEACH];
      
      public static var isPlayKOMovie:Boolean = true;
      
      protected var _readyInfo:FightReadyInfo;
      
      protected var _resLoader:FightLoader;
      
      protected var _mapType:int;
      
      protected var _newMapID:uint;
      
      public var _awardInfo:FightAwardInfo;
      
      protected var _firstEntry:Boolean = false;
      
      protected var _stageID:uint;
      
      protected var _reasonCode:int;
      
      protected var _teamMemberHead:HashMap;
      
      protected var _fightEndEffect:FightEndEffect;
      
      public var isStart:Boolean = false;
      
      private var _leftTime:LeftTimeUI;
      
      protected var _slowTimeID:uint;
      
      public function FightEntry()
      {
         super();
      }
      
      public function setup(param1:FightReadyInfo) : void
      {
         this.isStart = true;
         FightManager.isLoadingRes = true;
         this._readyInfo = param1;
         this._newMapID = this._readyInfo.mapID;
         SocketConnection.addCmdListener(CommandID.FIGHT_READY_COMPLETE,this.onReadyComplete);
         SocketConnection.addCmdListener(CommandID.FIGHT_BEGIN,this.onBegin);
         SocketConnection.addCmdListener(CommandID.FIGHT_END,this.onEnd);
         SocketConnection.addCmdListener(CommandID.FIGHT_AWARD,this.onAward);
         SocketConnection.addCmdListener(CommandID.FIGHT_COUNT_DOWN,this.onCountDown);
         if(FightManager.fightMode == FightMode.WATCH)
         {
            this._resLoader = new WatchFightLoader();
         }
         else if(FightManager.fightMode == FightMode.PVAI)
         {
            this._resLoader = new PvaiLoader();
         }
         else
         {
            this._resLoader = new FightLoader();
         }
         this._resLoader.addEventListener(Event.COMPLETE,this.onResLoadComplete);
         this._resLoader.addWinReaSound(MainManager.roleType);
         MainManager.closeOperate();
         ConvertMovieClipManager.getInstance().disposeData();
         EffectBitmapCache.clearCache();
      }
      
      public function destroy() : void
      {
         this.isStart = false;
         if(this._readyInfo)
         {
            this._readyInfo.destroy();
            this._readyInfo = null;
         }
         this._awardInfo = null;
         SocketConnection.removeCmdListener(CommandID.FIGHT_READY_COMPLETE,this.onReadyComplete);
         SocketConnection.removeCmdListener(CommandID.FIGHT_BEGIN,this.onBegin);
         SocketConnection.removeCmdListener(CommandID.FIGHT_END,this.onEnd);
         SocketConnection.removeCmdListener(CommandID.FIGHT_AWARD,this.onAward);
         SocketConnection.removeCmdListener(CommandID.FIGHT_COUNT_DOWN,this.onCountDown);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,this.onMapComplete);
         this.clearSlow();
         this.destroyLoader();
         FightMap.destroy();
         SoundCache.clearCache();
         EffectCache.clearCache();
         CommonCache.clearFightCache();
         FightToolBar.destroy();
         MiniMap.destroy();
         HeadOgrePanel.destroy();
         HeadSummonPanel.destroy();
         HeadHeroSoulPanel.destroy();
         FightOperatePanel.destroy();
         FightGo.destroy();
         FightMonsterClear.destroy();
         if(this._firstEntry)
         {
            CityToolBar.instance.show();
            TootalExpBar.hide();
            MainManager.actorModel.destroyBloodBar();
            MainManager.actorModel.clickEnabled = true;
            MainManager.actorModel.removeEventListener(UserEvent.DIE,this.onActorDie);
            ItemManager.updateEquipDurability();
            if(FightManager.outToMapID > 0)
            {
               CityMap.instance.changeMap(FightManager.outToMapID,FightManager.outToMapType,1,FightManager.outToMapPos);
            }
            else
            {
               CityMap.instance.refMap();
            }
         }
         else
         {
            MainManager.openOperate();
         }
         FightManager.outToMapID = 0;
         FightManager.outToMapType = MapType.STAND;
         this._firstEntry = false;
         FightManager.isLoadingRes = false;
         FightManager.isAutoReasonEnd = true;
         FightManager.isAutoWinnerEnd = true;
         this._reasonCode = 0;
         FightAdded.showToolbar();
         SoundManager.bgPlayer.clear();
         SoundManager.bgPlayer.stop();
         SummonManager.clearFightInfo();
         GodManager.fightGodStageID = 0;
         FightGroupManager.instance.groupFightOver();
         FightCountDown.destroy();
         if(FightGroupManager.instance.groupId != 0)
         {
            GroupHeadInfoEntry.instance.visible = true;
         }
         else
         {
            GroupHeadInfoEntry.instance.visible = false;
         }
         if(MainManager.actorInfo.carrierID != 0)
         {
            MainManager.actorModel.changeRoleView(0);
            MainManager.actorInfo.carrierID = 0;
            KeyFuncProcess.normalAttackForbidden = false;
            KeyManager.reset();
            KeyManager.upDateSkillQuickKeys(MainManager.actorModel.info.skills);
            KeyManager.upDateItemQuickKeys(MainManager.actorInfo.items);
         }
         if(this._leftTime)
         {
            this._leftTime.destory();
            DisplayUtil.removeForParent(this._leftTime);
         }
         ConvertMovieClipManager.getInstance().disposeData();
         EffectBitmapCache.clearCache();
         ActorOperateBuffManager.instance.removeAllChangeViewBuff();
      }
      
      protected function destroyLoader() : void
      {
         if(this._resLoader)
         {
            this._resLoader.removeEventListener(Event.COMPLETE,this.onResLoadComplete);
            this._resLoader.destroy();
            this._resLoader = null;
         }
      }
      
      protected function onResLoadComplete(param1:Event) : void
      {
         this._resLoader.removeEventListener(Event.COMPLETE,this.onResLoadComplete);
         this.startChangeMap();
      }
      
      private function startChangeMap() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,this.onMapComplete);
         FightMap.instance.changeMap(this._newMapID,this._mapType,LoadingType.NO_ALL);
      }
      
      protected function onMapComplete(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,this.onMapComplete);
         SocketConnection.send(CommandID.FIGHT_READY_COMPLETE);
      }
      
      protected function onReadyComplete(param1:SocketEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.readUnsignedInt();
            _loc6_ = _loc2_.readUnsignedInt();
            if(_loc5_ <= 10)
            {
               switch(_loc5_)
               {
                  case 4:
                     MainManager.actorInfo.huntAward -= _loc6_;
               }
            }
            else
            {
               ItemManager.removeItem(_loc5_,_loc6_);
            }
            _loc4_++;
         }
         CDManager.skillCD.removeAll();
         CDManager.itemCD.removeAll();
         Logger.info(this,param1.headInfo.userID + " 对战准备");
      }
      
      protected function onBegin(param1:SocketEvent) : void
      {
         if(this._resLoader)
         {
            this._resLoader.destroyLoading();
         }
         Logger.info(this,"对战开始" + "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
         MainManager.openOperate();
         MainManager.actorModel.setSummonVisible(true);
         MainManager.actorModel.endBuff(93);
         FightManager.isWinTheFight = false;
         FightManager.actorDiedCount = 0;
         this.checkShowCount();
      }
      
      protected function initSkillCD() : void
      {
         var data:Vector.<SummonShenTongInfo>;
         var cd:CDInfo = null;
         var activitySkills:Vector.<KeyInfo> = null;
         var length:int = 0;
         var index:int = 0;
         var i:int = 0;
         var step:SummonShenTongStepInfo = null;
         var level:SkillLevelInfo = null;
         KeyManager.skillQuickKeys.forEach(function(param1:uint, param2:int, param3:Vector.<uint>):void
         {
            var _loc4_:KeyInfo = KeyManager.getSingleInfoForFuncID(param1);
            var _loc5_:SkillLevelInfo = SkillXMLInfo.getLevelInfo(_loc4_.dataID,_loc4_.lv);
            if((Boolean(_loc5_)) && Boolean(_loc5_.cdFlag))
            {
               if(_loc5_.cd > 0)
               {
                  cd = new CDInfo();
                  cd.id = _loc4_.dataID;
                  cd.runTime = _loc5_.duration;
                  cd.cdTime = _loc5_.cd;
                  CDManager.skillCD.add(cd);
               }
            }
         });
         data = SummonShenTongManager.getData();
         if(data)
         {
            activitySkills = SummonShenTongManager.getActiveSkill();
            length = int(data.length);
            i = 0;
            while(i < length)
            {
               if(Boolean(data[i]) && Boolean(data[i].getMatchShenTong()))
               {
                  step = data[i].getMatchShenTong();
                  level = SkillXMLInfo.getLevelInfo(step.skillId,step.skillLevel);
                  if(Boolean(level) && Boolean(level.cdFlag))
                  {
                     if(level.cd > 0)
                     {
                        cd = new CDInfo();
                        cd.id = step.skillId;
                        cd.runTime = level.duration;
                        cd.cdTime = level.cd;
                        CDManager.skillCD.add(cd);
                     }
                  }
               }
               i++;
            }
         }
      }
      
      private function checkShowCount() : void
      {
         var _loc1_:TollgateInfo = TollgateXMLInfo.getTollgateInfoById(this._stageID);
         if(Boolean(_loc1_) && Boolean(_loc1_.countDownTime > 0) && Boolean(_loc1_.showCount))
         {
            if(_loc1_.leftUrl)
            {
               this._leftTime = new LeftTimeUI(_loc1_.countDownTime * 1000,null,_loc1_.leftUrl);
            }
            else
            {
               this._leftTime = new LeftTimeUI(_loc1_.countDownTime * 1000);
            }
            if(_loc1_.leftRect)
            {
               this._leftTime.x = _loc1_.leftRect.x;
               this._leftTime.y = _loc1_.leftRect.y;
            }
            else
            {
               this._leftTime.x = LayerManager.stageWidth / 2;
               this._leftTime.y = 150;
            }
            LayerManager.topLevel.addChild(this._leftTime);
         }
      }
      
      protected function fightInit() : void
      {
         if(!this._firstEntry)
         {
            this._firstEntry = true;
            CityMap.instance.clear();
            CityToolBar.instance.hide();
            TootalExpBar.show();
            FightAdded.hideToolbar();
            FightToolBar.instance.show(this._mapType,this._stageID);
            MiniMap.instance.init(0);
            MiniMap.instance.show();
            HeadSelfPanel.instance.init(MainManager.actorModel);
            HeadSelfPanel.instance.show();
            HeadOgrePanel.instance.start();
            FightOperatePanel.instance.show(this._mapType,TollgateXMLInfo.getType(this._stageID));
            MainManager.actorModel.clickEnabled = false;
            MainManager.actorModel.addEventListener(UserEvent.DIE,this.onActorDie);
            if(this._mapType != MapType.PVP)
            {
            }
         }
         FightMap.instance.initMap();
         MainManager.actorModel.setBloodBar(new FightBloodBar(FightBloodBar.COLOR_SELF));
         MainManager.actorModel.showBloodBar();
         FightManager.isLoadingRes = false;
         if(FightGroupManager.instance.groupBtlId != 0)
         {
            GroupHeadInfoEntry.instance.visible = true;
         }
         else
         {
            GroupHeadInfoEntry.instance.visible = false;
         }
         if(SummonManager.getActorSummonInfo().fightSummonInfo != null)
         {
            SummonManager.getActorSummonInfo().fightSummonInfo.rage = 0;
            HeadSummonPanel.instance.setRage(0);
         }
         FightToolBar.instance.clearCD();
      }
      
      protected function onEnd(param1:SocketEvent) : void
      {
         var data:ByteArray;
         var winner:uint;
         var reason:uint;
         var e:SocketEvent = param1;
         if(Boolean(MainManager.actorModel.fightSummonModel) && Boolean(MainManager.actorModel.fightSummonModel.info))
         {
            MainManager.actorModel.fightSummonModel.execStandAction(false);
            MainManager.actorModel.fightSummonModel.fightEndFollowMaster();
         }
         if(this._resLoader)
         {
            this._resLoader.destroyPvpTransition();
         }
         SoundManager.bgPlayer.stop();
         SummonManager.clearFightInfo();
         data = e.data as ByteArray;
         data.position = 0;
         winner = data.readUnsignedInt();
         reason = data.readUnsignedInt();
         this._reasonCode = reason;
         if(reason == 6)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.ACTOR_STATUS_COLLECTION[1],function():void
            {
               FightManager.quit();
            });
            return;
         }
         MainManager.closeOperate(false,false);
         if(this._firstEntry)
         {
            if(winner == MainManager.actorID)
            {
               if(FightManager.isAutoWinnerEnd)
               {
                  this.startSlow(winner,reason,true);
               }
               FightManager.isAutoWinnerEnd = true;
               FightManager.isWinTheFight = true;
               FightManager.instance.dispatchEvent(new FightEvent(FightEvent.WINNER,this._awardInfo));
               FightManager.instance.dispatchEvent(new ActivitySuggestionEvents(ActivitySuggestionEvents.MAP_COMPLETE,MapManager.currentMap.info.id.toString()));
               TimerComponents.instance.stop();
            }
            else
            {
               FightManager.isWinTheFight = false;
               if(FightManager.isAutoReasonEnd)
               {
                  if(reason == 0)
                  {
                     this.startSlow(winner,MainManager.actorID);
                  }
                  else
                  {
                     this.startSlow(winner,reason);
                  }
               }
               if(this._stageID == 475)
               {
                  FightManager.instance.dispatchEvent(new FightEvent(FightEvent.WINNER,this._awardInfo));
               }
               if(this._stageID != 475)
               {
                  FightManager.isAutoReasonEnd = true;
                  FightManager.instance.dispatchEvent(new FightEvent(FightEvent.REASON,this._awardInfo));
               }
            }
         }
         else
         {
            FightManager.quit();
         }
      }
      
      protected function onActorDie(param1:UserEvent) : void
      {
         ++FightManager.actorDiedCount;
         FightManager.actorLifeTime = TimerComponents.instance.timeCost;
      }
      
      public function onActorRevive() : void
      {
         MainManager.actorModel.actionManager.clear();
         MainManager.actorModel.execStandAction();
         MainManager.actorModel.showBloodBar();
         MainManager.openOperate();
         SoundManager.bgPlayer.play();
      }
      
      public function onSummonRevive(param1:int) : void
      {
         var _loc2_:SummonModel = SummonManager.getSummonModelByStageId(param1);
         if(_loc2_)
         {
            _loc2_.actionManager.clear();
            _loc2_.execStandAction(false);
            HeadSummonPanel.instance.clearCutDown();
            _loc2_.fightWord();
         }
      }
      
      protected function clearSlow() : void
      {
         clearTimeout(this._slowTimeID);
         Tick.timeScaleAll = 1;
         this.destroyFightEndEffect();
      }
      
      protected function startSlow(param1:uint = 0, param2:uint = 0, param3:Boolean = false) : void
      {
         if(this._fightEndEffect == null && isPlayKOMovie && MainManager.actorInfo.hp <= 0)
         {
            this._fightEndEffect = new FightEndEffect();
            this._fightEndEffect.init(param3);
         }
         Tick.timeScaleAll = 0.2;
         clearTimeout(this._slowTimeID);
         this._slowTimeID = setTimeout(this.onNoneSlow,5000,param1,param2);
         SoundManager.bgPlayer.stop();
         if(param1 == MainManager.actorID)
         {
            SoundManager.playSound(ClientConfig.getSoundWinner(MainManager.roleType),0,false);
            if(this._stageID == 593)
            {
               ActivityExchangeTimesManager.updataTimes(3255,ActivityExchangeTimesManager.getTimes(3255) + 25);
            }
            else if(this._stageID == 594)
            {
               ActivityExchangeTimesManager.updataTimes(3255,ActivityExchangeTimesManager.getTimes(3255) + 65);
            }
         }
         else
         {
            SoundManager.playSound(ClientConfig.getSoundReason(MainManager.roleType),0,false);
         }
      }
      
      protected function onNoneSlow(param1:uint, param2:uint) : void
      {
         Tick.timeScaleAll = 1;
         this.destroyFightEndEffect();
         MainManager.actorModel.actionManager.clear();
         if(param1 == MainManager.actorID)
         {
            this.winnerFun(param1,param2);
         }
         else
         {
            this.reasonFun(param1,param2);
         }
      }
      
      protected function winnerFun(param1:uint, param2:uint) : void
      {
         this._slowTimeID = setTimeout(this.onWinner,3000);
         if(this._stageID == 593)
         {
            AlertManager.showSimpleAlarm("恭喜小侠士完成本次历练，获得25点历练值！");
         }
         else if(this._stageID == 594)
         {
            AlertManager.showSimpleAlarm("恭喜小侠士完成本次历练，获得65点历练值！");
         }
         else if(this._stageID == 1118)
         {
            AlertManager.showSimpleAlarm("恭喜小侠士完成本次历练，获得10点毁灭值！");
         }
      }
      
      protected function reasonFun(param1:uint, param2:uint) : void
      {
         this._slowTimeID = setTimeout(this.onReason,3000,param2);
      }
      
      public function onWinner() : void
      {
         MainManager.openOperate();
         FightOperatePanel.instance.onShow();
      }
      
      private function destroyFightEndEffect() : void
      {
         if(this._fightEndEffect)
         {
            this._fightEndEffect.destroy();
            this._fightEndEffect = null;
         }
      }
      
      private function onCountDown(param1:SocketEvent) : void
      {
      }
      
      public function onReason(param1:uint = 0) : void
      {
         FightOperatePanel.instance.onShow();
      }
      
      protected function onAward(param1:SocketEvent) : void
      {
         this._awardInfo = param1.data as FightAwardInfo;
         this._awardInfo.stageId = this._stageID;
      }
      
      protected function setStageID(param1:uint) : void
      {
         this._stageID = param1;
         MainManager.pveTollgateId = this._stageID;
      }
      
      public function getStageID() : uint
      {
         return this._stageID;
      }
      
      public function get resLoader() : FightLoader
      {
         return this._resLoader;
      }
      
      public function get fightReadyInfo() : FightReadyInfo
      {
         return this._readyInfo;
      }
   }
}

