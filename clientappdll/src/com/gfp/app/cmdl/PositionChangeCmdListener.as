package com.gfp.app.cmdl
{
   import com.gfp.core.CommandID;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.Direction;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class PositionChangeCmdListener extends BaseBean
   {
      
      public function PositionChangeCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.POSITION_CHANGE,this.onPosChange);
         finish();
      }
      
      private function onPosChange(param1:SocketEvent) : void
      {
         var _loc8_:Point = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         var _loc7_:UserModel = UserManager.getModel(_loc3_);
         if(_loc7_)
         {
            _loc8_ = new Point(_loc4_,_loc5_);
            if(_loc3_ == MainManager.actorInfo.userID)
            {
               MainManager.actorInfo.lastWalkPoint = _loc8_;
            }
            if(_loc7_.info == null)
            {
               return;
            }
            _loc7_.pos = MapManager.getEndPosForPos(_loc7_.pos,_loc8_);
            _loc7_.direction = Direction.indexToStr2(_loc6_);
            _loc7_.execStandAction(false);
         }
      }
   }
}

