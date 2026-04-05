package com.gfp.app.mapConfigFun
{
   import com.gfp.core.action.mouse.MouseProcess;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.utils.XMLUitl;
   import flash.geom.Point;
   
   public class MapXML_MoveTo implements IMapConfigFun
   {
      
      public function MapXML_MoveTo()
      {
         super();
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         var _loc4_:Point = XMLUitl.toPoint(String(param2));
         if(_loc4_)
         {
            MouseProcess.execWalk(MainManager.actorModel,_loc4_);
         }
      }
   }
}

