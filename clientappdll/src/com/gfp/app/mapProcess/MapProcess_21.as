package com.gfp.app.mapProcess
{
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class MapProcess_21 extends BaseMapProcess
   {
      
      private var hours:Number;
      
      public function MapProcess_21()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:int = 0;
         while(_loc1_ < 7)
         {
            _loc2_ = _mapModel.root["Exchange" + _loc1_];
            _loc2_.buttonMode = true;
            _loc2_.addEventListener(MouseEvent.CLICK,this.onExchange);
            _loc1_++;
         }
      }
      
      private function onExchange(param1:MouseEvent) : void
      {
         param1.currentTarget.play();
      }
      
      override public function destroy() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 7)
         {
            _mapModel.root["Exchange" + _loc1_].removeEventListener(MouseEvent.CLICK,this.onExchange);
            _loc1_++;
         }
         super.destroy();
      }
   }
}

