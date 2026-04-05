package com.gfp.app.cmdl
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.BaseAction;
   import com.gfp.core.action.net.NetJumpAction;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.FightMode;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class JumpCmdListener extends BaseBean
   {
      
      private var _data:ByteArray;
      
      public function JumpCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.JUMP,this.onEvent);
         finish();
      }
      
      private function onEvent(param1:SocketEvent) : void
      {
         var _loc3_:Point = null;
         var _loc4_:BaseAction = null;
         var _loc2_:uint = uint(param1.headInfo.userID);
         if(_loc2_ != MainManager.actorID || FightManager.fightMode == FightMode.WATCH)
         {
            this._data = param1.data as ByteArray;
            this._data.position = 0;
            _loc3_ = new Point(this._data.readUnsignedInt(),this._data.readUnsignedInt());
            _loc4_ = new NetJumpAction(ActionXMLInfo.getInfo(11001),_loc3_);
            UserManager.execAction(_loc2_,_loc4_);
         }
      }
   }
}

