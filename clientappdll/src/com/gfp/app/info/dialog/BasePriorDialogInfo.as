package com.gfp.app.info.dialog
{
   public class BasePriorDialogInfo
   {
      
      public var prior:uint;
      
      public function BasePriorDialogInfo(param1:XML)
      {
         super();
         if(param1)
         {
            this.prior = uint(param1.@prior);
         }
      }
   }
}

