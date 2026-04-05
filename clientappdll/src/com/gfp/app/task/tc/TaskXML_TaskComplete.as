package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   
   public class TaskXML_TaskComplete extends TaskXML_Base
   {
      
      public var task_params:String;
      
      public function TaskXML_TaskComplete()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         this.task_params = param3;
         if(TasksManager.isCompleted(uint(this.task_params)))
         {
            this.setComplete();
         }
      }
      
      override protected function addListener() : void
      {
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == uint(this.task_params))
         {
            this.setComplete();
         }
      }
      
      private function setComplete() : void
      {
         TasksManager.taskProComplete(_taskID,_proID);
         TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
         this.uninit();
      }
      
      private function getTaskProcName(param1:uint, param2:uint) : String
      {
         return TasksXMLInfo.getProDoc(param1,param2);
      }
      
      override public function uninit() : void
      {
         ItemManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      override public function get isComplete() : Boolean
      {
         if(TasksManager.isCompleted(uint(this.task_params)))
         {
            return true;
         }
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
   }
}

