package com.gfp.app.config.xml
{
   import com.gfp.app.info.summonRoomStore.SummonRoomStoreInfo;
   import org.taomee.ds.HashMap;
   
   public class SummonRoomStoreXMLInfo
   {
      
      private static var _dataHash:HashMap;
      
      private static var xmlClass:Class = SummonRoomStoreXMLInfo_xmlClass;
      
      setup();
      
      public function SummonRoomStoreXMLInfo()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc3_:XML = null;
         var _loc4_:SummonRoomStoreInfo = null;
         _dataHash = new HashMap();
         var _loc1_:XML = XML(new xmlClass());
         var _loc2_:XMLList = _loc1_.elements("store");
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = new SummonRoomStoreInfo(_loc3_);
            _dataHash.add(_loc4_.id,_loc4_);
         }
      }
      
      public static function getInfo(param1:uint) : SummonRoomStoreInfo
      {
         return _dataHash.getValue(param1);
      }
   }
}

