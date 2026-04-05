package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.info.ActivityExchangeAwardInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   
   public class GrowBookButton extends BaseActivitySprite
   {
      
      public function GrowBookButton(param1:ActivityNodeInfo)
      {
         super(param1);
         this.initUI();
         this.checkTips();
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
      }
      
      private function onExchangeComplete(param1:ExchangeEvent) : void
      {
         var _loc2_:ActivityExchangeAwardInfo = param1.info;
         var _loc3_:uint = uint(_loc2_.id);
         if(_loc3_ == 3672 || _loc3_ == 3673)
         {
            this.checkTips();
         }
      }
      
      private function initUI() : void
      {
      }
      
      private function checkTips() : void
      {
         if(ActivityExchangeTimesManager.getTimes(3672) == 0 || ActivityExchangeTimesManager.getTimes(3673) == 0)
         {
         }
      }
   }
}

