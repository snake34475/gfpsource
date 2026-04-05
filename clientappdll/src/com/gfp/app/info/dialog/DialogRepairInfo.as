package com.gfp.app.info.dialog
{
   public class DialogRepairInfo
   {
      
      public var repairID:uint;
      
      public var repairDesc:String;
      
      public function DialogRepairInfo(param1:XML)
      {
         super();
         this.repairID = param1.@id;
         this.repairDesc = param1.toString();
      }
   }
}

