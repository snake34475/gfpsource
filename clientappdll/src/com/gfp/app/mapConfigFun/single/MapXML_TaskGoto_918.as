package com.gfp.app.mapConfigFun.single
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapXML_TaskGoto_918 extends MapXML_TaskGotoBase
   {
      
      public function MapXML_TaskGoto_918()
      {
         super();
      }
      
      override public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         ModuleManager.turnModule(ClientConfig.getAppModule("TeamFightPanel"),"正在……",918);
      }
   }
}

