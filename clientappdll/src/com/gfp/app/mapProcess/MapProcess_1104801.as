package com.gfp.app.mapProcess
{
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   
   public class MapProcess_1104801 extends BaseMapProcess
   {
      
      protected var ui:MovieClip;
      
      protected var currentNum:int = 0;
      
      protected var bossID:int = 0;
      
      public function MapProcess_1104801()
      {
         super();
      }
      
      override protected function init() : void
      {
      }
      
      private function onDie(param1:UserEvent) : void
      {
      }
      
      protected function updateView() : void
      {
      }
      
      override public function destroy() : void
      {
      }
   }
}

