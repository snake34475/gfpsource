package com.gfp.app.mapConfigFun.single
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapXML_TaskGoto_18 extends MapXML_TaskGotoBase
   {
      
      public function MapXML_TaskGoto_18()
      {
         super();
      }
      
      override public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         if(TasksManager.isProcess(28,0))
         {
            PveEntry.enterTollgate(904);
         }
         else
         {
            CityMap.instance.changeMap(18,0);
         }
      }
   }
}

