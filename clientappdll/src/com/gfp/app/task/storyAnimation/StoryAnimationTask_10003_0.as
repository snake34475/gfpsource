package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.TasksManager;
   import flash.events.MouseEvent;
   
   public class StoryAnimationTask_10003_0 extends BaseStoryAnimation
   {
      
      private static const TollgateID:int = 661;
      
      public function StoryAnimationTask_10003_0()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("StoryAnimationTask_10002_0","animat");
      }
      
      override protected function addJumpBtn() : void
      {
         _jumpBtn = new UI_fight();
         _jumpBtn.addEventListener(MouseEvent.CLICK,onJump);
         LayerManager.stage.addChild(_jumpBtn);
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         TasksManager.taskProComplete(10003,0);
         PveEntry.enterTollgate(TollgateID);
      }
   }
}

