package com.gfp.app.info
{
   import flash.utils.IDataInput;
   
   public class EquiptSaleInfo
   {
      
      public var coins:int;
      
      public var itemID:int;
      
      public var unique:int;
      
      public function EquiptSaleInfo(param1:IDataInput)
      {
         super();
         if(param1)
         {
            this.coins = param1.readUnsignedInt();
            this.itemID = param1.readUnsignedInt();
            this.unique = param1.readUnsignedInt();
         }
      }
   }
}

