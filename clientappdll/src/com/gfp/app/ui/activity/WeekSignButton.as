package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.player.MovieClipPlayerEx;
   import com.gfp.core.utils.TickManager;
   import com.gfp.core.utils.TimeUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class WeekSignButton extends BaseActivitySprite
   {
      
      private var _txtTime:TextField;
      
      private var _mcOpenState:MovieClip;
      
      private var _mcEffect:MovieClipPlayerEx;
      
      private var _timeLeft:int;
      
      public function WeekSignButton(param1:ActivityNodeInfo)
      {
         super(param1);
      }
      
      override public function addEvent() : void
      {
         super.addEvent();
         ActivityExchangeTimesManager.addEventListener(13717,this.onGetTime);
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchange);
      }
      
      override public function removeEvent() : void
      {
         super.removeEvent();
         ActivityExchangeTimesManager.removeEventListener(13717,this.onGetTime);
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchange);
      }
      
      private function onExchange(param1:ExchangeEvent) : void
      {
         this.updateView();
      }
      
      private function onGetTime(param1:Event) : void
      {
         var _loc2_:int = int(ActivityExchangeTimesManager.getTimes(13717));
         var _loc3_:int = TimeUtil.getServerSecond() - _loc2_;
         this.showAlert(false);
         if(_loc2_ == 0)
         {
            _loc3_ = int(MainManager.olToday);
         }
         this._timeLeft = 30 * 60 - _loc3_;
         TickManager.instance.addRender(this.countDown,1000);
      }
      
      private function countDown() : void
      {
         if(this._timeLeft <= 0)
         {
            TickManager.instance.removeRender(this.countDown);
            this.showAlert(true);
            return;
         }
         --this._timeLeft;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._mcEffect = getEffect(SYSTEM_EFFECT_ID);
      }
      
      override public function executeShow() : Boolean
      {
         var _loc1_:Boolean = super.executeShow();
         this.updateView();
         if(_loc1_)
         {
            return true;
         }
         return false;
      }
      
      private function showAlert(param1:Boolean) : void
      {
         this._mcEffect.visible = param1;
      }
      
      private function updateView() : void
      {
         ActivityExchangeTimesManager.getActiviteTimeInfo(13717);
      }
   }
}

