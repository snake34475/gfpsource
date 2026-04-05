package com.gfp.app.bag
{
   import com.gfp.app.ParseSocketError;
   import com.gfp.app.cartoon.DailyActivityAward;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.ActivityExchangeXMLInfo;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.info.ActivityExchangeAwardInfo;
   import com.gfp.core.info.DailyActiveAwardInfo;
   import com.gfp.core.info.dailyActivity.ActivityExchangeAward;
   import com.gfp.core.info.dailyActivity.ActivityExchangeInfo;
   import com.gfp.core.info.dailyActivity.CostInfo;
   import com.gfp.core.info.item.SingleItemInfo;
   import com.gfp.core.info.itemsUpgrade.ItemsLineInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.net.SocketConnection;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import org.taomee.net.SocketEvent;
   
   public class BagBatchUseManager
   {
      
      private static var _instance:BagBatchUseManager;
      
      private var batchUseList:Array;
      
      private var batchSwapList:Array;
      
      private var waitUseMap:Dictionary;
      
      private var waitSwapMap:Dictionary;
      
      private var batchUseBak:Array;
      
      private var curExchanging:Boolean;
      
      private var useSwapSpecialIds:Array = [1300323,1300324,1300325,1300326];
      
      private var isShow:Boolean;
      
      private var _isFirstSwap:Boolean = true;
      
      private var _allAwardInfo:*;
      
      private var _swapTimes:uint = 0;
      
      public function BagBatchUseManager()
      {
         super();
         this.batchUseList = [];
         this.batchSwapList = [];
         this.waitUseMap = new Dictionary();
         this.waitSwapMap = new Dictionary();
         this.batchUseBak = new Array();
      }
      
      public static function batchUse(param1:uint, param2:uint) : void
      {
         if(!_instance)
         {
            _instance = new BagBatchUseManager();
         }
         if(_instance.waitUseMap[param1] != null)
         {
            _instance.waitUseMap[param1] += param2;
         }
         else
         {
            _instance.waitUseMap[param1] = param2;
            _instance.batchUseList.push(param1);
         }
         if(!_instance.curExchanging)
         {
            _instance.useNext();
         }
      }
      
      public static function batchSwap(param1:uint, param2:uint) : void
      {
         if(!_instance)
         {
            _instance = new BagBatchUseManager();
         }
         if(_instance.waitSwapMap[param1] != null)
         {
            _instance.waitSwapMap[param1] += param2;
         }
         else
         {
            _instance.waitSwapMap[param1] = param2;
            _instance.batchSwapList.push(param1);
         }
         if(!_instance.curExchanging)
         {
            _instance.swapNext();
         }
      }
      
      private function useNext() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.curExchanging = true;
         if(this.batchUseList.length > 0)
         {
            _loc1_ = uint(this.batchUseList[0]);
            if(ItemManager.getItemCount(_loc1_) >= 1)
            {
               _loc2_ = uint(ItemXMLInfo.getDailyId(_loc1_));
               _loc3_ = uint(ItemXMLInfo.getSwapId(_loc1_));
               if(this.useSwapSpecialIds.indexOf(_loc1_) != -1)
               {
                  _loc3_ = _loc2_;
                  _loc2_ = 0;
               }
               if(_loc2_ != 0)
               {
                  SocketConnection.addCmdListener(CommandID.BATCH_DAILY_ACTIVITY,this.dailyExchangeCompleteHandler);
                  SocketConnection.send(CommandID.BATCH_DAILY_ACTIVITY,_loc2_);
                  ParseSocketError.addErrorCodeListener(CommandID.BATCH_DAILY_ACTIVITY,this.batchUseErrorHandler);
                  return;
               }
               if(_loc3_ != 0)
               {
                  SocketConnection.addCmdListener(CommandID.BATCH_ACTIVITY_EXCHANGE,this.exchangeCompleteHandler);
                  SocketConnection.send(CommandID.BATCH_ACTIVITY_EXCHANGE,_loc3_,0,0);
                  ParseSocketError.addErrorCodeListener(CommandID.BATCH_ACTIVITY_EXCHANGE,this.batchUseErrorHandler);
                  return;
               }
            }
            else
            {
               this.waitUseMap[this.batchUseList[0]] = 0;
               this.batchUseList.splice(0,1);
               this.useNext();
               this._isFirstSwap = true;
               this._swapTimes = 0;
            }
         }
         else
         {
            this.curExchanging = false;
         }
      }
      
      private function swapNext() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:ActivityExchangeInfo = null;
         var _loc4_:CostInfo = null;
         var _loc5_:int = 0;
         this.curExchanging = true;
         if(this.batchSwapList.length > 0)
         {
            _loc1_ = uint(this.batchSwapList[0]);
            _loc2_ = uint(this.waitSwapMap[_loc1_]);
            _loc3_ = ActivityExchangeXMLInfo.getActivityById(_loc1_);
            for each(_loc4_ in _loc3_.costVect)
            {
               if(ItemManager.getItemCount(_loc4_.id) < _loc4_.count * _loc2_)
               {
                  AlertManager.showSimpleAlarm("小侠士，你背包中的物品不足。");
                  MainManager.openOperate();
                  return;
               }
            }
            ActivityExchangeCommander.instance.closeID(_loc1_);
            ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
            _loc5_ = 0;
            while(_loc5_ < _loc2_)
            {
               ActivityExchangeCommander.exchange(_loc1_);
               _loc5_++;
            }
         }
         else
         {
            this.curExchanging = false;
         }
      }
      
      private function batchUseErrorHandler(param1:Event) : void
      {
         ParseSocketError.removeErrorCodeListener(CommandID.ACTIVITY_EXCHANGE,this.batchUseErrorHandler);
         delete this.waitUseMap[this.batchUseList[0]];
         this.batchUseList.splice(0,1);
         this.useNext();
         this._isFirstSwap = true;
         this._swapTimes = 0;
      }
      
      private function dailyExchangeCompleteHandler(param1:SocketEvent) : void
      {
         ParseSocketError.removeErrorCodeListener(CommandID.ACTIVITY_EXCHANGE,this.batchUseErrorHandler);
         SocketConnection.removeCmdListener(CommandID.BATCH_DAILY_ACTIVITY,this.dailyExchangeCompleteHandler);
         var _loc2_:DailyActiveAwardInfo = new DailyActiveAwardInfo(param1.data as ByteArray);
         this.waitUseMap[this.batchUseList[0]] = this.waitUseMap[this.batchUseList[0]] - 1;
         this.showExchange(_loc2_);
         this.useNext();
      }
      
      private function exchangeCompleteHandler(param1:SocketEvent) : void
      {
         ParseSocketError.removeErrorCodeListener(CommandID.ACTIVITY_EXCHANGE,this.batchUseErrorHandler);
         SocketConnection.removeCmdListener(CommandID.BATCH_ACTIVITY_EXCHANGE,this.exchangeCompleteHandler);
         var _loc2_:ActivityExchangeAwardInfo = new ActivityExchangeAwardInfo(param1.data as ByteArray);
         this.waitUseMap[this.batchUseList[0]] = this.waitUseMap[this.batchUseList[0]] - 1;
         this.showExchange(_loc2_);
         this.useNext();
      }
      
      private function onExchangeComplete(param1:ExchangeEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc2_:ActivityExchangeAwardInfo = param1.info;
         var _loc3_:uint = uint(_loc2_.id);
         var _loc4_:int = this.batchSwapList.indexOf(_loc3_);
         if(_loc4_ != -1)
         {
            ++this._swapTimes;
            if(this._isFirstSwap)
            {
               this._allAwardInfo = _loc2_;
               this._isFirstSwap = false;
            }
            else
            {
               this.addActivityExchangeAward(this._allAwardInfo,_loc2_);
            }
            _loc5_ = uint(this.waitSwapMap[_loc3_]);
            if(this._swapTimes >= _loc5_)
            {
               this._swapTimes = 0;
               delete this.waitSwapMap[_loc3_];
               this.batchSwapList.splice(_loc4_,1);
               this.useNext();
               this._isFirstSwap = true;
               this._swapTimes = 0;
               ActivityExchangeAward.addAward(this._allAwardInfo);
               ActivityExchangeCommander.dispatchEvent(new ExchangeEvent(ExchangeEvent.BATCH_EXCHANGE_COMPLETE,this._allAwardInfo));
            }
         }
      }
      
      private function showExchange(param1:*) : void
      {
         var _loc2_:int = 0;
         if(this._isFirstSwap)
         {
            this._allAwardInfo = param1;
            this._isFirstSwap = false;
         }
         else
         {
            ++this._swapTimes;
            if(param1 is DailyActiveAwardInfo && this._allAwardInfo is DailyActiveAwardInfo)
            {
               this.addDailyActiveAward(this._allAwardInfo,param1);
            }
            if(param1 is ActivityExchangeAwardInfo && this._allAwardInfo is ActivityExchangeAwardInfo)
            {
               this.addActivityExchangeAward(this._allAwardInfo,param1);
            }
         }
         if(this.waitUseMap[this.batchUseList[0]] == 0)
         {
            delete this.waitUseMap[this.batchUseList[0]];
            this.batchUseList.splice(0,1);
            this._isFirstSwap = true;
            if(this._allAwardInfo is DailyActiveAwardInfo)
            {
               DailyActivityAward.addAward(this._allAwardInfo);
               _loc2_ = 0;
               while(_loc2_ < this._swapTimes)
               {
                  DailyActivityAward.reduceCostItemNum(this._allAwardInfo.dailyActivityId);
                  _loc2_++;
               }
            }
            if(this._allAwardInfo is ActivityExchangeAwardInfo)
            {
               ActivityExchangeAward.addAward(this._allAwardInfo);
            }
            this._swapTimes = 0;
         }
      }
      
      private function addDailyActiveAward(param1:DailyActiveAwardInfo, param2:DailyActiveAwardInfo) : void
      {
         var _loc3_:* = 0;
         if(param1.dailyActivityId == param2.dailyActivityId)
         {
            _loc3_ = 0;
            while(_loc3_ < param2.itemCount)
            {
               if(this.compareDailyActiveAward(param1.itemArr,param2.itemArr[_loc3_]))
               {
                  param2.itemArr.splice(_loc3_,1);
                  --param2.itemCount;
                  _loc3_--;
               }
               _loc3_++;
            }
            if(param2.itemArr)
            {
               param1.itemArr = param1.itemArr.concat(param2.itemArr);
               param1.itemCount += param2.itemCount;
            }
            param1.equiptArr = param1.equiptArr.concat(param2.equiptArr);
            param1.equiptCount += param2.equiptCount;
         }
      }
      
      private function compareDailyActiveAward(param1:Array, param2:SingleItemInfo) : Boolean
      {
         var _loc3_:uint = param1.length;
         var _loc4_:uint = uint(param2.itemID);
         var _loc5_:uint = uint(param2.itemNum);
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_)
         {
            if(param1[_loc6_].itemID == _loc4_)
            {
               param1[_loc6_].itemNum += _loc5_;
               return true;
            }
            _loc6_++;
         }
         return false;
      }
      
      private function addActivityExchangeAward(param1:ActivityExchangeAwardInfo, param2:ActivityExchangeAwardInfo) : void
      {
         var _loc3_:Vector.<ItemsLineInfo> = null;
         var _loc4_:* = 0;
         if(param1.id == param2.id)
         {
            param1.delCnt += param2.delCnt;
            param1.delVec = param1.delVec.concat(param2.delVec);
            _loc3_ = param2.addVec;
            _loc4_ = 0;
            while(_loc4_ < param2.addCnt)
            {
               if(this.compareActivityExchangeAward(param1.addVec,param2.addVec[_loc4_]))
               {
                  param2.addVec.splice(_loc4_,1);
                  --param2.addCnt;
                  _loc4_--;
               }
               _loc4_++;
            }
            if(param2.addVec)
            {
               param1.addVec = param1.addVec.concat(param2.addVec);
               param1.addCnt += param2.addCnt;
            }
         }
      }
      
      private function compareActivityExchangeAward(param1:Vector.<ItemsLineInfo>, param2:ItemsLineInfo) : Boolean
      {
         if(param2.type == 1)
         {
            return false;
         }
         var _loc3_:uint = param1.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(param1[_loc4_].id == param2.id)
            {
               param1[_loc4_].count += param2.count;
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      private function showNext() : void
      {
         this.isShow = true;
         var _loc1_:* = this.batchUseBak.shift();
         if(_loc1_ is DailyActiveAwardInfo)
         {
            DailyActivityAward.addAward(_loc1_);
         }
         else
         {
            ActivityExchangeAward.addAward(_loc1_);
         }
      }
   }
}

