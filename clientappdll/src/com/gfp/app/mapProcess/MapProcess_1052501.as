package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.net.SocketConnection;
   import flash.display.DisplayObjectContainer;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1052501 extends BaseMapProcess
   {
      
      public function MapProcess_1052501()
      {
         super();
      }
      
      override protected function init() : void
      {
         SocketConnection.addCmdListener(CommandID.PVP_BOTTOM_POUR,this.onBottomPour);
      }
      
      private function onBottomPour(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:DisplayObjectContainer = MapManager.currentMap.contentLevel;
         if(_loc4_["coinTxt"])
         {
            _loc4_["coinTxt"].text = _loc3_ + "功夫豆";
         }
      }
      
      override public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.PVP_BOTTOM_POUR,this.onBottomPour);
      }
   }
}

