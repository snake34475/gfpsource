package com.gfp.app.mapConfigFun
{
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapXML_OpenModule implements IMapConfigFun
   {
      
      private var _moduleName:String;
      
      public function MapXML_OpenModule()
      {
         super();
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         this._moduleName = param2.toString();
         ModuleManager.turnAppModule(this._moduleName);
      }
   }
}

