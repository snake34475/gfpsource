package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityMultiNodeInfo;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.net.SocketConnection;
   import flash.events.Event;
   import flash.utils.setTimeout;
   
   public class FreeAwardButton extends BaseActivityMultiSprite
   {
      
      private var TONG_BAO_ID:int = 11683;
      
      private var SWAP_ID:Array = [11684,11685,11686,11687,11688,11683];
      
      private var needNum:Array = [250,500,1000,2000];
      
      public function FreeAwardButton(param1:ActivityMultiNodeInfo)
      {
         super(param1);
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeComplete);
         SocketConnection.addCmdListener(CommandID.BUY_MALL_ITEMS,this.xiaofeiHandle);
         ActivityExchangeTimesManager.addEventListener(this.TONG_BAO_ID,this.responseTongbao);
         resetPromptEffect();
      }
      
      private function xiaofeiHandle(param1:Event) : void
      {
         setTimeout(ActivityExchangeTimesManager.getActiviteTimeInfo,2000,this.TONG_BAO_ID);
      }
      
      private function responseTongbao(param1:Event) : void
      {
         resetPromptEffect();
      }
      
      private function exchangeComplete(param1:ExchangeEvent) : void
      {
         var _loc2_:int = int(param1.info.id);
         if(this.SWAP_ID.indexOf(_loc2_) != -1)
         {
            resetPromptEffect();
         }
      }
      
      override public function hasProptEffect() : Boolean
      {
         var _loc1_:int = int(ActivityExchangeTimesManager.getTimes(this.TONG_BAO_ID));
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            if(_loc1_ >= this.needNum[_loc2_] && ActivityExchangeTimesManager.getTimes(this.SWAP_ID[_loc2_]) == 0)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
   }
}

