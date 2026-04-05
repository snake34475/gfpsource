package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_MinigamePlay extends TaskXML_Base
   {
      
      public function TaskXML_MinigamePlay()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr(_params,param1,param2);
         Logger.info(this,_loc5_);
      }
      
      private function onMinigamePlay(param1:TaskActionEvent) : void
      {
         TasksManager.taskProComplete(_taskID,_proID);
         this.uninit();
      }
      
      override protected function addListener() : void
      {
         TasksManager.addActionListener(TaskActionEvent.TASK_MINIGAMEPLAY,_params,this.onMinigamePlay);
      }
      
      override public function uninit() : void
      {
         TasksManager.removeActionListener(TaskActionEvent.TASK_MINIGAMEPLAY,_params,this.onMinigamePlay);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
   }
}

