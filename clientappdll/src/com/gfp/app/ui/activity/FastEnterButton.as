package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   
   public class FastEnterButton extends BaseActivitySprite
   {
      
      public function FastEnterButton(param1:ActivityNodeInfo)
      {
         super(param1);
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
         if([13296].indexOf(param1.info.id) != -1)
         {
            DynamicActivityEntry.instance.updateAlign();
         }
      }
      
      override public function executeShow() : Boolean
      {
         var _loc1_:Boolean = super.executeShow();
         if(this.swapTimes(13296) == 1)
         {
            return false;
         }
         return _loc1_;
      }
      
      private function swapTimes(param1:int) : int
      {
         return ActivityExchangeTimesManager.getTimes(param1);
      }
   }
}

