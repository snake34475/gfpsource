package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1078201 extends BaseMapProcess
   {
      
      public function MapProcess_1078201()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         FightManager.isAutoWinnerEnd = false;
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         ActivityExchangeTimesManager.updataTimesByOnce(2031);
         AnimatPlay.startAnimat("task1825_",2,false,0,0,false,true);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
      }
   }
}

