package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   
   public class StoryAnimationTask_1102_0 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_1102_0()
      {
         super();
      }
      
      override public function onStart() : void
      {
         super.onStart();
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task1102_1",null);
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         NpcDialogController.showForNpc(10014);
      }
   }
}

