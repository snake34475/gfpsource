package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class StoryAnimationTask_68_0 extends BaseStoryAnimation
   {
      
      private var npc:SightModel = SightManager.getSightModel(10127);
      
      public function StoryAnimationTask_68_0()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task68_0","mc");
      }
      
      override public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         super.onStart();
         this.npc.visible = false;
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         this.npc.visible = true;
         NpcDialogController.showForNpc(10127);
      }
   }
}

