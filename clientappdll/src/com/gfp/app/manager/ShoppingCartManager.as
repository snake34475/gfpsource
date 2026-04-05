package com.gfp.app.manager
{
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.info.mall.MallProductInfo;
   import com.gfp.core.info.mall.MallStoreInfo;
   import com.gfp.core.info.mall.ShoppingCartInfo;
   import com.gfp.core.language.ModuleLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.SOManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.SharedObject;
   import flash.utils.ByteArray;
   import org.taomee.ds.HashMap;
   import org.taomee.net.SocketEvent;
   
   public class ShoppingCartManager extends EventDispatcher
   {
      
      private static var _instance:ShoppingCartManager;
      
      public static var SHOPPING_CART_DATA_CHANG:String = "shopping_cart_data_chang";
      
      public static var SHOPPING_CART_DATA_ADD:String = "shopping_cart_data_add";
      
      public static var SHOPPING_CART_COIN_CHANG:String = "shopping_cart_coin_chang";
      
      public static var SHOPPING_CART_BUY_COMPLETE:String = "shopping_cart_buy_complete";
      
      public static var GF_CHANGE:String = "GF_CHANGE";
      
      public static var REFRESH_CARD:String = "REFRESH_CARD";
      
      public static const ACTIVITY_MUILTY:uint = 1;
      
      private var _freeCoinMap:HashMap;
      
      private var cacheSO:SharedObject;
      
      private var _map:HashMap;
      
      private var _totalCoin:int;
      
      private var _totalGlod:int;
      
      public function ShoppingCartManager()
      {
         var _loc1_:Object = null;
         var _loc2_:XML = null;
         var _loc3_:ShoppingCartInfo = null;
         super();
         this._map = new HashMap();
         this.cacheSO = SOManager.getUserSO(SOManager.SHOPPING_CART_CACHE);
         for each(_loc1_ in this.cacheSO.data)
         {
            _loc2_ = new XML(_loc1_.xml);
            _loc3_ = this.getShoppingCartInfo(_loc2_,_loc1_.num);
            this._map.add(_loc1_.key,_loc3_);
            this.resetShopCartTotalCoin();
         }
         this.initFreeCoinMap();
      }
      
      public static function get instance() : ShoppingCartManager
      {
         if(_instance == null)
         {
            _instance = new ShoppingCartManager();
         }
         return _instance;
      }
      
      public function addShoppingCart(param1:MallProductInfo) : void
      {
         var _loc4_:ShoppingCartInfo = null;
         var _loc5_:Object = null;
         var _loc2_:MallStoreInfo = param1.stores[0];
         var _loc3_:String = param1.icon + "_" + _loc2_.storeID;
         if(this.cacheSO.data.hasOwnProperty(_loc3_))
         {
            _loc5_ = this.cacheSO.data[_loc3_];
            _loc5_.num += 1;
            _loc4_ = this._map.getValue(_loc3_);
            _loc4_.num += 1;
         }
         else
         {
            _loc4_ = this.getShoppingCartInfo(param1.xmlInfo,1);
            this._map.add(_loc3_,_loc4_);
            this.cacheSO.data[_loc3_] = {
               "xml":param1.xmlInfo.toString(),
               "num":1,
               "key":_loc3_
            };
            this.cacheSO.flush();
         }
         this.dispatchDataChange();
         dispatchEvent(new Event(SHOPPING_CART_DATA_ADD));
      }
      
      public function delShoppingCart(param1:MallProductInfo) : void
      {
         var _loc2_:MallStoreInfo = param1.stores[0];
         var _loc3_:String = param1.icon + "_" + _loc2_.storeID;
         if(this.cacheSO.data.hasOwnProperty(_loc3_))
         {
            delete this.cacheSO.data[_loc3_];
            this._map.remove(_loc3_);
         }
         this.dispatchDataChange();
      }
      
      public function setNum(param1:MallProductInfo, param2:int) : void
      {
         var _loc5_:Object = null;
         var _loc3_:MallStoreInfo = param1.stores[0];
         var _loc4_:String = param1.icon + "_" + _loc3_.storeID;
         if(this.cacheSO.data.hasOwnProperty(_loc4_))
         {
            _loc5_ = this.cacheSO.data[_loc4_];
            _loc5_.num = param2;
         }
         else
         {
            this.cacheSO.data[_loc4_] = {
               "xml":param1.xmlInfo.toString(),
               "num":param2,
               "key":_loc4_
            };
            this.cacheSO.flush();
         }
         this.dispatchDataChange();
      }
      
      public function get shoppingArr() : Array
      {
         return this._map.getValues();
      }
      
      public function get totalCoin() : int
      {
         return this._totalCoin;
      }
      
      public function get totalGlod() : int
      {
         return this._totalGlod;
      }
      
      public function buyAllShopCart(param1:int = 0) : void
      {
         var _loc4_:ShoppingCartInfo = null;
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUnsignedInt(param1);
         var _loc3_:Array = this._map.getValues();
         _loc2_.writeUnsignedInt(_loc3_.length);
         for each(_loc4_ in _loc3_)
         {
            _loc2_.writeUnsignedInt(_loc4_.productInfo.stores[0].storeID);
            _loc2_.writeUnsignedInt(_loc4_.num);
         }
         SocketConnection.addCmdListener(CommandID.BUY_SHOPPING_CART,this.onBuyShoppingCart);
         SocketConnection.send(CommandID.BUY_SHOPPING_CART,_loc2_);
      }
      
      public function isAlreadyHave(param1:MallProductInfo) : Boolean
      {
         var _loc2_:MallStoreInfo = param1.stores[0];
         var _loc3_:String = param1.icon + "_" + _loc2_.storeID;
         return this._map.containsKey(_loc3_);
      }
      
      public function getFreeCoinNumByItemId(param1:int) : int
      {
         if(this._freeCoinMap.containsKey(param1))
         {
            return this._freeCoinMap.getValue(param1);
         }
         return 0;
      }
      
      private function onBuyShoppingCart(param1:SocketEvent) : void
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc12_:String = null;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:SingleEquipInfo = null;
         var _loc18_:uint = 0;
         var _loc19_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:int = int(_loc2_.readUnsignedInt());
         ItemManager.removeItem(_loc4_,1);
         dispatchEvent(new DataEvent(SHOPPING_CART_COIN_CHANG,_loc3_));
         var _loc8_:String = "";
         var _loc9_:int = 0;
         while(_loc9_ < _loc5_)
         {
            _loc13_ = _loc2_.readUnsignedInt();
            _loc14_ = _loc2_.readUnsignedInt();
            _loc15_ = _loc2_.readUnsignedInt();
            _loc16_ = _loc2_.readUnsignedInt();
            _loc6_ = ItemXMLInfo.getName(_loc13_);
            _loc7_ = ClientConfig.getItemIcon(_loc13_);
            _loc8_ = TextFormatUtil.substitute(ModuleLanguageDefine.MALL_GET_MSG,1,_loc6_);
            AlertManager.showSimpleItemAlarm(_loc8_,_loc7_);
            _loc17_ = new SingleEquipInfo();
            _loc17_.itemID = _loc13_;
            _loc17_.leftTime = _loc14_;
            _loc17_.duration = int(ItemXMLInfo.getDuration(_loc13_)) * 50;
            _loc17_.gotTimeInSecond = _loc15_;
            _loc17_.endTimeInSecond = _loc16_;
            ItemManager.addEquip(_loc17_);
            _loc9_++;
         }
         var _loc10_:uint = _loc2_.readUnsignedInt();
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            _loc18_ = _loc2_.readUnsignedInt();
            _loc19_ = _loc2_.readUnsignedInt();
            _loc6_ = ItemXMLInfo.getName(_loc18_);
            _loc7_ = ClientConfig.getItemIcon(_loc18_);
            _loc8_ = TextFormatUtil.substitute(ModuleLanguageDefine.MALL_GET_MSG,_loc19_,_loc6_);
            AlertManager.showSimpleItemAlarm(_loc8_,_loc7_);
            ItemManager.addItem(_loc18_,_loc19_);
            _loc9_++;
         }
         var _loc11_:Array = this._map.getKeys();
         for each(_loc12_ in _loc11_)
         {
            delete this.cacheSO.data[_loc12_];
         }
         try
         {
            this.cacheSO.flush();
         }
         catch(e:Error)
         {
         }
         this._map = new HashMap();
         this.dispatchDataChange();
         dispatchEvent(new Event(SHOPPING_CART_BUY_COMPLETE));
      }
      
      private function resetShopCartTotalCoin() : void
      {
         var _loc2_:ShoppingCartInfo = null;
         this._totalCoin = 0;
         this._totalGlod = 0;
         var _loc1_:Array = this._map.getValues();
         for each(_loc2_ in _loc1_)
         {
            this._totalCoin += _loc2_.num * _loc2_.productInfo.stores[0].price;
            if(_loc2_.productInfo.isBox)
            {
               this._totalGlod += _loc2_.num * _loc2_.productInfo.stores[0].price * 2 * ACTIVITY_MUILTY;
            }
            else
            {
               this._totalGlod += _loc2_.num * _loc2_.productInfo.stores[0].price * ACTIVITY_MUILTY;
            }
         }
      }
      
      private function getShoppingCartInfo(param1:XML, param2:int) : ShoppingCartInfo
      {
         var _loc3_:MallProductInfo = new MallProductInfo();
         _loc3_.initInfo(param1);
         var _loc4_:ShoppingCartInfo = new ShoppingCartInfo();
         _loc4_.num = param2;
         _loc4_.productInfo = _loc3_;
         return _loc4_;
      }
      
      private function dispatchDataChange() : void
      {
         this.resetShopCartTotalCoin();
         dispatchEvent(new Event(SHOPPING_CART_DATA_CHANG));
      }
      
      private function initFreeCoinMap() : void
      {
         this._freeCoinMap = new HashMap();
         this._freeCoinMap.add(1740031,5);
         this._freeCoinMap.add(1740032,10);
         this._freeCoinMap.add(1740033,20);
         this._freeCoinMap.add(1740034,30);
         this._freeCoinMap.add(1740035,40);
         this._freeCoinMap.add(1740036,50);
         this._freeCoinMap.add(1740037,100);
         this._freeCoinMap.add(1740038,500);
         this._freeCoinMap.add(1740039,1000);
         this._freeCoinMap.add(1740040,1);
      }
   }
}

