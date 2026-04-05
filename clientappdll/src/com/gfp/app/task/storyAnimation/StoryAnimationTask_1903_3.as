package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import flash.display.MovieClip;
   
   public class StoryAnimationTask_1903_3 extends PureStoryAnimationTask
   {
      
      private var isWin:Boolean = false;
      
      public function StoryAnimationTask_1903_3()
      {
         super();
      }
      
      override protected function onComplete() : void
      {
         onFinish();
         PveEntry.enterTollgate(514);
         FightManager.instance.addEventListener(FightEvent.QUITE,this.fightQuiteHandler);
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         this.isWin = true;
      }
      
      private function fightQuiteHandler(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.QUITE,this.fightQuiteHandler);
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         if(this.isWin)
         {
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_FINISH,"");
         }
      }
      
      override protected function handleLoadMc(param1:MovieClip) : void
      {
         super.handleLoadMc(param1);
      }
      
      override protected function loadAnimation(param1:String) : void
      {
         super.loadAnimation(param1);
      }
   }
}

