package com.gfp.app.cmdl
{
   import com.gfp.core.CommandID;
   import com.gfp.core.info.TradeItemInfo;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.TradeManager;
   import com.gfp.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class TradeCmdListener extends BaseBean
   {
      
      public function TradeCmdListener()
      {
         super();
         SocketConnection.addCmdListener(CommandID.STORE_ITEM_SALE,this.onItemSaled);
         SocketConnection.addCmdListener(CommandID.STORE_CLOSE,this.closeMyShop);
         finish();
      }
      
      private function onItemSaled(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         var _loc7_:uint = _loc2_.readUnsignedInt();
         var _loc8_:uint = _loc2_.readUnsignedInt();
         var _loc9_:uint = _loc2_.readUnsignedInt();
         var _loc10_:uint = _loc2_.readUnsignedInt();
         ItemManager.addItem(1500586,_loc10_);
         var _loc11_:TradeItemInfo = new TradeItemInfo();
         if(_loc3_ == 1)
         {
            _loc11_.type = TradeItemInfo.EQUIP;
         }
         else
         {
            _loc11_.type = TradeItemInfo.ITEM;
         }
         _loc11_.gridID = _loc5_;
         _loc11_.id = _loc6_;
         _loc11_.uniqueID = _loc7_;
         _loc11_.num = _loc8_;
         TradeManager.onSaled(_loc4_,_loc9_,_loc11_);
      }
      
      private function closeMyShop(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         TradeManager.closeMyShop(_loc3_);
      }
   }
}

