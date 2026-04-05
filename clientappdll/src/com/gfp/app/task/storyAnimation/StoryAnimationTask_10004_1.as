package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.UILoader;
   import flash.display.MovieClip;
   
   public class StoryAnimationTask_10004_1 implements IStoryAnimation
   {
      
      private var _mainMC:MovieClip;
      
      private var _loader:UILoader;
      
      public function StoryAnimationTask_10004_1()
      {
         super();
      }
      
      public function setParams(param1:String) : void
      {
      }
      
      public function start() : void
      {
         MainManager.closeOperate();
         this.onStart();
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onFinishHandler);
         AnimatPlay.startAnimat("StoryAnimationTask_10004_",1,false,231,133,false,true);
      }
      
      public function onStart() : void
      {
      }
      
      public function onFinishHandler(param1:AnimatEvent) : void
      {
         this.onFinish();
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onFinishHandler);
         MainManager.openOperate();
         TasksManager.taskComplete(10004);
      }
      
      public function onFinish() : void
      {
      }
   }
}

