package com.gfp.app.module
{
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.ServerUniqDataEvent;
   import com.gfp.core.info.ServerUniqDataInfo;
   import com.gfp.core.info.SwapActionLimitInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.ServerUniqDataManager;
   import com.gfp.core.popup.ModalType;
   import com.gfp.core.ui.ItemIconTip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class BaseRepMatPanel extends BaseExchangeModule
   {
      
      protected var _dataList:Array = [];
      
      protected var _needItemId:int = 1;
      
      public function BaseRepMatPanel()
      {
         super();
      }
      
      override public function setup() : void
      {
         _modalType = ModalType.DARK;
         isCanOperate = false;
      }
      
      override public function show() : void
      {
         super.show();
         this.addTips();
         this.getRep();
      }
      
      private function addTips() : void
      {
         var _loc1_:ItemIconTip = null;
         var _loc3_:Object = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._dataList.length)
         {
            _loc3_ = this._dataList[_loc2_];
            _loc1_ = new ItemIconTip();
            _loc1_.setID(_loc3_.itemid);
            _mainUI["item" + _loc2_.toString()].addChild(_loc1_);
            _loc2_++;
         }
      }
      
      private function getRep() : void
      {
         ServerUniqDataManager.addListener(ServerUniqDataEvent.EVENT_SECKILL_DEPOT,this.onServerData);
         ServerUniqDataManager.requestDateByType(ServerUniqDataManager.TYPE_SECKILL_DEPOT);
      }
      
      private function onServerData(param1:ServerUniqDataEvent) : void
      {
         var _loc6_:SwapActionLimitInfo = null;
         ServerUniqDataManager.removeListener(ServerUniqDataEvent.EVENT_SECKILL_DEPOT,this.onServerData);
         var _loc2_:ServerUniqDataInfo = param1.serverUniqDataInfo;
         var _loc3_:Vector.<SwapActionLimitInfo> = _loc2_.infoArr;
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc6_ = _loc3_[_loc5_];
            this.updateSwapId(_loc6_);
            _loc5_++;
         }
         this.updateView();
      }
      
      private function updateSwapId(param1:SwapActionLimitInfo) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this._dataList)
         {
            if(_loc2_.repid == param1.dailyID)
            {
               _loc2_.times = param1.limitCount;
            }
         }
      }
      
      override protected function addEvent() : void
      {
         _mainUI.addEventListener(MouseEvent.CLICK,this.onMainUiClick);
         super.addEvent();
      }
      
      private function onMainUiClick(param1:MouseEvent) : void
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc2_:String = param1.target.name;
         var _loc3_:int = int(_loc2_.substr(_loc2_.length - 1,1));
         if(_loc2_.indexOf("btn") != -1)
         {
            _loc4_ = this._dataList[_loc3_];
            _loc5_ = int(ItemManager.getItemCount(this._needItemId));
            _loc6_ = ItemXMLInfo.getName(_loc4_.itemid);
            if(_loc3_ == 4 || _loc3_ == 5)
            {
               if(_loc4_.singlecnt != 0 && ActivityExchangeTimesManager.getTimes(_loc4_.repid) >= _loc4_.singlecnt)
               {
                  AlertManager.showSimpleAlarm("今日兑换次数已达到上限！");
                  return;
               }
            }
            if(_loc5_ < _loc4_.needcnt)
            {
               AlertManager.showSimpleAlarm("小侠士兑换券不足,兑换" + _loc6_ + "需要" + _loc4_.needcnt.toString() + "个" + ItemXMLInfo.getName(this._needItemId) + "！");
               return;
            }
            mExchange = _loc4_.repid;
            buyItem();
            return;
         }
      }
      
      override protected function removeEvent() : void
      {
         _mainUI.removeEventListener(MouseEvent.CLICK,this.onMainUiClick);
         ServerUniqDataManager.removeListener(ServerUniqDataEvent.EVENT_SECKILL_DEPOT,this.onServerData);
         super.removeEvent();
      }
      
      protected function updateView() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._dataList.length)
         {
            _loc1_ = this._dataList[_loc2_];
            (_mainUI["txt" + _loc2_.toString()] as TextField).text = _loc1_.times.toString();
            _loc2_++;
         }
      }
      
      override public function destroy() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._dataList.length)
         {
            _mainUI["item" + _loc1_.toString()].removeChildAt(_mainUI["item" + _loc1_.toString()].numChildren - 1);
            _loc1_++;
         }
         this._dataList = null;
         super.destroy();
      }
      
      override protected function exchangeCompleteHandler(param1:ExchangeEvent) : void
      {
         super.exchangeCompleteHandler(param1);
         this.getRep();
      }
   }
}

