package com.gfp.app.task.storyAnimation
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class StoryAnimationTask_1902_6 extends PanelStoryAnimationTask
   {
      
      private var closeButton:SimpleButton;
      
      private var arrow1:MovieClip;
      
      private var arrow2:MovieClip;
      
      public function StoryAnimationTask_1902_6()
      {
         super();
      }
      
      override protected function handleLoadMc(param1:MovieClip) : void
      {
         super.handleLoadMc(param1);
      }
      
      override protected function setupUI() : void
      {
         this.closeButton = _storyMc["closeButton"];
         this.arrow1 = _storyMc["arrow1"];
         this.arrow2 = _storyMc["arrow2"];
         this.arrow1.buttonMode = true;
         this.arrow1.useHandCursor = true;
         this.arrow2.buttonMode = true;
         this.arrow2.useHandCursor = true;
         this.arrow1.alpha = 0.01;
         this.arrow2.alpha = 0.01;
         this.closeButton.addEventListener(MouseEvent.CLICK,this.onCloseButtonClick);
         this.arrow1.addEventListener(MouseEvent.CLICK,this.onArrowClick);
         this.arrow1.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         this.arrow1.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         this.arrow2.addEventListener(MouseEvent.CLICK,this.onArrowClick);
         this.arrow2.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         this.arrow2.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.alpha != 1)
         {
            TweenLite.to(_loc2_,1,{"alpha":0.8});
         }
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.alpha != 1)
         {
            TweenLite.killTweensOf(_loc2_);
            _loc2_.alpha = 0.01;
         }
      }
      
      private function cleanUp() : void
      {
         this.closeButton.removeEventListener(MouseEvent.CLICK,this.onCloseButtonClick);
         this.arrow1.removeEventListener(MouseEvent.CLICK,this.onArrowClick);
         this.arrow2.removeEventListener(MouseEvent.CLICK,this.onArrowClick);
         this.arrow1.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         this.arrow1.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         this.arrow2.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         this.arrow2.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         this.closeButton = null;
         this.arrow1 = null;
         this.arrow2 = null;
      }
      
      private function onArrowClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.alpha != 1)
         {
            TweenLite.killTweensOf(_loc2_);
            _loc2_.alpha = 1;
            _loc2_.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
            _loc2_.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
            _loc2_.buttonMode = false;
            _loc2_.useHandCursor = false;
         }
         this.checkTaskComplete();
      }
      
      private function checkTaskComplete() : void
      {
         if(1 == this.arrow1.alpha && 1 == this.arrow2.alpha)
         {
            onComplete();
            this.cleanUp();
            onFinish();
         }
      }
      
      private function onCloseButtonClick(param1:MouseEvent) : void
      {
         this.cleanUp();
         onFinish();
      }
   }
}

