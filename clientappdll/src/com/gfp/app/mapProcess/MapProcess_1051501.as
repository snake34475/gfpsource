package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.events.UserItemEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.ByteArrayUtil;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1051501 extends BaseMapProcess
   {
      
      private var intervalID:int;
      
      public function MapProcess_1051501()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightManager.instance.addEventListener(FightEvent.REASON,this.onReasonHandler);
         this.addItemListener();
         this.intervalID = setTimeout(function():void
         {
            var _loc2_:* = undefined;
            clearTimeout(intervalID);
            MainManager.actorModel.fightSummonModel.showRing(ClientConfig.getBuff("summon_ring"));
            var _loc1_:* = SummonManager.getActorSummonInfo().summonHelpList;
            for each(_loc2_ in _loc1_)
            {
               UserManager.getModel(_loc2_.stageID).showRing(ClientConfig.getBuff("summon_ring"));
            }
         },1000);
      }
      
      private function onReasonHandler(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onReasonHandler);
         ModuleManager.getModule("FightRevivePanel","").destroy();
         ModuleManager.closeAllModule();
         MainManager.actorModel.removeEventListener(UserEvent.DIE,this.onUserDie);
      }
      
      private function addItemListener() : void
      {
         UserManager.addEventListener(UserEvent.BORN,this.onUserBorn);
         MainManager.actorModel.addEventListener(UserEvent.DIE,this.onUserDie);
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
      }
      
      private function onUserDie(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info == null)
         {
            return;
         }
         ModuleManager.turnModule(ClientConfig.getAppModule("FightRevivePanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[1],false);
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
         if(!ItemXMLInfo.isReviveGrass(_loc3_))
         {
         }
      }
      
      override public function destroy() : void
      {
         this.removeListener();
         super.destroy();
      }
   }
}

