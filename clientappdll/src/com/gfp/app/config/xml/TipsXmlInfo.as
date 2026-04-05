package com.gfp.app.config.xml
{
   import org.taomee.ds.HashMap;
   
   public class TipsXmlInfo
   {
      
      public static var treasureHouseData:HashMap;
      
      public static var treasureHousePost:String;
      
      public static var mallTips:Array;
      
      private static var xmlClass:Class = TipsXmlInfo_xmlClass;
      
      setup();
      
      public function TipsXmlInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc1_:XML = XML(new xmlClass());
         setupTreasureHouse(_loc1_);
         mallTips = [];
         setupMallTips(_loc1_);
      }
      
      private static function setupTreasureHouse(param1:XML) : void
      {
         var _loc4_:XML = null;
         treasureHouseData = new HashMap();
         var _loc2_:XML = param1.elements("treasureHouse")[0];
         var _loc3_:XMLList = _loc2_.elements("item");
         treasureHousePost = _loc2_.elements("post")[0].toString();
         for each(_loc4_ in _loc3_)
         {
            treasureHouseData.add(uint(_loc4_.@id),String(_loc4_.toString()));
         }
      }
      
      private static function setupMallTips(param1:XML) : void
      {
         var _loc4_:XML = null;
         var _loc2_:XML = param1.elements("malls")[0];
         var _loc3_:XMLList = _loc2_.elements("item");
         for each(_loc4_ in _loc3_)
         {
            mallTips.push(_loc4_.toString());
         }
      }
      
      public static function getTips(param1:int) : String
      {
         var _loc2_:String = treasureHouseData.getValue(param1);
         return _loc2_ == null ? "---" : _loc2_;
      }
   }
}

