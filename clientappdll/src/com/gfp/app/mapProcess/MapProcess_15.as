package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_15 extends MapProcessAnimat
   {
      
      private var _task29Animation:MovieClip;
      
      public function MapProcess_15()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addTasksManagerEventListener();
         this.addMapEventListener();
      }
      
      private function checkTaskStatus() : void
      {
         this.initTask29();
      }
      
      private function initTask29() : void
      {
         var _loc1_:int = 0;
         if(Boolean(TasksManager.isAccepted(29)) && !TasksManager.isTaskProComplete(29,0) || Boolean(TasksManager.isAccepted(525)) && !TasksManager.isTaskProComplete(525,0))
         {
            MainManager.closeOperate();
            this.hideActor();
            MapManager.currentMap.camera.scroll(0,70);
            _loc1_ = 1;
            this._task29Animation = _mapModel.libManager.getMovieClip("task29AnimationRole_" + _loc1_);
            this._task29Animation.addEventListener(Event.ENTER_FRAME,this.onTask29AnimationPlay);
            this._task29Animation.scaleX = -1;
            this._task29Animation.x = 2032;
            this._task29Animation.y = -212;
            _mapModel.contentLevel.addChild(this._task29Animation);
         }
      }
      
      private function hideActor() : void
      {
         MainManager.actorModel.visible = false;
         SummonManager.setActorSummonVisible(false);
      }
      
      private function showActor() : void
      {
         MainManager.actorModel.visible = true;
      }
      
      private function onTask29AnimationPlay(param1:Event) : void
      {
         if(this._task29Animation.currentFrame == this._task29Animation.totalFrames)
         {
            this._task29Animation.removeEventListener(Event.ENTER_FRAME,this.onTask29AnimationPlay);
            PveEntry.enterTollgate(905);
            DisplayUtil.removeForParent(this._task29Animation);
         }
      }
      
      private function addTasksManagerEventListener() : void
      {
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function removeTasksManagerEventListener() : void
      {
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 53 || param1.taskID == 54)
         {
            CityMap.instance.changeMap(2,0,1,new Point(131,440));
         }
      }
      
      private function addMapEventListener() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
      }
      
      private function removeMapEventListener() : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         this.checkTaskStatus();
      }
      
      override public function destroy() : void
      {
         this.removeTasksManagerEventListener();
         this.removeMapEventListener();
         this.showActor();
         super.destroy();
      }
   }
}

