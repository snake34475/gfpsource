package com.gfp.app.mapConfigFun.single
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapXML_TaskGoto_15 extends MapXML_TaskGotoBase
   {
      
      public function MapXML_TaskGoto_15()
      {
         super();
      }
      
      override public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         if(Boolean(TasksManager.isProcess(15,0)) || Boolean(TasksManager.isProcess(15,1)) || Boolean(TasksManager.isProcess(523,0)) || Boolean(TasksManager.isProcess(523,1)))
         {
            PveEntry.enterTollgate(902);
         }
         else
         {
            CityMap.instance.changeMap(2,0);
         }
      }
   }
}

