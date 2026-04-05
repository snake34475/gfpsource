package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1055901 extends BaseMapProcess
   {
      
      public function MapProcess_1055901()
      {
         super();
      }
      
      override protected function init() : void
      {
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onProComplete);
         FunctionManager.disabledFightAwardPanel = true;
      }
      
      private function onProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 2006 && param1.proID == 4)
         {
            AnimatPlay.startAnimat("task2006_",3,false,0,0,false,true);
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         FunctionManager.disabledFightAwardPanel = false;
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onProComplete);
      }
   }
}

