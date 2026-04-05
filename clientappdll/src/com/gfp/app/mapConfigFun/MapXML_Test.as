package com.gfp.app.mapConfigFun
{
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.utils.Logger;
   
   public class MapXML_Test implements IMapConfigFun
   {
      
      public function MapXML_Test()
      {
         super();
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         Logger.info(this,param1.info.name + param2.toXMLString());
      }
   }
}

