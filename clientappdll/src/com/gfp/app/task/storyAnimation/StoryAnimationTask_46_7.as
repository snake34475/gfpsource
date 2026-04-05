package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   
   public class StoryAnimationTask_46_7 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_46_7()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task46_7");
      }
      
      override public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         super.onStart();
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         NpcDialogController.showForNpc(10121);
      }
   }
}

