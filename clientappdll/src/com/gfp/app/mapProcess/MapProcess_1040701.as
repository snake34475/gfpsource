package com.gfp.app.mapProcess
{
   import com.gfp.app.time.TimerComponents;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1040701 extends BaseMapProcess
   {
      
      private var _socre:int;
      
      private var _time:uint;
      
      private var _timeID:uint;
      
      private var prevSysTime:int;
      
      private var prevTime:int;
      
      private var _scoreUI:Sprite;
      
      private var _timeText:TextField;
      
      public function MapProcess_1040701()
      {
         super();
      }
      
      override protected function init() : void
      {
         TimerComponents.instance.hide();
         this.initScoreUI();
      }
      
      private function initScoreUI() : void
      {
         this._scoreUI = UIManager.getSprite("ToolBar_TollgateTimeUI");
         this._timeText = this._scoreUI["time_txt"];
         LayerManager.topLevel.addChild(this._scoreUI);
         DisplayUtil.align(this._scoreUI,null,AlignType.TOP_CENTER);
         this._time = 120;
         this.prevTime = 120;
         this.prevSysTime = getTimer();
         this.updateTime();
         this._timeID = setInterval(this.updateTime,1000);
      }
      
      private function destroyScoreUI() : void
      {
         DisplayUtil.removeForParent(this._scoreUI);
         this._scoreUI = null;
      }
      
      private function onStageProChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         this._time = _loc2_.readUnsignedInt();
         this.prevSysTime = getTimer();
         this._socre = _loc2_.readUnsignedInt();
         this.updateTime();
      }
      
      private function updateTime() : void
      {
         var _loc1_:int = this._time - int((getTimer() - this.prevSysTime) * 0.001);
         if(_loc1_ > this.prevTime)
         {
            _loc1_ = this.prevTime;
         }
         if(_loc1_ <= 0)
         {
            _loc1_ = 0;
            this.detroyTime();
         }
         this.prevTime = _loc1_;
         this._timeText.text = _loc1_.toString();
      }
      
      private function detroyTime() : void
      {
         if(this._timeID != 0)
         {
            clearInterval(this._timeID);
            this._timeID = 0;
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.detroyTime();
         this.destroyScoreUI();
      }
   }
}

