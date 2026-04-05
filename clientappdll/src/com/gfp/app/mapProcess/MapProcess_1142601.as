package com.gfp.app.mapProcess
{
   import com.gfp.app.manager.module.HelpingABaoByFieldForceManager;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1142601 extends BaseMapProcess
   {
      
      public function MapProcess_1142601()
      {
         super();
      }
      
      override protected function init() : void
      {
         HelpingABaoByFieldForceManager.init();
      }
      
      override public function destroy() : void
      {
      }
   }
}

