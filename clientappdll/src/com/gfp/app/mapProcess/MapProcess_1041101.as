package com.gfp.app.mapProcess
{
   import com.gfp.app.time.TimerComponents;
   import com.gfp.core.CommandID;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import flash.display.Sprite;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1041101 extends BaseMapProcess
   {
      
      private var _time:uint;
      
      private var _timeID:uint;
      
      private var _timeUI:Sprite;
      
      public function MapProcess_1041101()
      {
         super();
      }
      
      override protected function init() : void
      {
         SocketConnection.addCmdListener(CommandID.FIGHT_END,this.onEnd);
         SocketConnection.addCmdListener(CommandID.STAGE_TIME_SYN,this.onTimeSyn);
         this._timeUI = UIManager.getSprite("ToolBar_TollgateTimeUI");
         LayerManager.topLevel.addChild(this._timeUI);
         DisplayUtil.align(this._timeUI,null,AlignType.TOP_CENTER);
         this._time = 60;
         this._timeID = setInterval(this.timeChange,1000);
         this.updateTime();
      }
      
      private function onEnd(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == MainManager.actorID)
         {
            AlertManager.showSimpleAlarm("恭喜小侠士撑过60秒，成功完成1次挑战。");
         }
         else
         {
            AlertManager.showSimpleAlarm("小侠士没撑过60秒，挑战失败。注意躲避落下的巨石。");
         }
         this.detroyTime();
         TimerComponents.instance.stop();
      }
      
      private function onTimeSyn(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         this._time = 60 - _loc4_;
         this.updateTime();
      }
      
      private function timeChange() : void
      {
         --this._time;
         this.updateTime();
         if(this._time == 0)
         {
            this.detroyTime();
         }
      }
      
      private function updateTime() : void
      {
         this._timeUI["time_txt"].text = this._time.toString();
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
         SocketConnection.removeCmdListener(CommandID.STAGE_TIME_SYN,this.onTimeSyn);
         this.detroyTime();
         DisplayUtil.removeForParent(this._timeUI);
         this._timeUI = null;
      }
   }
}

