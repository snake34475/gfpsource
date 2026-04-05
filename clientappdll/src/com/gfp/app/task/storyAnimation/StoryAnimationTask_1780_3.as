package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   
   public class StoryAnimationTask_1780_3 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_1780_3()
      {
         super();
      }
      
      override public function onFinish() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         super.onFinish();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task1780_3","mc");
      }
   }
}

