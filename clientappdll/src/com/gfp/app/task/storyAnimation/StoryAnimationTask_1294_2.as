package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   
   public class StoryAnimationTask_1294_2 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_1294_2()
      {
         super();
      }
      
      override public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         super.onStart();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task1294_2","updataMC");
      }
   }
}

