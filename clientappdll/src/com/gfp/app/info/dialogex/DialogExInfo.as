package com.gfp.app.info.dialogex
{
   public class DialogExInfo
   {
      
      public var id:int;
      
      private var _title:String;
      
      public var select:String;
      
      public var npcID:int;
      
      public var children:Vector.<DialogExInfo>;
      
      public var next:DialogExInfo;
      
      public var showCount:int = 0;
      
      public var mass:int = 0;
      
      public var tran:String;
      
      public var params:String;
      
      public var titleDisplay:String;
      
      public function DialogExInfo()
      {
         super();
      }
      
      public function get title() : String
      {
         if(this.titleDisplay)
         {
            return this.titleDisplay;
         }
         return this._title;
      }
      
      public function set title(param1:String) : void
      {
         this._title = param1;
      }
   }
}

