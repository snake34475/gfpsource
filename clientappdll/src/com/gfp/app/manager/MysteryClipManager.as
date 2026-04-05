package com.gfp.app.manager
{
   import com.gfp.core.CommandID;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.ActivityType;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.data.DataChangeEvent;
   import org.taomee.net.SocketEvent;
   
   public class MysteryClipManager
   {
      
      private static var _instance:MysteryClipManager;
      
      private static var _dataList:Vector.<MysteryClipItemVo>;
      
      public static var dataListener:EventDispatcher;
      
      public function MysteryClipManager()
      {
         super();
      }
      
      public static function get instance() : MysteryClipManager
      {
         if(_instance == null)
         {
            _instance = new MysteryClipManager();
         }
         return _instance;
      }
      
      public static function addListener() : void
      {
         SocketConnection.addCmdListener(CommandID.GET_ACTIVITY_INFO,onAcInfoHandler);
         SocketConnection.send(CommandID.GET_ACTIVITY_INFO,ActivityType.MYSTERY_CLIP1);
         dataListener = new EventDispatcher();
         SocketConnection.addCmdListener(CommandID.MYSTERY_DATA,onGetMysteryData);
      }
      
      private static function onAcInfoHandler(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GET_ACTIVITY_INFO,onAcInfoHandler);
         SocketConnection.send(CommandID.GET_ACTIVITY_INFO,ActivityType.MYSTERY_CLIP2);
      }
      
      private static function onGetMysteryData(param1:SocketEvent) : void
      {
         var _loc4_:MysteryClipItemVo = null;
         if(!_dataList)
         {
            _dataList = new Vector.<MysteryClipItemVo>(8);
         }
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         while(_loc3_ > 0)
         {
            if(_loc5_ < 8)
            {
               _loc4_ = _dataList[_loc5_];
               if(!_loc4_)
               {
                  _loc4_ = new MysteryClipItemVo();
                  _dataList[_loc5_] = _loc4_;
               }
               else
               {
                  _loc4_.resert();
               }
               _loc4_.swapId = _loc2_.readUnsignedInt();
            }
            else
            {
               _loc6_ = _loc5_ - 8;
               _loc4_ = _dataList[_loc6_];
               _loc4_.isBuyed = _loc2_.readUnsignedInt() == 0;
            }
            _loc3_--;
            _loc5_++;
         }
         dataListener.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE,"",null));
      }
      
      public static function get dataList() : Vector.<MysteryClipItemVo>
      {
         return _dataList;
      }
   }
}

import com.gfp.core.config.xml.ActivityExchangeXMLInfo;
import com.gfp.core.info.dailyActivity.ActivityExchangeInfo;

class MysteryClipItemVo
{
   
   private var _itemid:int;
   
   private var _coinPrice:int;
   
   private var _tbPrice:int;
   
   private var _swapId:int;
   
   private var _leftCount:int = -1;
   
   private var _isBuyed:Boolean;
   
   public function MysteryClipItemVo()
   {
      super();
   }
   
   public function get itemid() : int
   {
      return this._itemid;
   }
   
   public function set itemid(param1:int) : void
   {
      this._itemid = param1;
   }
   
   public function get coinPrice() : int
   {
      return this._coinPrice;
   }
   
   public function set coinPrice(param1:int) : void
   {
      this._coinPrice = param1;
   }
   
   public function get tbPrice() : int
   {
      return this._tbPrice;
   }
   
   public function set tbPrice(param1:int) : void
   {
      this._tbPrice = param1;
   }
   
   public function get swapId() : int
   {
      return this._swapId;
   }
   
   public function set swapId(param1:int) : void
   {
      this._swapId = param1;
      if(this._swapId == 0)
      {
         return;
      }
      var _loc2_:ActivityExchangeInfo = ActivityExchangeXMLInfo.getActivityById(this._swapId);
      this.itemid = _loc2_.rewardVect[0].id;
      if(_loc2_.costVect[0].id == 1)
      {
         this.coinPrice = _loc2_.costVect[0].count;
      }
      else
      {
         this.tbPrice = _loc2_.costVect[0].count;
      }
   }
   
   public function get leftCount() : int
   {
      return this._leftCount;
   }
   
   public function set leftCount(param1:int) : void
   {
      this._leftCount = param1;
   }
   
   public function get isBuyed() : Boolean
   {
      return this._isBuyed;
   }
   
   public function set isBuyed(param1:Boolean) : void
   {
      this._isBuyed = param1;
   }
   
   public function resert() : void
   {
      this.itemid = 0;
      this.coinPrice = 0;
      this.tbPrice = 0;
      this.swapId = 0;
      this.leftCount = -1;
      this.isBuyed = false;
   }
}
