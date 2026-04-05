package com.gfp.app.mapConfigFun.single
{
   import com.gfp.core.map.CityMap;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapXML_TaskGoto_23 extends MapXML_TaskGotoBase
   {
      
      public function MapXML_TaskGoto_23()
      {
         super();
      }
      
      override public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         CityMap.instance.changeMap(23,0);
      }
   }
}

