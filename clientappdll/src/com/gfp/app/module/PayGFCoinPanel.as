package com.gfp.app.module
{
   import com.gfp.core.CommandID;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.BuyMallItemManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.module.BaseViewModule;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class PayGFCoinPanel extends BaseViewModule
   {
      
      protected var _gfCoins:int;
      
      private const COINS_ID_MAP:Object = {
         1:1700124,
         10:1700125,
         100:1700126
      };
      
      private const STORE_ID_MAP:Object = {
         1:321090,
         10:321091,
         100:321092
      };
      
      public function PayGFCoinPanel()
      {
         super();
         this.getGfCoins();
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         SocketConnection.addCmdListener(CommandID.CHANGE_FOR_GF_COINS,this.onCoinChange);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         SocketConnection.removeCmdListener(CommandID.GET_GF_COINS,this.onGetUserGfCoins);
         SocketConnection.removeCmdListener(CommandID.CHANGE_FOR_GF_COINS,this.onCoinChange);
         SocketConnection.removeCmdListener(CommandID.BUY_MALL_ITEMS,this.onBuyTokenSuccess);
      }
      
      protected function getGfCoins() : void
      {
         SocketConnection.addCmdListener(CommandID.GET_GF_COINS,this.onGetUserGfCoins);
         SocketConnection.send(CommandID.GET_GF_COINS);
      }
      
      private function onGetUserGfCoins(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GET_GF_COINS,this.onGetUserGfCoins);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         this.gfCoins = _loc2_.readUnsignedInt() / 100;
      }
      
      private function coinNotEnough() : void
      {
         AlertManager.showSimpleAlert("小侠士，你的通宝不足，是否去商城兑换？",function():void
         {
            ModuleManager.turnAppModule("Mall",AppLanguageDefine.LOAD_MATTER_COLLECTION[23]);
         });
      }
      
      private function onCoinChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         this.gfCoins = _loc4_ / 100;
         _loc2_.position = 0;
      }
      
      protected function set gfCoins(param1:int) : void
      {
         this._gfCoins = param1;
      }
      
      protected function payToken(param1:int, param2:int) : void
      {
         var _loc5_:ByteArray = null;
         var _loc3_:int = int(this.COINS_ID_MAP[param1]);
         if(_loc3_ == 0)
         {
            throw new Error("coinValue不合法，面值 1、10、100合法！");
         }
         var _loc4_:uint = uint(ItemManager.getItemCount(_loc3_));
         if(this._gfCoins < param1 * param2 && _loc4_ < param2)
         {
            this.coinNotEnough();
            return;
         }
         if(_loc4_ >= param2)
         {
            this.onBuyTokenComplete();
         }
         else
         {
            _loc5_ = new ByteArray();
            _loc5_.writeUnsignedInt(this.STORE_ID_MAP[param1]);
            _loc5_.writeUnsignedInt(param2 - _loc4_);
            _loc5_.writeUnsignedInt(1);
            _loc5_.writeUnsignedInt(_loc3_);
            SocketConnection.addCmdListener(CommandID.BUY_MALL_ITEMS,this.onBuyTokenSuccess);
            BuyMallItemManager.instance.buyItemByBa(_loc5_);
         }
      }
      
      private function onBuyTokenSuccess(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.BUY_MALL_ITEMS,this.onBuyTokenSuccess);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         _loc2_.readUnsignedInt();
         _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         ItemManager.addItem(_loc4_,_loc5_);
         this.gfCoins = _loc3_ / 100;
         this.onBuyTokenComplete();
      }
      
      protected function onBuyTokenComplete() : void
      {
         throw new Error("override function onBuyTokenComplete");
      }
   }
}

