package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeFeather;
   import com.gfp.core.CommandID;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import flash.events.Event;
   
   public class MapProcess_1114201 extends BaseMapProcess
   {
      
      private var _hasBuff:Boolean;
      
      private var _totalTime:int = 180000;
      
      private var _mapTimer:LeftTimeFeather;
      
      public function MapProcess_1114201()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._mapTimer = new LeftTimeFeather(this._totalTime);
         var _loc1_:int = int(ActivityExchangeTimesManager.getTimes(5222));
         this._hasBuff = (_loc1_ & 1) == 1;
         if(!this._hasBuff)
         {
            SocketConnection.addCmdListener(CommandID.FIGHT_END,this.onEnd);
         }
      }
      
      private function requestScore() : void
      {
         ActivityExchangeTimesManager.getActiviteTimeInfo(5222);
         ActivityExchangeTimesManager.addEventListener(5222,this.responseScore);
      }
      
      private function responseScore(param1:Event) : void
      {
         ActivityExchangeTimesManager.removeEventListener(5222,this.responseScore);
         var _loc2_:int = int(ActivityExchangeTimesManager.getTimes(5222));
         this._hasBuff = (_loc2_ & 1) == 1;
         if(this._hasBuff)
         {
            AlertManager.showSimpleAlarm("恭喜小侠士，幸运的获得了第四关专属BUFF，可在生存第四关中祝你一臂之力！”");
         }
      }
      
      private function onEnd(param1:Event) : void
      {
         this.requestScore();
         SocketConnection.removeCmdListener(CommandID.FIGHT_END,this.onEnd);
      }
      
      override public function destroy() : void
      {
         if(this._mapTimer)
         {
            this._mapTimer.destroy();
         }
         SocketConnection.removeCmdListener(CommandID.FIGHT_END,this.onEnd);
         super.destroy();
      }
   }
}

