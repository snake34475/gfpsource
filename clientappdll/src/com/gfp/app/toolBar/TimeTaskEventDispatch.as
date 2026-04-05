package com.gfp.app.toolBar
{
   import flash.events.EventDispatcher;
   
   public class TimeTaskEventDispatch extends EventDispatcher
   {
      
      private static var _instance:TimeTaskEventDispatch;
      
      public static const TIME_TASK:String = "time_task";
      
      public function TimeTaskEventDispatch()
      {
         super();
      }
      
      public static function get instance() : TimeTaskEventDispatch
      {
         if(_instance == null)
         {
            _instance = new TimeTaskEventDispatch();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance = null;
         }
      }
   }
}

