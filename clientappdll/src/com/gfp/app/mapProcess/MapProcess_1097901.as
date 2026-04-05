package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.ByteArrayUtil;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1097901 extends BaseMapProcess
   {
      
      private const INTERVAL:uint = 10;
      
      private var _timeID:uint;
      
      private var useReviveNum:int;
      
      public function MapProcess_1097901()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addItemListener();
         this.initItemKeys();
      }
      
      private function initItemKeys() : void
      {
         KeyManager.upDateItemQuickKeys(MainManager.actorInfo.items);
      }
      
      private function addItemListener() : void
      {
         UserManager.addEventListener(UserEvent.DIE,this.onUserDie);
         SocketConnection.addCmdListener(CommandID.BAG_USEMEDICINE,this.onUserReviveCallBack);
      }
      
      private function onUserDie(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info == null)
         {
            return;
         }
         if(_loc2_.info.userID == MainManager.actorInfo.userID && this.useReviveNum < 3)
         {
            ModuleManager.turnModule(ClientConfig.getAppModule("FightRevivePanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[1],false);
            this.timeStart();
         }
      }
      
      private function timeStart() : void
      {
         this._timeID = setTimeout(this.timeOut,this.INTERVAL * 1000);
      }
      
      private function timeOut() : void
      {
         ModuleManager.destroy(ClientConfig.getAppModule("FightRevivePanel"));
         this.clearTime();
      }
      
      private function clearTime() : void
      {
         if(this._timeID != 0)
         {
            clearTimeout(this._timeID);
            this._timeID = 0;
         }
      }
      
      private function onUserReviveCallBack(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = ByteArrayUtil.clone(param1.data as ByteArray);
         var _loc3_:uint = _loc2_.readUnsignedInt();
         if(ItemXMLInfo.isReviveGrass(_loc3_))
         {
            this.useReviveNum += 1;
            this.clearTime();
         }
      }
      
      private function removeListener() : void
      {
         UserManager.removeEventListener(UserEvent.DIE,this.onUserDie);
         SocketConnection.removeCmdListener(CommandID.BAG_USEMEDICINE,this.onUserReviveCallBack);
      }
      
      override public function destroy() : void
      {
         this.removeListener();
         super.destroy();
      }
   }
}

