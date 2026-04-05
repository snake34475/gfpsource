package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.events.Event;
   import flash.utils.setTimeout;
   
   public class MapProcess_1136401 extends BaseMapProcess
   {
      
      private var _swapID:int = 11264;
      
      public function MapProcess_1136401()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         FightManager.instance.addEventListener(FightEvent.QUITE,this.reasonHandle);
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      private function reasonHandle(param1:Event) : void
      {
         setTimeout(this.reslut,2000);
      }
      
      private function reslut() : void
      {
         FightManager.instance.removeEventListener(FightEvent.QUITE,this.reasonHandle);
         ActivityExchangeTimesManager.addEventListener(this._swapID,this.responseInfo);
         ActivityExchangeTimesManager.getActiviteTimeInfo(this._swapID);
      }
      
      private function responseInfo(param1:Event) : void
      {
         ActivityExchangeTimesManager.removeEventListener(this._swapID,this.responseInfo);
         var _loc2_:int = int(ActivityExchangeTimesManager.getTimes(this._swapID));
         AlertManager.showSimpleAlarm("小侠士，你造成了" + _loc2_ + "点伤害");
      }
   }
}

