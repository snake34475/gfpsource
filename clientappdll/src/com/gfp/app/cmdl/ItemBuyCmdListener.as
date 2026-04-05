package com.gfp.app.cmdl
{
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.info.EquipBuyInfo;
   import com.gfp.core.info.ItemBuyInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class ItemBuyCmdListener extends BaseBean
   {
      
      public function ItemBuyCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.BAG_BUYITEM,this.onBuyItem);
         SocketConnection.addCmdListener(CommandID.BAG_BUYEQUIP,this.onBuyEquip);
         SocketConnection.addCmdListener(CommandID.DELETE_ITEMS,this.onDeleteItems);
         finish();
      }
      
      private function onBuyItem(param1:SocketEvent) : void
      {
         var _loc2_:ItemBuyInfo = param1.data as ItemBuyInfo;
         MainManager.actorInfo.coins = _loc2_.restCoin;
         ItemManager.addItem(_loc2_.itemID,_loc2_.count);
         var _loc3_:String = _loc2_.count.toString() + AppLanguageDefine.SPECIAL_CHARACTER[0] + "<font color=\'#ff0000\'>" + ItemXMLInfo.getName(_loc2_.itemID) + "</font>" + AppLanguageDefine.HAS_ADDTOBAG;
         AlertManager.showSimpleItemAlarm(_loc3_,ClientConfig.getItemIcon(_loc2_.itemID));
      }
      
      private function onBuyEquip(param1:SocketEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         var _loc2_:EquipBuyInfo = param1.data as EquipBuyInfo;
         if(_loc2_.type == 0)
         {
            MainManager.actorInfo.coins = _loc2_.restCoin;
         }
         ItemManager.addEquips(_loc2_.list);
         var _loc3_:int = int(_loc2_.list.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = uint(SingleEquipInfo(_loc2_.list[_loc4_]).itemID);
            _loc6_ = "<font color=\'#ff0000\'>" + ItemXMLInfo.getName(_loc5_) + "</font>" + AppLanguageDefine.HAS_ADDTOBAG;
            AlertManager.showSimpleItemAlarm(_loc6_,ClientConfig.getItemIcon(_loc5_));
            _loc4_++;
         }
      }
      
      private function onDeleteItems(param1:SocketEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.readUnsignedInt();
            _loc6_ = _loc2_.readUnsignedInt();
            ItemManager.removeItem(_loc5_,_loc6_);
            _loc4_++;
         }
      }
   }
}

