package com.gfp.app.mapConfigFun
{
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapXML_Alert implements IMapConfigFun
   {
      
      public function MapXML_Alert()
      {
         super();
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         var _loc4_:String = String(param2);
         AlertManager.showSimpleAlarm(_loc4_);
      }
   }
}

