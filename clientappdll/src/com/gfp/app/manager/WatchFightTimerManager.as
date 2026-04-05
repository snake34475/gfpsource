package com.gfp.app.manager
{
   import com.gfp.core.events.CommEvent;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.net.SocketItemInfo;
   import com.gfp.core.net.SocketListPackage;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.net.tmf.TMF;
   
   public class WatchFightTimerManager extends EventDispatcher
   {
      
      private static var _instance:WatchFightTimerManager;
      
      public static const WATCH_TIME_START_EVENT:String = "watch_time_start_event";
      
      public static const WATCH_TIME_END_EVENT:String = "watch_time_end_event";
      
      public static const INTERVAL_TIME:uint = 30;
      
      public static const MAX_REQUEST_COUNT:uint = 3;
      
      public static const REQUEST_INTERVAL_TIMES:Array = [0,3000,5000,3000];
      
      private var _socketListPackage:SocketListPackage;
      
      private var timeCountVal:uint;
      
      private var curIndex:int;
      
      private var timeInterval:uint;
      
      private var leftTimes:int;
      
      private var leftTimeCount:uint;
      
      private var getNextPackegTimeCountFlag:Boolean;
      
      public function WatchFightTimerManager()
      {
         super();
      }
      
      public static function get instance() : WatchFightTimerManager
      {
         if(!_instance)
         {
            _instance = new WatchFightTimerManager();
         }
         return _instance;
      }
      
      public function set socketListPackage(param1:SocketListPackage) : void
      {
         this._socketListPackage = param1;
      }
      
      public function start() : void
      {
         if(Boolean(this._socketListPackage) && this._socketListPackage.packageList.length > 0)
         {
            this.leftTimeCount = 0;
            this.curIndex = 0;
            this.timeCountVal = this._socketListPackage.packageList[0].time;
            this.timeInterval = setInterval(this.timerIntervalHandler,INTERVAL_TIME);
            dispatchEvent(new CommEvent(WATCH_TIME_START_EVENT));
         }
      }
      
      private function timerIntervalHandler() : void
      {
         var _loc1_:SocketItemInfo = null;
         var _loc2_:Class = null;
         var _loc3_:Number = NaN;
         this.timeCountVal += INTERVAL_TIME;
         this.curIndex;
         while(this.curIndex < this._socketListPackage.packageList.length)
         {
            _loc1_ = this._socketListPackage.packageList[this.curIndex];
            if(_loc1_.time > this.timeCountVal)
            {
               return;
            }
            if(_loc1_.data == null)
            {
               SocketConnection.mainSocket.dispatchCommand(_loc1_.cmdId,_loc1_.headInfo,null);
            }
            else
            {
               if(_loc1_.data is ByteArray)
               {
                  ByteArray(_loc1_.data).position = 0;
               }
               _loc2_ = TMF.getClass(_loc1_.cmdId);
               SocketConnection.mainSocket.dispatchCommand(_loc1_.cmdId,_loc1_.headInfo,new _loc2_(_loc1_.data));
            }
            ++this.curIndex;
         }
         if(this.curIndex == this._socketListPackage.packageList.length)
         {
            if(WatchFightManager.instance.videoPackageEnd)
            {
               WatchFightManager.instance.leaveWatchFight();
            }
            else if(this.getNextPackegTimeCountFlag)
            {
               if(this.leftTimes <= MAX_REQUEST_COUNT)
               {
                  this.leftTimeCount += INTERVAL_TIME;
                  _loc3_ = this.leftTimeCount - REQUEST_INTERVAL_TIMES[this.leftTimes];
                  if(_loc3_ > 0 && _loc3_ <= INTERVAL_TIME)
                  {
                     this.leftTimeCount = 0;
                     WatchFightManager.instance.getFollowPackage();
                  }
               }
               else
               {
                  WatchFightManager.instance.leaveWatchFight();
               }
            }
            else
            {
               WatchFightManager.instance.getFollowPackage();
            }
         }
      }
      
      public function nextPackage() : void
      {
         if(this._socketListPackage.packageList.length > this.curIndex + 1)
         {
            this.timeCountVal = this._socketListPackage.packageList[this.curIndex + 1].time;
         }
      }
      
      public function getPackageError() : void
      {
         if(this.timeInterval != 0)
         {
            this.getNextPackegTimeCountFlag = true;
            ++this.leftTimes;
         }
      }
      
      public function getPackageSuc() : void
      {
         if(this.timeInterval != 0)
         {
            this.getNextPackegTimeCountFlag = false;
         }
      }
      
      public function destroy() : void
      {
         if(this.timeInterval != 0)
         {
            clearInterval(this.timeInterval);
            this.timeInterval = 0;
            this._socketListPackage = null;
            dispatchEvent(new CommEvent(WATCH_TIME_END_EVENT));
         }
      }
   }
}

