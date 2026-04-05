package com.gfp.app.cmdl
{
   import com.gfp.core.CommandID;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class InfoUserSpeedCmdListener extends BaseBean
   {
      
      public function InfoUserSpeedCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.INFORM_USER_SPEED,this.onSpeedChange);
         finish();
      }
      
      private function onSpeedChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:UserModel = UserManager.getModel(_loc3_);
         var _loc6_:uint = uint(MapManager.mapInfo.mapType);
         if(_loc5_)
         {
            _loc5_.speed = _loc4_;
         }
      }
   }
}

