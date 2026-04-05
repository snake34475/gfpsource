package com.gfp.app.storyProcess.localSO
{
   import com.gfp.app.storyProcess.StoryProcess_1;
   import com.gfp.core.CommandID;
   import com.gfp.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class StorySO_1 extends BaseBean
   {
      
      public function StorySO_1()
      {
         super();
      }
      
      override public function start() : void
      {
         var _loc1_:Object = StoryProcess_1.instance.getLocalSO();
         if(_loc1_)
         {
            StoryProcess_1.instance.step = uint(_loc1_["step"]);
         }
         SocketConnection.addCmdListener(CommandID.DAILY_USE_TIME,this.onDailyCount);
         SocketConnection.send(CommandID.DAILY_USE_TIME,230);
         SocketConnection.send(CommandID.DAILY_USE_TIME,231);
         SocketConnection.send(CommandID.DAILY_USE_TIME,232);
         finish();
      }
      
      private function onDailyCount(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         StoryProcess_1.instance.add(_loc3_,_loc4_);
      }
   }
}

