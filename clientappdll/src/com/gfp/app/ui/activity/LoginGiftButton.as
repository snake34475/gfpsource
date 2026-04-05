package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.manager.EveryDayLuckManager;
   import com.gfp.core.player.MovieClipPlayerEx;
   import com.gfp.core.utils.TimeUtil;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class LoginGiftButton extends BaseActivitySprite
   {
      
      private var _txtTime:TextField;
      
      private var _mcOpenState:MovieClipPlayerEx;
      
      private var _mcEffect:MovieClipPlayerEx;
      
      public function LoginGiftButton(param1:ActivityNodeInfo)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._txtTime = _sprite["txtTime"];
         this._mcEffect = getEffect(1);
         this._mcOpenState = getEffect(2);
         this.clearAwardAlert();
      }
      
      override public function addEvent() : void
      {
         super.addEvent();
         EveryDayLuckManager.instance.addEventListener(EveryDayLuckManager.CD_CHANGE,this.onCDChangeHandle);
         EveryDayLuckManager.instance.addEventListener(EveryDayLuckManager.LEFT_TIMES_CHANGE,this.onLeftTimeHandle);
         this.onCDChangeHandle(null);
      }
      
      override public function removeEvent() : void
      {
         super.removeEvent();
         EveryDayLuckManager.instance.removeEventListener(EveryDayLuckManager.CD_CHANGE,this.onCDChangeHandle);
         EveryDayLuckManager.instance.removeEventListener(EveryDayLuckManager.LEFT_TIMES_CHANGE,this.onLeftTimeHandle);
      }
      
      private function onCDChangeHandle(param1:Event) : void
      {
         var _loc2_:int = EveryDayLuckManager.instance.cd;
         if(_loc2_ > 0)
         {
            this.clearAwardAlert();
            this._txtTime.text = TimeUtil.formatSeconds(_loc2_);
         }
         else
         {
            this.hasAwardAlert();
         }
      }
      
      private function onLeftTimeHandle(param1:Event) : void
      {
         var _loc2_:int = EveryDayLuckManager.instance.leftTimes;
         if(_loc2_ == 0)
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
         if(EveryDayLuckManager.instance.cd <= 0 && EveryDayLuckManager.instance.leftTimes > 0)
         {
            this._mcEffect.play();
            this._mcEffect.visible = true;
            this._mcOpenState.play();
            this._mcOpenState.visible = true;
         }
      }
      
      public function clearAwardAlert() : void
      {
         this._mcEffect.stop();
         this._mcEffect.visible = false;
         this._mcOpenState.stop();
         this._mcOpenState.visible = false;
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

