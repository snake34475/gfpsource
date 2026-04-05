package com.gfp.app.info.dialog
{
   public class DialogGotoTowerInfo
   {
      
      public var id:uint;
      
      public var desc:String;
      
      public function DialogGotoTowerInfo(param1:XML)
      {
         super();
         this.id = param1.@id;
         this.desc = param1.toString();
      }
   }
}

