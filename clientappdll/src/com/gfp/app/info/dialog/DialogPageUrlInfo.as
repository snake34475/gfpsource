package com.gfp.app.info.dialog
{
   public class DialogPageUrlInfo extends BasePriorDialogInfo
   {
      
      public var url:String;
      
      public var urlDesc:String;
      
      public function DialogPageUrlInfo(param1:XML)
      {
         super(param1);
         this.url = param1.@url;
         this.urlDesc = param1.toString();
      }
   }
}

