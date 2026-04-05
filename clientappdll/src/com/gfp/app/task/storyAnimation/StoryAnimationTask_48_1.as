package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   
   public class StoryAnimationTask_48_1 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_48_1()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task47_2","mc");
      }
      
      override public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_SIMPLEACTION,"BrainsPanel_Close");
         super.onStart();
      }
   }
}

