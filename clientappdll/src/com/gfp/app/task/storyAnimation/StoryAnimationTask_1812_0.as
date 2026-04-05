package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   
   public class StoryAnimationTask_1812_0 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_1812_0()
      {
         super();
      }
      
      override public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         super.onStart();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task1812_0","mc");
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         NpcDialogController.showForNpc(1812);
      }
   }
}

