package com.gfp.app.cmdl
{
   import com.gfp.core.CommandID;
   import com.gfp.core.info.VipInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.net.SocketConnection;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class VipCmdListener extends BaseBean
   {
      
      public static const BE_VIP:String = "beVip";
      
      public static const FIRST_VIP:String = "firstVip";
      
      public function VipCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.VIP_INFO,this.onChange);
         finish();
      }
      
      private function onChange(param1:SocketEvent) : void
      {
         var _loc2_:VipInfo = param1.data as VipInfo;
         if(param1.headInfo.userID == MainManager.actorID)
         {
            VipInfo.updateForUserInfo(MainManager.actorInfo,_loc2_);
            MainManager.actorModel.upDateNickText();
         }
      }
   }
}

