package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.TasksManager;
   
   public class StoryAnimationTask_1833_0 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_1833_0()
      {
         super();
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         _background.visible = false;
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task1833_0","mc");
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
      }
   }
}

