package com.gfp.app.cmdl
{
   import com.gfp.core.CommandID;
   import com.gfp.core.action.ActionInfo;
   import com.gfp.core.action.constants.SubType;
   import com.gfp.core.action.normal.PosMoveAction;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class MouseMoveCmdListener extends BaseBean
   {
      
      public function MouseMoveCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.MOUSE_MOVE,this.onMove);
         finish();
      }
      
      private function onMove(param1:SocketEvent) : void
      {
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:Point = null;
         var _loc6_:uint = 0;
         var _loc7_:UserModel = null;
         var _loc8_:uint = 0;
         var _loc9_:ActionInfo = null;
         var _loc2_:uint = uint(param1.headInfo.userID);
         if(_loc2_ != MainManager.actorID)
         {
            _loc3_ = param1.data as ByteArray;
            _loc3_.position = 0;
            _loc4_ = _loc3_.readUnsignedInt();
            _loc5_ = new Point(_loc3_.readUnsignedInt(),_loc3_.readUnsignedInt());
            _loc6_ = _loc3_.readUnsignedInt();
            _loc7_ = UserManager.getModel(_loc2_);
            if(_loc7_ != null)
            {
               if(_loc6_ == SubType.RUN)
               {
                  _loc9_ = ActionXMLInfo.getInfo(9002);
                  UserManager.execAction(_loc2_,new PosMoveAction(_loc9_,_loc5_,false));
               }
               else
               {
                  _loc9_ = ActionXMLInfo.getInfo(9001);
                  UserManager.execAction(_loc2_,new PosMoveAction(_loc9_,_loc5_,false));
               }
            }
         }
      }
   }
}

