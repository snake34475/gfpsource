package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.Constant;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.fight.BruiseInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.geom.Rectangle;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1093901 extends BaseMapProcess
   {
      
      private var _oldCameraRect:Rectangle;
      
      private var _time1:uint;
      
      private var _time2:uint;
      
      public function MapProcess_1093901()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.initItemKeys();
         this.addItemListener();
         MainManager.closeOperate();
         this._time1 = setTimeout(function():void
         {
            clearTimeout(_time1);
            setCameraView();
            MainManager.actorModel.execStandAction();
            MainManager.closeOperate();
            _time2 = setTimeout(function():void
            {
               clearTimeout(_time2);
               resetCameraView();
               MainManager.openOperate();
            },2000);
         },3000);
      }
      
      private function initItemKeys() : void
      {
         KeyManager.upDateItemQuickKeys(MainManager.actorInfo.items);
      }
      
      private function addItemListener() : void
      {
         UserManager.addEventListener(UserEvent.BORN,this.onUserBorn);
         UserManager.addEventListener(UserEvent.DIE,this.onUserDie);
         SocketConnection.addCmdListener(CommandID.ACTION_BRUISE,this.onEvent);
      }
      
      private function removeListener() : void
      {
         UserManager.removeEventListener(UserEvent.BORN,this.onUserBorn);
         UserManager.removeEventListener(UserEvent.DIE,this.onUserDie);
         SocketConnection.removeCmdListener(CommandID.ACTION_BRUISE,this.onEvent);
      }
      
      private function onUserBorn(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info == null)
         {
            return;
         }
         if(_loc2_.info.roleType > Constant.MAX_ROLE_TYPE)
         {
            _loc2_.info.lv = 1;
            _loc2_.upDateNickText();
         }
         if(_loc2_.info.roleType == 13095 || _loc2_.info.roleType == 13096)
         {
            _loc2_.hideBloodBar();
         }
      }
      
      private function setCameraView() : void
      {
         this._oldCameraRect = MapManager.currentMap.camera.viewArea.clone();
         if(MainManager.actorModel.x < 200)
         {
            MapManager.currentMap.camera.scroll(500,0);
            TextAlert.show("消灭蓝方获胜！");
         }
         else
         {
            MapManager.currentMap.camera.scroll(0,0);
            TextAlert.show("消灭红方获胜！");
         }
      }
      
      private function resetCameraView() : void
      {
         MapManager.currentMap.camera.scroll(this._oldCameraRect.x,this._oldCameraRect.y);
         MainManager.actorModel.execStandAction();
      }
      
      private function onUserDie(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info == null)
         {
            return;
         }
         if(_loc2_.info.userID == MainManager.actorInfo.userID)
         {
            ModuleManager.turnModule(ClientConfig.getAppModule("FightRevivePanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[1]);
         }
      }
      
      private function onEvent(param1:SocketEvent) : void
      {
         var _loc2_:BruiseInfo = param1.data as BruiseInfo;
         var _loc3_:UserModel = UserManager.getModel(_loc2_.userID);
         if(Boolean(_loc3_) && (_loc3_.info.roleType == 13095 || _loc3_.info.roleType == 13096))
         {
            _loc3_.hideBloodBar();
         }
      }
      
      override public function destroy() : void
      {
         this.removeListener();
         clearTimeout(this._time1);
         clearTimeout(this._time2);
         super.destroy();
      }
   }
}

