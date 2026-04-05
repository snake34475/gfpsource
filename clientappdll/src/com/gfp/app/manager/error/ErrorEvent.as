package com.gfp.app.manager.error
{
   import flash.events.Event;
   
   public class ErrorEvent extends Event
   {
      
      private var _commandId:uint;
      
      private var _errorId:uint;
      
      private var _errorValue:uint;
      
      public function ErrorEvent(param1:String, param2:uint, param3:uint, param4:uint, param5:Boolean = false, param6:Boolean = false)
      {
         super(param1,param5,param6);
         this._commandId = param2;
         this._errorId = param3;
         this._errorValue = param4;
      }
      
      public function get commandId() : uint
      {
         return this._commandId;
      }
      
      public function get errorId() : uint
      {
         return this._errorId;
      }
      
      public function get errorValue() : uint
      {
         return this._errorValue;
      }
   }
}

