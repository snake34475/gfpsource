package com.gfp.app.task.tc
{
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   
   public class TaskXML_EscortPathComplete extends TaskXML_EscortComplete
   {
      
      public function TaskXML_EscortPathComplete()
      {
         super();
      }
      
      override public function onEscortComplete(param1:DataEvent) : void
      {
         var _loc2_:int = int(param1.data);
         if(_loc2_ == _taskType)
         {
            TasksManager.taskProComplete(_taskID,_proID);
            TextAlert.show(getTaskProcName(_taskID,_proID) + " (完成)");
            uninit();
         }
      }
   }
}

