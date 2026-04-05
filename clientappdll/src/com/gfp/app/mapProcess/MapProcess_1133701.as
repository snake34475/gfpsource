package com.gfp.app.mapProcess
{
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.events.Event;
   
   public class MapProcess_1133701 extends BaseMapProcess
   {
      
      private const MY_DAMAGE:int = 10610;
      
      public function MapProcess_1133701()
      {
         super();
      }
      
      private function responseDamage(param1:Event) : void
      {
         AlertManager.showSimpleAlarm("本次共造成伤害" + ActivityExchangeTimesManager.getTimes(this.MY_DAMAGE) + "w");
         ActivityExchangeTimesManager.removeEventListener(this.MY_DAMAGE,this.responseDamage);
      }
      
      override public function destroy() : void
      {
         ActivityExchangeTimesManager.getActiviteTimeInfo(this.MY_DAMAGE);
         ActivityExchangeTimesManager.addEventListener(this.MY_DAMAGE,this.responseDamage);
      }
   }
}

