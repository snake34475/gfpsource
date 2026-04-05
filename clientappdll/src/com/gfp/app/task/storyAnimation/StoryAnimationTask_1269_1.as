package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import org.taomee.manager.DepthManager;
   
   public class StoryAnimationTask_1269_1 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_1269_1()
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
         loadAndPlayAnimat("task1269_1",null);
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         _offsetX = 0;
         _offsetY = 0;
         layout();
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         DepthManager.swapDepthAll(MapManager.currentMap.contentLevel);
         NpcDialogController.showForNpc(10034);
      }
   }
}

