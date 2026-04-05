package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1102301 extends BaseMapProcess
   {
      
      private const HERO_ID:uint = 13917;
      
      public function MapProcess_1102301()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addMapListener();
      }
      
      private function addMapListener() : void
      {
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
      }
      
      private function removeMapListener() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         var _loc2_:Array = MainManager.actorInfo.defeatHeros;
         if(_loc2_.indexOf(this.HERO_ID) == -1)
         {
            MainManager.actorInfo.defeatHeros.push(this.HERO_ID);
         }
      }
      
      override public function destroy() : void
      {
         this.removeMapListener();
         super.destroy();
      }
   }
}

