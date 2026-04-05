package com.gfp.app.misc
{
   import com.gfp.core.CommandID;
   import com.gfp.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.net.SocketEvent;
   
   public class AwardInfoTool
   {
      
      public static const SMASHEGG:int = 1;
      
      public static const MONEYTREE:int = 2;
      
      public static const FIGHT_TOGETHER:int = 3;
      
      private var _time:int;
      
      private var _type:int;
      
      private var _callback:Function;
      
      public function AwardInfoTool(param1:Function, param2:int)
      {
         super();
         this._callback = param1;
         this._type = param2;
      }
      
      public function start() : void
      {
         clearInterval(this._time);
         this._time = setInterval(this.run,3000);
         this.run();
      }
      
      private function run() : void
      {
         this.requestTxtMsg();
      }
      
      private function requestTxtMsg() : void
      {
         SocketConnection.addCmdListener(CommandID.TEXT_BROADCAST_MSG,this.onTextMsg);
         SocketConnection.send(CommandID.TEXT_BROADCAST_MSG,this._type);
      }
      
      private function onTextMsg(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TEXT_BROADCAST_MSG,this.onTextMsg);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.readInt();
         var _loc3_:* = _loc2_.readInt();
         var _loc4_:Array = [];
         while(_loc3_-- > 0)
         {
            _loc4_.push(_loc2_.readUTFBytes(128));
         }
         this._callback(_loc4_);
      }
      
      public function stop() : void
      {
         this._callback = null;
         clearInterval(this._time);
         SocketConnection.removeCmdListener(CommandID.TEXT_BROADCAST_MSG,this.onTextMsg);
      }
   }
}

