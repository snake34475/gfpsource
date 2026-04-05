package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import flash.geom.Point;
   
   public class StoryAnimationTask_79_1 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_79_1()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task79_1","mc");
      }
      
      override public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         super.onStart();
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         CityMap.instance.changeMap(53,0,1,new Point(1055,575));
      }
   }
}

