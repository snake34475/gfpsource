package com.gfp.app.cartoon
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.LayerManager;
   import flash.events.Event;
   import org.taomee.utils.DisplayUtil;
   
   public class PlayPaipaiNewYearCartoon extends AnimatBase
   {
      
      public function PlayPaipaiNewYearCartoon()
      {
         super();
      }
      
      public function play(param1:String) : void
      {
         loadMC(ClientConfig.getCartoon(param1));
      }
      
      override protected function playAnimat() : void
      {
         super.playAnimat();
         animatMC.addEventListener(Event.ENTER_FRAME,this.onAnimatEnter);
         animatMC.gotoAndPlay(1);
         LayerManager.topLevel.addChild(animatMC);
      }
      
      private function onAnimatEnter(param1:Event) : void
      {
         if(animatMC.currentFrame == animatMC.totalFrames)
         {
            animatMC.removeEventListener(Event.ENTER_FRAME,this.onAnimatEnter);
            DisplayUtil.removeForParent(animatMC);
            destroy();
         }
      }
   }
}

