package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.ByteArrayUtil;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1042001 extends BaseMapProcess
   {
      
      public function MapProcess_1042001()
      {
         super();
      }
      
      override protected function init() : void
      {
         SocketConnection.addCmdListener(CommandID.STAGE_QUIT,this.onQuit);
      }
      
      private function onQuit(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = ByteArrayUtil.clone(param1.data as ByteArray);
         var _loc3_:uint = _loc2_.readUnsignedByte();
         var _loc4_:uint = uint(_loc2_.readInt());
         if(_loc4_ == 0)
         {
            AlertManager.showSimpleAlarm("恭喜你，友好度+3");
         }
         else
         {
            AlertManager.showSimpleAlarm("很遗憾，你输了，友好度+1");
         }
      }
      
      override public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.STAGE_QUIT,this.onQuit);
         super.destroy();
      }
   }
}

