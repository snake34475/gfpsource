package com.gfp.app.question
{
   public class OptionInfo
   {
      
      public var index:uint;
      
      public var label:String = "";
      
      public function OptionInfo(param1:XML)
      {
         super();
         this.index = uint(param1.@Index);
         this.label = String(param1.@Lable);
      }
   }
}

