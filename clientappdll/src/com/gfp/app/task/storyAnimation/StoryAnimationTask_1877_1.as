package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.manager.TasksManager;
   
   public class StoryAnimationTask_1877_1 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_1877_1()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task1877_1","mc");
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         TasksManager.taskProComplete(1877,1);
         NpcDialogController.showForNpc(10438);
      }
   }
}

