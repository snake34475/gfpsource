package com.gfp.app.mapConfigFun
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapXML_MedalBuy implements IMapConfigFun
   {
      
      public function MapXML_MedalBuy()
      {
         super();
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         ModuleManager.turnModule(ClientConfig.getAppModule("MedalBuyPanel"),"正在加载兑换面版...",uint(param2));
      }
   }
}

