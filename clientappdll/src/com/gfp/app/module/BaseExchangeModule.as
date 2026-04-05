package com.gfp.app.module
{
   import com.gfp.app.manager.ShoppingCartManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.ActivityExchangeXMLInfo;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.info.dailyActivity.ActivityExchangeInfo;
   import com.gfp.core.info.dailyActivity.CostInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.BuyMallItemManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.ByteArrayUtil;
   import com.gfp.core.utils.TextUtil;
   import com.gfp.core.utils.WallowUtil;
   import com.gfp.module.BaseViewModule;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class BaseExchangeModule extends BaseViewModule
   {
      
      protected const COINS_ID:Object = {
         1700124:1,
         1700125:10,
         1700126:100,
         1303028:1,
         1303029:10,
         1303030:100
      };
      
      protected const SOTRE_ID:Object = {
         1700124:321090,
         1700125:321091,
         1700126:321092,
         1303028:321214,
         1303029:321215,
         1303030:321216
      };
      
      protected var mIsSend:Boolean;
      
      protected var mGfCoin:int;
      
      protected var mTbText:TextField;
      
      protected var mExchange:int;
      
      protected var mNeedTB:int;
      
      protected var youHui:int;
      
      protected var mCoinID:int;
      
      protected var mParam1:int;
      
      protected var mParam2:int;
      
      protected var mParam3:int;
      
      protected var mCost:Object = {};
      
      protected var _isThreeParams:Boolean;
      
      public function BaseExchangeModule()
      {
         super();
      }
      
      protected function getUserGfCoins() : void
      {
         SocketConnection.addCmdListener(CommandID.GET_GF_COINS,this.onGetUserGfCoins);
         SocketConnection.send(CommandID.GET_GF_COINS);
      }
      
      protected function onGetUserGfCoins(param1:SocketEvent) : void
      {
         (param1.data as ByteArray).position = 0;
         SocketConnection.removeCmdListener(CommandID.GET_GF_COINS,this.onGetUserGfCoins);
         this.gfCoin = (param1.data as ByteArray).readUnsignedInt() / 100;
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         SocketConnection.addCmdListener(CommandID.CHANGE_FOR_GF_COINS,this.onChangeCoin);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         SocketConnection.removeCmdListener(CommandID.CHANGE_FOR_GF_COINS,this.onChangeCoin);
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeCompleteHandler);
         SocketConnection.removeCmdListener(CommandID.BUY_MALL_ITEMS,this.onBuyItemSuccess);
      }
      
      protected function getActivityTimes(param1:int) : int
      {
         return ActivityExchangeTimesManager.getTimes(param1);
      }
      
      override public function show() : void
      {
         showFor(LayerManager.topLevel);
      }
      
      protected function onChangeCoin(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:ByteArray = ByteArrayUtil.clone(_loc2_);
         _loc3_.position = 0;
         var _loc4_:uint = _loc3_.readUnsignedInt();
         var _loc5_:uint = _loc3_.readUnsignedInt();
         this.gfCoin = _loc5_ / 100;
      }
      
      protected function buyItem(param1:Boolean = false, param2:String = null, param3:Function = null, param4:Boolean = false, param5:int = 0, param6:int = 0, param7:int = 0) : void
      {
         var _loc9_:CostInfo = null;
         if(WallowUtil.isWallow())
         {
            WallowUtil.showWallowMsg(AppLanguageDefine.WALLOW_MSG_ARR[18]);
            return;
         }
         this.youHui = param7;
         this._isThreeParams = false;
         this.mParam1 = param5;
         this.mParam2 = param6;
         this.mNeedTB = 0;
         this.mCoinID = 0;
         var _loc8_:ActivityExchangeInfo = ActivityExchangeXMLInfo.getActivityById(this.mExchange);
         for each(_loc9_ in _loc8_.costVect)
         {
            if(_loc9_.type == 2 && Boolean(this.COINS_ID[_loc9_.id]))
            {
               this.mNeedTB += _loc9_.count;
               this.mCoinID = _loc9_.id;
            }
         }
         this.mNeedTB -= param7;
         this.mNeedTB = this._getDynamicNeedTB(this.mNeedTB);
         if(this.mNeedTB > 0)
         {
            if(param1)
            {
               if(param3 == null)
               {
                  param3 = this.onCall;
               }
               this.setCostToNull(this.mExchange,this.youHui);
               AlertManager.showSimpleAlert(TextUtil.substitute(param2,[_loc8_.name,this.COINS_ID[this.mCoinID] * this.mNeedTB]),param3,this.onCancel,param4);
            }
            else
            {
               this.setCostToNull(this.mExchange,this.youHui);
               this.buyCoin(this.mCoinID,this.mNeedTB);
            }
         }
         else
         {
            this.setCostToNull(this.mExchange,this.youHui);
            this.exchange(this.mParam1,this.mParam2);
         }
      }
      
      protected function _getDynamicNeedTB(param1:int) : int
      {
         return param1;
      }
      
      protected function buyItemThreeParams(param1:Boolean = false, param2:String = null, param3:Function = null, param4:Boolean = false, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0) : void
      {
         var _loc10_:CostInfo = null;
         this._isThreeParams = true;
         this.mParam1 = param5;
         this.mParam2 = param6;
         this.mParam3 = param7;
         this.mNeedTB = 0;
         this.mCoinID = 0;
         var _loc9_:ActivityExchangeInfo = ActivityExchangeXMLInfo.getActivityById(this.mExchange);
         for each(_loc10_ in _loc9_.costVect)
         {
            if(_loc10_.type == 2 && Boolean(this.COINS_ID[_loc10_.id]))
            {
               this.mNeedTB += _loc10_.count;
               this.mCoinID = _loc10_.id;
            }
         }
         this.mNeedTB -= param8;
         this.mNeedTB = this._getDynamicNeedTB(this.mNeedTB);
         if(this.mNeedTB > 0)
         {
            if(param1)
            {
               if(param3 == null)
               {
                  param3 = this.onCall;
               }
               AlertManager.showSimpleAlert(TextUtil.substitute(param2,[_loc9_.name,this.COINS_ID[this.mCoinID] * this.mNeedTB]),param3,this.onCancel,param4);
            }
            else
            {
               this.buyCoin(this.mCoinID,this.mNeedTB);
            }
         }
         else
         {
            this.exchangeThreeParams(this.mParam1,this.mParam2,this.mParam3);
         }
      }
      
      public function getNeedTb(param1:int) : int
      {
         var _loc5_:CostInfo = null;
         var _loc2_:ActivityExchangeInfo = ActivityExchangeXMLInfo.getActivityById(param1);
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         for each(_loc5_ in _loc2_.costVect)
         {
            if(_loc5_.type == 2 && Boolean(this.COINS_ID[_loc5_.id]))
            {
               _loc3_ += _loc5_.count;
               _loc4_ = int(_loc5_.id);
            }
         }
         return this.COINS_ID[_loc4_] * _loc3_;
      }
      
      protected function onCancel() : void
      {
         this.recoverCost(this.mExchange,this.youHui);
      }
      
      protected function onCall() : void
      {
         this.buyCoin(this.mCoinID,this.mNeedTB);
      }
      
      protected function buyCoin(param1:uint, param2:uint) : void
      {
         var _loc3_:uint = uint(ItemManager.getItemCount(param1));
         if(_loc3_ < param2 && this.gfCoin < this.COINS_ID[param1] * (param2 - _loc3_))
         {
            this.recoverCost(this.mExchange,this.youHui);
            this.notEoughTb();
            AlertManager.showSimpleAlert("小侠士，你的通宝不足哦！是否需要进行兑换？",this.onBuyTbClick,this.tbCancel);
            return;
         }
         this.mIsSend = true;
         if(_loc3_ >= param2)
         {
            this.onBuyItemSuccess();
         }
         else
         {
            this.buyMallItem(this.SOTRE_ID[param1],param2 - _loc3_,param1);
         }
      }
      
      protected function notEoughTb() : void
      {
      }
      
      protected function tbCancel() : void
      {
      }
      
      protected function buyMallItem(param1:int, param2:int, ... rest) : void
      {
         var _loc5_:int = 0;
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeUnsignedInt(param1);
         _loc4_.writeUnsignedInt(param2);
         _loc4_.writeUnsignedInt(rest.length);
         for each(_loc5_ in rest)
         {
            _loc4_.writeUnsignedInt(_loc5_);
         }
         this.addSocketError();
         SocketConnection.addCmdListener(CommandID.BUY_MALL_ITEMS,this.onBuyItemSuccess);
         BuyMallItemManager.instance.buyItemByBa(_loc4_);
      }
      
      protected function onBuyItemSuccess(param1:SocketEvent = null) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         this.removeSocketError();
         SocketConnection.removeCmdListener(CommandID.BUY_MALL_ITEMS,this.onBuyItemSuccess);
         if(param1)
         {
            _loc2_ = param1.data as ByteArray;
            _loc2_.position = 0;
            _loc3_ = _loc2_.readUnsignedInt();
            _loc4_ = _loc2_.readUnsignedInt();
            _loc5_ = _loc2_.readUnsignedInt();
            _loc6_ = _loc2_.readUnsignedInt();
            _loc7_ = _loc2_.readUnsignedInt();
            this.gfCoin = _loc3_ / 100;
            MainManager.actorInfo.gfCoin = this.gfCoin;
            ItemManager.addItem(_loc6_,_loc7_);
         }
         if(this._isThreeParams)
         {
            this.exchangeThreeParams(this.mParam1,this.mParam2,this.mParam3);
         }
         else
         {
            this.exchange(this.mParam1,this.mParam2);
         }
      }
      
      protected function onBuyTbClick() : void
      {
         ModuleManager.turnAppModule("MallChangePanel","Loading...",this.onMallPanelDestroy);
      }
      
      protected function onMallPanelDestroy() : void
      {
         ShoppingCartManager.instance.dispatchEvent(new DataEvent(ShoppingCartManager.GF_CHANGE,this.gfCoin));
      }
      
      public function get gfCoin() : int
      {
         return this.mGfCoin;
      }
      
      public function set gfCoin(param1:int) : void
      {
         this.mGfCoin = param1;
         if(this.mTbText)
         {
            this.mTbText.text = this.mGfCoin.toString();
         }
      }
      
      protected function exchange(param1:int = 0, param2:int = 0) : void
      {
         if(this.mExchange == 0)
         {
            return;
         }
         this.mIsSend = true;
         this.addSocketError();
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeCompleteHandler);
         ActivityExchangeCommander.exchange(this.mExchange,param1,param2,this.onExchangeError);
      }
      
      protected function exchangeThreeParams(param1:int = 0, param2:int = 0, param3:int = 0) : void
      {
         if(this.mExchange == 0)
         {
            return;
         }
         this.mIsSend = true;
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeCompleteHandler);
         ActivityExchangeCommander.exchange(this.mExchange,param1,param2,param3);
      }
      
      protected function setCostToNull(param1:int, param2:int = 0) : void
      {
         var _loc3_:ActivityExchangeInfo = ActivityExchangeXMLInfo.getActivityById(param1);
         if(this.mCost[param1] == null)
         {
            this.mCost[param1] = _loc3_.costVect;
         }
         if(param2 != 0)
         {
            _loc3_.costVect[0].count -= param2;
            this.mCost["youhui" + param1.toString()] = param2;
         }
         else
         {
            _loc3_.costVect = new Vector.<CostInfo>();
         }
      }
      
      protected function recoverCost(param1:int, param2:int = 0) : void
      {
         var _loc3_:ActivityExchangeInfo = ActivityExchangeXMLInfo.getActivityById(param1);
         if(this.mCost[param1] != null)
         {
            _loc3_.costVect = this.mCost[param1];
            if(param2 != 0)
            {
               _loc3_.costVect[0].count += param2;
            }
            this.mCost[param1] = null;
            delete this.mCost[param1];
         }
         this.youHui = 0;
      }
      
      protected function onExchangeError() : void
      {
         this.onSocketError(null);
      }
      
      protected function addSocketError() : void
      {
         SocketConnection.addEventListener(SocketEvent.SOCKET_ERROR,this.onSocketError);
      }
      
      protected function removeSocketError() : void
      {
         SocketConnection.removeEventListener(SocketEvent.SOCKET_ERROR,this.onSocketError);
      }
      
      private function onSocketError(param1:SocketEvent = null) : void
      {
         this.removeSocketError();
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeCompleteHandler);
         SocketConnection.removeCmdListener(CommandID.BUY_MALL_ITEMS,this.onBuyItemSuccess);
         this.mIsSend = false;
      }
      
      protected function exchangeCompleteHandler(param1:ExchangeEvent) : void
      {
         if(param1.info.id != this.mExchange)
         {
            return;
         }
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeCompleteHandler);
         this.recoverCost(this.mExchange,this.youHui);
         this.removeSocketError();
         this.mIsSend = false;
         this.dispatchEvent(new ExchangeEvent(ExchangeEvent.EXCHANGE_COMPLETE,param1.info));
      }
   }
}

