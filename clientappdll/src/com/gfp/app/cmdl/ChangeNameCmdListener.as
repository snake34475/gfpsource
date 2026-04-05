package com.gfp.app.cmdl
{
   import com.gfp.core.CommandID;
   import com.gfp.core.behavior.NicknameBehavior;
   import com.gfp.core.info.NicknameChangeInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.net.SocketConnection;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class ChangeNameCmdListener extends BaseBean
   {
      
      public function ChangeNameCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.CHANGE_NICK,this.onNameChanged);
         finish();
      }
      
      private function onNameChanged(param1:SocketEvent) : void
      {
         var _loc2_:NicknameChangeInfo = param1.data as NicknameChangeInfo;
         if(_loc2_.userId == MainManager.actorID)
         {
         }
         UserManager.execBehavior(_loc2_.userId,new NicknameBehavior(_loc2_.nickName,false),true);
      }
   }
}

