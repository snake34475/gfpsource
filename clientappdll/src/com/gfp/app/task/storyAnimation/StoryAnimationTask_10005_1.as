package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   
   public class StoryAnimationTask_10005_1 implements IStoryAnimation
   {
      
      public function StoryAnimationTask_10005_1()
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
      }
      
      public function onStart() : void
      {
         this.loadAnimat();
      }
      
      private function loadAnimat() : void
      {
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onFinishHandler);
         AnimatPlay.startAnimat("StoryAnimationTask_10005_",1,false,231,133,false,true);
      }
      
      public function onFinishHandler(param1:AnimatEvent) : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onFinishHandler);
         MainManager.openOperate();
         TasksManager.taskComplete(10005);
      }
      
      public function onFinish() : void
      {
      }
   }
}

