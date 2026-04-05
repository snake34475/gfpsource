package com.gfp.app.manager
{
   import com.gfp.core.utils.TimeUtil;
   
   public class TradeAuctionManager
   {
      
      private static var _instance:TradeAuctionManager;
      
      private var _itemIDs:Array = [1500580,1500354,1570011,1500579,1500637,1500566];
      
      public function TradeAuctionManager()
      {
         super();
      }
      
      public static function getInstance() : TradeAuctionManager
      {
         return _instance = _instance || new TradeAuctionManager();
      }
      
      public function inActivityTime() : Boolean
      {
         return true;
      }
      
      public function getCurrentTimeIndex() : int
      {
         if(this.inActivityTime() == false)
         {
            return -1;
         }
         var _loc1_:Date = TimeUtil.getSeverDateObject();
         if(_loc1_.hours > 18)
         {
            return -2;
         }
         if(_loc1_.hours == 13 || _loc1_.hours == 18)
         {
            return int(_loc1_.minutes * 0.1);
         }
         return -1;
      }
      
      public function getCurrentItemID() : int
      {
         var _loc1_:int = this.getCurrentTimeIndex();
         return _loc1_ < 0 ? -1 : int(this._itemIDs[_loc1_]);
      }
      
      public function getNextTimeIndex() : int
      {
         var _loc1_:int = this.getCurrentTimeIndex();
         return _loc1_ < 0 ? -1 : ++_loc1_;
      }
      
      public function getNextTime() : String
      {
         var _loc2_:int = 0;
         if(this.inActivityTime() == false)
         {
            return "00:00";
         }
         var _loc1_:Date = TimeUtil.getSeverDateObject();
         if(_loc1_.hours > 18)
         {
            return "13:00";
         }
         if(_loc1_.hours == 18)
         {
            _loc2_ = int(_loc1_.minutes * 0.1);
            if(_loc2_ == 5)
            {
               return "13:00";
            }
            return "18:" + (_loc2_ + 1) * 10;
         }
         if(_loc1_.hours > 13)
         {
            return "18:00";
         }
         if(_loc1_.hours == 13)
         {
            _loc2_ = int(_loc1_.minutes * 0.1);
            if(_loc2_ == 5)
            {
               return "18:00";
            }
            return "13:" + (_loc2_ + 1) * 10;
         }
         return "13:00";
      }
   }
}

