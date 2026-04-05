package com.gfp.app.task.tc
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   
   public class TaskXML_StoryAnimationEndFinish extends TaskXML_StoryAnimation
   {
      
      public function TaskXML_StoryAnimationEndFinish()
      {
         super();
      }
      
      override protected function onAnimationStart(param1:TaskActionEvent) : void
      {
      }
      
      override protected function addListener() : void
      {
         super.addListener();
         TasksManager.addActionListener(TaskActionEvent.TASK_ANIMATION_FINISH,"",this.onAnimationFinish);
      }
      
      override public function uninit() : void
      {
         super.uninit();
         TasksManager.removeActionListener(TaskActionEvent.TASK_ANIMATION_FINISH,"",this.onAnimationFinish);
      }
      
      protected function onAnimationFinish(param1:TaskActionEvent) : void
      {
         TasksManager.taskProComplete(_taskID,_proID);
         this.uninit();
      }
   }
}

