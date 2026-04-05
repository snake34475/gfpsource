package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.TasksManager;
   
   public class StoryAnimationTask_1901_1 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_1901_1()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task1901_1","movie");
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         _offsetX = 233.35;
         _offsetY = 131.65;
         layout();
      }
      
      override public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_SIMPLEACTION,"BrainsPanel_Close");
         super.onStart();
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         TasksManager.taskProComplete(1901,1);
      }
   }
}

