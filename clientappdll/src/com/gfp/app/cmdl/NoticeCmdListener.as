package com.gfp.app.cmdl
{
   import com.gfp.app.info.SystemNoticeInfo;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SysNoticeManager;
   import com.gfp.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class NoticeCmdListener extends BaseBean
   {
      
      public function NoticeCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.NOTICE_SYSTEM,this.onSystemNotice);
         SocketConnection.addCmdListener(CommandID.ZHAN_QU_ZHENG_BA_PVP_NOTIFY,this.onZhanquNotify);
         finish();
      }
      
      private function onSystemNotice(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:SystemNoticeInfo = new SystemNoticeInfo(_loc2_);
         SysNoticeManager.waiteNoticeArr.push(_loc3_);
         ModuleManager.turnModule(ClientConfig.getAppModule("SystemNoticePanel"),"...",_loc3_);
      }
      
      private function onZhanquNotify(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:String = _loc2_.readUTFBytes(16);
         var _loc6_:int = int(_loc2_.readUnsignedInt());
         var _loc7_:int = int(_loc2_.readUnsignedInt());
         var _loc8_:SystemNoticeInfo = new SystemNoticeInfo();
         _loc8_.userID = _loc3_;
         _loc8_.createTime = _loc4_;
         _loc8_.type = 2;
         _loc8_.content = this.getLandName(_loc6_) + "的" + _loc5_ + "连杀超过" + _loc7_ + "个，谁能挡我？<font color=\'#FF0000\'><u><a href=\'event:pvp|72|" + _loc3_ + "|" + _loc4_ + "\'>我要挑战</a></u></font>";
         SysNoticeManager.waiteNoticeArr.push(_loc8_);
         ModuleManager.turnModule(ClientConfig.getAppModule("SystemNoticePanel"),"...",_loc8_);
      }
      
      private function getLandName(param1:int) : String
      {
         var _loc2_:Array = null;
         if(param1 > 0)
         {
            _loc2_ = ["东部大陆","西部大陆","南部大陆","北部大陆","中部大陆"];
            return _loc2_[param1 - 1];
         }
         return "";
      }
   }
}

