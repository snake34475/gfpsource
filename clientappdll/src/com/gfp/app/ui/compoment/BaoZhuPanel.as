package com.gfp.app.ui.compoment
{
   import com.gfp.app.manager.NewYearBaoZhuManager;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.UserItemEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.ui.ExtenalUIPanel;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class BaoZhuPanel extends ExtenalUIPanel
   {
      
      private var _baoBtn0:SimpleButton;
      
      private var _baoBtn1:SimpleButton;
      
      private var _enable:Boolean = true;
      
      private var _txt:TextField;
      
      public function BaoZhuPanel()
      {
         super("bao_zhu");
      }
      
      override protected function initUI() : void
      {
         super.initUI();
         this._baoBtn0 = _ui["baoBtn0"];
         this._baoBtn1 = _ui["baoBtn1"];
         this._txt = _ui["txt"];
         this.updateItemCount();
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         this._baoBtn0.addEventListener(MouseEvent.CLICK,this.onBao0Click);
         this._baoBtn1.addEventListener(MouseEvent.CLICK,this.onBao1Click);
         ItemManager.addListener(UserItemEvent.ITEM_DROP,this.onItemUpdate);
         ItemManager.addListener(UserItemEvent.ITEM_ADD,this.onItemUpdate);
         ItemManager.addListener(UserItemEvent.ITEM_REMOVE,this.onItemUpdate);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._baoBtn0.removeEventListener(MouseEvent.CLICK,this.onBao0Click);
         this._baoBtn1.removeEventListener(MouseEvent.CLICK,this.onBao1Click);
         ItemManager.removeListener(UserItemEvent.ITEM_DROP,this.onItemUpdate);
         ItemManager.removeListener(UserItemEvent.ITEM_ADD,this.onItemUpdate);
         ItemManager.removeListener(UserItemEvent.ITEM_REMOVE,this.onItemUpdate);
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
      }
      
      private function onItemUpdate(param1:Event) : void
      {
         this.updateItemCount();
      }
      
      private function updateItemCount() : void
      {
         if(this._txt)
         {
            this._txt.text = "爆竹数量:" + ItemManager.getItemCount(NewYearBaoZhuManager.BAO_ITEM_ID);
         }
      }
      
      private function onExchangeComplete(param1:ExchangeEvent) : void
      {
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
         this._enable = true;
         this.updateItemCount();
      }
      
      private function onBao0Click(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         if(!this._enable)
         {
            return;
         }
         if(ItemManager.getItemCount(NewYearBaoZhuManager.BAO_ITEM_ID) < 1)
         {
            AlertManager.showSimpleAlert("小侠士，您新春爆竹数量不足哦， 请问是否去购买？",function():void
            {
               ModuleManager.turnAppModule("NewYearBaoZhuQuickBuyPanel");
            });
            return;
         }
         this._enable = false;
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
         ActivityExchangeCommander.exchange(NewYearBaoZhuManager.BAO0_SWAP_ID,MainManager.actorModel.x,MainManager.actorModel.y);
      }
      
      private function onBao1Click(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         if(!this._enable)
         {
            return;
         }
         if(ItemManager.getItemCount(NewYearBaoZhuManager.BAO_ITEM_ID) < 10)
         {
            AlertManager.showSimpleAlert("小侠士，您新春爆竹数量不足哦， 请问是否去购买？",function():void
            {
               ModuleManager.turnAppModule("NewYearBaoZhuQuickBuyPanel");
            });
            return;
         }
         this._enable = false;
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
         ActivityExchangeCommander.exchange(NewYearBaoZhuManager.BAO1_SWAP_ID,MainManager.actorModel.x,MainManager.actorModel.y);
      }
   }
}

