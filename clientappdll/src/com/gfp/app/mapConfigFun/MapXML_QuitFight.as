package com.gfp.app.mapConfigFun
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapXML_QuitFight implements IMapConfigFun
   {
      
      public function MapXML_QuitFight()
      {
         super();
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         FightManager.quit();
      }
   }
}

