package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   
   public class StoryAnimationTask_2090_1 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_2090_1()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task2090_1","mc");
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
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
         TasksManager.taskComplete(2090);
         CityMap.instance.tranToNpc(10001);
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         if(param1.taskID == 2090)
         {
            TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
            _loc2_ = [2085,2086,2087,2088,2089];
            for each(_loc3_ in _loc2_)
            {
               if(!TasksManager.isCompleted(_loc3_))
               {
                  TasksManager.taskComplete(_loc3_);
               }
            }
         }
      }
   }
}

