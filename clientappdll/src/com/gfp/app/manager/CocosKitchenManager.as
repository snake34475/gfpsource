package com.gfp.app.manager
{
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.core.config.xml.ActivityExchangeXMLInfo;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.info.ActivityExchangeAwardInfo;
   import com.gfp.core.info.dailyActivity.ActivityExchangeInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.utils.TickManager;
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;
   
   public class CocosKitchenManager extends EventDispatcher
   {
      
      private static var _instance:CocosKitchenManager;
      
      public static const DRAW_END:String = "draw_end";
      
      public static const SWAP_IDS:Array = [11443,11440,11441,11439,11442];
      
      public static const LEFT_TIME_MAX:int = 300;
      
      public var canDraw:Boolean;
      
      private var _leftTime:int;
      
      private var _curAward:ActivityExchangeAwardInfo;
      
      public function CocosKitchenManager()
      {
         super();
         this._init();
      }
      
      public static function get instance() : CocosKitchenManager
      {
         if(_instance == null)
         {
            _instance = new CocosKitchenManager();
         }
         return _instance;
      }
      
      public function get leftTime() : int
      {
         return this._leftTime;
      }
      
      public function set leftTime(param1:int) : void
      {
         this._leftTime = param1;
         if(this._leftTime <= 0)
         {
            this.canDraw = true;
            TickManager.instance.removeRender(this._drawTick);
         }
         else
         {
            this.canDraw = false;
            TickManager.instance.addRender(this._drawTick,1000);
         }
      }
      
      private function _drawTick() : void
      {
         if(this._leftTime > 0)
         {
            --this._leftTime;
         }
         else
         {
            this.canDraw = true;
            TickManager.instance.removeRender(this._drawTick);
         }
      }
      
      private function _init() : void
      {
         var _loc1_:uint = ClientTempState.StartTime / 1000;
         var _loc2_:uint = getTimer() / 1000;
         if(_loc2_ - _loc1_ >= LEFT_TIME_MAX)
         {
            this.leftTime = 0;
         }
         else
         {
            this.leftTime = LEFT_TIME_MAX - (_loc2_ - _loc1_);
         }
      }
      
      public function setup() : void
      {
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this._drawSucHandler);
         ActivityExchangeCommander.instance.closeID(SWAP_IDS[0]);
         ActivityExchangeCommander.instance.closeID(SWAP_IDS[1]);
         ActivityExchangeCommander.instance.closeID(SWAP_IDS[2]);
         ActivityExchangeCommander.instance.closeID(SWAP_IDS[3]);
      }
      
      public function destroy() : void
      {
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this._drawSucHandler);
         ActivityExchangeCommander.instance.unCloseID(SWAP_IDS[0]);
         ActivityExchangeCommander.instance.unCloseID(SWAP_IDS[1]);
         ActivityExchangeCommander.instance.unCloseID(SWAP_IDS[2]);
         ActivityExchangeCommander.instance.unCloseID(SWAP_IDS[3]);
      }
      
      public function draw() : void
      {
         var _loc1_:uint = uint(ActivityExchangeTimesManager.getTimes(SWAP_IDS[4]));
         var _loc2_:ActivityExchangeInfo = ActivityExchangeXMLInfo.getActivityById(SWAP_IDS[4]);
         if(ActivityExchangeTimesManager.getTimes(SWAP_IDS[3]) > 0)
         {
            if(_loc1_ == 3)
            {
               ActivityExchangeCommander.exchange(SWAP_IDS[1]);
            }
            else if(_loc1_ == 7)
            {
               ActivityExchangeCommander.exchange(SWAP_IDS[2]);
            }
            else if(_loc1_ < _loc2_.limit)
            {
               ActivityExchangeCommander.exchange(SWAP_IDS[0]);
            }
            else if(_loc1_ >= _loc2_.limit)
            {
               AlertManager.showSimpleAlarm("小侠士，你今天的抽奖次数已经达到上限了哦！明天再来吧！");
               return;
            }
         }
         else
         {
            ActivityExchangeCommander.exchange(SWAP_IDS[3]);
         }
      }
      
      private function _drawSucHandler(param1:ExchangeEvent = null) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:ActivityExchangeAwardInfo = param1.info;
         switch(_loc2_.id)
         {
            case SWAP_IDS[0]:
               this._curAward = _loc2_;
               ActivityExchangeCommander.exchange(SWAP_IDS[4]);
               break;
            case SWAP_IDS[1]:
               this._curAward = _loc2_;
               ActivityExchangeCommander.exchange(SWAP_IDS[4]);
               break;
            case SWAP_IDS[2]:
               this._curAward = _loc2_;
               ActivityExchangeCommander.exchange(SWAP_IDS[4]);
               break;
            case SWAP_IDS[3]:
               this._curAward = _loc2_;
               ActivityExchangeCommander.exchange(SWAP_IDS[4]);
               break;
            case SWAP_IDS[4]:
               dispatchEvent(new ExchangeEvent(DRAW_END,this._curAward));
         }
      }
   }
}

