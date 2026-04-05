package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   
   public class StoryAnimationTask_1834_0 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_1834_0()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task1834_0","mc");
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
      }
   }
}

