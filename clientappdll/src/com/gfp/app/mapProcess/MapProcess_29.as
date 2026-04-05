package com.gfp.app.mapProcess
{
   import com.gfp.app.info.StoreInfo;
   import com.gfp.app.manager.TradeAuctionManager;
   import com.gfp.app.store.StoreDisplay;
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.CameraController;
   import com.gfp.core.controller.KeyController;
   import com.gfp.core.controller.MouseController;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.net.SocketConnection;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.ds.HashMap;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_29 extends BaseMapProcess
   {
      
      private var _storeInfoMap:HashMap;
      
      private var _storeDisplayMap:HashMap;
      
      private var _prevTransport:SightModel;
      
      private var _tradeAuctionUI:Sprite;
      
      private var _timer:int;
      
      private var _currentTimeIndex:int = 2147483647;
      
      public function MapProcess_29()
      {
         super();
      }
      
      private function initAuction() : void
      {
         this._timer = setInterval(this.onTimer,10 * 1000);
         this.onTimer();
      }
      
      private function onTimer() : void
      {
         var _loc1_:int = TradeAuctionManager.getInstance().getCurrentTimeIndex();
         if(this._currentTimeIndex != _loc1_)
         {
            this._currentTimeIndex = _loc1_;
            this.updateView();
         }
      }
      
      private function updateView() : void
      {
         if(this._currentTimeIndex >= 0)
         {
            if(this._tradeAuctionUI == null)
            {
               this._tradeAuctionUI = _mapModel.libManager.getSprite("TradeAuctionUI");
               this._tradeAuctionUI["goBtn"].addEventListener(MouseEvent.CLICK,this.moduleHandle);
            }
            LayerManager.topLevel.addChild(this._tradeAuctionUI);
            this._tradeAuctionUI.visible = true;
            this.layout();
            StageResizeController.instance.register(this.layout);
            this._tradeAuctionUI["itemMC"].gotoAndStop(this._currentTimeIndex + 1);
         }
         else if(this._tradeAuctionUI)
         {
            this._tradeAuctionUI.visible = false;
            this._tradeAuctionUI["itemMC"].gotoAndStop(1);
         }
      }
      
      protected function layout() : void
      {
         if(this._tradeAuctionUI)
         {
            this._tradeAuctionUI.x = LayerManager.stageWidth - this._tradeAuctionUI.width >> 1;
            this._tradeAuctionUI.y = 65;
         }
      }
      
      private function moduleHandle(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("TradeAuctionPanel");
      }
      
      override protected function init() : void
      {
         this.addTradeMapListener();
         this.initStoreInfo();
         this.initStoreDisplay();
         this.requestStoreInfo();
         this.addStoreCommandListener();
         this.initAuction();
      }
      
      private function addTradeMapListener() : void
      {
         MapManager.addEventListener(MapEvent.USER_ENTER_TRADE_MAP,this.onEnterTradeMap);
      }
      
      private function removeTradeMapListener() : void
      {
         MapManager.removeEventListener(MapEvent.USER_ENTER_TRADE_MAP,this.onEnterTradeMap);
      }
      
      private function onEnterTradeMap(param1:MapEvent) : void
      {
         if(MapManager.currentMap.info.id == 1)
         {
            this._prevTransport = SightManager.getSightModel(1);
            this._prevTransport.hide();
         }
      }
      
      private function initStoreInfo() : void
      {
         var _loc3_:uint = 0;
         var _loc4_:StoreInfo = null;
         this._storeInfoMap = new HashMap();
         var _loc1_:int = 8;
         var _loc2_:int = 1;
         while(_loc2_ <= _loc1_)
         {
            _loc3_ = uint(_loc2_);
            _loc4_ = new StoreInfo(_loc3_);
            this._storeInfoMap.add(_loc3_,_loc4_);
            _loc2_++;
         }
      }
      
      private function initStoreDisplay() : void
      {
         var _loc6_:uint = 0;
         var _loc7_:StoreInfo = null;
         var _loc8_:StoreDisplay = null;
         this._storeDisplayMap = new HashMap();
         var _loc1_:int = 8;
         var _loc2_:int = 12;
         var _loc3_:int = 377;
         var _loc4_:int = 250;
         var _loc5_:int = 1;
         while(_loc5_ <= _loc1_)
         {
            _loc6_ = uint(_loc5_);
            _loc7_ = this._storeInfoMap.getValue(_loc6_) as StoreInfo;
            _loc8_ = new StoreDisplay(_loc7_);
            this._storeDisplayMap.add(_loc6_,_loc8_);
            _loc8_.x = _loc2_ + (_loc5_ - 1) * _loc4_;
            _loc8_.y = _loc3_;
            _mapModel.contentLevel.addChild(_loc8_);
            _loc5_++;
         }
      }
      
      private function getStoreInfoById(param1:uint) : StoreInfo
      {
         return this._storeInfoMap.getValue(param1) as StoreInfo;
      }
      
      private function getStoreDisplayById(param1:uint) : StoreDisplay
      {
         return this._storeDisplayMap.getValue(param1) as StoreDisplay;
      }
      
      private function requestStoreInfo() : void
      {
         SocketConnection.send(CommandID.GET_STORE_LIST);
      }
      
      private function onGetStoreList(param1:SocketEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:StoreInfo = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.readUnsignedInt();
            _loc6_ = _loc2_.readUnsignedInt();
            _loc7_ = this.getStoreInfoById(_loc5_);
            _loc7_.ownerId = _loc2_.readUnsignedInt();
            _loc7_.shopType = _loc6_;
            _loc7_.ownerCreateTime = _loc2_.readUnsignedInt();
            _loc7_.ownerRoleType = _loc2_.readUnsignedInt();
            _loc7_.status = _loc2_.readUnsignedInt();
            _loc7_.decorateItemId = _loc2_.readUnsignedInt();
            if(_loc7_.shopType == 1)
            {
               _loc7_.decorateItemId = 1190000;
            }
            _loc7_.name = _loc2_.readUTFBytes(32);
            this.updateStoreDisplay(_loc5_);
            _loc4_++;
         }
      }
      
      private function addStoreCommandListener() : void
      {
         SocketConnection.addCmdListener(CommandID.STORE_STATUS_UPDATE,this.onStoreStatusUpdate);
         SocketConnection.addCmdListener(CommandID.GET_STORE_LIST,this.onGetStoreList);
         SocketConnection.addCmdListener(CommandID.STORE_CLOSE,this.onOwnStoreClose);
         _mapModel.camera.edgeRect = CameraController.TRADE_HOT_AREA;
      }
      
      private function removeStoreCommandListener() : void
      {
         SocketConnection.removeCmdListener(CommandID.GET_STORE_LIST,this.onGetStoreList);
         SocketConnection.removeCmdListener(CommandID.STORE_STATUS_UPDATE,this.onStoreStatusUpdate);
         SocketConnection.removeCmdListener(CommandID.STORE_CLOSE,this.onOwnStoreClose);
         _mapModel.camera.edgeRect = CameraController.NORMAL_HOT_AREA;
      }
      
      private function onStoreStatusUpdate(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:StoreInfo = this.getStoreInfoById(_loc3_);
         _loc4_.shopType = _loc2_.readUnsignedInt();
         _loc4_.ownerId = _loc2_.readUnsignedInt();
         _loc4_.ownerCreateTime = _loc2_.readUnsignedInt();
         _loc4_.ownerRoleType = _loc2_.readUnsignedInt();
         _loc4_.status = _loc2_.readUnsignedInt();
         _loc4_.decorateItemId = _loc2_.readUnsignedInt();
         if(_loc4_.shopType == 1)
         {
            _loc4_.decorateItemId = 1190000;
         }
         _loc4_.name = _loc2_.readUTFBytes(32);
         var _loc5_:StoreDisplay = this.getStoreDisplayById(_loc3_);
         _loc5_.updateInfo(_loc4_);
         if(_loc4_.ownerId == MainManager.actorInfo.userID)
         {
            if(_loc4_.status > 0)
            {
               this.hideCurrentUser();
            }
         }
      }
      
      private function hideCurrentUser() : void
      {
         MainManager.actorModel.visible = false;
         if(MainManager.actorModel.summonModel)
         {
            MainManager.actorModel.summonModel.visible = false;
         }
         this.closeInteraction();
      }
      
      private function openInteraction() : void
      {
         MouseController.instance.init();
         KeyController.instance.init();
      }
      
      private function closeInteraction() : void
      {
         KeyController.instance.clear();
         MouseController.instance.clear();
      }
      
      private function showCurrentUser() : void
      {
         MainManager.actorModel.visible = true;
         if(MainManager.actorModel.summonModel)
         {
            MainManager.actorModel.summonModel.visible = true;
         }
         this.openInteraction();
      }
      
      private function onOwnStoreClose(param1:SocketEvent) : void
      {
         this.showCurrentUser();
      }
      
      private function updateStoreDisplay(param1:uint) : void
      {
         var _loc2_:StoreDisplay = this._storeDisplayMap.getValue(param1) as StoreDisplay;
         var _loc3_:StoreInfo = this.getStoreInfoById(param1);
         _loc2_.updateInfo(_loc3_);
      }
      
      private function removeStoreDisplayMap() : void
      {
         var _loc2_:StoreDisplay = null;
         var _loc1_:Array = this._storeDisplayMap.getValues();
         for each(_loc2_ in _loc1_)
         {
            DisplayUtil.removeForParent(_loc2_);
            _loc2_.destroy();
            _loc2_ = null;
         }
      }
      
      override public function destroy() : void
      {
         StageResizeController.instance.unregister(this.layout);
         if(this._tradeAuctionUI)
         {
            this._tradeAuctionUI["goBtn"].removeEventListener(MouseEvent.CLICK,this.moduleHandle);
            DisplayUtil.removeForParent(this._tradeAuctionUI);
            this._tradeAuctionUI = null;
         }
         clearInterval(this._timer);
         this.removeTradeMapListener();
         this.removeStoreDisplayMap();
         this.removeStoreCommandListener();
         super.destroy();
      }
   }
}

