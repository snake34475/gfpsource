package com.gfp.app.mapProcess
{
   import com.gfp.app.time.TimerComponents;
   import com.gfp.core.CommandID;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import flash.display.Sprite;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1102901 extends BaseMapProcess
   {
      
      private var _totalTime:uint;
      
      private var _timeID:uint;
      
      private var _timeUI:Sprite;
      
      private var _startTime:int;
      
      public function MapProcess_1102901()
      {
         super();
      }
      
      override protected function init() : void
      {
         ActivityExchangeTimesManager.updataTimesByOnce(5201);
         SocketConnection.addCmdListener(CommandID.FIGHT_END,this.onEnd);
         this._timeUI = UIManager.getSprite("ToolBar_TollgateTimeUI");
         LayerManager.topLevel.addChild(this._timeUI);
         DisplayUtil.align(this._timeUI,null,AlignType.TOP_CENTER);
         this._totalTime = 180;
         this._startTime = getTimer();
         this._timeID = setInterval(this.timeChange,1000);
         this.updateTime();
      }
      
      private function onEnd(param1:SocketEvent) : void
      {
         this.detroyTime();
         TimerComponents.instance.stop();
      }
      
      private function timeChange() : void
      {
         this.updateTime();
         if(this.leftSeconds <= 0)
         {
            this.detroyTime();
         }
      }
      
      private function updateTime() : void
      {
         this._timeUI["time_txt"].text = Math.max(this.leftSeconds,0).toString();
      }
      
      private function get leftSeconds() : int
      {
         return this._totalTime - int((getTimer() - this._startTime) * 0.001);
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
         SocketConnection.removeCmdListener(CommandID.FIGHT_END,this.onEnd);
         this.detroyTime();
         DisplayUtil.removeForParent(this._timeUI);
         this._timeUI = null;
      }
   }
}

