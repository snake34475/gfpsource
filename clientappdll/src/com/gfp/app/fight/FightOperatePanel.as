package com.gfp.app.fight
{
   import com.gfp.app.manager.FightGroupManager;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.utils.FightMode;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.motion.Tween;
   import org.taomee.motion.easing.Back;
   import org.taomee.utils.DisplayUtil;
   
   public class FightOperatePanel extends Sprite
   {
      
      private static var _instance:FightOperatePanel;
      
      public static const CLOSE_STATE:String = "close";
      
      public static const OPEN_STATE:String = "open";
      
      private var _mainUI:MovieClip;
      
      private var _refreshBtn:SimpleButton;
      
      private var _backHomeBtn:SimpleButton;
      
      private var _disBtn:SimpleButton;
      
      private var _outBtn:SimpleButton;
      
      private var _currentState:String = "close";
      
      private var _tween:Tween;
      
      public function FightOperatePanel()
      {
         super();
         this._mainUI = UIManager.getSprite("Fight_operatePanel") as MovieClip;
         this._disBtn = this._mainUI["disBtn"] as SimpleButton;
         this._refreshBtn = this._mainUI["Fight_refresh_btn"] as SimpleButton;
         this._backHomeBtn = this._mainUI["back_home"] as SimpleButton;
         this._outBtn = this._mainUI["out_btn"] as SimpleButton;
         this._disBtn.addEventListener(MouseEvent.CLICK,this.onOtherFight);
         this._refreshBtn.addEventListener(MouseEvent.CLICK,this.onRefreshFight);
         this._backHomeBtn.addEventListener(MouseEvent.CLICK,this.onBackHome);
         this._outBtn.addEventListener(MouseEvent.CLICK,this.onBackHome);
         StageResizeController.instance.register(this.onStageRezise);
      }
      
      public static function get instance() : FightOperatePanel
      {
         if(_instance == null)
         {
            _instance = new FightOperatePanel();
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
      
      private function onStageRezise() : void
      {
         if(this._tween)
         {
            this._tween.stop();
         }
         this._mainUI.x = this._currentState == OPEN_STATE ? LayerManager.stageWidth - 140 : LayerManager.stageWidth - 26;
      }
      
      private function onRefreshFight(param1:Event) : void
      {
         PveEntry.afreshTollgate();
      }
      
      private function onOtherFight(param1:Event) : void
      {
         if(this._currentState == CLOSE_STATE)
         {
            this.onShow();
         }
         else
         {
            this.onClose();
         }
      }
      
      public function onShow() : void
      {
         if(this._currentState == OPEN_STATE)
         {
            return;
         }
         this._tween = new Tween(this._mainUI,"x",Back.easeOut,this._mainUI.x,LayerManager.stageWidth - 140,600,true);
         this._tween.start();
         this._currentState = OPEN_STATE;
         this._disBtn.rotation = 180;
      }
      
      public function onClose() : void
      {
         if(this._currentState == CLOSE_STATE)
         {
            return;
         }
         this._tween = new Tween(this._mainUI,"x",Back.easeOut,this._mainUI.x,LayerManager.stageWidth - 26,600,true);
         this._tween.start();
         this._currentState = CLOSE_STATE;
         this._disBtn.rotation = 0;
      }
      
      private function onBackHome(param1:Event) : void
      {
         if(FightManager.fightMode == FightMode.WATCH)
         {
            FightManager.quitWithWatch();
            return;
         }
         if(FightGroupManager.instance.groupBtlId != 0)
         {
            FightGroupManager.instance.pvpTypeIndex = 0;
         }
         FightManager.quit();
      }
      
      public function show(param1:int, param2:int, param3:uint = 0) : void
      {
         this._backHomeBtn.y = 73;
         if(param1 == MapType.PVE)
         {
            if(PveEntry.instance.getStageID() == 101)
            {
               this._refreshBtn.visible = false;
            }
            else
            {
               this._refreshBtn.visible = true;
            }
            this._backHomeBtn.visible = true;
            this._outBtn.visible = false;
            if(param2 == 1)
            {
               this._refreshBtn.mouseEnabled = false;
               this._refreshBtn.alpha = 0.8;
            }
         }
         else if(param1 == MapType.PVP || param1 == MapType.PVAI)
         {
            this._refreshBtn.visible = false;
            this._backHomeBtn.visible = false;
            this._outBtn.visible = true;
         }
         else if(param1 == MapType.WATCH)
         {
            this._refreshBtn.visible = false;
            this._backHomeBtn.visible = false;
            this._outBtn.visible = true;
         }
         if(FightManager.isTeamFight)
         {
            this._refreshBtn.visible = false;
            this._backHomeBtn.visible = true;
            this._backHomeBtn.y = 53;
            this._outBtn.visible = false;
            this._refreshBtn.mouseEnabled = false;
         }
         if(SinglePkManager.instance.roomID != 0)
         {
            this._refreshBtn.visible = false;
            this._backHomeBtn.visible = false;
            this._outBtn.visible = true;
            this._refreshBtn.mouseEnabled = false;
         }
         LayerManager.topLevel.addChild(this._mainUI);
         this._mainUI.x = LayerManager.stageWidth - 26;
         this._mainUI.y = 90;
      }
      
      public function destroy() : void
      {
         if(this._tween)
         {
            this._tween.stop();
            this._tween = null;
         }
         this.hide();
         this.removeEventList();
         this._refreshBtn = null;
         this._disBtn = null;
         this._backHomeBtn = null;
         this._outBtn = null;
         this._mainUI = null;
         StageResizeController.instance.unregister(this.onStageRezise);
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this._mainUI);
      }
      
      private function removeEventList() : void
      {
         this._refreshBtn.removeEventListener(MouseEvent.CLICK,this.onRefreshFight);
         this._disBtn.removeEventListener(MouseEvent.CLICK,this.onOtherFight);
         this._backHomeBtn.removeEventListener(MouseEvent.CLICK,this.onBackHome);
         this._outBtn.removeEventListener(MouseEvent.CLICK,this.onBackHome);
      }
      
      public function get mainUI() : MovieClip
      {
         return this._mainUI;
      }
   }
}

