package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1121104 extends BaseMapProcess
   {
      
      public function MapProcess_1121104()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addEventListener();
      }
      
      private function addEventListener() : void
      {
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onFightWinner);
      }
      
      private function removeEventListener() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onFightWinner);
      }
      
      private function onFightWinner(param1:FightEvent) : void
      {
         AlertManager.showSimpleAlarm("小侠士，你通过本次战斗，削弱了年兽·烈天3%的战斗力。");
      }
      
      override public function destroy() : void
      {
         this.removeEventListener();
      }
   }
}

