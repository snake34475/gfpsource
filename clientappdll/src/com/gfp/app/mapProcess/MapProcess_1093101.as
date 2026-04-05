package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.Constant;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.fight.BruiseInfo;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1093101 extends BaseMapProcess
   {
      
      public function MapProcess_1093101()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addItemListener();
      }
      
      private function addItemListener() : void
      {
         UserManager.addEventListener(UserEvent.BORN,this.onUserBorn);
         SocketConnection.addCmdListener(CommandID.ACTION_BRUISE,this.onEvent);
      }
      
      private function onUserBorn(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType > Constant.MAX_ROLE_TYPE)
         {
            _loc2_.info.lv = 1;
            _loc2_.upDateNickText();
         }
         if(_loc2_.info.roleType == 13089 || _loc2_.info.roleType == 13090)
         {
            _loc2_.hideBloodBar();
         }
      }
      
      private function onEvent(param1:SocketEvent) : void
      {
         var _loc2_:BruiseInfo = param1.data as BruiseInfo;
         var _loc3_:UserModel = UserManager.getModel(_loc2_.userID);
         if(Boolean(_loc3_) && (_loc3_.info.roleType == 13089 || _loc3_.info.roleType == 13090))
         {
            _loc3_.hideBloodBar();
         }
      }
      
      override public function destroy() : void
      {
         UserManager.removeEventListener(UserEvent.BORN,this.onUserBorn);
         SocketConnection.removeCmdListener(CommandID.ACTION_BRUISE,this.onEvent);
      }
   }
}

