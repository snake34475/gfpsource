package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   
   public class ReturnSevenDayGiftBtn extends BaseActivitySprite
   {
      
      public function ReturnSevenDayGiftBtn(param1:ActivityNodeInfo)
      {
         super(param1);
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
      }
      
      private function onExchangeComplete(param1:ExchangeEvent) : void
      {
         if(param1.info.id == 10282)
         {
            DynamicActivityEntry.instance.updateAlign();
         }
      }
      
      override public function executeShow() : Boolean
      {
         return Boolean(super.executeShow()) && ActivityExchangeTimesManager.getTimes(10282) == 0 && ActivityExchangeTimesManager.getTimes(10308) == 1;
      }
      
      override public function hasProptEffect() : Boolean
      {
         return this.executeShow();
      }
   }
}

