package com.gfp.app.time
{
   import com.gfp.core.config.xml.TollgateXMLInfo;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.TollgateTimeEvent;
   import com.gfp.core.info.TollgateInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UIManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class TimerComponents
   {
      
      private static var _instance:TimerComponents;
      
      private var timer:Timer;
      
      private var _mainUI:Sprite;
      
      private var num:int;
      
      private var _countDownNum:int;
      
      private var _tollgateId:int;
      
      private var _isCountDown:Boolean;
      
      private var timeMaxOneHour:uint = 0;
      
      private var _startTime:int;
      
      private var _ed:EventDispatcher;
      
      public function TimerComponents()
      {
         super();
         this._mainUI = UIManager.getSprite("Time_Components");
         this._mainUI.cacheAsBitmap = true;
         this.num = 5000;
         this.timer = new Timer(1000);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      public static function get instance() : TimerComponents
      {
         if(!_instance)
         {
            _instance = new TimerComponents();
         }
         return _instance;
      }
      
      public static function hasInstance() : Boolean
      {
         return _instance != null;
      }
      
      private function onTimeSyn(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:int = int(TollgateXMLInfo.getTollgateInfoById(this._tollgateId).countDownTime);
         if(this._isCountDown && _loc5_ > 0)
         {
            this.num = _loc5_ - _loc4_;
         }
         else
         {
            this.num = _loc4_;
         }
         this.refreshNum();
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         var _loc2_:int = getTimer() - this._startTime;
         if(this._isCountDown)
         {
            this.num = this._countDownNum - _loc2_ / 1000;
         }
         else
         {
            this.num = _loc2_ / 1000;
         }
         this.refreshNum();
         if(this.num < 0)
         {
            return;
         }
         this.dispatchEvent(new TollgateTimeEvent(TollgateTimeEvent.TIMER_FRAME,this.num));
      }
      
      private function refreshNum() : void
      {
         var _loc3_:uint = 0;
         if(this.num < 0)
         {
            return;
         }
         if(this.num > 3600)
         {
            _loc3_ = uint(this.num / 3600);
            this.setNum(this._mainUI["num0"],uint(_loc3_ / 10) + 1);
            this.setNum(this._mainUI["num1"],uint(_loc3_ % 10) + 1);
            this.timeMaxOneHour = uint(this.num / 3600);
         }
         var _loc1_:uint = uint((this.num - this.timeMaxOneHour * 3600) / 60);
         this.setNum(this._mainUI["num2"],uint(_loc1_ / 10) + 1);
         this.setNum(this._mainUI["num3"],uint(_loc1_ % 10) + 1);
         var _loc2_:uint = uint(this.num % 60);
         this.setNum(this._mainUI["num4"],uint(_loc2_ / 10) + 1);
         this.setNum(this._mainUI["num5"],uint(_loc2_ % 10) + 1);
      }
      
      private function setNum(param1:MovieClip, param2:int) : void
      {
         param1.gotoAndStop(param2);
      }
      
      public function show() : void
      {
         LayerManager.toolsLevel.addChild(this._mainUI);
         this.layout();
         StageResizeController.instance.register(this.layout);
      }
      
      private function layout() : void
      {
         this._mainUI.x = LayerManager.stageWidth - this._mainUI.width;
         this._mainUI.y = LayerManager.stageHeight - this._mainUI.height - 15;
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this._mainUI);
         StageResizeController.instance.unregister(this.layout);
      }
      
      public function isShow() : Boolean
      {
         return this._mainUI != null && this._mainUI.parent != null;
      }
      
      public function start(param1:int) : void
      {
         this._tollgateId = param1;
         this.initTimeNum();
         if(this.timer)
         {
            this.timer.start();
         }
         else
         {
            this.timer = new Timer(1000);
            this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer.start();
         }
         this.dispatchEvent(new TollgateTimeEvent(TollgateTimeEvent.TIMER_START));
      }
      
      private function initTimeNum() : void
      {
         this._startTime = getTimer();
         var _loc1_:TollgateInfo = TollgateXMLInfo.getTollgateInfoById(this._tollgateId);
         var _loc2_:int = _loc1_ ? int(_loc1_.countDownTime) : 0;
         this._countDownNum = _loc2_;
         this.num = _loc2_;
         this._isCountDown = this.num != 0;
      }
      
      public function stop() : void
      {
         if(this.timer)
         {
            this.timer.stop();
         }
      }
      
      public function reset() : void
      {
         this._startTime = getTimer();
         this.num = 0;
         this.timeMaxOneHour = 0;
      }
      
      public function get timeCost() : uint
      {
         return this.num;
      }
      
      public function destroy() : void
      {
         this.num = 0;
         this.timeMaxOneHour = 0;
         if(this.timer)
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer = null;
         }
         if(this._mainUI)
         {
            DisplayUtil.removeForParent(this._mainUI,false);
         }
         _instance = null;
         StageResizeController.instance.unregister(this.layout);
      }
      
      private function getED() : EventDispatcher
      {
         if(this._ed == null)
         {
            this._ed = new EventDispatcher();
         }
         return this._ed;
      }
      
      public function dispatchEvent(param1:Event) : void
      {
         this.getED().dispatchEvent(param1);
      }
      
      public function addEventListener(param1:String, param2:Function) : void
      {
         this.getED().addEventListener(param1,param2);
      }
      
      public function removeEventListener(param1:String, param2:Function) : void
      {
         this.getED().removeEventListener(param1,param2);
      }
   }
}

