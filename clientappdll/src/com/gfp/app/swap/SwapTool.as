package com.gfp.app.swap
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
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.BuyMallItemManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.ByteArrayUtil;
   import com.gfp.core.utils.TextUtil;
   import com.gfp.core.utils.WallowUtil;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class SwapTool extends EventDispatcher
   {
      
      protected static const COINS_ID:Object = {
         1700124:1,
         1700125:10,
         1700126:100,
         1303028:1,
         1303029:10,
         1303030:100
      };
      
      protected static const SOTRE_ID:Object = {
         1700124:321090,
         1700125:321091,
         1700126:321092,
         1303028:321214,
         1303029:321215,
         1303030:321216
      };
      
      protected var mExchange:int;
      
      protected var mGfCoin:int;
      
      protected var mParam1:int;
      
      protected var mParam2:int;
      
      protected var mCost:Object = {};
      
      protected var mIsSend:Boolean;
      
      protected var mNeedTB:int;
      
      protected var youHui:int;
      
      protected var mCoinID:int;
      
      private var _stop:Boolean;
      
      private var _completeCallback:Function;
      
      public function SwapTool(param1:Boolean = true)
      {
         super();
         this.addEvent();
         param1 && this.getUserGfCoins();
      }
      
      public function getUserGfCoins() : void
      {
         SocketConnection.addCmdListener(CommandID.GET_GF_COINS,this.onGetUserGfCoins);
         SocketConnection.send(CommandID.GET_GF_COINS);
      }
      
      public function stop() : void
      {
         this._stop = true;
      }
      
      protected function onGetUserGfCoins(param1:SocketEvent) : void
      {
         (param1.data as ByteArray).position = 0;
         SocketConnection.removeCmdListener(CommandID.GET_GF_COINS,this.onGetUserGfCoins);
         this.mGfCoin = (param1.data as ByteArray).readUnsignedInt() / 100;
      }
      
      protected function addEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.CHANGE_FOR_GF_COINS,this.onChangeCoin);
      }
      
      protected function removeEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.CHANGE_FOR_GF_COINS,this.onChangeCoin);
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeCompleteHandler);
         SocketConnection.removeCmdListener(CommandID.BUY_MALL_ITEMS,this.onBuyItemSuccess);
      }
      
      protected function onChangeCoin(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:ByteArray = ByteArrayUtil.clone(_loc2_);
         _loc3_.position = 0;
         var _loc4_:uint = _loc3_.readUnsignedInt();
         var _loc5_:uint = _loc3_.readUnsignedInt();
         this.mGfCoin = _loc5_ / 100;
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
            this.mGfCoin = _loc3_ / 100;
            MainManager.actorInfo.gfCoin = this.mGfCoin;
            ItemManager.addItem(_loc6_,_loc7_);
         }
         this.doExchange(this.mParam1,this.mParam2);
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
         if(this._completeCallback != null)
         {
            if(this._completeCallback.length == 0)
            {
               this._completeCallback();
            }
            else
            {
               this._completeCallback(param1.info);
            }
            this._completeCallback = null;
         }
      }
      
      protected function doExchange(param1:int = 0, param2:int = 0) : void
      {
         if(this._stop)
         {
            return;
         }
         this.mIsSend = true;
         this.addSocketError();
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeCompleteHandler);
         ActivityExchangeCommander.exchange(this.mExchange,param1,param2,this.onExchangeError);
      }
      
      public function exchange(param1:int, param2:Boolean = false, param3:String = null, param4:Function = null, param5:Boolean = false, param6:int = 0, param7:int = 0, param8:int = 0) : void
      {
         var _loc10_:CostInfo = null;
         if(WallowUtil.isWallow())
         {
            WallowUtil.showWallowMsg(AppLanguageDefine.WALLOW_MSG_ARR[18]);
            return;
         }
         this._stop = false;
         this._completeCallback = param4;
         this.mExchange = param1;
         this.youHui = param8;
         this.mParam1 = param6;
         this.mParam2 = param7;
         this.mNeedTB = 0;
         this.mCoinID = 0;
         var _loc9_:ActivityExchangeInfo = ActivityExchangeXMLInfo.getActivityById(this.mExchange);
         for each(_loc10_ in _loc9_.costVect)
         {
            if(_loc10_.type == 2 && Boolean(COINS_ID[_loc10_.id]))
            {
               this.mNeedTB += _loc10_.count;
               this.mCoinID = _loc10_.id;
            }
         }
         this.mNeedTB -= param8;
         if(this.mNeedTB > 0)
         {
            if(param2)
            {
               this.setCostToNull(this.mExchange,this.youHui);
               AlertManager.showSimpleAlert(TextUtil.substitute(param3,[_loc9_.name,COINS_ID[this.mCoinID] * this.mNeedTB]),this.onCall,this.onCancel,param5);
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
            this.doExchange(this.mParam1,this.mParam2);
         }
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
         if(_loc3_ < param2 && this.mGfCoin < COINS_ID[param1] * (param2 - _loc3_))
         {
            this.recoverCost(this.mExchange,this.youHui);
            AlertManager.showSimpleAlert("小侠士，你的通宝不足哦！是否需要进行兑换？",this.onBuyTbClick);
            return;
         }
         this.mIsSend = true;
         this.recoverCost(this.mExchange,this.youHui);
         if(_loc3_ >= param2)
         {
            this.onBuyItemSuccess();
         }
         else
         {
            this.buyMallItem(SOTRE_ID[param1],param2 - _loc3_,param1);
         }
      }
      
      protected function onBuyTbClick() : void
      {
         ModuleManager.turnAppModule("MallChangePanel","Loading...",this.onMallPanelDestroy);
      }
      
      protected function onMallPanelDestroy() : void
      {
         ShoppingCartManager.instance.dispatchEvent(new DataEvent(ShoppingCartManager.GF_CHANGE,this.mGfCoin));
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
      
      protected function onExchangeError() : void
      {
         this.onSocketError(null);
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
      
      public function destroy() : void
      {
         this.mCost = {};
         this.removeEvent();
      }
   }
}

