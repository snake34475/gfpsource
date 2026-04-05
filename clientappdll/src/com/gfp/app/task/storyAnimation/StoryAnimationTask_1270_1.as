package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.TasksManager;
   import flash.events.Event;
   
   public class StoryAnimationTask_1270_1 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_1270_1()
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
         loadAndPlayAnimat("task1270_1",null);
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         NpcDialogController.showForNpc(10003);
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         _mainMC.stop();
      }
      
      override protected function onEnterFrame(param1:Event) : void
      {
      }
   }
}

