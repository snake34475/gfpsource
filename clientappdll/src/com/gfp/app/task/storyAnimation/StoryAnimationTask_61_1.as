package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.action.mouse.MouseProcess;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import flash.geom.Point;
   
   public class StoryAnimationTask_61_1 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_61_1()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task61_1","mc");
      }
      
      override public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         super.onStart();
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         MouseProcess.execWalk(MainManager.actorModel,new Point(1000,570));
      }
   }
}

