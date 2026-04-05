package com.gfp.app.mapProcess
{
   import com.gfp.app.manager.VipFightManager;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1049 extends BaseMapProcess
   {
      
      public function MapProcess_1049()
      {
         super();
      }
      
      override protected function init() : void
      {
         VipFightManager.instance.setUp();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         VipFightManager.destroy();
      }
   }
}

