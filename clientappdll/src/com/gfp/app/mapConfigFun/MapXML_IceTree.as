package com.gfp.app.mapConfigFun
{
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapXML_IceTree implements IMapConfigFun
   {
      
      public function MapXML_IceTree()
      {
         super();
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         ModuleManager.turnAppModule("IceTreePanel");
      }
   }
}

