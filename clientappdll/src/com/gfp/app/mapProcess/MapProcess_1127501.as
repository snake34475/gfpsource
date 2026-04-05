package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.events.Event;
   
   public class MapProcess_1127501 extends BaseMapProcess
   {
      
      public function MapProcess_1127501()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.requestData();
         FightManager.instance.addEventListener(FightEvent.WINNER,this.winHandle);
      }
      
      private function requestData() : void
      {
         ActivityExchangeTimesManager.getActiviteTimeInfo(9652);
      }
      
      private function winHandle(param1:Event) : void
      {
         if(ActivityExchangeTimesManager.getTimes(9652) > 0 && ActivityExchangeTimesManager.getTimes(9654) == 0)
         {
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.winHandle);
      }
   }
}

