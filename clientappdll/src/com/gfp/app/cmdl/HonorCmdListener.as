package com.gfp.app.cmdl
{
   import com.gfp.core.CommandID;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class HonorCmdListener extends BaseBean
   {
      
      public function HonorCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.USER_HONOR_UPDATE,this.onHonorUpdate);
         finish();
      }
      
      private function onHonorUpdate(param1:SocketEvent) : void
      {
         var _loc3_:ByteArray = null;
         var _loc2_:UserModel = UserManager.getModel(param1.headInfo.userID);
         if(Boolean(_loc2_) && _loc2_.info.userID != MainManager.actorID)
         {
            _loc3_ = param1.data as ByteArray;
            _loc2_.info.honor = _loc3_.readUnsignedInt();
         }
      }
   }
}

