package com.gfp.app.toolBar
{
   import com.gfp.app.fight.FightEntry;
   import com.gfp.app.toolBar.tollgate.MaigcCDIcon;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.controller.ToolBarQuickKey;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MagicChangeManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SOManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.player.MovieClipPlayerEx;
   import com.gfp.core.utils.TextFormatUtil;
   import com.gfp.core.utils.WebURLUtil;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.SharedObject;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class FightToolBar
   {
      
      private static var _instance:FightToolBar;
      
      private const TIP_STR:String = "当前网络延时：";
      
      private const TIP_HM:String = " 毫秒";
      
      private const ITEM_START_INDEX:int = 0;
      
      private const SKILL_START_INDEX:int = 5;
      
      public var defY:Number;
      
      private var _mainUI:UI_SWF_ToolBar_Fight_Game;
      
      private var _bagBtn:InteractiveObject;
      
      private var _skillPointMC:Sprite;
      
      private var _bzdMC:MovieClip;
      
      private var _skillPointAnimat:MovieClipPlayerEx;
      
      private var _bzdAnimat:MovieClipPlayerEx;
      
      private var _mapType:int;
      
      private var _stageID:uint;
      
      private var _netState:MovieClip;
      
      private var _netDelay:uint;
      
      private var _qickBar:QuickBarComponent;
      
      private var _magicCDIcon:MaigcCDIcon;
      
      private var _koPoint:Point;
      
      private var _vipPoint:Point;
      
      private var _warnVipPickId:int;
      
      private var _warnVipReckId:int;
      
      public function FightToolBar()
      {
         var _loc3_:int = 0;
         this._koPoint = new Point();
         this._vipPoint = new Point();
         super();
         this._mainUI = new UI_SWF_ToolBar_Fight_Game();
         this._magicCDIcon = new MaigcCDIcon(this._mainUI["magicCD"]);
         this._skillPointMC = this._mainUI.skillPointMC;
         this._skillPointMC.visible = false;
         this._skillPointMC["countLabel"].text = MainManager.actorInfo.skillPoint + "";
         ToolTipManager.add(this._skillPointMC,"技能经验，可用于升级角色技能等级");
         this._bzdMC = this._mainUI["bzdMC"];
         this._mainUI["bzdNumTxt"].text = MainManager.actorInfo.bzdPoint.toString();
         ToolTipManager.add(this._bzdMC,"消灭备战之地中的部分怪物可奖励备战点，可在全民备战主界面上兑换各种奖励");
         var _loc1_:MovieClip = this._mainUI.removeChild(this._mainUI.skillPointAnimat) as MovieClip;
         this._skillPointAnimat = new MovieClipPlayerEx(_loc1_);
         _loc1_.stop();
         this._skillPointAnimat.stop();
         _loc1_ = this._mainUI.removeChild(this._mainUI["bzdAnima"]) as MovieClip;
         this._bzdAnimat = new MovieClipPlayerEx(_loc1_);
         this._bzdAnimat.stop();
         this._bagBtn = this._mainUI.bagBtn;
         this._netState = this._mainUI.netState;
         this._netState.gotoAndStop(1);
         ToolTipManager.add(this._netState,this.TIP_STR + "<b>" + TextFormatUtil.getColorText(this._netDelay.toString(),39168) + "</b>" + this.TIP_HM,200,false);
         this._qickBar = new QuickBarComponent(true);
         this._mainUI.addChild(this._qickBar);
         this._qickBar.x = 100;
         this._mainUI["koSetBtn"].buttonMode = true;
         this._koPoint.x = this._mainUI["koSetBtn"].x;
         this._koPoint.y = this._mainUI["koSetBtn"].y;
         this._vipPoint.x = this._mainUI["vipSetBtn"].x;
         this._vipPoint.y = this._mainUI["vipSetBtn"].y;
         var _loc2_:SharedObject = SOManager.getActorSO("isPlayKOMovie");
         if(_loc2_.data.hasOwnProperty("koSetBtn"))
         {
            FightEntry.isPlayKOMovie = _loc2_.data["koSetBtn"];
            _loc3_ = FightEntry.isPlayKOMovie ? 1 : 2;
            if(_loc3_ == 1)
            {
               ToolTipManager.add(this._mainUI["koSetBtn"],"关闭KO动画效果");
            }
            else
            {
               ToolTipManager.add(this._mainUI["koSetBtn"],"显示KO动画效果");
            }
            this._mainUI["koSetBtn"].gotoAndStop(_loc3_);
         }
         else
         {
            this._mainUI["koSetBtn"].gotoAndStop(1);
         }
         this._mainUI["vipRecEff"].mouseEnabled = this._mainUI["vipRecEff"].mouseChildren = false;
         this._mainUI["vipPickEff"].mouseEnabled = this._mainUI["vipPickEff"].mouseChildren = false;
         this._mainUI["notVipEff"].mouseEnabled = this._mainUI["notVipEff"].mouseChildren = false;
         this._mainUI["notVipEff"].stop();
         this._mainUI["notVipEff"].visible = false;
      }
      
      public static function get instance() : FightToolBar
      {
         if(_instance == null)
         {
            _instance = new FightToolBar();
         }
         return _instance;
      }
      
      public static function addEventListener(param1:String, param2:Function) : void
      {
         instance._qickBar.addEventListener(param1,param2);
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void
      {
         instance._qickBar.removeEventListener(param1,param2);
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      public static function setNetDelay(param1:uint) : void
      {
         if(_instance)
         {
            _instance.setNetDelay(param1);
         }
      }
      
      public static function updateSkillPoint() : void
      {
         if(_instance)
         {
            _instance.updateSkillPoint();
         }
      }
      
      public function getMainUI() : UI_SWF_ToolBar_Fight_Game
      {
         return this._mainUI;
      }
      
      public function getQickBar() : QuickBarComponent
      {
         return this._qickBar;
      }
      
      public function disabledBag() : void
      {
         this._bagBtn.mouseEnabled = false;
         ToolBarQuickKey.unRegistQuickKey(11);
      }
      
      public function enabledBag() : void
      {
         this._bagBtn.mouseEnabled = true;
         ToolBarQuickKey.registQuickKey(11,this.onBagQuick);
      }
      
      public function clearSkillQuickKeys() : void
      {
         this._qickBar.clearSkillQuickKeys();
      }
      
      public function disabledSkillQuickKeys() : void
      {
         this._qickBar.disabledSkillQuickKeys();
      }
      
      public function enabledSkillQuickKeys() : void
      {
         this._qickBar.enabledSkillQuickKeys();
      }
      
      public function initCD() : void
      {
         this._qickBar.initCD();
      }
      
      public function clearCD() : void
      {
         this._qickBar.clearCD();
      }
      
      public function showCallBtns() : void
      {
         this._qickBar.showCallBtns();
      }
      
      public function hideCallBtns() : void
      {
         this._qickBar.hideCallBtns();
      }
      
      public function show(param1:int, param2:uint = 0) : void
      {
         LayerManager.toolsLevel.addChildAt(this._mainUI,0);
         this.layout();
         StageResizeController.instance.register(this.layout);
         this.defY = this._mainUI.y;
         this._mapType = param1;
         this._stageID = param2;
         this._skillPointMC.visible = false;
         if(this._skillPointMC.visible)
         {
            this._mainUI["koSetBtn"].x = this._skillPointMC.x + this._skillPointMC.width / 4 + 20;
            this._mainUI["vipSetBtn"].x = this._mainUI["koSetBtn"].x + 7 + this._mainUI["koSetBtn"].width;
         }
         else
         {
            this._mainUI["koSetBtn"].x = this._koPoint.x;
            this._mainUI["vipSetBtn"].x = this._vipPoint.x;
         }
         this._mainUI["vipPickEff"].x = this._mainUI["vipSetBtn"].x - 46;
         this._mainUI["vipRecEff"].x = this._mainUI["vipPickEff"].x;
         this._mainUI["notVipEff"].x = this._mainUI["vipPickEff"].x;
         if(MainManager.actorInfo.isVip)
         {
            this._mainUI["notVipEff"].stop();
            this._mainUI["notVipEff"].visible = false;
         }
         else
         {
            this._mainUI["notVipEff"].play();
            this._mainUI["notVipEff"].visible = true;
         }
         this._bagBtn.addEventListener(MouseEvent.CLICK,this.onBagBtnClick);
         this._mainUI["koSetBtn"].addEventListener(MouseEvent.CLICK,this.onBagBtnClick);
         this._mainUI["vipSetBtn"].addEventListener(MouseEvent.CLICK,this.onBagBtnClick);
         ToolBarQuickKey.addTip(this._bagBtn,11);
         ToolBarQuickKey.registQuickKey(11,this.onBagQuick);
         if(param2 == 1017)
         {
            this.showBzd();
         }
         else
         {
            this.hideBzd();
         }
         this.checkMagic();
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapChangeComplete);
      }
      
      public function checkMagic() : void
      {
         if(!MagicChangeManager.instance.isIconDispear())
         {
            this._magicCDIcon.visible = true;
         }
         else
         {
            this._magicCDIcon.visible = false;
         }
      }
      
      public function onMapChangeComplete(param1:Event) : void
      {
         this.checkMagic();
      }
      
      public function hide() : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapChangeComplete);
         this._bagBtn.removeEventListener(MouseEvent.CLICK,this.onBagBtnClick);
         this._mainUI["koSetBtn"].removeEventListener(MouseEvent.CLICK,this.onBagBtnClick);
         this._mainUI["vipSetBtn"].removeEventListener(MouseEvent.CLICK,this.onBagBtnClick);
         ToolBarQuickKey.removeTip(this._bagBtn);
         ToolBarQuickKey.unRegistQuickKey(11);
         DisplayUtil.removeForParent(this._mainUI,false);
         StageResizeController.instance.unregister(this.layout);
      }
      
      private function layout() : void
      {
         this._mainUI.x = LayerManager.stageWidth - 150 - 640 >> 1;
         this._mainUI.y = LayerManager.stageHeight - 53;
      }
      
      private function onBagQuick() : void
      {
         this.onBagBtnClick(new MouseEvent(MouseEvent.CLICK));
      }
      
      public function getBzdPoint() : Point
      {
         var _loc1_:Point = new Point(this._bzdMC.x - 20,this._bzdMC.y);
         return this._mainUI.localToGlobal(_loc1_);
      }
      
      public function destroy() : void
      {
         ToolTipManager.remove(this._skillPointMC);
         this.hide();
         this._magicCDIcon.destroy();
         this._magicCDIcon = null;
         this._qickBar.destroy();
         this._qickBar = null;
         this._mainUI = null;
         this._bagBtn = null;
         this._skillPointMC = null;
         this._netState = null;
         this._skillPointAnimat.stop();
         this._skillPointAnimat.destory();
         this._skillPointAnimat.removeEventListener(Event.ENTER_FRAME,this.onAnimatPlay);
         this._skillPointAnimat = null;
         this._bzdMC.stop();
         this._bzdAnimat.stop();
         this._bzdAnimat.destory();
         this._bzdAnimat.removeEventListener(Event.ENTER_FRAME,this.onBDZAnimatPlay);
         clearInterval(this._warnVipReckId);
         clearInterval(this._warnVipPickId);
      }
      
      public function hideBzd() : void
      {
         this._bzdAnimat.stop();
         if(this._bzdAnimat.parent)
         {
            this._bzdAnimat.parent.removeChild(this._bzdAnimat);
         }
         if(this._mainUI["bzdNumTxt"].parent)
         {
            this._mainUI.removeChild(this._mainUI["bzdNumTxt"]);
         }
         if(this._bzdMC.parent)
         {
            this._bzdMC.parent.removeChild(this._bzdMC);
         }
      }
      
      public function showBzd() : void
      {
         if(!this._bzdMC.parent)
         {
            this._mainUI.removeChild(this._bzdMC);
         }
         if(!this._mainUI["bzdNumTxt"].parent)
         {
            this._mainUI.addChild(this._mainUI["bzdNumTxt"]);
         }
      }
      
      public function setNetDelay(param1:uint) : void
      {
         this._netDelay = param1;
         if(param1 < 150)
         {
            this._netState.gotoAndStop(1);
            ToolTipManager.add(this._netState,this.TIP_STR + "<b>" + TextFormatUtil.getColorText(this._netDelay.toString(),39168) + "</b>" + this.TIP_HM,200,false);
         }
         else if(param1 >= 150 && param1 < 500)
         {
            this._netState.gotoAndStop(2);
            ToolTipManager.add(this._netState,this.TIP_STR + "<b>" + TextFormatUtil.getColorText(this._netDelay.toString(),16763904) + "</b>" + this.TIP_HM,200,false);
         }
         else if(param1 >= 500)
         {
            this._netState.gotoAndStop(3);
            ToolTipManager.add(this._netState,this.TIP_STR + "<b>" + TextFormatUtil.getColorText(this._netDelay.toString(),16724736) + "</b>" + this.TIP_HM,200,false);
         }
      }
      
      public function updateBzdPoint() : void
      {
         this._mainUI.addChild(this._bzdAnimat);
         this._bzdAnimat.reset();
         this._bzdAnimat.play();
         this._bzdAnimat.addEventListener(Event.ENTER_FRAME,this.onBDZAnimatPlay);
         this._mainUI["bzdNumTxt"].text = MainManager.actorInfo.bzdPoint.toString();
      }
      
      public function updateSkillPoint() : void
      {
         this._mainUI.addChild(this._skillPointAnimat);
         this._skillPointAnimat.reset();
         this._skillPointAnimat.play();
         this._skillPointAnimat.addEventListener(Event.ENTER_FRAME,this.onAnimatPlay);
         this._skillPointMC["countLabel"].text = MainManager.actorInfo.skillPoint + "";
      }
      
      private function onAnimatPlay(param1:Event) : void
      {
         if(this._skillPointAnimat)
         {
            if(this._skillPointAnimat.currentFrame == this._skillPointAnimat.totalFrames)
            {
               this._skillPointAnimat.stop();
               this._mainUI.removeChild(this._skillPointAnimat);
               this._skillPointAnimat.removeEventListener(Event.ENTER_FRAME,this.onAnimatPlay);
            }
         }
      }
      
      public function showRecoverEff() : void
      {
         this._warnVipReckId = setInterval(this.tryShow,1000,1);
      }
      
      private function tryShow(param1:int = 1) : void
      {
         if(param1 == 1)
         {
            if(!(this._mainUI["vipPickEff"] as MovieClip).isPlaying)
            {
               this._mainUI["vipRecEff"].visible = true;
               this._mainUI["vipRecEff"].gotoAndPlay(2);
               clearInterval(this._warnVipReckId);
            }
         }
         else if(!(this._mainUI["vipRecEff"] as MovieClip).isPlaying)
         {
            this._mainUI["vipPickEff"].visible = true;
            this._mainUI["vipPickEff"].gotoAndPlay(2);
            clearInterval(this._warnVipPickId);
         }
      }
      
      public function showPickEff() : void
      {
         this._warnVipPickId = setInterval(this.tryShow,1000,2);
      }
      
      private function onBDZAnimatPlay(param1:Event) : void
      {
         if(this._bzdAnimat)
         {
            if(this._bzdAnimat.currentFrame == this._bzdAnimat.totalFrames)
            {
               this._bzdAnimat.stop();
               this._mainUI.removeChild(this._bzdAnimat);
               this._bzdAnimat.removeEventListener(Event.ENTER_FRAME,this.onBDZAnimatPlay);
            }
         }
      }
      
      private function onBagBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:SharedObject = null;
         switch(param1.currentTarget)
         {
            case this._bagBtn:
               ModuleManager.turnModule(ClientConfig.getAppModule("BagPanel"),"正在加载背包...");
               break;
            case this._mainUI["koSetBtn"]:
               FightEntry.isPlayKOMovie = !FightEntry.isPlayKOMovie;
               _loc2_ = FightEntry.isPlayKOMovie ? 1 : 2;
               this._mainUI["koSetBtn"].gotoAndStop(_loc2_);
               _loc3_ = SOManager.getActorSO("isPlayKOMovie");
               _loc3_.data["koSetBtn"] = FightEntry.isPlayKOMovie;
               _loc3_.flush();
               if(_loc2_ == 1)
               {
                  ToolTipManager.add(this._mainUI["koSetBtn"],"关闭KO动画效果");
                  break;
               }
               ToolTipManager.add(this._mainUI["koSetBtn"],"显示KO动画效果");
               break;
            case this._mainUI["vipSetBtn"]:
               if(MainManager.actorInfo.isVip)
               {
                  ModuleManager.turnModule(ClientConfig.getAppModule("VIPSetBattlePanel"),"正在加载VIP战斗设置面板...");
                  break;
               }
               WebURLUtil.intance.navigatePayVip();
         }
      }
   }
}

