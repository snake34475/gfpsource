package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class RookieGiftButton extends BaseActivitySprite
   {
      
      private var _daysID:int = 11939;
      
      private var _isSignTodayID:int = 11981;
      
      private var swapID:Array = [11980,11940,11941,11942,11943,11944,11945,11985,11986,11981,11939];
      
      private var newUserSwaps:Array = [13040,13041,13042,13043,13044,13045];
      
      private var _totaySigned:Boolean;
      
      private var _registTime:int;
      
      public function RookieGiftButton(param1:ActivityNodeInfo)
      {
         var _loc2_:Date = new Date(2016,3,22,0,0,0,0);
         this._registTime = _loc2_.time * 0.001;
         super(param1);
         if(this.isNewUser())
         {
            this._totaySigned = ActivityExchangeTimesManager.getTimes(11981) > 0;
         }
         else
         {
            this._totaySigned = ActivityExchangeTimesManager.getTimes(this._isSignTodayID) > 0;
         }
         _hasProptEffect = this._totaySigned == false;
         (_sprite as MovieClip).gotoAndStop(this.isNewUser() ? 2 : 1);
         resetPromptEffect();
      }
      
      private function isNewUser() : Boolean
      {
         return MainManager.actorInfo.createTime > this._registTime;
      }
      
      override protected function doAction() : void
      {
         if(this.isNewUser())
         {
            ModuleManager.turnAppModule("FiveGiftPanel");
         }
         else
         {
            super.doAction();
         }
      }
      
      override public function addEvent() : void
      {
         super.addEvent();
         ActivityExchangeTimesManager.addEventListener(this._daysID,this.repsonseDays);
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeComplete);
      }
      
      override public function removeEvent() : void
      {
         super.removeEvent();
         ActivityExchangeTimesManager.removeEventListener(this._daysID,this.repsonseDays);
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeComplete);
      }
      
      private function exchangeComplete(param1:ExchangeEvent) : void
      {
         if(this.swapID.indexOf(param1.info.id) != -1 || this.newUserSwaps.indexOf(param1.info.id) != -1)
         {
            this._totaySigned = true;
            _hasProptEffect = false;
            resetPromptEffect();
         }
      }
      
      private function repsonseDays(param1:Event) : void
      {
         if(this.isNewUser() == false && ActivityExchangeTimesManager.getTimes(this._daysID) >= 7)
         {
            DynamicActivityEntry.instance.updateAlign();
         }
      }
      
      override public function executeShow() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.isNewUser() == false)
         {
            _loc1_ = ActivityExchangeTimesManager.getTimes(this._daysID) > 0;
            return Boolean(super.executeShow()) && (MainManager.actorInfo.lv < 100 || _loc1_) && ActivityExchangeTimesManager.getTimes(this._daysID) < 7;
         }
         _loc2_ = 0;
         _loc3_ = 0;
         while(_loc3_ < this.newUserSwaps.length)
         {
            if(ActivityExchangeTimesManager.getTimes(this.newUserSwaps[_loc3_]) > 0)
            {
               _loc2_++;
            }
            _loc3_++;
         }
         return Boolean(super.executeShow()) && _loc2_ < 5;
      }
   }
}

