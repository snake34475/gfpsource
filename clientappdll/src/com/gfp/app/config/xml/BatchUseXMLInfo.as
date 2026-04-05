package com.gfp.app.config.xml
{
   public class BatchUseXMLInfo
   {
      
      private static var itemIds:Array;
      
      private static var batchUseCla:Class = BatchUseXMLInfo_batchUseCla;
      
      setup();
      
      public function BatchUseXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc3_:XML = null;
         itemIds = [];
         var _loc1_:XML = XML(new batchUseCla());
         var _loc2_:XMLList = _loc1_.descendants("item");
         for each(_loc3_ in _loc2_)
         {
            itemIds.push(uint(_loc3_.@id));
         }
      }
      
      public static function canBatchUse(param1:uint) : Boolean
      {
         return itemIds.indexOf(param1) != -1;
      }
   }
}

