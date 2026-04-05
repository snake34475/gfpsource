package com.gfp.app.cartoon.event
{
   import flash.events.Event;
   
   public class AnimatEvent extends Event
   {
      
      public static const ANIMAT_START:String = "animat_start";
      
      public static const ANIMAT_END:String = "animat_end";
      
      private var _data:*;
      
      public function AnimatEvent(param1:String, param2:* = null)
      {
         super(param1);
         this._data = param2;
      }
      
      public function get data() : *
      {
         return this._data;
      }
   }
}

