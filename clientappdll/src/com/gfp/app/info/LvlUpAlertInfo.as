package com.gfp.app.info
{
   public class LvlUpAlertInfo
   {
      
      private var _lv:uint;
      
      private var _roleType:uint;
      
      private var _msg:String;
      
      private var _transName:String;
      
      private var _src:String;
      
      public function LvlUpAlertInfo(param1:XML)
      {
         super();
         this._lv = uint(param1.@lv);
         this._roleType = uint(param1.@roleType);
         this._msg = param1.@msg;
         this._transName = param1.@transName;
         this._src = param1.@src;
      }
      
      public function get lv() : uint
      {
         return this._lv;
      }
      
      public function get roleType() : uint
      {
         return this._roleType;
      }
      
      public function get msg() : String
      {
         return this._msg;
      }
      
      public function get transName() : String
      {
         return this._transName;
      }
      
      public function get src() : String
      {
         return this._src;
      }
   }
}

