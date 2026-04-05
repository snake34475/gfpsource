package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.TasksManager;
   import flash.events.MouseEvent;
   
   public class StoryAnimationTask_1899_1 extends BaseStoryAnimation
   {
      
      private static const TollgateID:int = 500;
      
      public function StoryAnimationTask_1899_1()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("StoryAnimationTask_1899_1");
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
         TasksManager.taskProComplete(1899,3);
         PveEntry.enterTollgate(TollgateID);
      }
   }
}

