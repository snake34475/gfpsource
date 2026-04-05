package com.gfp.app.control
{
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.utils.TimerManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class SnowBallControl extends EventDispatcher
   {
      
      private static var _instance:SnowBallControl;
      
      public var isSetup:Boolean;
      
      public var isAble0:Boolean = true;
      
      public var isAble1:Boolean = true;
      
      public var isAble2:Boolean = true;
      
      public function SnowBallControl()
      {
         super();
      }
      
      public static function get instance() : SnowBallControl
      {
         if(_instance == null)
         {
            _instance = new SnowBallControl();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.isSetup = true;
         TimerManager.instance.addEventListener("timer_every_full_hour",this.hourHandler);
      }
      
      private function hourHandler(param1:Event) : void
      {
         this.isAble0 = true;
         this.isAble1 = true;
         this.isAble2 = true;
         _instance.dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function exchange(param1:int) : void
      {
         this["isAble" + param1] = false;
         ActivityExchangeCommander.exchange(2093);
         _instance.dispatchEvent(new Event(Event.CHANGE));
      }
   }
}

