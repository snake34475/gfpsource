package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   
   public class StoryAnimationTask_2064_4 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_2064_4()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task2064_4");
      }
      
      override public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         super.onStart();
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         TasksManager.taskComplete(2064);
      }
   }
}

