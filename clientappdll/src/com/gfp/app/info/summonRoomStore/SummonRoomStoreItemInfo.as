package com.gfp.app.info.summonRoomStore
{
   public class SummonRoomStoreItemInfo
   {
      
      public var id:uint;
      
      public function SummonRoomStoreItemInfo(param1:XML)
      {
         super();
         this.id = param1.@id;
      }
   }
}

