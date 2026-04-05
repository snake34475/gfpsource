package com.gfp.app.mapConfigFun
{
   import com.gfp.app.fight.SinglePkManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapXML_PVPAlert implements IMapConfigFun
   {
      
      public function MapXML_PVPAlert()
      {
         super();
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         var split:Array = null;
         var sm:SightModel = param1;
         var data:XML = param2;
         var dataList:XMLList = param3;
         split = String(data).split(",");
         var alert:String = split[0];
         var onAlert:Function = function():void
         {
            var _loc1_:uint = uint(split[1]);
            SinglePkManager.instance.joinPvPArea(_loc1_);
         };
         AlertManager.showSimpleAlert(alert,onAlert);
      }
   }
}

