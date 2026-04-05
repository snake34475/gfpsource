package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.sound.SoundManager;
   import flash.display.MovieClip;
   
   public class StoryAnimationTask_1903_2 extends PureStoryAnimationTask
   {
      
      private var tempMusicSetting:Boolean;
      
      public function StoryAnimationTask_1903_2()
      {
         super();
      }
      
      override protected function handleLoadMc(param1:MovieClip) : void
      {
         super.handleLoadMc(param1);
         this.tempMusicSetting = SoundManager.isMusicEnable;
         if(this.tempMusicSetting)
         {
            SoundManager.setMusicEnable(false);
         }
      }
      
      override protected function onComplete() : void
      {
         super.onComplete();
         if(this.tempMusicSetting)
         {
            SoundManager.setMusicEnable(this.tempMusicSetting);
         }
      }
   }
}

