package com.gfp.app.time
{
   import flash.events.Event;
   
   public class SystimeEvent extends Event
   {
      
      public static const STARTING:String = "systimeHasStart";
      
      public static const NOT_START:String = "systimeNotStart";
      
      public static const HAS_END:String = "systimeHasEnd";
      
      public static const TIME_COME:String = "systimeTimeCome";
      
      public var isStart:Boolean;
      
      public var index:int;
      
      public var systemID:int;
      
      public function SystimeEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

