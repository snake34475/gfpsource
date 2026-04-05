package com.gfp.app.info.dialog
{
   public class DialogCustomInfo extends BasePriorDialogInfo
   {
      
      public var id:uint;
      
      public var lv:uint;
      
      public var desc:String;
      
      public var startTime:Date;
      
      public var endTime:Date;
      
      public var sysTimeID:int = 0;
      
      public var displaySystimeId:int = 0;
      
      public var visible:String;
      
      public function DialogCustomInfo(param1:XML)
      {
         super(param1);
         this.id = param1.@id;
         this.lv = uint(param1.@lv);
         this.desc = param1.toString();
         this.visible = String(param1.@visible);
         var _loc2_:String = param1.@startTime;
         var _loc3_:String = param1.@endTime;
         this.sysTimeID = int(param1.@sysTimeID);
         this.displaySystimeId = int(param1.@displaySystimeId);
         if(_loc2_ != "" && _loc2_ != null)
         {
            this.startTime = new Date(_loc2_);
         }
         if(_loc3_ != "" && _loc3_ != null)
         {
            this.endTime = new Date(_loc3_);
         }
      }
   }
}

