package com.gfp.app.cmdl
{
   import com.gfp.app.toolBar.FightToolBar;
   import com.gfp.core.CommandID;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.TimeUtil;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class DelayTestCmdListener extends BaseBean
   {
      
      public function DelayTestCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.FIGHT_DELAY_TEST_IN,this.onIn);
         SocketConnection.addCmdListener(CommandID.FIGHT_DELAY_TEST_OUT,this.onOut);
         finish();
      }
      
      private function onIn(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         SocketConnection.send(CommandID.FIGHT_DELAY_TEST_OUT,_loc2_.readUnsignedInt());
      }
      
      private function onOut(param1:SocketEvent) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedShort();
         if(_loc2_.bytesAvailable >= 16)
         {
            _loc2_.readUnsignedInt();
            _loc4_ = _loc2_.readUnsignedInt();
            _loc5_ = _loc2_.readUnsignedInt();
            _loc6_ = _loc2_.readUnsignedInt();
            TimeUtil.synTime(_loc4_,_loc6_);
         }
         Logger.debug(this,"网络延时：" + _loc3_);
         MainManager.netDely = _loc3_;
         FightToolBar.setNetDelay(_loc3_);
      }
   }
}

