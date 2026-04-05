package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.utils.TickManager;
   import com.gfp.core.utils.TimeUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class SanShengButton extends BaseActivitySprite
   {
      
      private var _txtTime:TextField;
      
      private var _alertMC:MovieClip;
      
      private var leftTime:int;
      
      public function SanShengButton(param1:ActivityNodeInfo)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._txtTime = _sprite["txtTime"];
         this._alertMC = _sprite["effectbmp_2"];
      }
      
      override public function addEvent() : void
      {
         super.addEvent();
         ActivityExchangeTimesManager.addEventListener(13625,this.onGetTime);
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchange);
      }
      
      override public function removeEvent() : void
      {
         super.removeEvent();
         ActivityExchangeTimesManager.removeEventListener(13625,this.onGetTime);
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchange);
      }
      
      private function onExchange(param1:ExchangeEvent) : void
      {
         ActivityExchangeTimesManager.getActiviteTimeInfo(13625);
      }
      
      private function onGetTime(param1:Event) : void
      {
         var _loc2_:int = int(ActivityExchangeTimesManager.getTimes(13625));
         var _loc3_:int = int(TimeUtil.getServerSecond());
         this.leftTime = 5 * 60 - (_loc3_ - _loc2_);
         TickManager.instance.addRender(this.countDown,1000);
         this._alertMC.visible = false;
      }
      
      private function countDown() : void
      {
         if(this.leftTime <= 0)
         {
            TickManager.instance.removeRender(this.countDown);
            this._txtTime.text = "" + TimeUtil.formatSeconds(0);
            this._alertMC.visible = true;
            return;
         }
         this._txtTime.text = "" + TimeUtil.formatSeconds(this.leftTime);
         --this.leftTime;
      }
      
      override public function executeShow() : Boolean
      {
         ActivityExchangeTimesManager.getActiviteTimeInfo(13625);
         var _loc1_:Boolean = super.executeShow();
         if(_loc1_)
         {
            return true;
         }
         return false;
      }
   }
}

