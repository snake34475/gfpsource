package com.gfp.app.mapProcess
{
   import com.gfp.core.manager.TeamFight3v3CityManager;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1103601 extends BaseMapProcess
   {
      
      public function MapProcess_1103601()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         TeamFight3v3CityManager.getInstance().setup();
      }
      
      override public function destroy() : void
      {
         TeamFight3v3CityManager.getInstance().destory();
         super.destroy();
      }
   }
}

