package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import org.taomee.manager.DepthManager;
   
   public class StoryAnimationTask_1255_5 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_1255_5()
      {
         super();
      }
      
      override public function onStart() : void
      {
         super.onStart();
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task1255_5",null);
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         _background.visible = false;
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         DepthManager.swapDepthAll(MapManager.currentMap.contentLevel);
      }
   }
}

