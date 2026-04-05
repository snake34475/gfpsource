package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.manager.TasksManager;
   
   public class TaskXML_Donothing extends TaskXML_Base
   {
      
      public function TaskXML_Donothing()
      {
         super();
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
   }
}

