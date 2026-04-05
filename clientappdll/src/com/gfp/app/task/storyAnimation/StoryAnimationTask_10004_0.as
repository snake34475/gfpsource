package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.TasksManager;
   import flash.display.MovieClip;
   
   public class StoryAnimationTask_10004_0 implements IStoryAnimation
   {
      
      private static const TollgateID:int = 666;
      
      private var _mainMC:MovieClip;
      
      public function StoryAnimationTask_10004_0()
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
         AnimatPlay.startAnimat("StoryAnimationTask_10004_",0,false,231,133,false,true);
      }
      
      public function onFinishHandler(param1:AnimatEvent) : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onFinishHandler);
         MainManager.openOperate();
         TasksManager.taskProComplete(10004,0);
         ModuleManager.turnModule(ClientConfig.getAppModule("FragJade"),"开始拼接玉佩...");
      }
      
      public function onFinish() : void
      {
      }
   }
}

