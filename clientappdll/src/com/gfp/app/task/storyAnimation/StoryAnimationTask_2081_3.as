package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import org.taomee.manager.DepthManager;
   
   public class StoryAnimationTask_2081_3 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_2081_3()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task2081_3","mc");
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
         var onComplete:Function = null;
         onComplete = function(param1:TaskEvent):void
         {
            TasksManager.removeListener(TaskEvent.COMPLETE,onComplete);
            if(param1.taskID == 2081)
            {
               CityMap.instance.tranToNpc(10001);
            }
         };
         super.onFinish();
         DepthManager.swapDepthAll(MapManager.currentMap.contentLevel);
         TasksManager.taskComplete(2081);
         TasksManager.addListener(TaskEvent.COMPLETE,onComplete);
      }
   }
}

