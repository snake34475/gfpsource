package com.gfp.app.info.dialog
{
   public class DialogActivityExchangeInfo
   {
      
      public var dailyActivityID:uint;
      
      public var sysTimeID:uint;
      
      public var desc:String;
      
      public function DialogActivityExchangeInfo(param1:XML)
      {
         super();
         this.dailyActivityID = param1.@id;
         this.sysTimeID = param1.@sysTimeID;
         this.desc = param1.toString();
      }
   }
}

