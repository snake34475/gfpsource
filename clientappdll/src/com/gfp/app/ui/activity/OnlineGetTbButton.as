package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityMultiNodeInfo;
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.player.MovieClipPlayerEx;
   import com.gfp.core.utils.TimeUtil;
   import flash.text.TextField;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class OnlineGetTbButton extends BaseActivityMultiSprite
   {
      
      private var _txtTime:TextField;
      
      private var _mcOpenState:MovieClipPlayerEx;
      
      private var _mcEffect:MovieClipPlayerEx;
      
      private var _timer:int;
      
      private var _leftCount:int;
      
      private var _swapIDs:Array = [4660,4661,4662,4663,4664,4665];
      
      private var _vipSwapIDs:Array = [5002,5003,5004,5005,5006,5007];
      
      private var _needTime:Array = [0 * 60,10 * 60,30 * 60,60 * 60,90 * 60,120 * 60];
      
      public function OnlineGetTbButton(param1:ActivityNodeInfo)
      {
         super(param1 as ActivityMultiNodeInfo);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._txtTime = _sprite["txtTime"];
         this._mcEffect = getEffect(SYSTEM_EFFECT_ID);
         this._mcOpenState = getEffect(2);
         this.clearAwardAlert();
         this.reset();
      }
      
      override public function addEvent() : void
      {
         super.addEvent();
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
         this.onCDChangeHandle();
      }
      
      override public function removeEvent() : void
      {
         super.removeEvent();
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
      }
      
      private function onExchangeComplete(param1:ExchangeEvent) : void
      {
         if(this._swapIDs.indexOf(param1.info.id) != -1 || this._vipSwapIDs.indexOf(param1.info.id) != -1)
         {
            this.reset();
         }
      }
      
      private function reset() : void
      {
         clearInterval(this._timer);
         var _loc1_:int = int(MainManager.olToday);
         this._leftCount = 0;
         var _loc2_:int = 0;
         while(_loc2_ < 6)
         {
            if(_loc1_ >= this._needTime[_loc2_])
            {
               ++this._leftCount;
               if(MainManager.actorInfo.isVip)
               {
                  ++this._leftCount;
               }
            }
            _loc2_++;
         }
         this._leftCount -= this.getDrawedCount();
         this.onLeftTimeHandle();
         if(this.cd > 0)
         {
            this._timer = setInterval(this.onTimer,1000);
         }
         this.onCDChangeHandle();
      }
      
      private function getDrawedCount() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._swapIDs.length)
         {
            if(ActivityExchangeTimesManager.getTimes(this._swapIDs[_loc2_]) > 0)
            {
               _loc1_++;
            }
            if(ActivityExchangeTimesManager.getTimes(this._vipSwapIDs[_loc2_]) > 0)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function get cd() : int
      {
         if(this._leftCount > 0)
         {
            return 0;
         }
         var _loc1_:int = int(MainManager.olToday);
         var _loc2_:int = 0;
         while(_loc2_ < 6)
         {
            if(ActivityExchangeTimesManager.getTimes(this._swapIDs[_loc2_]) == 0)
            {
               if(_loc1_ < this._needTime[_loc2_])
               {
                  return this._needTime[_loc2_] - _loc1_;
               }
               return 0;
            }
            _loc2_++;
         }
         return 0;
      }
      
      private function onTimer() : void
      {
         if(this.cd <= 0)
         {
            clearInterval(this._timer);
            this.reset();
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
      
      private function onLeftTimeHandle() : void
      {
         if(this._leftCount == 0)
         {
            this._txtTime.text = "";
            this.clearAwardAlert();
         }
         else
         {
            this.hasAwardAlert();
         }
      }
      
      private function hasAwardAlert() : void
      {
         this._txtTime.text = "00:00";
         if(this.cd <= 0 && this._leftCount > 0)
         {
            this._mcEffect.play();
            this._mcEffect.visible = true;
            this._mcOpenState.play();
            this._mcOpenState.visible = true;
         }
      }
      
      private function clearAwardAlert() : void
      {
         this._mcEffect.stop();
         this._mcEffect.visible = false;
         this._mcOpenState.stop();
         this._mcOpenState.visible = false;
      }
      
      override public function hasProptEffect() : Boolean
      {
         return this.cd <= 0 && this._leftCount > 0;
      }
      
      override public function executeShow() : Boolean
      {
         var _loc1_:Boolean = super.executeShow();
         if(_loc1_)
         {
            return true;
         }
         return false;
      }
   }
}

