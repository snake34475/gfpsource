package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.ui.alert.TextAlert;
   
   public class MapProcess_1074501 extends BaseMapProcess
   {
      
      public function MapProcess_1074501()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addMapListener();
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         TextAlert.show("恭喜小侠士获得了一个小时内关卡功夫豆翻倍祝福，抓紧时间体验吧！");
         ActivityExchangeTimesManager.updataTimesByOnce(1820);
      }
      
      private function addMapListener() : void
      {
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
      }
      
      private function removeMapListener() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.removeMapListener();
      }
   }
}

