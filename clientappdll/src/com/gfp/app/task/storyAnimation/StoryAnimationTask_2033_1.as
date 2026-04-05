package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import org.taomee.manager.DepthManager;
   
   public class StoryAnimationTask_2033_1 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_2033_1()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task2033_1");
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         _offsetX = 18;
         layout();
      }
      
      override public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         super.onStart();
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 2033)
         {
            TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
            CityMap.instance.tranToNpc(10146);
         }
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 2034)
         {
            TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
            CityMap.instance.tranToNpc(10146);
         }
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         DepthManager.swapDepthAll(MapManager.currentMap.contentLevel);
         TasksManager.taskComplete(2033);
      }
   }
}

