package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import org.taomee.manager.DepthManager;
   
   public class StoryAnimationTask_2032_3 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_2032_3()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task2032_3");
      }
      
      override public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         super.onStart();
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 2032)
         {
            CityMap.instance.changeMap(58);
            TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
         }
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         DepthManager.swapDepthAll(MapManager.currentMap.contentLevel);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
         TasksManager.taskComplete(2032);
      }
   }
}

