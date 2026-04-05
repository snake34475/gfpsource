package com.gfp.app.mapProcess
{
   import com.gfp.app.manager.module.HelpingABaoByFieldForceManager;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1142503 extends BaseMapProcess
   {
      
      public function MapProcess_1142503()
      {
         super();
      }
      
      override protected function init() : void
      {
         HelpingABaoByFieldForceManager.showCallSummonAlert();
      }
      
      override public function destroy() : void
      {
      }
   }
}

