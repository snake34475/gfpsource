package com.gfp.app.info
{
   public class GuaranteeTradeInfo
   {
      
      public static const EQUIP:uint = 0;
      
      public static const ITEM:uint = 1;
      
      public static const MATERIAL:uint = 2;
      
      public var itemId:uint;
      
      public var type:uint;
      
      public var uniqueId:uint;
      
      public var itemNum:uint;
      
      public var info:*;
      
      public function GuaranteeTradeInfo()
      {
         super();
      }
      
      public function copy() : GuaranteeTradeInfo
      {
         var _loc1_:GuaranteeTradeInfo = new GuaranteeTradeInfo();
         _loc1_.itemId = this.itemId;
         _loc1_.type = this.type;
         _loc1_.uniqueId = this.uniqueId;
         _loc1_.itemNum = this.itemNum;
         _loc1_.info = this.info;
         return _loc1_;
      }
   }
}

