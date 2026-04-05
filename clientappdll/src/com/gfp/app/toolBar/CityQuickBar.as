package com.gfp.app.toolBar
{
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.motion.Tween;
   import org.taomee.motion.easing.Back;
   import org.taomee.utils.DisplayUtil;
   
   public class CityQuickBar
   {
      
      private static var _instance:CityQuickBar;
      
      public static const CLOSE_STATE:String = "close";
      
      public static const OPEN_STATE:String = "open";
      
      private var _mainUI:UI_SWF_CityQuickBar;
      
      private var _pickUpBtn:SimpleButton;
      
      private var _tween:Tween;
      
      private var _currentState:String = "close";
      
      private var _quickBar:QuickBarComponent;
      
      public function CityQuickBar()
      {
         super();
         this._mainUI = new UI_SWF_CityQuickBar();
         this._pickUpBtn = this._mainUI.pickUpBtn;
         this._pickUpBtn.addEventListener(MouseEvent.CLICK,this.onPickUpBtnClick);
         ToolTipManager.add(this._pickUpBtn,"点击打开快捷栏");
         this._quickBar = QuickBarComponent.instance;
         this._quickBar.x = 1024;
         this._pickUpBtn.rotationY = 180;
         StageResizeController.instance.register(this.layout);
      }
      
      public static function get instance() : CityQuickBar
      {
         if(_instance == null)
         {
            _instance = new CityQuickBar();
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
      
      private function onPickUpBtnClick(param1:MouseEvent) : void
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
         this._tween = new Tween(QuickBarComponent.instance,"x",Back.easeOut,this._quickBar.x,-65,600,true);
         this._tween.start();
         this._currentState = OPEN_STATE;
         this._pickUpBtn.rotationY = 0;
         ToolTipManager.add(this._pickUpBtn,"点击关闭快捷栏");
      }
      
      public function onClose() : void
      {
         this._tween = new Tween(QuickBarComponent.instance,"x",Back.easeOut,this._quickBar.x,this._mainUI.width + 10,600,true);
         this._tween.start();
         this._currentState = CLOSE_STATE;
         this._pickUpBtn.rotationY = 180;
         ToolTipManager.add(this._pickUpBtn,"点击打开快捷栏");
      }
      
      public function show() : void
      {
         this._mainUI.x = LayerManager.stageWidth - 440;
         this._mainUI.y = LayerManager.stageHeight - 110 - 30;
         this._mainUI.addChild(this._quickBar);
         LayerManager.toolsLevel.addChildAt(this._mainUI,0);
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this._mainUI,false);
      }
      
      private function layout() : void
      {
         if(this._tween)
         {
            this._tween.stop();
         }
         QuickBarComponent.instance.x = this._currentState == CLOSE_STATE ? this._mainUI.width + 10 : -100;
         this._mainUI.x = LayerManager.stageWidth - 440;
         this._mainUI.y = LayerManager.stageHeight - 110;
      }
      
      public function destroy() : void
      {
         StageResizeController.instance.unregister(this.layout);
         ToolTipManager.remove(this._pickUpBtn);
      }
   }
}

