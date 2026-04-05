package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.events.MouseEvent;
   
   public class MapProcess_1041 extends BaseMapProcess
   {
      
      public function MapProcess_1041()
      {
         super();
      }
      
      override protected function init() : void
      {
      }
      
      protected function onMouseClick(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("SummonFishPanel");
      }
      
      private function addEvent() : void
      {
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function removeEvent() : void
      {
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 2005)
         {
            AnimatPlay.startAnimat("task2005_",0,false,0,0,false,true);
         }
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 2005 && param1.proID == 0)
         {
            PveEntry.enterTollgate(555);
         }
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 2005)
         {
            SightManager.getSightModel(10510).visible = false;
            SightManager.getSightModel(10501).visible = true;
         }
      }
      
      override public function destroy() : void
      {
         this.removeEvent();
      }
   }
}

