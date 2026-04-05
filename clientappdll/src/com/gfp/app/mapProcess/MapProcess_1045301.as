package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.info.dailyActivity.SwapTimesInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.ByteArrayUtil;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1045301 extends BaseMapProcess
   {
      
      private var _prevValue:int;
      
      public function MapProcess_1045301()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._prevValue = ActivityExchangeTimesManager.getTimes(4066);
         SocketConnection.addCmdListener(CommandID.STAGE_QUIT,this.onQuit);
      }
      
      private function onQuit(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = ByteArrayUtil.clone(param1.data as ByteArray);
         var _loc3_:uint = _loc2_.readUnsignedByte();
         var _loc4_:uint = uint(_loc2_.readInt());
         if(_loc4_ == 0)
         {
            ActivityExchangeTimesManager.addEventListener(4066,this.responseTollageProgress);
            ActivityExchangeTimesManager.getActiviteTimeInfo(4066);
         }
      }
      
      private function responseTollageProgress(param1:DataEvent) : void
      {
         var _loc2_:SwapTimesInfo = param1.data as SwapTimesInfo;
         var _loc3_:int = int(_loc2_.times);
         if(_loc3_ - this._prevValue > 0)
         {
            AlertManager.showSimpleAlarm("恭喜你，信赖度+" + (_loc3_ - this._prevValue));
         }
         ActivityExchangeTimesManager.removeEventListener(4066,this.responseTollageProgress);
      }
      
      override public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.STAGE_QUIT,this.onQuit);
         super.destroy();
      }
   }
}

