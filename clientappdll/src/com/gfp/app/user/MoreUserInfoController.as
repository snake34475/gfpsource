package com.gfp.app.user
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import flash.display.DisplayObjectContainer;
   
   public class MoreUserInfoController
   {
      
      private static var _myTempPanel:TempUserInfoPanel;
      
      private static var status:Boolean = false;
      
      public function MoreUserInfoController()
      {
         super();
      }
      
      public static function get myTempPanel() : TempUserInfoPanel
      {
         if(!_myTempPanel)
         {
            _myTempPanel = new TempUserInfoPanel();
         }
         return _myTempPanel;
      }
      
      public static function show(param1:UserInfo, param2:DisplayObjectContainer = null, param3:Boolean = false) : void
      {
         if(param2 == null)
         {
            param2 = LayerManager.uiLevel;
         }
         if(param1.userID == MainManager.actorInfo.userID && !status)
         {
            ModuleManager.turnModule(ClientConfig.getAppModule("UserInfoPanel"),"",{
               "info":param1,
               "isConceal":param3
            });
         }
      }
      
      public static function set setStatus(param1:Boolean) : void
      {
         status = param1;
      }
      
      public static function get getStatus() : Boolean
      {
         return status;
      }
   }
}

