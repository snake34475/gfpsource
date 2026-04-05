package com.gfp.app.module
{
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.language.ModuleLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.utils.FilterUtil;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class BaseGetPetModule extends BaseExchangeModule
   {
      
      private var _conditionStateId:int = 0;
      
      private var _conditionValue:int = 0;
      
      private var _interactiveId:int = 0;
      
      private var _usualGetID:int = 0;
      
      private var _usualCountLimit:int = 1;
      
      private var _qulicklyId:int = 1;
      
      private var _qulicklyCoutLimit:int = 999;
      
      private var _maxInteractiveCount:int = 5;
      
      private var _tongbaoPrice:int = 100;
      
      private var _buyAlertStr:String = "";
      
      private var _usualAlertStr:String = "";
      
      private var _enoughCondtion:int = 100;
      
      protected var isUsualGeted:Boolean = false;
      
      protected var isUsualCanGet:Boolean = false;
      
      protected var _usualGetedCount:int = 0;
      
      protected var _remainCount:int = 0;
      
      public function BaseGetPetModule()
      {
         super();
      }
      
      protected function showPanelState() : void
      {
         (_mainUI["usualTakeBtn"] as SimpleButton).mouseEnabled = this.isUsualCanGet;
         if(!this.isUsualCanGet)
         {
            (_mainUI["usualTakeBtn"] as SimpleButton).filters = FilterUtil.GRAY_FILTER;
         }
         else
         {
            (_mainUI["usualTakeBtn"] as SimpleButton).filters = [];
         }
         var _loc1_:int = int(ActivityExchangeTimesManager.getTimes(this.usualGetID));
         if(_mainUI["usualTakedBtn"])
         {
            (_mainUI["usualTakedBtn"] as SimpleButton).visible = false;
         }
         this.showTxt();
         if(_loc1_ >= this.usualCountLimit)
         {
            this.isUsualGeted = true;
            if(_mainUI["usualTakedBtn"])
            {
               (_mainUI["usualTakeBtn"] as SimpleButton).visible = false;
               (_mainUI["usualTakedBtn"] as SimpleButton).visible = true;
               return;
            }
            if(this.usualAlertStr == "")
            {
               (_mainUI["usualTakeBtn"] as SimpleButton).mouseEnabled = false;
               (_mainUI["usualTakeBtn"] as SimpleButton).filters = FilterUtil.GRAY_FILTER;
            }
            return;
         }
      }
      
      protected function showTxt() : void
      {
         this._remainCount = this.maxInteractiveCount - ActivityExchangeTimesManager.getTimes(this.interactiveId);
         (_mainUI["remianTxt"] as TextField).text = this._remainCount.toString();
         (_mainUI["ripeTxt"] as TextField).text = this.conditionValue.toString() + "/" + this.enoughCondtion;
      }
      
      protected function showTips() : void
      {
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         ActivityExchangeTimesManager.addEventListener(this.conditionStateId,this.onGetComplete);
         (_mainUI["usualTakeBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK,this.onUsualTakeClick);
         (_mainUI["qulicklyTakeBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK,this.onQulicklyTakeClick);
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
      }
      
      protected function onGetComplete(param1:DataEvent) : void
      {
         this.conditionValue = param1.data.times;
         if(this.conditionValue > this.enoughCondtion)
         {
            this.conditionValue = this.enoughCondtion;
         }
         this.isUsualCanGet = this.conditionValue >= this.enoughCondtion;
         if(_mainUI)
         {
            this.showPanelState();
         }
      }
      
      protected function onUsualTakeClick(param1:MouseEvent) : void
      {
         var _loc2_:int = int(ActivityExchangeTimesManager.getTimes(this.usualGetID));
         if(_loc2_ >= this.usualCountLimit)
         {
            if(this.usualAlertStr != "")
            {
               AlertManager.showSimpleAlarm(this.usualAlertStr);
            }
            return;
         }
         ActivityExchangeCommander.exchange(this.usualGetID);
      }
      
      protected function onQulicklyTakeClick(param1:MouseEvent) : void
      {
         if(mIsSend)
         {
            return;
         }
         mExchange = this.qulicklyId;
         if(gfCoin < this.tongbaoPrice)
         {
            AlertManager.showSimpleAlarm(ModuleLanguageDefine.TOMBO_EMPTY);
            return;
         }
         var _loc2_:int = int(ActivityExchangeTimesManager.getTimes(this.qulicklyId));
         if(_loc2_ >= this.qulicklyCoutLimit)
         {
            AlertManager.showSimpleAlarm(this.usualAlertStr);
            return;
         }
         buyItem(true,this.buyAlertStr,null,false);
      }
      
      protected function onExchangeComplete(param1:ExchangeEvent) : void
      {
         if(param1.info.id == this.usualGetID)
         {
            this.showPanelState();
         }
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         ActivityExchangeTimesManager.removeEventListener(this.conditionStateId,this.onGetComplete);
         (_mainUI["usualTakeBtn"] as SimpleButton).removeEventListener(MouseEvent.CLICK,this.onUsualTakeClick);
         (_mainUI["qulicklyTakeBtn"] as SimpleButton).removeEventListener(MouseEvent.CLICK,this.onQulicklyTakeClick);
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      public function get conditionStateId() : int
      {
         return this._conditionStateId;
      }
      
      public function set conditionStateId(param1:int) : void
      {
         this._conditionStateId = param1;
      }
      
      public function get interactiveId() : int
      {
         return this._interactiveId;
      }
      
      public function set interactiveId(param1:int) : void
      {
         this._interactiveId = param1;
      }
      
      public function get usualGetID() : int
      {
         return this._usualGetID;
      }
      
      public function set usualGetID(param1:int) : void
      {
         this._usualGetID = param1;
      }
      
      public function get qulicklyId() : int
      {
         return this._qulicklyId;
      }
      
      public function set qulicklyId(param1:int) : void
      {
         this._qulicklyId = param1;
      }
      
      public function get maxInteractiveCount() : int
      {
         return this._maxInteractiveCount;
      }
      
      public function set maxInteractiveCount(param1:int) : void
      {
         this._maxInteractiveCount = param1;
      }
      
      public function get usualCountLimit() : int
      {
         return this._usualCountLimit;
      }
      
      public function set usualCountLimit(param1:int) : void
      {
         this._usualCountLimit = param1;
      }
      
      public function get qulicklyCoutLimit() : int
      {
         return this._qulicklyCoutLimit;
      }
      
      public function set qulicklyCoutLimit(param1:int) : void
      {
         this._qulicklyCoutLimit = param1;
      }
      
      public function get tongbaoPrice() : int
      {
         return this._tongbaoPrice;
      }
      
      public function set tongbaoPrice(param1:int) : void
      {
         this._tongbaoPrice = param1;
      }
      
      public function get buyAlertStr() : String
      {
         return this._buyAlertStr;
      }
      
      public function set buyAlertStr(param1:String) : void
      {
         this._buyAlertStr = param1;
      }
      
      public function get usualAlertStr() : String
      {
         return this._usualAlertStr;
      }
      
      public function set usualAlertStr(param1:String) : void
      {
         this._usualAlertStr = param1;
      }
      
      public function get enoughCondtion() : int
      {
         return this._enoughCondtion;
      }
      
      public function set enoughCondtion(param1:int) : void
      {
         this._enoughCondtion = param1;
      }
      
      public function get conditionValue() : int
      {
         return this._conditionValue;
      }
      
      public function set conditionValue(param1:int) : void
      {
         this._conditionValue = param1;
      }
   }
}

