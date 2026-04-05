package com.gfp.app.manager
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.info.dailyActivity.SwapTimesInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.ModuleManager;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class OldBackManager
   {
      
      private static var _inst:OldBackManager;
      
      private var _isOldBack:Boolean;
      
      private var _todayGot:Boolean;
      
      private var _index:int;
      
      private const OLD_MAN_ID:int = 10308;
      
      private const CHECK_TODAY_ID:int = 10309;
      
      private const REWARD_IDS:Array = [10274,10275,10276,10278,10279,10281,10282];
      
      public function OldBackManager()
      {
         super();
      }
      
      public static function get inst() : OldBackManager
      {
         if(_inst == null)
         {
            _inst = new OldBackManager();
         }
         return _inst;
      }
      
      private function checkIsOldBack() : void
      {
         var t:uint = 0;
         t = setTimeout(function():void
         {
            clearTimeout(t);
            ActivityExchangeTimesManager.addEventListener(OLD_MAN_ID,onCheckBack);
            ActivityExchangeTimesManager.getActiviteTimeInfo(OLD_MAN_ID);
         },1000);
      }
      
      private function onCheckBack(param1:DataEvent) : void
      {
         ActivityExchangeTimesManager.removeEventListener(this.OLD_MAN_ID,this.onCheckBack);
         var _loc2_:SwapTimesInfo = param1.data as SwapTimesInfo;
         if(_loc2_.times > 0)
         {
            this._isOldBack = true;
         }
         ActivityExchangeTimesManager.addEventListener(this.CHECK_TODAY_ID,this.onCheckGot);
         ActivityExchangeTimesManager.getActiviteTimeInfo(this.CHECK_TODAY_ID);
      }
      
      private function onCheckGot(param1:DataEvent) : void
      {
         ActivityExchangeTimesManager.removeEventListener(this.CHECK_TODAY_ID,this.onCheckGot);
         var _loc2_:SwapTimesInfo = param1.data as SwapTimesInfo;
         this._todayGot = _loc2_.times > 0;
         if(this._isOldBack)
         {
            this.getIndex();
         }
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function getIndex() : void
      {
         var _loc2_:int = 0;
         this._index = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 7)
         {
            _loc2_ = int(ActivityExchangeTimesManager.getTimes(this.REWARD_IDS[_loc1_]));
            if(_loc2_ == 0 && (_loc1_ == 2 || _loc1_ == 4))
            {
               if(_loc1_ == 2)
               {
                  _loc2_ = int(ActivityExchangeTimesManager.getTimes(10277));
               }
               else
               {
                  _loc2_ = int(ActivityExchangeTimesManager.getTimes(10280));
               }
            }
            if(_loc2_ > 0)
            {
               this._index = _loc1_ + 1;
            }
            _loc1_++;
         }
         if(this._index > 0 && this._index < 7 && !this.todayGot)
         {
            ModuleManager.turnAppModule("ReturnSevenDayGiftPanel");
            return;
         }
         if(this._index == 0 && !this.todayGot)
         {
            ModuleManager.turnAppModule("ReturnSevenDayGiftPanel","正在加载...");
         }
      }
      
      private function onAnimateEnd(param1:AnimatEvent) : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimateEnd);
         if(param1.data == "oldBackMovie")
         {
            ModuleManager.turnAppModule("ReturnSevenDayGiftPanel","正在加载...");
         }
      }
      
      public function get todayGot() : Boolean
      {
         return this._todayGot;
      }
      
      public function set todayGot(param1:Boolean) : void
      {
         this._todayGot = param1;
      }
      
      public function get isOldBack() : Boolean
      {
         return this._isOldBack;
      }
      
      public function init() : void
      {
         this.checkIsOldBack();
      }
   }
}

