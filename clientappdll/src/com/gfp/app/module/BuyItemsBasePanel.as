package com.gfp.app.module
{
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.BatSwapManager;
   import com.gfp.core.net.SocketConnection;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.net.SocketEvent;
   
   public class BuyItemsBasePanel extends BaseExchangeModule
   {
      
      private var myItems:Vector.<MY_ITEM>;
      
      private var _willBuyItems:Vector.<MY_ITEM>;
      
      private var _callback:Function;
      
      public function BuyItemsBasePanel()
      {
         getUserGfCoins();
         super();
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         _mainUI["buyBtn"].addEventListener(MouseEvent.CLICK,this.buyHandle);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         _mainUI["buyBtn"].addEventListener(MouseEvent.CLICK,this.buyHandle);
         SocketConnection.removeCmdListener(CommandID.BAT_SWAP,this.onBatSwap);
      }
      
      override public function init(param1:Object = null) : void
      {
         var _loc5_:MY_ITEM = null;
         super.init(param1);
         var _loc2_:Array = param1.items as Array;
         var _loc3_:Array = param1.itemCounts as Array;
         this._callback = param1.callback as Function;
         this.myItems = new Vector.<MY_ITEM>();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = new MY_ITEM(_mainUI["item" + _loc4_]);
            this.myItems[_loc4_] = _loc5_;
            _loc5_.itemID = _loc2_[_loc4_];
            _loc5_.itemCount = _loc3_[_loc4_];
            _loc5_.addEventListener(Event.CHANGE,this.onChangeHandle);
            _loc4_++;
         }
         this.onChangeHandle(null);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         while(this.myItems.length)
         {
            this.myItems.pop().destroy();
         }
      }
      
      private function onChangeHandle(param1:Event) : void
      {
         var _loc3_:MY_ITEM = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:int = 0;
         for each(_loc3_ in this.myItems)
         {
            if(_loc3_.itemCount > 0)
            {
               _loc4_ = ItemXMLInfo.getItemSwapPrice(_loc3_.itemID);
               _loc5_ = _loc4_.split(":");
               _loc6_ = int(_loc5_[0]);
               _loc7_ = int(_loc5_[1]);
               _loc2_ += COINS_ID[_loc6_] * _loc7_ * _loc3_.itemCount;
            }
         }
         _mainUI["priceLabel"].text = _loc2_;
      }
      
      private function buyHandle(param1:MouseEvent) : void
      {
         var _loc2_:MY_ITEM = null;
         this._willBuyItems = new Vector.<MY_ITEM>();
         for each(_loc2_ in this.myItems)
         {
            if(_loc2_.itemCount > 0)
            {
               this._willBuyItems.push(_loc2_);
            }
         }
         if(this._willBuyItems.length == 0)
         {
            AlertManager.showSimpleAlarm("小侠士，请选择要购买的物品！");
         }
         else
         {
            this.doBuy();
            _mainUI["buyBtn"].mouseEnabled = false;
            SocketConnection.send(CommandID.STATISTICS,34,1,1);
         }
      }
      
      override protected function onBuyTbClick() : void
      {
         super.onBuyTbClick();
         _mainUI["buyBtn"].mouseEnabled = true;
      }
      
      private function doBuy() : void
      {
         var _loc1_:MY_ITEM = null;
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this._willBuyItems.length == 0)
         {
            if(_mainUI)
            {
               this.destroy();
            }
            if(this._callback != null)
            {
               this._callback();
               this._callback = null;
            }
         }
         else
         {
            _loc1_ = this._willBuyItems[0];
            _loc2_ = ItemXMLInfo.getItemSwapPrice(_loc1_.itemID);
            _loc3_ = _loc2_.split(":");
            _loc4_ = int(_loc3_[0]);
            _loc5_ = int(_loc3_[1]);
            buyCoin(_loc4_,_loc5_ * _loc1_.itemCount);
         }
      }
      
      override protected function exchange(param1:int = 0, param2:int = 0) : void
      {
         var _loc3_:int = int(ItemXMLInfo.getItemSwapID(this._willBuyItems[0].itemID));
         if(_loc3_ == 0)
         {
         }
         BatSwapManager.execSwap(_loc3_,this._willBuyItems[0].itemCount);
         SocketConnection.addCmdListener(CommandID.BAT_SWAP,this.onBatSwap);
      }
      
      private function onBatSwap(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.BAT_SWAP,this.onBatSwap);
         this._willBuyItems.shift();
         this.doBuy();
         if(this._callback != null)
         {
            this._callback();
         }
      }
   }
}

import com.gfp.core.ui.ItemIconTip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;

class MY_ITEM extends EventDispatcher
{
   
   public var mainUI:Sprite;
   
   private var _itemID:int;
   
   private var _itemCount:int;
   
   private var _itemIcon:ItemIconTip;
   
   private var _batSwapId:int;
   
   public function MY_ITEM(param1:Sprite)
   {
      super();
      this.mainUI = param1;
      this._itemIcon = new ItemIconTip();
      this._itemIcon.x = 1;
      this._itemIcon.y = -51;
      param1.addChild(this._itemIcon);
      param1["lessBtn"].addEventListener(MouseEvent.CLICK,this.lessHandle);
      param1["addBtn"].addEventListener(MouseEvent.CLICK,this.addHandle);
   }
   
   private function addHandle(param1:MouseEvent) : void
   {
      if(this._itemCount < 99)
      {
         ++this.itemCount;
      }
   }
   
   private function lessHandle(param1:MouseEvent) : void
   {
      if(this._itemCount > 0)
      {
         --this.itemCount;
      }
   }
   
   public function set itemID(param1:int) : void
   {
      this._itemID = param1;
      this._itemIcon.setID(param1);
   }
   
   public function get itemID() : int
   {
      return this._itemID;
   }
   
   public function set itemCount(param1:int) : void
   {
      this._itemCount = param1;
      this.mainUI["countLabel"].text = param1 + "";
      dispatchEvent(new Event(Event.CHANGE));
   }
   
   public function get itemCount() : int
   {
      return this._itemCount;
   }
   
   public function destroy() : void
   {
      this._itemIcon.destroy();
      this.mainUI["lessBtn"].addEventListener(MouseEvent.CLICK,this.lessHandle);
      this.mainUI["addBtn"].addEventListener(MouseEvent.CLICK,this.addHandle);
   }
   
   public function get batSwapId() : int
   {
      return this._batSwapId;
   }
   
   public function set batSwapId(param1:int) : void
   {
      this._batSwapId = param1;
   }
}
