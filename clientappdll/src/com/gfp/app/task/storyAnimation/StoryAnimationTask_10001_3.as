package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.model.MapModel;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.sound.SoundManager;
   import flash.display.MovieClip;
   import org.taomee.media.ListSoundPlayer;
   
   public class StoryAnimationTask_10001_3 implements IStoryAnimation
   {
      
      private var _drankMC:MovieClip;
      
      private var _grandpaNPC:SightModel;
      
      private var _mapModel:MapModel;
      
      private var pl:ListSoundPlayer;
      
      public function StoryAnimationTask_10001_3()
      {
         super();
      }
      
      public function setParams(param1:String) : void
      {
      }
      
      public function start() : void
      {
         if(ClientTempState.isPlayTASKAnimate == false)
         {
            return;
         }
         ClientTempState.isPlayTASKAnimate = false;
         MainManager.closeOperate();
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onFinishHandler);
         AnimatPlay.startAnimat("StoryAnimationTask_10001_",3,false,231,133,false,true);
      }
      
      public function onStart() : void
      {
         if(SoundManager.isMusicEnable)
         {
            SoundManager.bgPlayer.stop();
            this.pl = new ListSoundPlayer();
            this.pl.volume = 0.4;
            this.pl.enabled = true;
            this.pl.addUrl(ClientConfig.getSoundStory("story_001"),3000);
            this.pl.play();
         }
      }
      
      public function onFinishHandler(param1:AnimatEvent) : void
      {
         this.onFinish();
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onFinishHandler);
      }
      
      public function onFinish() : void
      {
         if(this.pl)
         {
            this.pl.stop();
         }
         if(SoundManager.isMusicEnable)
         {
            SoundManager.bgPlayer.play();
         }
         TasksManager.taskComplete(10001);
      }
   }
}

