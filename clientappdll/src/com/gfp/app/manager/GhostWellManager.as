package com.gfp.app.manager
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.TollgateXMLInfo;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class GhostWellManager
   {
      
      private static var _instance:GhostWellManager;
      
      public function GhostWellManager()
      {
         super();
      }
      
      public static function get instance() : GhostWellManager
      {
         if(!_instance)
         {
            _instance = new GhostWellManager();
         }
         return _instance;
      }
      
      public function enterGhostWell() : void
      {
         SocketConnection.addCmdListener(CommandID.MINI_ROOM_HAS_USER,this.requestMiniRoomUserCheckBackHandler);
         SocketConnection.send(CommandID.MINI_ROOM_HAS_USER);
      }
      
      private function requestMiniRoomUserCheckBackHandler(param1:SocketEvent) : void
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         SocketConnection.removeCmdListener(CommandID.MINI_ROOM_HAS_USER,this.requestMiniRoomUserCheckBackHandler);
         var _loc2_:uint = ByteArray(param1.data).readUnsignedInt();
         if(_loc2_ >= 1)
         {
            _loc3_ = [708,709,710];
            _loc4_ = uint(_loc3_[Math.floor(Math.random() * 3)]);
            PveEntry.enterTollgate(_loc4_,TollgateXMLInfo.getMinDifficultStep(_loc4_) + 1);
         }
         else
         {
            AlertManager.showSimpleAlarm("亲爱的小侠士，你的家园中必须有一名侠士指引你在神魔井的战斗，快去找一位好友前来相助吧。");
         }
      }
      
      public function reset() : void
      {
         SocketConnection.removeCmdListener(CommandID.MINI_ROOM_HAS_USER,this.requestMiniRoomUserCheckBackHandler);
      }
   }
}

