package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.events.Event;
   
   public class MapProcess_1127401 extends BaseMapProcess
   {
      
      private var oldTime:int;
      
      public function MapProcess_1127401()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.oldTime = ActivityExchangeTimesManager.getTimes(9942);
         FightManager.instance.addEventListener(FightEvent.WINNER,this.winHandle);
      }
      
      private function winHandle(param1:Event) : void
      {
         ActivityExchangeTimesManager.addEventListener(9942,this.onTimeChange);
         ActivityExchangeTimesManager.getActiviteTimeInfo(9942);
      }
      
      private function onTimeChange(param1:Event) : void
      {
         var _loc2_:int = int(ActivityExchangeTimesManager.getTimes(9942));
         if(_loc2_ > this.oldTime)
         {
            AlertManager.showSimpleAlarm("恭喜你击败闪电斗神！你获得了" + (_loc2_ - this.oldTime) + "点闪电之力！");
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         ActivityExchangeTimesManager.removeEventListener(9942,this.onTimeChange);
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.winHandle);
      }
   }
}

