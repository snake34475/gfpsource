package com.gfp.app.manager
{
   import com.gfp.core.CommandID;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class DirtyWordManager
   {
      
      public function DirtyWordManager()
      {
         super();
      }
      
      public static function start() : void
      {
         SocketConnection.addCmdListener(CommandID.DIRTY_WORD,onDirtyWordReceive);
      }
      
      private static function onDirtyWordReceive(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:String = _loc2_.readUTFBytes(_loc3_);
         TextAlert.show("小侠士，\"" + _loc4_ + "\" 为敏感词语！请勿使用！");
      }
   }
}

