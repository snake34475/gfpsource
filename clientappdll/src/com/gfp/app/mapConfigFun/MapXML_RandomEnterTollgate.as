package com.gfp.app.mapConfigFun
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapXML_RandomEnterTollgate implements IMapConfigFun
   {
      
      public function MapXML_RandomEnterTollgate()
      {
         super();
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc4_:Array = String(param2).split("|");
         if(_loc4_.length > 0)
         {
            _loc5_ = Math.floor(Math.random() * _loc4_.length);
            _loc6_ = uint(_loc4_[_loc5_]);
            PveEntry.instance.enterTollgate(_loc6_);
         }
      }
   }
}

