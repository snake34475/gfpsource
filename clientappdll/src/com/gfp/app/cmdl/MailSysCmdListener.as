package com.gfp.app.cmdl
{
   import com.gfp.app.toolBar.MailSysEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.info.LoginMailInfo;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MailManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.ByteArrayUtil;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class MailSysCmdListener extends BaseBean
   {
      
      public function MailSysCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.MAIL_RECEIVE,this.onNewMail);
         SocketConnection.addCmdListener(CommandID.MAIL_SEND,this.onSendMail);
         finish();
      }
      
      private function onNewMail(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:ByteArray = ByteArrayUtil.clone(_loc2_);
         _loc3_.position = 0;
         var _loc4_:LoginMailInfo = new LoginMailInfo(_loc3_);
         MailManager.mailListInfo.mailList.push(_loc4_);
         MailSysEntry.instance.getUnreadCount();
      }
      
      private function onSendMail(param1:SocketEvent) : void
      {
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:ByteArray = ByteArrayUtil.clone(_loc2_);
         _loc3_.position = 0;
         var _loc4_:uint = _loc3_.readUnsignedInt();
         var _loc5_:uint = _loc3_.readUnsignedInt();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _loc3_.readUnsignedInt();
            _loc8_ = _loc3_.readUnsignedInt();
            _loc9_ = _loc3_.readUnsignedInt();
            ItemManager.removeItem(_loc8_,_loc9_);
            _loc6_++;
         }
      }
   }
}

