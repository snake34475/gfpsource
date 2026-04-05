package com.gfp.app.info
{
   public class ActivityPromptInfo
   {
      
      private var _id:uint;
      
      private var _name:String;
      
      private var _lv:uint;
      
      private var _sysTime:uint;
      
      private var _offset:int;
      
      private var _trans:String;
      
      private var _advertise:String;
      
      private var _desc:String;
      
      private var _rewards:String;
      
      public function ActivityPromptInfo(param1:XML)
      {
         super();
         this._id = uint(param1.@id);
         this._name = param1.@name;
         this._lv = uint(param1.@lv);
         this._sysTime = uint(param1.@sysTime);
         this._offset = int(param1.@offset);
         this._trans = param1.@trans;
         this._advertise = param1.elements("advertise")[0];
         this._desc = param1.elements("desc")[0];
         this._rewards = param1.elements("rewards")[0];
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get lv() : uint
      {
         return this._lv;
      }
      
      public function get sysTime() : uint
      {
         return this._sysTime;
      }
      
      public function get offset() : int
      {
         return this._offset;
      }
      
      public function get trans() : String
      {
         return this._trans;
      }
      
      public function get advertise() : String
      {
         return this._advertise;
      }
      
      public function get desc() : String
      {
         return this._desc;
      }
      
      public function get rewards() : String
      {
         return this._rewards;
      }
   }
}

