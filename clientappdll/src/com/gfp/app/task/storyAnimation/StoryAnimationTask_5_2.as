package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class StoryAnimationTask_5_2 implements IStoryAnimation
   {
      
      private var _params:String;
      
      private var _animation:MovieClip;
      
      private var _closeBtn:SimpleButton;
      
      public function StoryAnimationTask_5_2()
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
         this.playAnimation();
         this.onStart();
      }
      
      public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
      }
      
      private function playAnimation() : void
      {
         if(MapManager.currentMap)
         {
            this._animation = MapManager.currentMap.libManager.getMovieClip(this._params);
            if(this._animation)
            {
               this._animation.x = LayerManager.stageWidth - this._animation.width >> 1;
               this._animation.y = 70;
               this._closeBtn = this._animation["closeBtn"];
               this._closeBtn.visible = false;
               LayerManager.topLevel.addChild(this._animation);
               this._animation.addEventListener(Event.ENTER_FRAME,this.onAnimationPlay);
            }
            else
            {
               this.onFinish();
            }
         }
         else
         {
            this.onFinish();
         }
      }
      
      public function onAnimationPlay(param1:Event) : void
      {
         if(this._animation.currentFrame == this._animation.totalFrames)
         {
            this._animation.removeEventListener(Event.ENTER_FRAME,this.onAnimationPlay);
            this._closeBtn.visible = true;
            this._closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         }
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
         this.onFinish();
      }
      
      public function onFinish() : void
      {
         DisplayUtil.removeForParent(this._animation);
         this._animation = null;
         MainManager.openOperate();
      }
   }
}

