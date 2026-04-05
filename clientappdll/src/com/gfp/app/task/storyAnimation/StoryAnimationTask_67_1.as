package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class StoryAnimationTask_67_1 extends BaseStoryAnimation
   {
      
      private var npc:SightModel = SightManager.getSightModel(10127);
      
      public function StoryAnimationTask_67_1()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         if(MainManager.actorInfo.roleType > 4)
         {
            loadAndPlayAnimat("task67_1_" + 1,"mc");
         }
         else
         {
            loadAndPlayAnimat("task67_1_" + MainManager.actorInfo.roleType,"mc");
         }
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

