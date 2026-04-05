package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   
   public class StoryAnimationTask_10006_3 implements IStoryAnimation
   {
      
      public function StoryAnimationTask_10006_3()
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
         AnimatPlay.startAnimat("StoryAnimationTask_10006_",4,true,0,0,false,false,false);
      }
      
      public function onStart() : void
      {
      }
      
      public function onFinishHandler(param1:AnimatEvent) : void
      {
         this.onFinish();
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onFinishHandler);
         MainManager.openOperate();
         TasksManager.taskProComplete(10006,3);
         PveEntry.enterTollgate(674);
      }
      
      public function onFinish() : void
      {
      }
   }
}

