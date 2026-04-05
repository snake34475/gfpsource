package com.gfp.app.manager
{
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.popup.ModalType;
   import com.gfp.core.utils.TimeUtil;
   import flash.events.NetStatusEvent;
   import flash.net.SharedObject;
   import flash.net.SharedObjectFlushStatus;
   import flash.system.Security;
   import flash.system.SecurityPanel;
   import flash.utils.setTimeout;
   
   public class ShareObjectManager
   {
      
      private static var _instance:ShareObjectManager;
      
      public static const MAX_LOCAL_STORAGE_SIZE:uint = 1024 * 1024 * 1024;
      
      private var localSo:SharedObject;
      
      public function ShareObjectManager()
      {
         super();
         this.localSo = SharedObject.getLocal("local_storage");
         this.localSo.data.userName = "taomee_gfp";
      }
      
      public static function get instance() : ShareObjectManager
      {
         if(!_instance)
         {
            _instance = new ShareObjectManager();
         }
         return _instance;
      }
      
      public function showTipPanel() : void
      {
         var lastTime:Number = NaN;
         var timer:int = 0;
         if(this.localSo.data.isSet != "1")
         {
            lastTime = Number(this.localSo.data.lastTime);
            if(TimeUtil.getSeverDateObject().time - lastTime <= 7 * TimeUtil.ONE_HOUR_SECONDS * 24 * 1000)
            {
               return;
            }
            timer = int(setTimeout(function():void
            {
               ModuleManager.turnAppModule("LocalStoragePanel","正在加载...",{"modalType":ModalType.DARK});
            },2000));
         }
         else
         {
            this.checkLocalStorageSize();
         }
      }
      
      public function checkLocalStorageSize() : void
      {
         var flushResult:String = null;
         try
         {
            flushResult = this.localSo.flush(MAX_LOCAL_STORAGE_SIZE);
            if(flushResult == SharedObjectFlushStatus.PENDING)
            {
               this.localSo.addEventListener(NetStatusEvent.NET_STATUS,this.onStatus);
            }
            else if(flushResult == SharedObjectFlushStatus.FLUSHED)
            {
               this.localSo.data.isSet = "1";
            }
         }
         catch(e:Error)
         {
            Security.showSettings(SecurityPanel.LOCAL_STORAGE);
         }
      }
      
      private function onStatus(param1:NetStatusEvent) : void
      {
         switch(param1.info.code)
         {
            case "SharedObject.Flush.Success":
               this.localSo.data.isSet = "1";
               this.localSo.flush();
               break;
            case "SharedObject.Flush.Failed":
               this.localSo.data.lastTime = String(TimeUtil.getSeverDateObject().time);
         }
         this.localSo.removeEventListener(NetStatusEvent.NET_STATUS,this.onStatus);
      }
   }
}

