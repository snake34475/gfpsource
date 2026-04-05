package com.gfp.app.cmdl
{
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.net.SocketConnection;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class BadPlusInCmdListener extends BaseBean
   {
      
      private var _intervalID:uint;
      
      public function BadPlusInCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.BAD_PLUG_IN,this.onBadPlusIn);
         finish();
      }
      
      private function onBadPlusIn(param1:SocketEvent) : void
      {
         AlertManager.showSimpleAlarm("系统检测到你有使用外挂或电脑时间被异常修改，请关闭外挂后重新登录！如有疑问请联系客服",this.onApply);
         this._intervalID = setInterval(this.onRefresh,3000);
      }
      
      private function onApply() : void
      {
         AlertManager.showSimpleAlarm("系统检测到你有使用外挂或电脑时间被异常修改，请关闭外挂后重新登录！如有疑问请联系客服",this.onApply);
      }
      
      private function onRefresh() : void
      {
         clearInterval(this._intervalID);
         navigateToURL(new URLRequest(ClientConfig.mainURL()),"_self");
      }
   }
}

