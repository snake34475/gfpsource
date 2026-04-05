package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.sound.SoundManager;
   import flash.events.MouseEvent;
   import org.taomee.media.ListSoundPlayer;
   
   public class StoryAnimationTask_10001_2 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_10001_2()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("StoryAnimationTask_10001_2","animat");
      }
      
      override protected function playSound() : void
      {
         if(SoundManager.isMusicEnable)
         {
            SoundManager.bgPlayer.stop();
            pl = new ListSoundPlayer();
            pl.volume = 0.4;
            pl.enabled = true;
            pl.addUrl(ClientConfig.getSoundStory("story_001"),3000);
            pl.play();
         }
      }
      
      override protected function addJumpBtn() : void
      {
         _jumpBtn = new ToolBar_BitSnake();
         _jumpBtn.addEventListener(MouseEvent.CLICK,onJump);
         LayerManager.stage.addChild(_jumpBtn);
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         TasksManager.taskProComplete(10001,3);
         PveEntry.enterTollgate(609);
      }
   }
}

