package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   
   public class StoryAnimationTask_1330_1 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_1330_1()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task1330_1_" + MainManager.actorInfo.roleType);
      }
      
      override public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_MAPCOLLECT,"MonsterTurnToPig");
         this.loadAnimat();
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         PveEntry.onWinner();
      }
   }
}

