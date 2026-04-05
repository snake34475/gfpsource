package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.TasksManager;
   import flash.events.MouseEvent;
   
   public class StoryAnimationTask_1881_1 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_1881_1()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task1881_1");
      }
      
      override protected function addJumpBtn() : void
      {
         _jumpBtn = new ToolBar_JumpOverBtn();
         _jumpBtn.addEventListener(MouseEvent.CLICK,onJump);
         LayerManager.stage.addChild(_jumpBtn);
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         TasksManager.taskProComplete(1881,1);
         NpcDialogController.showForNpc(10066);
      }
   }
}

