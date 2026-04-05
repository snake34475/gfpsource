package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   
   public class StoryAnimationTask_1724_0 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_1724_0()
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
         loadAndPlayAnimat("task1724_0");
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         PveEntry.enterTollgate(980);
      }
   }
}

