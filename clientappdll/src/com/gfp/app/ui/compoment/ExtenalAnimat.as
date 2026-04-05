package com.gfp.app.ui.compoment
{
   import com.gfp.core.ui.ExtenalUIPanel;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class ExtenalAnimat extends ExtenalUIPanel
   {
      
      public function ExtenalAnimat(param1:String)
      {
         super(param1);
      }
      
      override protected function initUI() : void
      {
         super.initUI();
         (_ui as MovieClip).play();
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         _ui.addEventListener(Event.ENTER_FRAME,this.onUIEnterFrame);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         _ui.removeEventListener(Event.ENTER_FRAME,this.onUIEnterFrame);
      }
      
      private function onUIEnterFrame(param1:Event) : void
      {
         if(_ui.currentFrame == _ui.totalFrames)
         {
            _ui.stop();
            destory();
         }
      }
   }
}

