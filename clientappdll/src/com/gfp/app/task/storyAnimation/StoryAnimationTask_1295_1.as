package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class StoryAnimationTask_1295_1 extends BaseStoryAnimation
   {
      
      private var _npc10020:SightModel;
      
      private var _npc10019:SightModel;
      
      public function StoryAnimationTask_1295_1()
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
         loadAndPlayAnimat("task1295_1","mainMC");
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         this._npc10020 = SightManager.getSightModel(10020);
         this._npc10020.hide();
         this._npc10019 = SightManager.getSightModel(10019);
         this._npc10019.hide();
         _offsetX = 290;
         _offsetY = 330;
         layout();
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         this._npc10020.show();
         this._npc10019.show();
         this._npc10020 = null;
         this._npc10019 = null;
         NpcDialogController.showForNpc(10019);
      }
   }
}

