package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.core.manager.TasksManager;
   
   public class StoryAnimationTask_10006_1 implements IStoryAnimation
   {
      
      public function StoryAnimationTask_10006_1()
      {
         super();
      }
      
      public function setParams(param1:String) : void
      {
      }
      
      public function start() : void
      {
         this.onStart();
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onFinishHandler);
         AnimatPlay.startAnimat("StoryAnimationTask_10006_",2,true,0,10,false,false,false);
      }
      
      public function onStart() : void
      {
      }
      
      public function onFinishHandler(param1:AnimatEvent) : void
      {
         this.onFinish();
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onFinishHandler);
         TasksManager.taskProComplete(10006,1);
      }
      
      public function onFinish() : void
      {
      }
   }
}

