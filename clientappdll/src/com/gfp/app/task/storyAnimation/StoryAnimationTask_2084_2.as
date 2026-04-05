package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import org.taomee.manager.DepthManager;
   
   public class StoryAnimationTask_2084_2 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_2084_2()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task2084_2","mc");
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         _offsetX = 233.35;
         _offsetY = 131.65;
         layout();
      }
      
      override public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         super.onStart();
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         DepthManager.swapDepthAll(MapManager.currentMap.contentLevel);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onComplete);
         TasksManager.taskComplete(2084);
      }
      
      private function onComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 2084)
         {
            TasksManager.removeListener(TaskEvent.COMPLETE,this.onComplete);
            TasksManager.accept(2085);
            TasksManager.accept(2086);
            TasksManager.accept(2087);
            TasksManager.accept(2088);
            TasksManager.accept(2089);
         }
      }
   }
}

