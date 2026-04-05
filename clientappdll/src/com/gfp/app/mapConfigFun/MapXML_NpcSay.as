package com.gfp.app.mapConfigFun
{
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapXML_NpcSay implements IMapConfigFun
   {
      
      public function MapXML_NpcSay()
      {
         super();
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         param1.showBox(param2.toString());
      }
   }
}

