package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.events.UserItemEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.SummonModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.ByteArrayUtil;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1094101 extends BaseMapProcess
   {
      
      private var _ringModels:Array;
      
      private var useReviveNum:int;
      
      public function MapProcess_1094101()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addItemListener();
         this.initItemKeys();
         this._ringModels = [];
      }
      
      private function initItemKeys() : void
      {
         KeyManager.upDateItemQuickKeys(MainManager.actorInfo.items);
      }
      
      private function addItemListener() : void
      {
         UserManager.addEventListener(UserEvent.BORN,this.onUserBorn);
         UserManager.addEventListener(UserEvent.DIE,this.onUserDie);
         ItemManager.addListener(UserItemEvent.ITEM_DROP,this.onItemDrop);
         ItemManager.addListener(UserItemEvent.ITEM_ADD,this.onAddItem);
         SocketConnection.addCmdListener(CommandID.BAG_USEMEDICINE,this.onUserReviveCallBack);
      }
      
      private function removeListener() : void
      {
         UserManager.removeEventListener(UserEvent.BORN,this.onUserBorn);
         UserManager.removeEventListener(UserEvent.DIE,this.onUserDie);
         ItemManager.removeListener(UserItemEvent.ITEM_DROP,this.onItemDrop);
         ItemManager.removeListener(UserItemEvent.ITEM_ADD,this.onAddItem);
         SocketConnection.removeCmdListener(CommandID.BAG_USEMEDICINE,this.onUserReviveCallBack);
      }
      
      private function onUserBorn(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data;
         if(_loc2_.info.userID == MainManager.actorID)
         {
            _loc2_.showRing(ClientConfig.getBuff("summon_ring"));
            this._ringModels.push(_loc2_);
         }
         if(_loc2_ is SummonModel)
         {
            if(SummonModel(_loc2_).summonInfo.masterID == MainManager.actorID)
            {
               _loc2_.showRing(ClientConfig.getBuff("summon_ring"));
               this._ringModels.push(_loc2_);
            }
         }
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
         }
      }
      
      private function onItemDrop(param1:UserItemEvent) : void
      {
      }
      
      private function onAddItem(param1:UserItemEvent) : void
      {
         var _loc2_:Array = param1.param as Array;
         var _loc3_:uint = uint(_loc2_[0]);
         var _loc4_:uint = uint(_loc2_[1]);
         AlertManager.showSimpleItemAlarm("恭喜你获得了" + _loc4_ + "个" + ItemXMLInfo.getName(_loc3_),ClientConfig.getItemIcon(_loc3_));
      }
      
      private function onUserReviveCallBack(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = ByteArrayUtil.clone(param1.data as ByteArray);
         var _loc3_:uint = _loc2_.readUnsignedInt();
         if(ItemXMLInfo.isReviveGrass(_loc3_))
         {
            this.useReviveNum += 1;
         }
      }
      
      private function clearRing() : void
      {
         var _loc1_:UserModel = null;
         for each(_loc1_ in this._ringModels)
         {
            _loc1_.hideRing();
         }
         this._ringModels = [];
      }
      
      override public function destroy() : void
      {
         this.clearRing();
         this.removeListener();
         super.destroy();
      }
   }
}

