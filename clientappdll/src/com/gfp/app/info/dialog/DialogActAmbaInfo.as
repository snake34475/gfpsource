package com.gfp.app.info.dialog
{
   public class DialogActAmbaInfo
   {
      
      public var actDesc:String;
      
      public function DialogActAmbaInfo(param1:XML)
      {
         super();
         this.actDesc = param1.toString();
      }
   }
}

