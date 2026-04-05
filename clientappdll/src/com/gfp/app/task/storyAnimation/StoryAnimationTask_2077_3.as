package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import org.taomee.manager.DepthManager;
   
   public class StoryAnimationTask_2077_3 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_2077_3()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task2077_3");
      }
      
      override public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         super.onStart();
      }
      
      override public function onFinish() : void
      {
         var onComplegte:Function = null;
         onComplegte = function(param1:TaskEvent):void
         {
            if(param1.taskID == 2077)
            {
               TasksManager.removeListener(TaskEvent.COMPLETE,onComplegte);
               TasksManager.accept(2078);
            }
         };
         super.onFinish();
         DepthManager.swapDepthAll(MapManager.currentMap.contentLevel);
         TasksManager.taskComplete(2077);
         TasksManager.addListener(TaskEvent.COMPLETE,onComplegte);
      }
   }
}

