package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.utils.DisplayUtil;
   
   public class StoryAnimationTask_28_2 implements IStoryAnimation
   {
      
      private var _hugAnimation:MovieClip;
      
      private var _cameraX:Number;
      
      private var _cameraY:Number;
      
      private var _params:String;
      
      public function StoryAnimationTask_28_2()
      {
         super();
      }
      
      public function setParams(param1:String) : void
      {
         this._params = param1;
      }
      
      public function start() : void
      {
         MainManager.closeOperate();
         this.platHugAnimat();
         this.onStart();
      }
      
      private function platHugAnimat() : void
      {
         this.scrollMap();
         SightManager.getSightModel(10037).visible = false;
         this._hugAnimation = MapManager.currentMap.libManager.getMovieClip("hug_MC");
         this._hugAnimation.addEventListener(Event.ENTER_FRAME,this.onHugEnterFrame);
         this._hugAnimation.y = -20;
         LayerManager.topLevel.addChild(this._hugAnimation);
         this._hugAnimation.gotoAndPlay(1);
      }
      
      private function scrollMap() : void
      {
         this._cameraX = MapManager.currentMap.camera.viewArea.x;
         this._cameraY = MapManager.currentMap.camera.viewArea.y;
         MapManager.currentMap.camera.scroll(0,0);
      }
      
      private function onHugEnterFrame(param1:Event) : void
      {
         if(this._hugAnimation.currentFrame == this._hugAnimation.totalFrames)
         {
            this._hugAnimation.removeEventListener(Event.ENTER_FRAME,this.onHugEnterFrame);
            DisplayUtil.removeForParent(this._hugAnimation);
            SightManager.getSightModel(10037).visible = true;
            MapManager.currentMap.camera.scroll(this._cameraX,this._cameraX);
            this.onFinish();
         }
      }
      
      public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
      }
      
      public function onFinish() : void
      {
         this._hugAnimation = null;
         MainManager.openOperate();
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_FINISH,"");
         CityMap.instance.tranToNpc(10037);
      }
   }
}

