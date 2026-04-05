package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.TasksManager;
   
   public class StoryAnimationTask_1312_1 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_1312_1()
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
         loadAndPlayAnimat("task1312_1","updataMC");
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         _background.visible = false;
      }
   }
}

