package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.manager.TradeAuctionManager;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import flash.utils.setInterval;
   
   public class TradeAuctionButton extends BaseActivitySprite
   {
      
      private var _timer:int;
      
      private var _currentTimeIndex:int = -1;
      
      public function TradeAuctionButton(param1:ActivityNodeInfo)
      {
         super(param1);
         this._timer = setInterval(this.onTimer,10 * 1000);
         this.onTimer();
      }
      
      private function onTimer() : void
      {
         var _loc1_:int = TradeAuctionManager.getInstance().getCurrentTimeIndex();
         _loc1_ = _loc1_ >= 0 ? 1 : -1;
         if(this._currentTimeIndex != _loc1_)
         {
            this._currentTimeIndex = _loc1_;
            DynamicActivityEntry.instance.updateAlign();
         }
      }
      
      override public function executeShow() : Boolean
      {
         var _loc1_:Boolean = super.executeShow();
         if(_loc1_)
         {
            return this._currentTimeIndex >= 0;
         }
         return false;
      }
   }
}

