package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.TasksManager;
   
   public class StoryAnimationTask_2083_1 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_2083_1()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task2082_2","mc");
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         _offsetX = 234.35;
         _offsetY = 132.65;
         layout();
      }
      
      override public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         super.onStart();
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         PveEntry.instance.enterTollgate(414);
      }
   }
}

