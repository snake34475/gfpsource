package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class StoryAnimationTask_1319_1 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_1319_1()
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
         loadAndPlayAnimat("task1319_1","mc");
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         var _loc2_:SightModel = SightManager.getSightModel(10145);
         _loc2_.visible = false;
         _offsetX = 235;
         _offsetY = 248;
         layout();
      }
   }
}

