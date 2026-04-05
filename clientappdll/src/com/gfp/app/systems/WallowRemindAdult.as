package com.gfp.app.systems
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.utils.TextFormatUtil;
   import com.gfp.core.utils.TimeUtil;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class WallowRemindAdult
   {
      
      private static var _instacne:WallowRemindAdult;
      
      private static var ONE_MINUTE_SECOND:int = 60;
      
      private static var ONE_HOUR_SECOND:int = 3600;
      
      private static var HALF_HOUR_SECOND:int = 1800;
      
      private static var ONE_QUARTER_SECOND:int = 900;
      
      private var _isRuning:Boolean;
      
      private var _halfTimer:Timer;
      
      private var _illHealthTimer:Timer;
      
      public function WallowRemindAdult()
      {
         super();
      }
      
      public static function get instance() : WallowRemindAdult
      {
         if(_instacne == null)
         {
            _instacne = new WallowRemindAdult();
         }
         return _instacne;
      }
      
      public function update() : void
      {
         var _loc1_:int = MainManager.olToday / ONE_HOUR_SECOND;
         if(MainManager.olToday % ONE_HOUR_SECOND == 0)
         {
            if(_loc1_ < 3)
            {
               this.showText(AppLanguageDefine.ADULT_WALLOW_MSG_ARR[0]);
            }
         }
         if(ClientConfig.isAdult)
         {
            return;
         }
         if(_loc1_ >= 5)
         {
            this.startIllHealthAlert();
            return;
         }
         if(_loc1_ >= 3)
         {
            this.startHalfAlert();
         }
      }
      
      private function startHalfAlert() : void
      {
         if(this._halfTimer == null)
         {
            this._halfTimer = new Timer(TimeUtil.getMillisecondBySecond(HALF_HOUR_SECOND));
         }
         if(this._halfTimer.running)
         {
            return;
         }
         this._halfTimer.addEventListener(TimerEvent.TIMER,this.showHalfText);
         this._halfTimer.start();
      }
      
      private function showHalfText(param1:TimerEvent) : void
      {
         this.showText(AppLanguageDefine.ADULT_WALLOW_MSG_ARR[1]);
      }
      
      private function startIllHealthAlert() : void
      {
         if(Boolean(this._halfTimer) && this._halfTimer.running)
         {
            this.destoryHalfTimer();
         }
         if(this._illHealthTimer == null)
         {
            this._illHealthTimer = new Timer(TimeUtil.getMillisecondBySecond(ONE_QUARTER_SECOND));
         }
         if(this._illHealthTimer.running)
         {
            return;
         }
         this._illHealthTimer.addEventListener(TimerEvent.TIMER,this.showIllHeathText);
         this._illHealthTimer.start();
      }
      
      private function showIllHeathText(param1:TimerEvent) : void
      {
         this.showText(AppLanguageDefine.ADULT_WALLOW_MSG_ARR[2]);
      }
      
      private function showText(param1:String) : void
      {
         AlertManager.showSimpleAlarm(TextFormatUtil.getRedText(param1));
      }
      
      private function destoryHalfTimer() : void
      {
         if(this._halfTimer)
         {
            this._halfTimer.stop();
            this._halfTimer.removeEventListener(TimerEvent.TIMER,this.showHalfText);
            this._halfTimer = null;
         }
      }
      
      private function destoryIllHeathTimer() : void
      {
         if(this._illHealthTimer)
         {
            this._illHealthTimer.stop();
            this._illHealthTimer.removeEventListener(TimerEvent.TIMER,this.showIllHeathText);
            this._illHealthTimer = null;
         }
      }
   }
}

