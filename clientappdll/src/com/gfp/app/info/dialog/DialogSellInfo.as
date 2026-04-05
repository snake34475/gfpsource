package com.gfp.app.info.dialog
{
   public class DialogSellInfo
   {
      
      public var sellID:uint;
      
      public var sellDesc:String;
      
      public function DialogSellInfo(param1:XML)
      {
         super();
         this.sellID = param1.@id;
         this.sellDesc = param1.toString();
      }
   }
}

