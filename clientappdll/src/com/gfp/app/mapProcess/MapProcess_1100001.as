package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1100001 extends BaseMapProcess
   {
      
      public function MapProcess_1100001()
      {
         super();
      }
      
      override protected function init() : void
      {
         SocketConnection.addCmdListener(CommandID.STAGE_USER_LIST,this.onUserListHandler);
         super.init();
      }
      
      private function onUserListHandler(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.STAGE_USER_LIST,this.onUserListHandler);
      }
      
      override public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.STAGE_USER_LIST,this.onUserListHandler);
         super.destroy();
      }
   }
}

