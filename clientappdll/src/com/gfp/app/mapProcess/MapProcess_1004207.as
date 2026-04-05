package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.utils.setTimeout;
   
   public class MapProcess_1004207 extends BaseMapProcess
   {
      
      public function MapProcess_1004207()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(Boolean(TasksManager.isAccepted(67)) && Boolean(TasksManager.isProcess(67,3)))
         {
            FightManager.isAutoWinnerEnd = false;
            FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
         }
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         this.playAnimation();
      }
      
      private function playAnimation() : void
      {
         MainManager.actorModel.visible = false;
         AnimatPlay.startAnimat("task67_3");
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEndHandle);
      }
      
      private function onAnimatEndHandle(param1:AnimatEvent) : void
      {
         var event:AnimatEvent = param1;
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEndHandle);
         MainManager.actorModel.visible = true;
         MainManager.openOperate();
         setTimeout(function():void
         {
            PveEntry.onWinner();
         },3000);
      }
   }
}

