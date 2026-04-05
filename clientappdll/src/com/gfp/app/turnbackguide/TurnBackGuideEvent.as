package com.gfp.app.turnbackguide
{
   import flash.events.Event;
   
   public class TurnBackGuideEvent extends Event
   {
      
      public static const HIDE_ICON:String = "hide_icon";
      
      public static const SHOW_LIGHT_EFFECT:String = "show_light_effect";
      
      public static const HIDE_LIGHT_EFFECT:String = "hide_light_effect";
      
      public function TurnBackGuideEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new TurnBackGuideEvent(type,bubbles,cancelable);
      }
   }
}

