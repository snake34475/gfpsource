package com.gfp.app.info
{
   public class ActivityTansInfo
   {
      
      private var _name:String;
      
      private var _prio:uint;
      
      private var _pos:String;
      
      private var _title:String;
      
      public function ActivityTansInfo(param1:XML)
      {
         super();
         this._name = param1.@name;
         this._prio = uint(param1.@prio);
         this._pos = param1.@pos;
         this._title = param1.@title;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get prio() : uint
      {
         return this._prio;
      }
      
      public function get pos() : String
      {
         return this._pos;
      }
      
      public function get title() : String
      {
         return this._title;
      }
   }
}

