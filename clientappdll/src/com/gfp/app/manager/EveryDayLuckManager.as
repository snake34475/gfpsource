package com.gfp.app.manager
{
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.MainManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class EveryDayLuckManager extends EventDispatcher
   {
      
      private static var _instance:EveryDayLuckManager;
      
      public static const CD_CHANGE:String = "cd_change";
      
      public static const LEFT_TIMES_CHANGE:String = "left_times_change";
      
      private var _timer:int;
      
      private var _leftCount:int;
      
      private var _leftTime:int;
      
      public var signDays:int;
      
      private var _swapIDs:Array = [4660,4661,4662,4663,4664,4665];
      
      private var _vipSwapIDs:Array = [5002,5003,5004,5005,5006,5007];
      
      private var _needTime:Array = [5 * 60,15 * 60,25 * 60,40 * 60,60 * 60];
      
      public function EveryDayLuckManager()
      {
         super();
      }
      
      public static function get instance() : EveryDayLuckManager
      {
         if(!_instance)
         {
            _instance = new EveryDayLuckManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
         this.reset();
      }
      
      private function onExchangeComplete(param1:ExchangeEvent) : void
      {
         if(this._swapIDs.indexOf(param1.info.id) != -1 || this._vipSwapIDs.indexOf(param1.info.id) != -1)
         {
            this.reset();
         }
      }
      
      public function reset() : void
      {
         clearInterval(this._timer);
         var _loc1_:Boolean = Boolean(MainManager.actorInfo.isVip);
         var _loc2_:int = int(MainManager.olToday);
         this._leftCount = 0;
         var _loc3_:int = 0;
         while(_loc3_ < 5)
         {
            if(ActivityExchangeTimesManager.getTimes(this._swapIDs[_loc3_]) == 0)
            {
               if(_loc2_ >= this._needTime[_loc3_])
               {
                  ++this._leftCount;
               }
            }
            _loc3_++;
         }
         dispatchEvent(new Event(LEFT_TIMES_CHANGE));
         if(this.cd > 0)
         {
            this._timer = setInterval(this.onTimer,1000);
         }
         dispatchEvent(new Event(CD_CHANGE));
      }
      
      public function get cd() : int
      {
         if(this._leftCount > 0)
         {
            return 0;
         }
         var _loc1_:int = int(MainManager.olToday);
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            if(ActivityExchangeTimesManager.getTimes(this._swapIDs[_loc2_]) == 0)
            {
               if(_loc1_ < this._needTime[_loc2_])
               {
                  return this._needTime[_loc2_] - _loc1_;
               }
               this.reset();
               return 0;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public function get leftTimes() : int
      {
         return this._leftCount;
      }
      
      private function onTimer() : void
      {
         if(this.cd <= 0)
         {
            clearInterval(this._timer);
         }
         dispatchEvent(new Event(CD_CHANGE));
      }
   }
}

