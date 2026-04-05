package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   
   public class StoryAnimationTask_1816_3 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_1816_3()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task1816_3","mc");
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         NpcDialogController.showForNpc(10427);
      }
   }
}

