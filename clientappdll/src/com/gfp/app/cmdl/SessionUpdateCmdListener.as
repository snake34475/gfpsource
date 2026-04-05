package com.gfp.app.cmdl
{
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.ServerSessionControl;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.WebURLUtil;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class SessionUpdateCmdListener extends BaseBean
   {
      
      private const TIME_INV:uint = 900000;
      
      public function SessionUpdateCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.SESSION_UPDATE,this.onSessionUpdate);
         this.getSession();
         setTimeout(this.getSession,this.TIME_INV);
         finish();
      }
      
      private function getSession() : void
      {
         SocketConnection.send(CommandID.SESSION_UPDATE,WebURLUtil.GF_GAMEID);
         SocketConnection.send(CommandID.SESSION_UPDATE,WebURLUtil.PAY_GAMEID);
      }
      
      private function onSessionUpdate(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:String = _loc2_.readUTFBytes(32);
         ServerSessionControl.addSessionID(_loc3_,_loc4_);
      }
   }
}

