package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.utils.DisplayUtil;
   
   public class BaseScrollTextButton extends BaseActivitySprite
   {
      
      private var _text:MovieClip;
      
      private var _time:uint;
      
      public function BaseScrollTextButton(param1:ActivityNodeInfo)
      {
         super(param1);
         this._text = _sprite["text"];
         DisplayUtil.removeForParent(this._text,false);
         this.startNew();
      }
      
      protected function startScroll() : void
      {
         if(visible == false)
         {
            return;
         }
         (_sprite as DisplayObjectContainer).addChild(this._text);
         this._text.gotoAndPlay(1);
         this._text.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.startNew();
      }
      
      private function startNew() : void
      {
         var _loc1_:int = int((Math.random() * 20 + 40) * 1000);
         clearTimeout(this._time);
         this._time = setTimeout(this.startScroll,_loc1_);
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
         if(this._text.currentFrame == this._text.totalFrames)
         {
            this._text.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            DisplayUtil.removeForParent(this._text,false);
         }
      }
      
      override public function executeShow() : Boolean
      {
         if(super.executeShow())
         {
            return true;
         }
         return false;
      }
   }
}

