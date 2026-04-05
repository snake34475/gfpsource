package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.config.xml.MapXMLInfo;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1056301 extends BaseMapProcess
   {
      
      public function MapProcess_1056301()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightManager.instance.addEventListener(FightEvent.REASON,this.onFightReason);
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onFightWinner);
      }
      
      private function onFightReason(param1:FightEvent) : void
      {
         FightManager.outToMapID = 1050;
         FightManager.outToMapPos = MapXMLInfo.getDefaultPos(1050);
         FightManager.quit();
      }
      
      private function onFightWinner(param1:FightEvent) : void
      {
         FightManager.quit();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onFightReason);
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onFightWinner);
      }
   }
}

