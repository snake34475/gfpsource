package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.core.player.MovieClipPlayerEx;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public class SevenAllInOneButton extends BaseActivitySprite
   {
      
      private var hidetimer:int;
      
      private var showtimer:int;
      
      private var _mcEffect:MovieClipPlayerEx;
      
      private var i:int = 0;
      
      private var min:int = 0;
      
      private var hou:int = 0;
      
      private var smith:int = 1;
      
      public function SevenAllInOneButton(param1:ActivityNodeInfo)
      {
         super(param1);
         this._mcEffect = getEffect(1);
         this._mcEffect.visible = true;
         this.showtimer = setInterval(this.showeef,300000);
         this.hidetimer = setTimeout(this.hideef,60000);
      }
      
      override protected function doAction() : void
      {
         this._mcEffect.visible = false;
         clearTimeout(this.hidetimer);
         this.hidetimer = setTimeout(this.hideef,60000);
         super.doAction();
      }
      
      private function hideef() : void
      {
         this._mcEffect.visible = false;
      }
      
      private function showeef() : void
      {
         this._mcEffect.visible = true;
         clearTimeout(this.hidetimer);
         this.hidetimer = setTimeout(this.hideef,60000);
      }
   }
}

