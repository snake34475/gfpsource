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
   import flash.events.Event;
   import flash.utils.setTimeout;
   
   public class MapProcess_1004607 extends BaseMapProcess
   {
      
      public function MapProcess_1004607()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(Boolean(TasksManager.isAccepted(72)) && Boolean(TasksManager.isProcess(72,0)))
         {
            MainManager.closeOperate(true);
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
         AnimatPlay.startAnimat("task72_0",-1,false,0,0,false,false,true,2);
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
      }
      
      private function onAnimatEnd(param1:Event) : void
      {
         var event:Event = param1;
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
         MainManager.openOperate();
         setTimeout(function():void
         {
            PveEntry.onWinner();
         },2000);
      }
      
      override public function destroy() : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
         super.destroy();
      }
   }
}

