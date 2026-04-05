package com.gfp.app.cmdl
{
   import com.gfp.core.CommandID;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.Direction;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class SpecialCmdListener extends BaseBean
   {
      
      public function SpecialCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.ACTION_DANCE,this.onSpecial);
         finish();
      }
      
      private function onSpecial(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:String = Direction.indexToStr2(_loc2_.readUnsignedInt());
      }
   }
}

