package com.gfp.app.control
{
   import com.gfp.app.config.xml.SystemTimeXMLInfo;
   import com.gfp.app.info.SystemTimeInfo;
   import com.gfp.core.events.CommEvent;
   import com.gfp.core.events.TimeEvent;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.utils.StringConstants;
   import com.gfp.core.utils.TimerManager;
   import flash.events.EventDispatcher;
   import org.taomee.ds.HashMap;
   
   public class SystemTimeController
   {
      
      private static var _instance:SystemTimeController;
      
      public static const SYSTEMTIME_ACHIEVE:String = "SYSTEMTIME0";
      
      public static const SYSTEMTIME_UNACHIEVE:String = "SYSTEMTIME1";
      
      private var evtDisp:EventDispatcher;
      
      private var curTimes:HashMap;
      
      private var curTimesListener:HashMap;
      
      public function SystemTimeController(param1:SystemTimeControllerOnly)
      {
         super();
         this.evtDisp = new EventDispatcher();
         this.curTimes = new HashMap();
         this.curTimesListener = new HashMap();
         TimerManager.ed.addEventListener(TimeEvent.TIMER_EVERY_MINUTE,this.timerCheckTime);
      }
      
      public static function get instance() : SystemTimeController
      {
         if(!_instance)
         {
            _instance = new SystemTimeController(new SystemTimeControllerOnly());
         }
         return _instance;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         var _loc8_:int = 0;
         this.evtDisp.addEventListener(param1,param2,param3,param4,param5);
         var _loc6_:uint = uint(param1.split(StringConstants.SIGN)[1]);
         var _loc7_:SystemTimeInfo = SystemTimeXMLInfo.getSystemTimeInfoById(_loc6_);
         if(!_loc7_)
         {
            return;
         }
         if(this.curTimes.containsKey(_loc6_))
         {
            _loc8_ = int(this.curTimesListener.getValue(_loc6_));
            this.curTimesListener.remove(_loc6_);
            this.curTimesListener.add(_loc6_,_loc8_ + 1);
         }
         else
         {
            this.curTimesListener.add(_loc6_,1);
            this.curTimes.add(_loc6_,_loc7_);
         }
         this.timerCheckTime();
      }
      
      private function timerCheckTime(param1:TimeEvent = null) : void
      {
         var _loc2_:SystemTimeInfo = null;
         for each(_loc2_ in this.curTimes.getValues())
         {
            if(_loc2_.checkTime())
            {
               this.evtDisp.dispatchEvent(new CommEvent(SYSTEMTIME_ACHIEVE + StringConstants.SIGN + _loc2_.id,null));
            }
            else
            {
               this.evtDisp.dispatchEvent(new CommEvent(SYSTEMTIME_UNACHIEVE + StringConstants.SIGN + _loc2_.id,null));
            }
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this.evtDisp.removeEventListener(param1,param2,param3);
         var _loc4_:uint = uint(param1.split(StringConstants.SIGN)[1]);
         var _loc5_:int = int(this.curTimesListener.getValue(_loc4_));
         this.curTimesListener.remove(_loc4_);
         this.curTimesListener.add(_loc4_,_loc5_ - 1);
         if(_loc5_ <= 1)
         {
            this.curTimesListener.remove(_loc4_);
            this.curTimes.remove(_loc4_);
         }
      }
      
      public function checkSysTimeAchieve(param1:uint) : Boolean
      {
         var _loc2_:SystemTimeInfo = SystemTimeXMLInfo.getSystemTimeInfoById(param1);
         if(_loc2_)
         {
            return _loc2_.checkTime();
         }
         return false;
      }
      
      public function checkSpecificTimeAchieve(param1:uint, param2:Date) : Boolean
      {
         var _loc3_:SystemTimeInfo = SystemTimeXMLInfo.getSystemTimeInfoById(param1);
         if(_loc3_)
         {
            return _loc3_.checkTimeForOffer(param2);
         }
         return false;
      }
      
      public function checkSystemEndTime(param1:uint) : Boolean
      {
         var _loc2_:SystemTimeInfo = SystemTimeXMLInfo.getSystemTimeInfoById(param1);
         if(_loc2_)
         {
            return _loc2_.checkEndTime();
         }
         return false;
      }
      
      public function checkSystemStartTime(param1:uint) : Boolean
      {
         var _loc2_:SystemTimeInfo = SystemTimeXMLInfo.getSystemTimeInfoById(param1);
         if(_loc2_)
         {
            return _loc2_.checkStartTime();
         }
         return false;
      }
      
      public function getActivityTimeStr(param1:uint) : String
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:uint = 0;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         var _loc2_:String = "";
         var _loc3_:SystemTimeInfo = SystemTimeXMLInfo.getSystemTimeInfoById(param1);
         if(_loc3_)
         {
            _loc4_ = _loc3_.startTime.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = _loc3_.startTime[_loc5_].concat();
               _loc7_ = _loc3_.endTime[_loc5_].concat();
               _loc8_ = uint(_loc6_[_loc6_.length - 1]);
               _loc6_.splice(_loc6_.length - 2,2);
               _loc7_.splice(_loc7_.length - 2,2);
               _loc9_ = _loc6_.slice(0,3);
               _loc10_ = _loc6_.slice(3);
               _loc11_ = _loc7_.slice(0,3);
               _loc12_ = _loc7_.slice(3);
               if(_loc8_ == 0)
               {
                  _loc2_ += _loc9_.toString().split(",").join("/");
                  _loc2_ += " ";
                  _loc2_ += _loc10_.toString().split(",").join(":");
                  _loc2_ += "~";
                  _loc2_ += _loc11_.toString().split(",").join("/");
                  _loc2_ += " ";
                  _loc2_ += _loc12_.toString().split(",").join(":");
                  _loc2_ += "  ";
               }
               else if(_loc8_ == 1)
               {
                  _loc2_ += "每日";
                  _loc2_ += _loc10_.toString().split(",").join(":");
                  _loc2_ += "~";
                  _loc2_ += _loc12_.toString().split(",").join(":");
                  _loc2_ += "  ";
               }
               _loc5_++;
            }
         }
         return _loc2_;
      }
      
      public function getActivityOutTimeMsg(param1:uint) : String
      {
         var _loc2_:String = "";
         var _loc3_:SystemTimeInfo = SystemTimeXMLInfo.getSystemTimeInfoById(param1);
         if(_loc3_)
         {
            _loc2_ = _loc3_.outTimeMsg;
         }
         return _loc2_;
      }
      
      public function getActivitydisplayTimeStr(param1:uint) : String
      {
         var _loc2_:String = "";
         var _loc3_:SystemTimeInfo = SystemTimeXMLInfo.getSystemTimeInfoById(param1);
         if(_loc3_)
         {
            _loc2_ = _loc3_.displayTimeStr;
         }
         return _loc2_;
      }
      
      public function showOutTimeAlert(param1:int) : void
      {
         AlertManager.showSimpleAlarm(this.getActivityOutTimeMsg(param1));
      }
   }
}

class SystemTimeControllerOnly
{
   
   public function SystemTimeControllerOnly()
   {
      super();
   }
}
