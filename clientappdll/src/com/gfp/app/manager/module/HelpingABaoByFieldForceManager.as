package com.gfp.app.manager.module
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.toolBar.FightToolBar;
   import com.gfp.app.toolBar.HeadSelfPanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.keyboard.KeyFuncProcess;
   import com.gfp.core.action.keyboard.KeySkillProcess;
   import com.gfp.core.behavior.ClothBehavior;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.controller.FightInteractiveController;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.FightInteractiveEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.SkillEvent;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.info.dailyActivity.SwapTimesInfo;
   import com.gfp.core.info.fight.BruiseInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.HeroSoulManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.NumberManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.ActorModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.EquipPart;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class HelpingABaoByFieldForceManager
   {
      
      private static var _originalPower:int;
      
      private static var _originalGildID:int;
      
      private static var _originalLevel:int;
      
      private static var _originalTurnBack:Boolean;
      
      private static var _originalModel:ActorModel;
      
      private static var _originalClothes:Vector.<SingleEquipInfo>;
      
      private static var _originalSkills:Vector.<KeyInfo>;
      
      private static var _originalMonster:uint;
      
      public static var curStage:int;
      
      public static var modelIDs:Array;
      
      public static const skillQuickKeys:Vector.<uint> = Vector.<uint>([10,28,13,26,32,30,12]);
      
      public static const SKILL_ID:Vector.<uint> = Vector.<uint>([300801,300802,300803,300804,300805,300806,4121146]);
      
      public static const MONSTER_KING_ID:uint = 15100;
      
      public static const RECORD_MODEL_IDS:Array = [12334,12335];
      
      public function HelpingABaoByFieldForceManager()
      {
         super();
      }
      
      public static function init() : void
      {
         _originalModel = MainManager.actorModel;
         _originalTurnBack = MainManager.actorInfo.isTurnBack;
         _originalLevel = MainManager.actorInfo.lv;
         _originalPower = MainManager.actorInfo.fightPower;
         _originalClothes = MainManager.actorInfo.clothes.concat(MainManager.actorInfo.fashionClothes);
         _originalSkills = MainManager.actorInfo.skills.concat();
         _originalMonster = MainManager.actorInfo.skillMonsterID;
         FightManager.instance.addEventListener(FightEvent.BEGIN,onFightBegin);
         SocketConnection.addCmdListener(CommandID.STAGE_QUIT,onQuit);
         SocketConnection.addCmdListener(CommandID.ACTION_BRUISE,bruiseHandle);
         UserManager.addEventListener(SkillEvent.SKILL_ACTION,onCallSoulSkill);
         modelIDs = [];
      }
      
      private static function onQuit(param1:SocketEvent) : void
      {
         destroy();
      }
      
      private static function onCallSoulSkill(param1:SkillEvent) : void
      {
         if(Boolean(param1.skillID == HeroSoulManager.CALL_SOUL_SKILL_ID) && Boolean(param1.model) && param1.model.info.userID == MainManager.actorID)
         {
            if(HelpingABaoByFieldForceManager.curStage == 1426)
            {
               HelpingABaoByFieldForceManager.afterCallSoul();
            }
         }
         if(Boolean(param1.skillID == SummonManager.CALL_SUMMON_SKILL_ID) && Boolean(param1.model) && param1.model.info.userID == MainManager.actorID)
         {
            if(HelpingABaoByFieldForceManager.curStage == 1425)
            {
               HelpingABaoByFieldForceManager.afterCallSummon();
            }
         }
      }
      
      private static function bruiseHandle(param1:SocketEvent) : void
      {
         var _loc4_:int = 0;
         var _loc2_:BruiseInfo = param1.data as BruiseInfo;
         var _loc3_:UserModel = UserManager.getModel(_loc2_.userID);
         if(Boolean(_loc3_) && HelpingABaoByFieldForceManager.modelIDs != null)
         {
            _loc4_ = HelpingABaoByFieldForceManager.modelIDs.indexOf(_loc2_.atkerID);
            if(_loc4_ == 0)
            {
               NumberManager.showHonghuangAtk(_loc3_,_loc2_.decHP);
            }
            _loc4_ = HelpingABaoByFieldForceManager.modelIDs.indexOf(_loc2_.userID);
            if(_loc4_ == 1)
            {
               NumberManager.showHonghuangDef(_loc3_,_loc2_.decHP);
            }
         }
      }
      
      private static function onFightBegin(param1:FightEvent) : void
      {
         var _loc4_:KeyInfo = null;
         if(PveEntry.instance.getStageID() == 1425 || PveEntry.instance.getStageID() == 1426)
         {
            HelpingABaoByFieldForceManager.curStage = PveEntry.instance.getStageID();
            HelpingABaoByFieldForceManager.registKey();
         }
         else
         {
            HelpingABaoByFieldForceManager.curStage = 0;
         }
         FightManager.instance.removeEventListener(FightEvent.BEGIN,onFightBegin);
         var _loc2_:Vector.<KeyInfo> = new Vector.<KeyInfo>();
         var _loc3_:int = 0;
         while(_loc3_ < skillQuickKeys.length)
         {
            _loc4_ = new KeyInfo();
            _loc4_.funcID = skillQuickKeys[_loc3_];
            _loc4_.dataID = SKILL_ID[_loc3_];
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         KeyManager.upDateSkillQuickKeys(_loc2_);
         MainManager.actorInfo.skillMonsterID = MONSTER_KING_ID;
         MainManager.actorInfo.isTurnBack = true;
         MainManager.actorModel.changeRoleView(MONSTER_KING_ID);
         MainManager.actorModel.resetBloodBarH();
         UserManager.execBehavior(MainManager.actorID,new ClothBehavior(MainManager.actorInfo.clothes,false),true);
         HeadSelfPanel.instance.headIconEnabled = false;
         FightToolBar.instance.disabledBag();
         KeySkillProcess.liyaChangeSkillState = 0;
         HeadSelfPanel.instance.init(MainManager.actorModel);
         FightToolBar.instance.getQickBar().removeShentong();
         KeyFuncProcess.shentongSkillForbidden = true;
      }
      
      public static function registKey() : void
      {
         FightInteractiveController.instance.addEventListener(FightInteractiveEvent.PRESS,_quickKeyHandler);
         FightToolBar.instance.hideCallBtns();
      }
      
      public static function unregistKey() : void
      {
         FightInteractiveController.instance.removeEventListener(FightInteractiveEvent.PRESS,_quickKeyHandler);
         FightToolBar.instance.showCallBtns();
      }
      
      private static function _quickKeyHandler(param1:FightInteractiveEvent) : void
      {
         var _loc3_:KeyInfo = null;
         var _loc2_:KeyInfo = param1.keyInfo;
         if(_loc2_.funcID == 45)
         {
            if(curStage == 1425)
            {
               _loc3_ = new KeyInfo();
               _loc3_.dataID = SummonManager.CALL_SUMMON_SKILL_ID;
               _loc3_.lv = 1;
               KeySkillProcess.exec(MainManager.actorModel,_loc3_);
            }
            else
            {
               if(curStage == 1426)
               {
                  return;
               }
               KeyFuncProcess.exec(MainManager.actorModel,_loc2_);
            }
         }
         else if(_loc2_.funcID == 46)
         {
            if(curStage == 1426)
            {
               _loc3_ = new KeyInfo();
               _loc3_.dataID = HeroSoulManager.CALL_SOUL_SKILL_ID;
               _loc3_.lv = 1;
               KeySkillProcess.exec(MainManager.actorModel,_loc3_);
            }
            else
            {
               if(curStage == 1425)
               {
                  return;
               }
               KeyFuncProcess.exec(MainManager.actorModel,_loc2_);
            }
         }
      }
      
      public static function destroy() : void
      {
         if(MainManager.actorInfo.skillMonsterID == MONSTER_KING_ID)
         {
            FightManager.instance.removeEventListener(FightEvent.BEGIN,onFightBegin);
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,resetRoleHandler);
            modelIDs = null;
            ActivityExchangeTimesManager.removeEventListener(RECORD_MODEL_IDS[0],_getBaixiIDHandler);
            ActivityExchangeTimesManager.removeEventListener(RECORD_MODEL_IDS[1],_getShenjingIDHandler);
         }
         SocketConnection.removeCmdListener(CommandID.STAGE_QUIT,onQuit);
         SocketConnection.removeCmdListener(CommandID.ACTION_BRUISE,bruiseHandle);
         UserManager.removeEventListener(SkillEvent.SKILL_ACTION,onCallSoulSkill);
      }
      
      private static function resetRoleHandler(param1:MapEvent) : void
      {
         var _loc3_:SingleEquipInfo = null;
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,resetRoleHandler);
         MainManager.actorInfo.skillMonsterID = _originalMonster;
         MainManager.actorModel.changeRoleView(0);
         KeyManager.reset();
         MainManager.actorInfo.skills = _originalSkills;
         KeyManager.upDateSkillQuickKeys(MainManager.actorInfo.skills);
         KeyManager.upDateItemQuickKeys(MainManager.actorInfo.items);
         MainManager.actorModel = _originalModel;
         MainManager.actorInfo.lv = _originalLevel;
         MainManager.actorInfo.fightPower = _originalPower;
         MainManager.actorInfo.isTurnBack = _originalTurnBack;
         UserManager.execBehavior(MainManager.actorID,new ClothBehavior(_originalClothes,false),true);
         HeadSelfPanel.instance.headIconEnabled = true;
         FightToolBar.instance.enabledBag();
         MainManager.actorModel.upDateNickText();
         var _loc2_:Array = ItemManager.warCloth;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.part == EquipPart.WEAPON && ItemXMLInfo.isMagicWeapon(_loc3_.itemID) == false)
            {
               _loc3_.gildSkillID = _originalGildID;
            }
         }
         HeadSelfPanel.instance.init(MainManager.actorModel);
         KeyFuncProcess.shentongSkillForbidden = false;
      }
      
      public static function afterCallSummon() : void
      {
         SwfCache.getSwfInfo(ClientConfig.getSubUI("helping_abao_call_summon"),loadComplete);
      }
      
      public static function afterCallSoul() : void
      {
         SwfCache.getSwfInfo(ClientConfig.getSubUI("helping_abao_call_soul"),loadComplete);
      }
      
      private static function loadComplete(param1:SwfInfo) : void
      {
         var _mainUI:MovieClip = null;
         var info:SwfInfo = param1;
         _mainUI = info.content as MovieClip;
         _mainUI.x = 373;
         _mainUI.y = 381;
         LayerManager.topLevel.addChild(_mainUI);
         TweenLite.to(_mainUI,8,{
            "alpha":0,
            "onComplete":function():void
            {
               DisplayUtil.removeForParent(_mainUI);
            }
         });
         if(curStage == 1425)
         {
            ActivityExchangeTimesManager.addEventListener(RECORD_MODEL_IDS[0],_getBaixiIDHandler);
            ActivityExchangeTimesManager.getActiviteTimeInfo(RECORD_MODEL_IDS[0]);
         }
         else if(curStage == 1426)
         {
            ActivityExchangeTimesManager.addEventListener(RECORD_MODEL_IDS[1],_getShenjingIDHandler);
            ActivityExchangeTimesManager.getActiviteTimeInfo(RECORD_MODEL_IDS[1]);
         }
      }
      
      private static function _getBaixiIDHandler(param1:DataEvent) : void
      {
         var _loc2_:SwapTimesInfo = param1.data as SwapTimesInfo;
         modelIDs[0] = _loc2_.times;
         modelIDs[1] = 0;
      }
      
      private static function _getShenjingIDHandler(param1:DataEvent) : void
      {
         var _loc2_:SwapTimesInfo = param1.data as SwapTimesInfo;
         modelIDs[0] = 0;
         modelIDs[1] = _loc2_.times;
      }
      
      public static function showCallSummonAlert() : void
      {
         SwfCache.getSwfInfo(ClientConfig.getSubUI("helping_abao_alert_call_summon"),loadComplete2);
      }
      
      public static function showCallSoulAlert() : void
      {
         SwfCache.getSwfInfo(ClientConfig.getSubUI("helping_abao_alert_call_soul"),loadComplete2);
      }
      
      private static function loadComplete2(param1:SwfInfo) : void
      {
         var _mainUI:MovieClip = null;
         var info:SwfInfo = param1;
         _mainUI = info.content as MovieClip;
         _mainUI.x = 516;
         _mainUI.y = 221;
         LayerManager.topLevel.addChild(_mainUI);
         TweenLite.to(_mainUI,8,{
            "alpha":0,
            "onComplete":function():void
            {
               DisplayUtil.removeForParent(_mainUI);
            }
         });
      }
   }
}

