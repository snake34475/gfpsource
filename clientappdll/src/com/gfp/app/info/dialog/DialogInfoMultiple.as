package com.gfp.app.info.dialog
{
   public class DialogInfoMultiple
   {
      
      private var _npcDialogs:Array;
      
      private var _playerDialogs:Array;
      
      public function DialogInfoMultiple(param1:Array, param2:Array)
      {
         super();
         this._npcDialogs = param1;
         this._playerDialogs = param2;
      }
      
      public function get playerDialogs() : Array
      {
         return this._playerDialogs || [];
      }
      
      public function get npcDialogs() : Array
      {
         return this._npcDialogs || [];
      }
   }
}

