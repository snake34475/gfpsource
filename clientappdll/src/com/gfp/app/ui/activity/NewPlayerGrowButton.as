package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.MainManager;
   
   public class NewPlayerGrowButton extends BaseActivitySprite
   {
      
      private const SWAP_IDS:Array = [5744,5745,5746,5747];
      
      public function NewPlayerGrowButton(param1:ActivityNodeInfo)
      {
         super(param1);
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
         if(this.SWAP_IDS.indexOf(param1.info.id) != -1)
         {
            if(this.hasGetAward())
            {
               DynamicActivityEntry.instance.updateAlign();
            }
         }
      }
      
      private function hasGetAward() : Boolean
      {
         var _loc2_:int = 0;
         var _loc1_:Boolean = true;
         for each(_loc2_ in this.SWAP_IDS)
         {
            if(ActivityExchangeTimesManager.getTimes(_loc2_) == 0)
            {
               _loc1_ = false;
               break;
            }
         }
         return _loc1_;
      }
      
      override public function executeShow() : Boolean
      {
         var _loc1_:Boolean = super.executeShow();
         if(_loc1_)
         {
            if(!this.isAlive())
            {
               return false;
            }
            return true;
         }
         return false;
      }
      
      private function isAlive() : Boolean
      {
         var _loc1_:Date = new Date(2014,6,7,0,0,0,0);
         return !this.hasGetAward() && MainManager.actorInfo.createTime > _loc1_.time * 0.001;
      }
   }
}

