package com.gfp.app.mapConfigFun
{
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapXML_StopAnimation implements IMapConfigFun
   {
      
      public function MapXML_StopAnimation()
      {
         super();
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         param1.stopAnimation();
      }
   }
}

