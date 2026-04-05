package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.LoadingType;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class StoryAnimationTaskBaseLoader
   {
      
      protected var _mainMC:MovieClip;
      
      private var _loader:UILoader;
      
      private var _isMainTimeLine:Boolean;
      
      private var _closeBtn:SimpleButton;
      
      public function StoryAnimationTaskBaseLoader()
      {
         super();
      }
      
      protected function loadAndPlayAnimat(param1:String, param2:Boolean = false) : void
      {
         this._isMainTimeLine = param2;
         this._loader = new UILoader(ClientConfig.getCartoon(param1),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         MainManager.closeOperate();
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         var _loc2_:MovieClip = param1.uiloader.loader.content as MovieClip;
         if(this._isMainTimeLine)
         {
            this._mainMC = _loc2_;
         }
         else
         {
            this._mainMC = _loc2_["mc"];
         }
         this._closeBtn = this._mainMC["closeBtn"];
         if(this._closeBtn)
         {
            this._closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         }
         LayerManager.topLevel.addChild(this._mainMC);
         this._mainMC.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._mainMC.gotoAndPlay(1);
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         this._mainMC.stop();
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
         this._mainMC.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         MainManager.openOperate();
         this.playEnd();
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this._mainMC.currentFrame == this._mainMC.totalFrames)
         {
            this._mainMC.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            MainManager.openOperate();
            this.playEnd();
         }
      }
      
      protected function playEnd() : void
      {
      }
   }
}

