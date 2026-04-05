package com.gfp.app.cmdl
{
   import com.gfp.app.manager.UserAddManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.SummonInfo;
   import com.gfp.core.info.UserSummonInfos;
   import com.gfp.core.manager.DeffEquiptManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.manager.DepthManager;
   import org.taomee.net.SocketEvent;
   
   public class UserListCmdListener extends BaseBean
   {
      
      public function UserListCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.MAP_PLAYERLIST,this.onUserList);
         SocketConnection.addCmdListener(CommandID.SUMMON_CHANGE,this.onUserSummonChange);
         SocketConnection.addCmdListener(CommandID.SOUL_CHANGE_STATE,this.onHeroChangeSelected);
         UserManager.addEventListener(UserEvent.ADD_TO_STAGE,this.onActorAdded);
         finish();
      }
      
      private function onActorAdded(param1:UserEvent) : void
      {
         DepthManager.bringToTop(MainManager.actorModel.iconContainer);
      }
      
      private function onUserList(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         UserAddManager.addUserListForCity(_loc2_);
      }
      
      private function onUserSummonChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:SummonInfo = new SummonInfo();
         _loc3_.readForSimple(_loc2_);
         var _loc4_:UserSummonInfos = SummonManager.getUserSummonInfo(param1.headInfo.userID);
         if(_loc4_)
         {
            _loc4_.updateMapUserSummon(_loc3_);
            if(!DeffEquiptManager.isHideAllPlayer)
            {
               SummonManager.updateSummonView(param1.headInfo.userID);
            }
         }
      }
      
      private function onHeroChangeSelected(param1:SocketEvent) : void
      {
         DepthManager.bringToTop(MainManager.actorModel.iconContainer);
      }
   }
}

