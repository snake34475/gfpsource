package com.gfp.app.cartoon
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.LayerManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class SummonUpdateAnimation extends AnimatBase
   {
      
      private var _closeBtn:SimpleButton;
      
      private var _mc:MovieClip;
      
      public function SummonUpdateAnimation()
      {
         super();
      }
      
      public function play() : void
      {
         loadMC(ClientConfig.getCartoon("summonUpdate"));
      }
      
      override protected function playAnimat() : void
      {
         super.playAnimat();
         this._mc = animatMC["mc"];
         this._closeBtn = this._mc["closeBtn"];
         this._mc.addEventListener(Event.ENTER_FRAME,this.onAnimatEnter);
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         this._mc.gotoAndPlay(1);
         LayerManager.topLevel.addChild(this._mc);
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         this.close();
      }
      
      private function onAnimatEnter(param1:Event) : void
      {
         if(this._mc.currentFrame == this._mc.totalFrames)
         {
            this.close();
            destroy();
         }
      }
      
      private function close() : void
      {
         this._mc.stop();
         this._mc.removeEventListener(Event.ENTER_FRAME,this.onAnimatEnter);
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         DisplayUtil.removeForParent(this._mc);
         this._closeBtn = null;
         this._mc = null;
      }
   }
}

