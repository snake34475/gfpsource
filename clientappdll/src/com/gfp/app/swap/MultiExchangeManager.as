package com.gfp.app.swap
{
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.info.dailyActivity.ActivityExchangeAward;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.MainManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class MultiExchangeManager extends EventDispatcher
   {
      
      private static var _instance:MultiExchangeManager;
      
      public static const MULTI_EXCHANGE_COMPLETE:String = "multi_exchange_complete";
      
      private var _swapID:uint;
      
      private var _swapTime:uint;
      
      private var _params:uint;
      
      public function MultiExchangeManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : MultiExchangeManager
      {
         if(_instance == null)
         {
            _instance = new MultiExchangeManager();
         }
         return _instance;
      }
      
      public static function multiExchange(param1:uint, param2:uint, param3:uint = 0) : void
      {
         instance.doMultiExchange(param1,param2,param3);
      }
      
      public function doMultiExchange(param1:uint, param2:uint, param3:uint = 0) : void
      {
         this._swapID = param1;
         this._swapTime = param2;
         this._params = param3;
         ActivityExchangeCommander.instance.closeID(this._swapID);
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onCompleteByStep);
         ActivityExchangeCommander.exchange(this._swapID,this._params);
         MainManager.closeOperate();
      }
      
      private function onCompleteByStep(param1:ExchangeEvent) : void
      {
         --this._swapTime;
         ActivityExchangeAward.addAward(param1.info,null,false);
         if(this._swapTime > 1)
         {
            ActivityExchangeCommander.exchange(this._swapID,this._params);
         }
         else
         {
            ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onCompleteByStep);
            ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onEnd);
            ActivityExchangeCommander.exchange(this._swapID,this._params);
         }
      }
      
      private function onEnd(param1:ExchangeEvent) : void
      {
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onEnd);
         ActivityExchangeAward.addAward(param1.info,null,false);
         ActivityExchangeCommander.instance.unCloseID(this._swapID);
         MainManager.openOperate();
         dispatchEvent(new ExchangeEvent(ExchangeEvent.EXCHANGE_COMPLETE,param1.info));
      }
   }
}

