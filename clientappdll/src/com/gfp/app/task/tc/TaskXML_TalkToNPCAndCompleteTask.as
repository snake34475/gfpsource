package com.gfp.app.task.tc
{
   import com.gfp.core.manager.TasksManager;
   
   public class TaskXML_TalkToNPCAndCompleteTask extends TaskXML_TalkToNPC
   {
      
      public function TaskXML_TalkToNPCAndCompleteTask()
      {
         super();
      }
      
      override protected function taskProComplete() : void
      {
         super.taskProComplete();
         TasksManager.taskComplete(_taskID);
      }
   }
}

