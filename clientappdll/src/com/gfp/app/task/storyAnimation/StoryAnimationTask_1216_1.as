package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.TasksManager;
   import flash.events.Event;
   
   public class StoryAnimationTask_1216_1 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_1216_1()
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
         loadAndPlayAnimat("task1216_1",null);
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         _mainMC.stop();
         _background.visible = false;
      }
      
      override protected function onEnterFrame(param1:Event) : void
      {
      }
   }
}

