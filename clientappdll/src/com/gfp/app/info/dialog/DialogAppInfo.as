package com.gfp.app.info.dialog
{
   public class DialogAppInfo extends BasePriorDialogInfo
   {
      
      public var appID:uint;
      
      public var appSrc:String;
      
      public var appDesc:String;
      
      public var appParams:Object;
      
      public var lv:int = 0;
      
      public var sysTimeID:int = 0;
      
      public var visible:String;
      
      public function DialogAppInfo(param1:XML)
      {
         super(param1);
         if(param1)
         {
            this.appID = param1.@id;
            this.appSrc = param1.@src;
            this.appDesc = param1.toString();
            this.sysTimeID = int(param1.@sysTimeID);
            this.lv = int(param1.@lv);
            this.visible = String(param1.@visible);
            if(param1.@params != null && String(param1.@params) != "")
            {
               this.appParams = param1.@params;
            }
         }
      }
   }
}

