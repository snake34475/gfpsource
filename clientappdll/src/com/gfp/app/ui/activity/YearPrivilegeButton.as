package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityMultiNodeInfo;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import flash.display.MovieClip;
   
   public class YearPrivilegeButton extends BaseActivityMultiSprite
   {
      
      private var _alertMC:MovieClip;
      
      private var leftTime:int;
      
      public function YearPrivilegeButton(param1:ActivityMultiNodeInfo)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(this.swapTimes(13882) >= 12 && this.swapTimes(13886) == 0)
         {
            showProptEffect();
         }
         else
         {
            hideProptEffect();
         }
      }
      
      private function swapTimes(param1:int) : int
      {
         return ActivityExchangeTimesManager.getTimes(param1);
      }
      
      override public function addEvent() : void
      {
         super.addEvent();
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchange);
      }
      
      override public function removeEvent() : void
      {
         super.removeEvent();
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchange);
      }
      
      private function onExchange(param1:ExchangeEvent) : void
      {
         if(this.swapTimes(13882) >= 12 && this.swapTimes(13886) == 0)
         {
            showProptEffect();
         }
      }
   }
}

