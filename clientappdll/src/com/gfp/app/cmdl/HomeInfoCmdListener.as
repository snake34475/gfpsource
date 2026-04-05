package com.gfp.app.cmdl
{
   import com.gfp.core.CommandID;
   import com.gfp.core.info.UserSummonInfos;
   import com.gfp.core.manager.HomeSummonManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class HomeInfoCmdListener extends BaseBean
   {
      
      public function HomeInfoCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.MAP_HOME_INFO,this.onHomeInfo);
         finish();
      }
      
      private function onHomeInfo(param1:SocketEvent) : void
      {
         var _loc4_:UserSummonInfos = null;
         var _loc5_:int = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         if(_loc3_ != MainManager.actorInfo.userID)
         {
            _loc4_ = new UserSummonInfos(_loc3_);
            _loc5_ = int(_loc2_.readUnsignedInt());
            _loc4_.readForHomeInfo(_loc2_);
            SummonManager.setupUserSummonInfo(_loc3_,_loc4_);
         }
         else
         {
            SummonManager.setupUserSummonInfo(_loc3_,SummonManager.getActorSummonInfo());
         }
         HomeSummonManager.instance.initMonster(_loc3_);
      }
   }
}

