package com.gfp.app.mapProcess
{
   import com.gfp.app.time.TimerComponents;
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.net.SocketConnection;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1103701 extends BaseMapProcess
   {
      
      private var _totalTime:uint;
      
      private var _timeID:uint;
      
      private var _progressBar:Sprite;
      
      private var _startTime:int;
      
      public function MapProcess_1103701()
      {
         super();
      }
      
      override protected function init() : void
      {
         SocketConnection.addCmdListener(CommandID.FIGHT_END,this.onEnd);
         this._totalTime = 180;
         this._startTime = getTimer();
         this._timeID = setInterval(this.timeChange,1000);
         this._progressBar = MapManager.currentMap.libManager.getSprite("Tollgate_ProgressBar");
         LayerManager.topLevel.addChild(this._progressBar);
         StageResizeController.instance.register(this.layout);
         this.updateTime();
         this.layout();
      }
      
      private function layout() : void
      {
         this._progressBar.x = LayerManager.stageWidth - this._progressBar.width >> 1;
         this._progressBar.y = 100;
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
         var _loc1_:Number = (this._totalTime - this.leftSeconds) / this._totalTime;
         this._progressBar["bar"].scrollRect = new Rectangle(0,0,395 * _loc1_,30);
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
         DisplayUtil.removeForParent(this._progressBar);
         this._progressBar = null;
         StageResizeController.instance.unregister(this.layout);
      }
   }
}

