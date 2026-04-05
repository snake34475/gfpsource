package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   
   public class MapProcess_1125201 extends BaseMapProcess
   {
      
      public function MapProcess_1125201()
      {
         super();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(FightManager.isWinTheFight)
         {
            MapManager.setMapEndAction("open:EastProtectLuPanel");
         }
      }
   }
}

