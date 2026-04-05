package com.gfp.app.toolBar
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.controller.ToolBarQuickKey;
   import com.gfp.core.info.LoginMailInfo;
   import com.gfp.core.manager.MailManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.popup.ModalType;
   import com.gfp.core.utils.RoleDisplayUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class MailSysEntry
   {
      
      private static var _instance:MailSysEntry;
      
      private var _mainUI:MovieClip;
      
      private var _unreadCount:int;
      
      public function MailSysEntry()
      {
         super();
         this._mainUI = UIManager.getGlobalUi("UI_SWF_BottomBar")["ToolBar_MailSysEntryNew"];
         this._mainUI.buttonMode = true;
         this.getUnreadCount();
         this.layout();
         StageResizeController.instance.register(this.layout);
      }
      
      public static function get instance() : MailSysEntry
      {
         if(_instance == null)
         {
            _instance = new MailSysEntry();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      private function layout() : void
      {
      }
      
      public function getUnreadCount() : void
      {
         var _loc4_:LoginMailInfo = null;
         this._unreadCount = 0;
         if(MailManager.mailListInfo == null)
         {
            return;
         }
         var _loc1_:Array = MailManager.mailListInfo.mailList;
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _loc1_[_loc3_] as LoginMailInfo;
            if(_loc4_.mailState == 2)
            {
               ++this._unreadCount;
            }
            _loc3_++;
         }
         if(this._unreadCount == 0)
         {
            this._mainUI["numMc"].visible = false;
         }
         else
         {
            this._mainUI["numMc"].visible = true;
            this._mainUI["numMc"]["numTxt"].text = this._unreadCount.toString();
         }
         if(this._unreadCount >= 1)
         {
         }
      }
      
      public function destroy() : void
      {
         this.hide();
         this._mainUI = null;
         StageResizeController.instance.unregister(this.layout);
      }
      
      public function show() : void
      {
         if(!RoleDisplayUtil.isRoleGraduate())
         {
            return;
         }
         if(this._mainUI)
         {
            ToolBarQuickKey.addTip(this._mainUI,2);
            ToolBarQuickKey.registQuickKey(2,this.onQuickKey);
            this._mainUI.addEventListener(MouseEvent.CLICK,this.onMail);
            this._mainUI.visible = true;
         }
      }
      
      public function hide() : void
      {
         if(this._mainUI)
         {
            ToolBarQuickKey.removeTip(this._mainUI);
            ToolBarQuickKey.unRegistQuickKey(2);
            this._mainUI.visible = false;
         }
      }
      
      private function onQuickKey() : void
      {
         this.onMail(new MouseEvent(MouseEvent.CLICK));
      }
      
      private function onMail(param1:MouseEvent) : void
      {
         ModuleManager.turnModule(ClientConfig.getAppModule("MailSysBox"),"正在加载邮件面板...",{"modalType":ModalType.DARK});
      }
   }
}

