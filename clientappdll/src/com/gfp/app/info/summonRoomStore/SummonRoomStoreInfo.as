package com.gfp.app.info.summonRoomStore
{
   public class SummonRoomStoreInfo
   {
      
      public var id:uint;
      
      public var itemsVec:Vector.<SummonRoomStoreItemInfo>;
      
      public function SummonRoomStoreInfo(param1:XML)
      {
         var _loc3_:XML = null;
         var _loc4_:SummonRoomStoreItemInfo = null;
         super();
         this.id = param1.@id;
         this.itemsVec = new Vector.<SummonRoomStoreItemInfo>();
         var _loc2_:XMLList = param1.elements("item");
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = new SummonRoomStoreItemInfo(_loc3_);
            this.itemsVec.push(_loc4_);
         }
      }
   }
}

