package com.gfp.app.mapProcess
{
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1039 extends BaseMapProcess
   {
      
      public function MapProcess_1039()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         FunctionManager.disabledChange = true;
         FunctionManager.disabledTransfiguration = true;
         FunctionManager.disabledTradeHouse = true;
         FunctionManager.disabledRide = true;
         this.initMapEvent();
      }
      
      private function initMapEvent() : void
      {
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
      }
      
      private function clearEvent() : void
      {
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         switch(param1.taskID)
         {
            case 1931:
               TasksManager.taskComplete(1931);
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.clearEvent();
         FunctionManager.disabledChange = false;
         FunctionManager.disabledTransfiguration = false;
         FunctionManager.disabledTradeHouse = false;
         FunctionManager.disabledRide = false;
      }
   }
}

