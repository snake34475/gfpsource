package com.gfp.app.info
{
   public class StoreInfo
   {
      
      public static const DECORATE_ITEM_TOTAL_NUM:int = 4;
      
      public var id:uint;
      
      public var shopType:uint;
      
      public var ownerId:uint;
      
      public var ownerCreateTime:uint;
      
      public var ownerRoleType:uint;
      
      public var name:String;
      
      public var status:uint;
      
      public var decorateItemId:int;
      
      public function StoreInfo(param1:uint)
      {
         super();
         this.id = param1;
      }
   }
}

