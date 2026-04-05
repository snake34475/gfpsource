package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.config.xml.NpcXMLInfo;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import org.taomee.utils.DisplayUtil;
   
   public class StoryAnimationTask_1880_1 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_1880_1()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("Task1880_1");
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         _offsetX = 0;
         _offsetY = 0;
         layout();
      }
      
      override public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         super.onStart();
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         DisplayUtil.removeForParent(_mainMC);
         MainManager.actorModel.changeRoleView(13623);
         MainManager.actorModel.pos = NpcXMLInfo.getTtranPos(10430);
         MainManager.actorModel.execStandAction(true);
         NpcDialogController.showForNpc(10430);
      }
   }
}

