package com.gfp.app.mapProcess
{
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.utils.FilterUtil;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1047501 extends BaseMapProcess
   {
      
      private const TOTAL_TIME:uint = 30;
      
      private var _timer:Timer;
      
      private var _displayText:TextField;
      
      public function MapProcess_1047501()
      {
         super();
      }
      
      override protected function init() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         ModuleManager.turnAppModule("TowerDefenseControlPanel");
         this._timer = new Timer(1000,30);
         this._timer.start();
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this._displayText = new TextField();
         this._displayText.autoSize = TextFieldAutoSize.LEFT;
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.size = 20;
         _loc2_.color = 16777215;
         this._displayText.defaultTextFormat = _loc2_;
         this._displayText.setTextFormat(_loc2_);
         this._displayText.filters = FilterUtil.DISPLAYOBJECT_FLASH_FILTER;
         LayerManager.topLevel.addChild(this._displayText);
         this.setTime(30);
         DisplayUtil.align(this._displayText,null,AlignType.MIDDLE_CENTER);
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         this.setTime(30 - this._timer.currentCount);
      }
      
      private function setTime(param1:int) : void
      {
         if(param1 >= 0)
         {
            this._displayText.text = "距离魔界大军入侵还有" + param1 + "秒，点击左侧可设置防御塔";
         }
      }
      
      private function onTimerComplete(param1:TimerEvent) : void
      {
         this.clearTimer();
      }
      
      private function clearTimer() : void
      {
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         }
         DisplayUtil.removeForParent(this._displayText);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.clearTimer();
         this._displayText = null;
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
      }
   }
}

