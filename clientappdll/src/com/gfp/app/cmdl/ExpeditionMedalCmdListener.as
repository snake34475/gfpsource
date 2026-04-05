package com.gfp.app.cmdl
{
   import com.gfp.core.CommandID;
   import com.gfp.core.manager.ExpeditionMedalManager;
   import com.gfp.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class ExpeditionMedalCmdListener extends BaseBean
   {
      
      public function ExpeditionMedalCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.EXPEDITION_INFO,this.onExpeditionInfo);
         SocketConnection.send(CommandID.EXPEDITION_INFO);
         finish();
      }
      
      private function onExpeditionInfo(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         ExpeditionMedalManager.expeditionPoint = _loc2_.readUnsignedInt();
         ExpeditionMedalManager.medalPoint = _loc2_.readUnsignedInt();
      }
   }
}

