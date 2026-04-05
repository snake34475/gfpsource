package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.SightModel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.DisplayUtil;
   
   public class StoryAnimationTask_19_0 implements IStoryAnimation
   {
      
      private var _params:String;
      
      private var _animation:MovieClip;
      
      private var _animationPlayCount:int;
      
      public function StoryAnimationTask_19_0()
      {
         super();
      }
      
      public function setParams(param1:String) : void
      {
         this._params = param1;
      }
      
      public function start() : void
      {
         this.onStart();
         MainManager.closeOperate();
         this.playAnimation();
         this.hideNPC10002();
      }
      
      private function playAnimation() : void
      {
         if(MapManager.currentMap)
         {
            this._animation = MapManager.currentMap.libManager.getMovieClip(this._params);
         }
         if(this._animation)
         {
            this._animation.x = 717;
            this._animation.y = 391;
            this._animationPlayCount = 0;
            MapManager.currentMap.contentLevel.addChild(this._animation);
            DepthManager.swapDepthAll(MapManager.currentMap.contentLevel);
            this._animation.addEventListener(Event.ENTER_FRAME,this.onAnimationPlay);
         }
         else
         {
            this.onFinish();
         }
      }
      
      private function onAnimationPlay(param1:Event) : void
      {
         ++this._animationPlayCount;
         if(this._animationPlayCount >= 100)
         {
            this._animation.removeEventListener(Event.ENTER_FRAME,this.onAnimationPlay);
            this.onFinish();
         }
      }
      
      private function hideNPC10002() : void
      {
         var _loc1_:SightModel = SightManager.getSightModel(10002);
         if(_loc1_)
         {
            _loc1_.visible = false;
         }
      }
      
      private function showNPC10002() : void
      {
         var _loc1_:SightModel = SightManager.getSightModel(10002);
         if(_loc1_)
         {
            _loc1_.visible = true;
         }
      }
      
      public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
      }
      
      public function onFinish() : void
      {
         this.showNPC10002();
         DisplayUtil.removeForParent(this._animation);
         this._animation = null;
         MainManager.openOperate();
      }
   }
}

