package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1058901 extends BaseMapProcess
   {
      
      public function MapProcess_1058901()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onFightWinner);
      }
      
      private function onFightWinner(param1:FightEvent) : void
      {
         if(!MainManager.actorInfo.isWorldBoss)
         {
            AlertManager.showSimpleAlarm("英勇的百级侠士团成员，你参加了此次战斗并获得了更高级的荣誉，快看下你名字前的新徽章吧~ ");
            MainManager.actorInfo.isWorldBoss = true;
            MainManager.actorModel.updateIconContainer();
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onFightWinner);
      }
   }
}

