package com.gfp.app.info
{
   import flash.utils.IDataInput;
   
   public class ItemSaleInfo
   {
      
      public var coins:int;
      
      public var itemID:int;
      
      public var count:int;
      
      public function ItemSaleInfo(param1:IDataInput)
      {
         super();
         if(param1)
         {
            this.coins = param1.readUnsignedInt();
            this.itemID = param1.readUnsignedInt();
            this.count = param1.readUnsignedInt();
         }
      }
   }
}

