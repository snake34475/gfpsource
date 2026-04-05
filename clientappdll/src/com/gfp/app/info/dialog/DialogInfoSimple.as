package com.gfp.app.info.dialog
{
   public class DialogInfoSimple
   {
      
      private var _selectDesc:String;
      
      private var _npcDialogs:Array;
      
      public function DialogInfoSimple(param1:Array = null, param2:String = "")
      {
         super();
         this._npcDialogs = param1;
         this._selectDesc = param2;
      }
      
      public function get selectDesc() : String
      {
         return this._selectDesc;
      }
      
      public function get npcDialogs() : Array
      {
         return this._npcDialogs;
      }
   }
}

