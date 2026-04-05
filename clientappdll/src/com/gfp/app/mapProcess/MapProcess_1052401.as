package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.net.SocketConnection;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1052401 extends BaseMapProcess
   {
      
      public function MapProcess_1052401()
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
         var _loc4_:uint = uint(MapManager.mapInfo.id);
         var _loc5_:TextField = MapManager.currentMap.contentLevel["coinTxt"];
         _loc5_.text = _loc3_.toString() + "功夫豆";
      }
      
      override public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.PVP_BOTTOM_POUR,this.onBottomPour);
      }
   }
}

