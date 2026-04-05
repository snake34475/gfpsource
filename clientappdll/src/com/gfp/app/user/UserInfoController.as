package com.gfp.app.user
{
   import com.gfp.app.manager.CityWarManager;
   import com.gfp.app.toolBar.RoleHeadEntry;
   import com.gfp.app.toolBar.RoleItemMenu;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import org.taomee.bean.BaseBean;
   
   public class UserInfoController extends BaseBean
   {
      
      private static var _userId:uint;
      
      private static var _pumpkin:Object = {};
      
      private static const PUMPKIN_ID:int = 10208;
      
      private static const PUMPKIN_TIME:int = 3 * 60 * 1000;
      
      public function UserInfoController()
      {
         super();
      }
      
      public static function setUserId(param1:int) : void
      {
         _userId = param1;
      }
      
      public static function showForInfo(param1:UserInfo, param2:Boolean = false, param3:Boolean = false) : void
      {
         _userId = param1.userID;
         ModuleManager.showModule(ClientConfig.getAppModule("UserInfoPanel"),"",{
            "info":param1,
            "isConceal":param2
         });
      }
      
      public static function initPvPState(param1:int) : void
      {
         UserManager.dispatchUser(UserEvent.PVP_CHANGE,_userId,param1);
      }
      
      public static function initGloryFightTeamPvp(param1:int, param2:uint) : void
      {
         UserManager.dispatchUser(UserEvent.PVP_CHANGE,param2,param1);
      }
      
      public static function initCityWarPvp(param1:int, param2:uint) : void
      {
         UserManager.dispatchUser(UserEvent.PVP_CHANGE,param2,param1);
      }
      
      public static function hasBeenInvitePK(param1:Boolean) : void
      {
         UserManager.dispatchUser(UserEvent.PVP_CHANGE,_userId,0);
      }
      
      public static function showForID(param1:uint, param2:Boolean = false, param3:uint = 0, param4:Boolean = false) : void
      {
         _userId = param1;
         ModuleManager.showModule(ClientConfig.getAppModule("UserInfoPanel"),"",{
            "info":param1,
            "isConceal":param2,
            "regTime":param3
         });
      }
      
      public static function showUserInfoByOnlyId(param1:uint, param2:uint = 0, param3:Boolean = false) : void
      {
         _userId = param1;
         ModuleManager.showModule(ClientConfig.getAppModule("UserInfoPanel"),"",{
            "info":param1,
            "isConceal":param3,
            "regTime":param2,
            "only":true
         });
      }
      
      override public function start() : void
      {
         UserManager.addEventListener(UserEvent.CLICK,this.onClick);
         UserManager.addEventListener(UserEvent.USER_CHAT_CLICK,this.onChatClick);
         finish();
      }
      
      private function onChatClick(param1:UserEvent) : void
      {
         var _loc2_:* = param1.data;
         if(MapManager.currentMap.info.mapType == MapType.PVE || MapManager.currentMap.info.mapType == MapType.PVP)
         {
            return;
         }
         RoleItemMenu.instance.show(_loc2_,RoleItemMenu.TYPE_ROLE,LayerManager.topLevel,LayerManager.stage.mouseX,LayerManager.stage.mouseY);
         RoleItemMenu.instance.reSizeForStage();
         if(_loc2_ is UserInfo)
         {
            _userId = _loc2_.userID;
         }
      }
      
      private function onClick(param1:UserEvent) : void
      {
         var _loc2_:* = param1.data;
         if(MapManager.currentMap.info.mapType == MapType.PVE || MapManager.currentMap.info.mapType == MapType.PVP || MapManager.currentMap.info.mapType == MapType.WATCH || CityWarManager.isInCityWar())
         {
            return;
         }
         RoleHeadEntry.instance.show(_loc2_);
         if(_loc2_ is UserInfo)
         {
            _userId = _loc2_.userID;
         }
      }
   }
}

