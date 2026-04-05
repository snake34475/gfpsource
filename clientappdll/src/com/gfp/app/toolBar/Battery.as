package com.gfp.app.toolBar
{
   import com.gfp.app.cartoon.SnowCarnivalAnimation;
   import com.gfp.app.systems.WallowRemindAdult;
   import com.gfp.app.systems.WallowRemindChild;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.utils.ClientType;
   import com.gfp.core.utils.TextFormatUtil;
   import com.gfp.core.utils.TimeUtil;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class Battery
   {
      
      private static var _instance:Battery;
      
      private var _mainUI:UI_SWF_Battery;
      
      private var _timeText:TextField;
      
      private var _addictedTimer:Timer;
      
      private var prevSyncTime:int;
      
      public function Battery()
      {
         super();
         this._mainUI = new UI_SWF_Battery();
         this._mainUI.buttonMode = true;
         this._timeText = this._mainUI["time_txt"];
         this._timeText.mouseEnabled = false;
         this._addictedTimer = new Timer(60000);
         this._addictedTimer.addEventListener(TimerEvent.TIMER,this.onAddictedTimer);
         this._addictedTimer.start();
         this.prevSyncTime = getTimer();
      }
      
      public static function get instance() : Battery
      {
         if(_instance == null)
         {
            _instance = new Battery();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this._mainUI,false);
         StageResizeController.instance.unregister(this.layout);
      }
      
      public function destroy() : void
      {
         this.hide();
      }
      
      public function show() : void
      {
         this.layout();
         LayerManager.toolsLevel.addChild(this._mainUI);
         this.updateTimeTips();
         this.updateTimeText();
         StageResizeController.instance.register(this.layout);
      }
      
      private function layout() : void
      {
         this._mainUI.x = LayerManager.stageWidth - 44;
         this._mainUI.y = LayerManager.stageHeight - 130 - 30;
      }
      
      private function onAddictedTimer(param1:TimerEvent) : void
      {
         MainManager.thisLoginOLTime += 1;
         this.onTimeUpdate();
         this.prevSyncTime = getTimer();
      }
      
      public function onTimeUpdate(param1:Boolean = false) : void
      {
         this.updateTimeTips();
         this.updateTimeText();
         if(ClientConfig.clientType == ClientType.KAIXIN)
         {
            WallowRemindAdult.instance.update();
         }
         else
         {
            WallowRemindChild.instance.update();
         }
         SnowCarnivalAnimation.whenTimerHandler();
      }
      
      private function updateTimeTips() : void
      {
         ToolTipManager.remove(this._mainUI);
         ToolTipManager.add(this._mainUI,AppLanguageDefine.BATTERY_CHARACTER_COLLECTION[8] + TextFormatUtil.getRedText(this.getOnlineMinute() + "") + AppLanguageDefine.BATTERY_CHARACTER_COLLECTION[9]);
      }
      
      private function getOnlineMinute() : int
      {
         return Math.floor(MainManager.olToday / TimeUtil.ONE_MINUTE_SECONDS);
      }
      
      private function updateTimeText() : void
      {
         var _loc1_:TextFormat = null;
         this._timeText.text = this.getTimeTxt();
         if(MainManager.battleTimeLimit - MainManager.olToday <= 10 * TimeUtil.ONE_MINUTE_SECONDS)
         {
            _loc1_ = new TextFormat();
            _loc1_.color = "0XFF0000";
            this._timeText.setTextFormat(_loc1_);
         }
      }
      
      private function getTimeTxt() : String
      {
         var _loc1_:int = MainManager.battleTimeLimit - MainManager.olToday;
         if(_loc1_ <= 0)
         {
            return "00:00";
         }
         var _loc2_:int = Math.ceil(_loc1_ / TimeUtil.ONE_MINUTE_SECONDS);
         var _loc3_:int = int(_loc2_ / TimeUtil.ONE_HOUR_MINUTE);
         var _loc4_:int = _loc2_ % TimeUtil.ONE_MINUTE_SECONDS;
         _loc4_ = _loc3_ < 0 ? 0 : _loc4_;
         _loc3_ = _loc3_ < 0 ? 0 : _loc3_;
         return _loc4_ < 10 ? "0" + _loc3_ + ":0" + _loc4_ : "0" + _loc3_ + ":" + _loc4_;
      }
   }
}

