package com.gfp.app.config.xml
{
   import com.gfp.app.info.SummonRaceInfo;
   import org.taomee.ds.HashMap;
   
   public class SummonRaceXMLInfo
   {
      
      private static var _dataHash:HashMap;
      
      private static var xmlClass:Class = SummonRaceXMLInfo_xmlClass;
      
      setup();
      
      public function SummonRaceXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc2_:XML = null;
         var _loc3_:uint = 0;
         var _loc4_:SummonRaceInfo = null;
         var _loc1_:XMLList = XML(new xmlClass()).elements("race");
         _dataHash = new HashMap();
         for each(_loc2_ in _loc1_)
         {
            _loc3_ = uint(_loc2_.@id);
            _loc4_ = new SummonRaceInfo(_loc2_);
            _dataHash.add(_loc3_,_loc4_);
         }
      }
      
      public static function getInfos(param1:uint) : SummonRaceInfo
      {
         return _dataHash.getValue(param1);
      }
   }
}

