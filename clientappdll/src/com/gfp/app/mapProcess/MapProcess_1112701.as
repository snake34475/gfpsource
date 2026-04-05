package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeFeather;
   import com.gfp.app.feature.ShowCartoonFeather;
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1112701 extends BaseMapProcess
   {
      
      private var _totalTime:int = 180000;
      
      private var _mapTimer:LeftTimeFeather;
      
      private var _featherCartoon:ShowCartoonFeather;
      
      public function MapProcess_1112701()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._mapTimer = new LeftTimeFeather(this._totalTime);
         this._featherCartoon = new ShowCartoonFeather("nan_man_tip");
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onFightWinner);
      }
      
      private function removeEvent() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onFightWinner);
      }
      
      private function onFightWinner(param1:FightEvent) : void
      {
         AlertManager.showSimpleAlarm("恭喜小侠士获得功勋*15！");
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.removeEvent();
         if(this._mapTimer)
         {
            this._mapTimer.destroy();
         }
         if(this._featherCartoon)
         {
            this._featherCartoon.destroy();
         }
      }
   }
}

