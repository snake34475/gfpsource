package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import flash.events.Event;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.DisplayUtil;
   
   public class StoryAnimationTask_2077_2 extends BaseStoryAnimation
   {
      
      private var _count:int = 0;
      
      public function StoryAnimationTask_2077_2()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task2077_2","mc");
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         if(this._count == 0)
         {
            _offsetY = 280;
            layout();
         }
         ++this._count;
      }
      
      override public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         super.onStart();
      }
      
      override protected function playEnd() : void
      {
         if(this._count == 1)
         {
            _loader.destroy();
            _mainMC.stop();
            _mainMC.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
            DisplayUtil.removeForParent(_mainMC);
            CityMap.instance.changeMap(62);
            loadAndPlayAnimat("task2077_3","mc");
         }
         else
         {
            super.playEnd();
         }
      }
      
      override public function onFinish() : void
      {
         var onComplegte:Function = null;
         onComplegte = function(param1:TaskEvent):void
         {
            var onAccept:Function;
            var e:TaskEvent = param1;
            if(e.taskID == 2077)
            {
               onAccept = function():void
               {
                  CityMap.instance.changeMap(67);
               };
               TasksManager.removeListener(TaskEvent.COMPLETE,onComplegte);
               TasksManager.addListener(TaskEvent.ACCEPT,onAccept);
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

