package com.gfp.app.mapConfigFun
{
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapXML_GotoTradeMap implements IMapConfigFun
   {
      
      public function MapXML_GotoTradeMap()
      {
         super();
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         var _loc4_:Array = param2.toString().split(",");
         CityMap.instance.changeTradeMap(_loc4_[0],_loc4_[1],_loc4_[2]);
      }
   }
}

