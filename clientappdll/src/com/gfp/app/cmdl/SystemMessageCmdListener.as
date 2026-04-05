package com.gfp.app.cmdl
{
   import com.gfp.core.CommandID;
   import com.gfp.core.info.SysMsgInfo;
   import com.gfp.core.manager.SystemMessageManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.TimeUtil;
   import com.gfp.core.utils.TimerManager;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class SystemMessageCmdListener
   {
      
      public function SystemMessageCmdListener()
      {
         super();
      }
      
      public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.SYSTEM_MESSAGE,this.onGetComplexMessage);
         SocketConnection.addCmdListener(CommandID.LINK_HOLD,this.onLinkHold);
      }
      
      private function onGetComplexMessage(param1:SocketEvent) : void
      {
         SystemMessageManager.addInfo(param1.data as SysMsgInfo);
      }
      
      private function onLinkHold(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         TimeUtil.synTime(_loc3_,_loc4_);
         TimerManager.synTime(_loc3_);
         if(TimeUtil.getSeverMonth() >= 10 && TimeUtil.getSeverDayIndex() > 19)
         {
         }
      }
   }
}

