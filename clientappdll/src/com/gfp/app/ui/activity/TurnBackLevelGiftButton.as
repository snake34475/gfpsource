package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.MainManager;
   
   public class TurnBackLevelGiftButton extends BaseActivitySprite
   {
      
      public function TurnBackLevelGiftButton(param1:ActivityNodeInfo)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
      }
      
      override public function addEvent() : void
      {
         super.addEvent();
         if(this.executeShow())
         {
            ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
         }
      }
      
      override public function removeEvent() : void
      {
         super.removeEvent();
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
      }
      
      private function onExchangeComplete(param1:ExchangeEvent) : void
      {
         if(param1.info.id >= 6568 || param1.info.id <= 6573)
         {
            if(this.getGettedCount() >= 6)
            {
               DynamicActivityEntry.instance.updateAlign();
            }
         }
      }
      
      override public function executeShow() : Boolean
      {
         var _loc1_:Boolean = super.executeShow();
         if(_loc1_)
         {
            if(MainManager.actorInfo.isTurnBack == false)
            {
               return false;
            }
            if(this.getGettedCount() >= 6)
            {
               return false;
            }
            return true;
         }
         return false;
      }
      
      private function getGettedCount() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < 6)
         {
            if(ActivityExchangeTimesManager.getTimes(6568 + _loc2_) > 0)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
   }
}

