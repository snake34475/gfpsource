package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   
   public class MapProcess_1107103 extends BaseMapProcess
   {
      
      public function MapProcess_1107103()
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

