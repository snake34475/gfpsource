package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.sound.SoundManager;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.LoadingType;
   import flash.display.Graphics;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import org.taomee.media.ListSoundPlayer;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class BaseStoryAnimation implements IStoryAnimation
   {
      
      protected var _mainMC:MovieClip;
      
      protected var _loader:UILoader;
      
      protected var _jumpBtn:InteractiveObject;
      
      protected var pl:ListSoundPlayer;
      
      protected var _animatName:String;
      
      protected var _closeBtn:SimpleButton;
      
      protected var _background:Shape;
      
      protected var _offsetX:int;
      
      protected var _offsetY:int;
      
      public function BaseStoryAnimation()
      {
         super();
      }
      
      public function setParams(param1:String) : void
      {
      }
      
      public function start() : void
      {
         MainManager.closeOperate();
         this.onStart();
      }
      
      public function onStart() : void
      {
         this.loadAnimat();
      }
      
      protected function loadAnimat() : void
      {
      }
      
      protected function loadAndPlayAnimat(param1:String, param2:String = null) : void
      {
         this._animatName = param2;
         this._loader = new UILoader(ClientConfig.getCartoon(param1),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      protected function onLoadComplete(param1:UILoadEvent) : void
      {
         StageResizeController.instance.register(this.layout);
         MainManager.closeOperate();
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         var _loc2_:MovieClip = param1.uiloader.loader.content as MovieClip;
         if(this._animatName == null)
         {
            this._mainMC = _loc2_;
         }
         else
         {
            this._mainMC = _loc2_[this._animatName];
         }
         this._closeBtn = this._mainMC["closeBtn"];
         if(this._closeBtn)
         {
            this._closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         }
         var _loc3_:Rectangle = this._mainMC.getBounds(this._mainMC);
         this._offsetX = (960 - this._mainMC.width >> 1) - _loc3_.x;
         this._offsetY = (560 - this._mainMC.height >> 1) - _loc3_.y;
         this._mainMC.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._mainMC.gotoAndPlay(1);
         if(this._background == null)
         {
            this._background = new Shape();
         }
         LayerManager.topLevel.addChild(this._mainMC);
         LayerManager.topLevel.addChild(this._background);
         this.addJumpBtn();
         this.playSound();
         this.layout();
      }
      
      protected function layout() : void
      {
         if(this._jumpBtn)
         {
            DisplayUtil.align(this._jumpBtn,null,AlignType.BOTTOM_RIGHT);
         }
         this._mainMC.x = (LayerManager.stageWidth - LayerManager.MIN_WIDTH) * 0.5 + this._offsetX;
         this._mainMC.y = (LayerManager.stageHeight - LayerManager.MIN_HEIGHT) * 0.5 + this._offsetY;
         this.drawBackgroud();
      }
      
      private function drawBackgroud() : void
      {
         var _loc1_:Graphics = this._background.graphics;
         _loc1_.clear();
         _loc1_.beginFill(0);
         _loc1_.drawRect(0,0,LayerManager.stageWidth,LayerManager.stageHeight - 550 >> 1);
         _loc1_.drawRect(0,550 + (LayerManager.stageHeight - 550 >> 1),LayerManager.stageWidth,LayerManager.stageHeight - 550 >> 1);
         _loc1_.drawRect(0,LayerManager.stageHeight - 550 >> 1,LayerManager.stageWidth - 950 >> 1,550);
         _loc1_.drawRect(950 + (LayerManager.stageWidth - 950 >> 1),LayerManager.stageHeight - 550 >> 1,LayerManager.stageWidth - 950 >> 1,550);
         _loc1_.endFill();
      }
      
      protected function playSound() : void
      {
      }
      
      protected function addJumpBtn() : void
      {
      }
      
      protected function onJump(param1:MouseEvent) : void
      {
         this.onFinish();
      }
      
      protected function onClose(param1:MouseEvent) : void
      {
         this.onFinish();
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
         if(this._mainMC.currentFrame == this._mainMC.totalFrames)
         {
            this._mainMC.stop();
            this._mainMC.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            DisplayUtil.removeForParent(this._mainMC);
            this.playEnd();
         }
      }
      
      protected function playEnd() : void
      {
         this.onFinish();
      }
      
      public function onFinish() : void
      {
         this.destroy();
      }
      
      protected function destroy() : void
      {
         StageResizeController.instance.unregister(this.layout);
         MainManager.openOperate();
         if(this._closeBtn)
         {
            this._closeBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
            this._closeBtn = null;
         }
         if(this._jumpBtn)
         {
            this._jumpBtn.removeEventListener(MouseEvent.CLICK,this.onJump);
            DisplayUtil.removeForParent(this._jumpBtn);
            this._jumpBtn = null;
         }
         DisplayUtil.removeForParent(this._background);
         this._background = null;
         this._loader.destroy(true);
         this._mainMC.stop();
         this._mainMC.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         DisplayUtil.removeForParent(this._mainMC);
         this._mainMC = null;
         if(this.pl != null)
         {
            this.pl.stop();
         }
         if(SoundManager.isMusicEnable)
         {
            SoundManager.bgPlayer.play();
         }
      }
   }
}

