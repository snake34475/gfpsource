package com.gfp.app.mapProcess
{
   import com.gfp.app.manager.GhostWellManager;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1002 extends BaseMapProcess
   {
      
      public function MapProcess_1002()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
      }
      
      override public function destroy() : void
      {
         GhostWellManager.instance.reset();
         super.destroy();
      }
   }
}

