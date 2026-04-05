package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.MainManager;
   
   public class LiuDaoForNewPlayerButton extends BaseActivitySprite
   {
      
      private var _registTime:uint;
      
      private var _todayGetted:Boolean;
      
      private var _rewardSwap:Array = [13103,13104,13105,13106,13107,13108,13109,13110];
      
      public function LiuDaoForNewPlayerButton(param1:ActivityNodeInfo)
      {
         super(param1);
         var _loc2_:Date = new Date(2016,4,13,0,0,0,0);
         this._registTime = _loc2_.time / 1000;
         this._todayGetted = ActivityExchangeTimesManager.getTimes(13111) > 0;
         resetPromptEffect();
      }
      
      private function isNewUser() : Boolean
      {
         return MainManager.actorInfo.createTime >= this._registTime;
      }
      
      override public function addEvent() : void
      {
         super.addEvent();
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeHandle);
      }
      
      override public function removeEvent() : void
      {
         super.removeEvent();
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeHandle);
      }
      
      private function exchangeHandle(param1:ExchangeEvent) : void
      {
         var _loc2_:int = int(param1.info.id);
         if(this._rewardSwap.indexOf(_loc2_) != -1)
         {
            this._todayGetted = true;
            resetPromptEffect();
            if(_loc2_ == 13110)
            {
               DynamicActivityEntry.instance.updateAlign();
            }
         }
         else if(_loc2_ == 9761)
         {
            DynamicActivityEntry.instance.updateAlign();
         }
      }
      
      override public function hasProptEffect() : Boolean
      {
         return this._todayGetted == false;
      }
      
      override public function executeShow() : Boolean
      {
         return Boolean(super.executeShow()) && this.isNewUser() && ActivityExchangeTimesManager.getTimes(13110) == 0 && ActivityExchangeTimesManager.getTimes(9761) > 0;
      }
   }
}

