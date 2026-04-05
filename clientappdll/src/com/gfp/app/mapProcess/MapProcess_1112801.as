package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeFeather;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.events.Event;
   
   public class MapProcess_1112801 extends BaseMapProcess
   {
      
      private var _totalTime:int = 180000;
      
      private var _mapTimer:LeftTimeFeather;
      
      private var _prevScore:int;
      
      public function MapProcess_1112801()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._mapTimer = new LeftTimeFeather(this._totalTime);
         this._prevScore = ActivityExchangeTimesManager.getTimes(6843);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._mapTimer)
         {
            this._mapTimer.destroy();
         }
         this.requestScore();
      }
      
      private function requestScore() : void
      {
         ActivityExchangeTimesManager.getActiviteTimeInfo(6843);
         ActivityExchangeTimesManager.addEventListener(6843,this.responseScore);
      }
      
      private function responseScore(param1:Event) : void
      {
         var _loc2_:int = int(ActivityExchangeTimesManager.getTimes(6843));
         ActivityExchangeTimesManager.removeEventListener(6843,this.responseScore);
         if(_loc2_ - this._prevScore > 0)
         {
            AlertManager.showSimpleAlarm("恭喜你，获得<font color=\'#FF0000\'>" + (_loc2_ - this._prevScore) + "</font>点天地精华！");
         }
      }
   }
}

