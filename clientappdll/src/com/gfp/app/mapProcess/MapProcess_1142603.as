package com.gfp.app.mapProcess
{
   import com.gfp.app.manager.module.HelpingABaoByFieldForceManager;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1142603 extends BaseMapProcess
   {
      
      public function MapProcess_1142603()
      {
         super();
      }
      
      override protected function init() : void
      {
         HelpingABaoByFieldForceManager.showCallSoulAlert();
      }
      
      override public function destroy() : void
      {
      }
   }
}

