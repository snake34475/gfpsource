package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityMultiNodeInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.player.MovieClipPlayerEx;
   import com.gfp.core.utils.TickManager;
   import com.gfp.core.utils.TimeUtil;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class MysteriousShopButton extends BaseActivityMultiSprite
   {
      
      private static const REFRESH_TIME_SWAP_ID:int = 10527;
      
      private var _txtTime:TextField;
      
      private var _mcEffect:MovieClipPlayerEx;
      
      private var _timer:int;
      
      private var _lastRefreshSeconds:int;
      
      public function MysteriousShopButton(param1:ActivityMultiNodeInfo)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._txtTime = _sprite["txtTime"];
         this._mcEffect = getEffect(1);
         this.clearAwardAlert();
         this.responseTime(null);
      }
      
      override public function addEvent() : void
      {
         super.addEvent();
         ActivityExchangeTimesManager.addEventListener(REFRESH_TIME_SWAP_ID,this.responseTime);
         this.responseTime(null);
      }
      
      override public function removeEvent() : void
      {
         super.removeEvent();
         ActivityExchangeTimesManager.removeEventListener(REFRESH_TIME_SWAP_ID,this.responseTime);
      }
      
      private function responseTime(param1:Event) : void
      {
         this._lastRefreshSeconds = ActivityExchangeTimesManager.getTimes(REFRESH_TIME_SWAP_ID);
         TickManager.instance.removeRender(this.onTimer);
         if(this.cd > 0)
         {
            TickManager.instance.addRender(this.onTimer,1000);
            this.onTimer();
         }
         else
         {
            this.hasAwardAlert();
         }
      }
      
      private function get cd() : int
      {
         return Math.max(0,this._lastRefreshSeconds + 1200 - TimeUtil.getServerSecond());
      }
      
      private function onTimer() : void
      {
         if(this.cd <= 0)
         {
            TickManager.instance.removeRender(this.onTimer);
         }
         this.onCDChangeHandle();
      }
      
      private function onCDChangeHandle() : void
      {
         if(this.cd > 0)
         {
            this.clearAwardAlert();
            this._txtTime.text = TimeUtil.formatSeconds(this.cd);
         }
         else
         {
            this.hasAwardAlert();
         }
      }
      
      private function hasAwardAlert() : void
      {
         this._txtTime.text = "00:00";
         if(this.cd <= 0)
         {
            this._mcEffect.play();
            this._mcEffect.visible = true;
         }
      }
      
      private function clearAwardAlert() : void
      {
         this._mcEffect.stop();
         this._mcEffect.visible = false;
      }
      
      override public function hasProptEffect() : Boolean
      {
         return this.cd <= 0;
      }
   }
}

