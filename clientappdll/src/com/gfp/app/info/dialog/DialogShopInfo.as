package com.gfp.app.info.dialog
{
   public class DialogShopInfo
   {
      
      public var shopID:uint;
      
      public var shopDesc:String;
      
      public var turnback:int;
      
      public function DialogShopInfo(param1:XML)
      {
         super();
         this.shopID = param1.@id;
         this.shopDesc = param1.toString();
         this.turnback = int(param1.@turnback);
      }
   }
}

