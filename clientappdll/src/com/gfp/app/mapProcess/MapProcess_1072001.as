package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.config.xml.NpcXMLInfo;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.ui.alert.TextAlert;
   
   public class MapProcess_1072001 extends BaseMapProcess
   {
      
      private var isWinner:Boolean = false;
      
      public function MapProcess_1072001()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addMapEvent();
      }
      
      private function addMapEvent() : void
      {
         FightManager.instance.addEventListener(FightEvent.REASON,this.onReason);
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
         FightManager.instance.addEventListener(FightEvent.QUITE,this.onQuit);
      }
      
      private function onQuit(param1:FightEvent) : void
      {
         if(!this.isWinner)
         {
            FightManager.outToMapID = 41;
            FightManager.outToMapPos = NpcXMLInfo.getTtranPos(10142);
         }
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         this.isWinner = true;
      }
      
      private function removeMapEvent() : void
      {
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onReason);
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         FightManager.instance.removeEventListener(FightEvent.QUITE,this.onQuit);
      }
      
      private function onReason(param1:FightEvent) : void
      {
         TextAlert.show("很遗憾，小侠士，你在侠士团荣誉对战中战败了。");
         FightManager.outToMapID = 41;
         FightManager.outToMapPos = NpcXMLInfo.getTtranPos(10142);
      }
      
      override public function destroy() : void
      {
         this.removeMapEvent();
         super.destroy();
      }
   }
}

