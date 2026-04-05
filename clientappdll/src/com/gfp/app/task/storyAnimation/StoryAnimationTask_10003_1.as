package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.events.MouseEvent;
   
   public class StoryAnimationTask_10003_1 extends BaseStoryAnimation
   {
      
      private static const TollgateID:int = 665;
      
      public function StoryAnimationTask_10003_1()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("StoryAnimationTask_10003_1","animat");
      }
      
      override protected function addJumpBtn() : void
      {
         _jumpBtn = new UI_fight();
         _jumpBtn.addEventListener(MouseEvent.CLICK,this.onJump);
         LayerManager.stage.addChild(_jumpBtn);
      }
      
      override protected function onJump(param1:MouseEvent) : void
      {
         TextAlert.show("小侠士别急，请再等一下吧");
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onFinishHandler);
         AnimatPlay.startAnimat("StoryAnimationTask_10003_",5,false,231,133,false,true);
      }
      
      private function onFinishHandler(param1:AnimatEvent) : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onFinishHandler);
         TasksManager.taskProComplete(10003,3);
         PveEntry.enterTollgate(TollgateID);
         MainManager.openOperate();
      }
   }
}

