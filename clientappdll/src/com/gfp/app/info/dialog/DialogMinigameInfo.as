package com.gfp.app.info.dialog
{
   public class DialogMinigameInfo extends BasePriorDialogInfo
   {
      
      public var gameID:uint;
      
      public var gameSrc:String;
      
      public var gameDesc:String;
      
      public var gameParams:String;
      
      public function DialogMinigameInfo(param1:XML)
      {
         super(param1);
         this.gameID = param1.@id;
         this.gameSrc = param1.@src;
         this.gameDesc = param1.toString();
         if(param1.@params != null && String(param1.@params) != "")
         {
            this.gameParams = String(param1.@params);
         }
      }
   }
}

