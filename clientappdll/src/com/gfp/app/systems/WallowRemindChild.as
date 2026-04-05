package com.gfp.app.systems
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.alert.AlertType;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.utils.ClientType;
   import com.gfp.core.utils.TextFormatUtil;
   import com.gfp.core.utils.TimeUtil;
   import com.gfp.core.utils.WebURLUtil;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class WallowRemindChild
   {
      
      private static var _instacne:WallowRemindChild;
      
      private static var ONE_HOUR_SECOND:int = 3600;
      
      private static var ONE_MINUTE_SECOND:int = 60;
      
      private static var HALF_HOUR_SECOND:int = 1800;
      
      private static var ONE_QUARTER_SECOND:int = 1800;
      
      private static var THREE_QUARTER_SECOND:int = 120;
      
      private var _isBlockAlarm:Boolean;
      
      private var _isBlockRest:Boolean;
      
      private var _isRuning:Boolean;
      
      private var _halfTimer:Timer;
      
      private var _illHealthTimer:Timer;
      
      private var _normDelyId:int;
      
      private var _isOneHourNote:Boolean;
      
      private var _isTwoHourNote:Boolean;
      
      private var _isThreeHourNote:Boolean;
      
      public function WallowRemindChild()
      {
         super();
      }
      
      public static function get instance() : WallowRemindChild
      {
         if(_instacne == null)
         {
            _instacne = new WallowRemindChild();
         }
         return _instacne;
      }
      
      public function update() : void
      {
         this.setWeekAlert();
      }
      
      private function setWeekAlert() : void
      {
         var _loc1_:int = MainManager.olToday / ONE_HOUR_SECOND;
         if(MainManager.actorInfo.isAdult)
         {
            if(_loc1_ >= 5)
            {
               this.startIllHealthAlert();
               return;
            }
            if(_loc1_ < 3)
            {
               this.startNormAlert();
            }
         }
         else
         {
            if(_loc1_ >= 5)
            {
               this.startIllHealthAlert();
               return;
            }
            if(_loc1_ >= 3)
            {
               this.startHalfAlert();
               return;
            }
            if(_loc1_ < 3)
            {
               this.startNormAlert();
            }
         }
      }
      
      private function startNormAlert() : void
      {
         var _loc1_:int = MainManager.olToday / ONE_HOUR_SECOND;
         if(_loc1_ >= 2)
         {
            if(!this._isTwoHourNote)
            {
               this.showText(AppLanguageDefine.WALLOW_MSG_ARR[15]);
               this._isTwoHourNote = true;
            }
            return;
         }
         if(_loc1_ >= 1 && !this._isOneHourNote)
         {
            this.showText(AppLanguageDefine.WALLOW_MSG_ARR[10]);
            this._isOneHourNote = true;
            return;
         }
      }
      
      private function showText(param1:String) : void
      {
         AlertManager.showSimpleAlarm(TextFormatUtil.getRedText(param1));
      }
      
      private function startHalfAlert() : void
      {
         if(this._halfTimer == null)
         {
            this._halfTimer = new Timer(TimeUtil.getMillisecondBySecond(HALF_HOUR_SECOND));
         }
         var _loc1_:int = MainManager.olToday / ONE_HOUR_SECOND;
         if(_loc1_ >= 3 && !this._isThreeHourNote)
         {
            this.showText(AppLanguageDefine.WALLOW_MSG_ARR[16]);
            this._isThreeHourNote = true;
         }
         if(this._halfTimer.running)
         {
            return;
         }
         this._halfTimer.addEventListener(TimerEvent.TIMER,this.halfTimerEvent);
         this._halfTimer.start();
         if(MainManager.olToday >= 11880)
         {
            this.halfTimerEvent(null);
         }
      }
      
      private function halfTimerEvent(param1:TimerEvent) : void
      {
         this.showText(AppLanguageDefine.WALLOW_MSG_ARR[7]);
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
         this._illHealthTimer.addEventListener(TimerEvent.TIMER,this.illHealthTimerEvent);
         this._illHealthTimer.start();
         this.illHealthTimerEvent(null);
      }
      
      private function illHealthTimerEvent(param1:TimerEvent) : void
      {
         this.showText(AppLanguageDefine.WALLOW_MSG_ARR[8]);
      }
      
      public function showFullTime() : void
      {
         if(!this.isCanShowMsg())
         {
            this._isBlockAlarm = true;
         }
         else
         {
            this.showFullTimeAlarm();
         }
      }
      
      public function showBlockMsg() : void
      {
         if(this._isBlockAlarm)
         {
            this._isBlockAlarm = false;
            this.showFullTimeAlarm();
         }
         if(this._isBlockRest)
         {
            this._isBlockRest = false;
            this.showHaveRestPanel();
         }
      }
      
      private function isCanShowMsg() : Boolean
      {
         var _loc1_:Boolean = true;
         if(MapManager.isFightMap)
         {
            _loc1_ = false;
         }
         else if(FightManager.isLoadingRes)
         {
            _loc1_ = false;
         }
         return _loc1_;
      }
      
      private function showFullTimeAlarm() : void
      {
         var _loc1_:String = "";
         if(ClientConfig.clientType == ClientType.KAIXIN)
         {
            _loc1_ = AppLanguageDefine.BATTERY_CHARACTER_COLLECTION[12];
         }
         else
         {
            _loc1_ = AppLanguageDefine.BATTERY_CHARACTER_COLLECTION[7];
         }
         AlertManager.show(AlertType.PREVENT_ADDICTED_ALARM,_loc1_,"",null,this.onFullTimeApply);
      }
      
      private function onFullTimeApply() : void
      {
         if(ClientConfig.clientType == ClientType.KAIXIN)
         {
            WebURLUtil.intance.navigateRealNameAuthenticationKaiXin();
         }
      }
      
      private function showHaveRestPanel() : void
      {
         ModuleManager.turnModule(ClientConfig.getAppModule("HaveRestPanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[17]);
      }
      
      private function destoryHalfTimer() : void
      {
         if(this._halfTimer)
         {
            this._halfTimer.stop();
            this._halfTimer.removeEventListener(TimerEvent.TIMER,this.halfTimerEvent);
            this._halfTimer = null;
         }
      }
      
      private function destoryIllHeathTimer() : void
      {
         if(this._illHealthTimer)
         {
            this._illHealthTimer.stop();
            this._illHealthTimer.removeEventListener(TimerEvent.TIMER,this.illHealthTimerEvent);
            this._illHealthTimer = null;
         }
      }
   }
}

