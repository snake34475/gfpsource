package com.gfp.app.info.dialog
{
   public class DialogTollgateInfo
   {
      
      public var tollgateID:uint;
      
      public var tollgateDesc:String;
      
      public var difficulty:uint;
      
      public function DialogTollgateInfo(param1:XML)
      {
         super();
         this.tollgateID = param1.@id;
         this.difficulty = param1.@difficulty;
         this.tollgateDesc = param1.toString();
      }
   }
}

