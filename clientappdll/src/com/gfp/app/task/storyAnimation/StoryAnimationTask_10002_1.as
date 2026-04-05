package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.core.manager.TasksManager;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class StoryAnimationTask_10002_1 implements IStoryAnimation
   {
      
      private var _mainMC:MovieClip;
      
      public function StoryAnimationTask_10002_1()
      {
         super();
      }
      
      public function setParams(param1:String) : void
      {
      }
      
      public function start() : void
      {
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onFinishHandler);
         this.playAnimate();
      }
      
      private function playAnimate() : void
      {
         AnimatPlay.startAnimat("StoryAnimationTask_10002_",1,false,231,133,false,true);
      }
      
      public function onStart() : void
      {
      }
      
      public function onFinishHandler(param1:AnimatEvent) : void
      {
         this.onFinish();
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onFinishHandler);
      }
      
      public function onFinish() : void
      {
         DisplayUtil.removeForParent(this._mainMC);
         this._mainMC = null;
         TasksManager.taskComplete(10002);
      }
   }
}

