package com.gfp.app.manager
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class OfflineExpManager extends EventDispatcher
   {
      
      private static var _instance:OfflineExpManager;
      
      public static const EXP_GETED:String = "exp_geted";
      
      private var _haveTime:uint;
      
      public function OfflineExpManager()
      {
         super();
      }
      
      public static function getInstance() : OfflineExpManager
      {
         return _instance = _instance || new OfflineExpManager();
      }
      
      public function get haveTime() : uint
      {
         return this._haveTime;
      }
      
      public function set haveTime(param1:uint) : void
      {
         this._haveTime = param1;
         if(this._haveTime > 0)
         {
         }
         dispatchEvent(new Event(EXP_GETED));
      }
   }
}

