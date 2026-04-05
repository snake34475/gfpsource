package com.gfp.app.cmdl
{
   import com.gfp.app.manager.UserAddManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class LeaveMapCmdListener extends BaseBean
   {
      
      public function LeaveMapCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.MAP_LEAVE,this.onEvent);
         finish();
      }
      
      private function onEvent(param1:SocketEvent) : void
      {
         var _loc3_:UserModel = null;
         var _loc2_:uint = uint(param1.headInfo.userID);
         if(_loc2_ != MainManager.actorID)
         {
            _loc3_ = UserManager.remove(_loc2_);
            if(_loc3_)
            {
               UserManager.addDispatcher(new UserEvent(UserEvent.LEAVE,_loc3_));
               UserManager.dispatchEvent(new UserEvent(UserEvent.LEAVE,_loc3_));
               _loc3_.destroy();
               _loc3_ = null;
            }
            else if(MapManager.currentMap)
            {
               if(MapManager.isFightMap)
               {
                  UserAddManager.removeUserID(_loc2_);
               }
               else
               {
                  UserAddManager.removeUserID(_loc2_);
               }
            }
         }
         MapManager.dispatchEvent(new MapEvent(MapEvent.USER_LEAVE_MAP,MapManager.currentMap));
      }
   }
}

