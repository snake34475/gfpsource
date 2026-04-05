package com.gfp.app.mapProcess
{
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapProcess_68 extends BaseMapProcess
   {
      
      private var _ymhModel:SightModel;
      
      private var _gljgModel:SightModel;
      
      public function MapProcess_68()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._ymhModel = SightManager.getSightModel(10568);
         this._gljgModel = SightManager.getSightModel(10569);
         this.checkModel();
      }
      
      private function checkModel() : void
      {
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
      }
   }
}

