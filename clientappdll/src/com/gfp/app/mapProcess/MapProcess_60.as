package com.gfp.app.mapProcess
{
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapProcess_60 extends BaseMapProcess
   {
      
      private var sightModel_10406:SightModel;
      
      public function MapProcess_60()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.sightModel_10406 = SightManager.getSightModel(10406);
         if(this.sightModel_10406 == null)
         {
            return;
         }
         if(!TasksManager.isCompleted(1780))
         {
            this.sightModel_10406.hide();
         }
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 1780)
         {
            this.sightModel_10406.show();
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
   }
}

