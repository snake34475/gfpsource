package com.gfp.app.info.dialog
{
   public class DialogPvPInfo
   {
      
      public var pvpID:uint;
      
      public var pvpLv:uint;
      
      public var pvpPay:uint;
      
      public var pvpDesc:String;
      
      public var entryPvpID:uint;
      
      public function DialogPvPInfo(param1:XML)
      {
         super();
         this.pvpID = param1.@id;
         this.entryPvpID = uint(param1.@entryID);
         this.pvpLv = param1.@lv;
         this.pvpPay = param1.@pay;
         this.pvpDesc = param1.toString();
      }
   }
}

