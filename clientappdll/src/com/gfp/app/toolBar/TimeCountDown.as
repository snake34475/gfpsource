package com.gfp.app.toolBar
{
   import com.gfp.core.manager.LayerManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class TimeCountDown extends EventDispatcher
   {
      
      private static var _instance:TimeCountDown;
      
      public static const COUNT_DOWN_START:String = "count_down_start";
      
      public static const COUNT_DOWN_OVER:String = "count_down_over";
      
      private var _mainUI:MovieClip;
      
      private var _timeTxt:TextField;
      
      private var _timer:Timer;
      
      private var _countNum:uint;
      
      private var _totalNum:uint;
      
      private var _offsetX:int;
      
      private var _offsetY:int;
      
      public function TimeCountDown()
      {
         super();
         this._mainUI = new ToolBar_TimeCountDown();
         this._timeTxt = this._mainUI["time_txt"];
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      public static function get instance() : TimeCountDown
      {
         if(_instance == null)
         {
            _instance = new TimeCountDown();
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
      
      private function complete() : void
      {
         dispatchEvent(new Event(COUNT_DOWN_OVER));
         this.destroy();
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         --this._countNum;
         if(this._countNum == 0)
         {
            this._timer.stop();
            this.complete();
         }
         this._timeTxt.text = this._countNum + "";
      }
      
      public function start(param1:int, param2:int = -20, param3:int = 80) : void
      {
         this._offsetX = param2;
         this._offsetY = param3;
         this.show();
         this._totalNum = param1;
         this._countNum = param1;
         this._timeTxt.text = this._countNum + "";
         this._timer.start();
         dispatchEvent(new Event(COUNT_DOWN_START));
      }
      
      public function stop() : void
      {
         if(this._timer.running)
         {
            this._timer.stop();
         }
      }
      
      public function show(param1:String = null) : void
      {
         LayerManager.toolsLevel.addChild(this._mainUI);
         DisplayUtil.align(this._mainUI,null,AlignType.TOP_RIGHT);
         this._mainUI.x += this._offsetX;
         this._mainUI.y += this._offsetY;
         if(param1 != null)
         {
            ToolTipManager.add(this._mainUI,param1);
         }
      }
      
      public function updateTime(param1:String) : void
      {
         this._timeTxt.text = param1;
      }
      
      public function getRemainTime() : int
      {
         return this._totalNum - this._countNum;
      }
      
      public function hide() : void
      {
         this.stop();
         DisplayUtil.removeForParent(this._mainUI);
         ToolTipManager.remove(this._mainUI);
      }
      
      public function get isRunning() : Boolean
      {
         return this._timer.running;
      }
      
      public function destroy() : void
      {
         this.hide();
         _instance = null;
         this._mainUI = null;
      }
   }
}

