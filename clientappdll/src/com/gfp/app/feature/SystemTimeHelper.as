package com.gfp.app.feature
{
   import com.gfp.app.config.xml.SystemTimeXMLInfo;
   import com.gfp.app.control.SystemTimeController;
   import com.gfp.app.info.SystemTimeInfo;
   import com.gfp.app.time.SystimeEvent;
   import com.gfp.core.utils.TimeUtil;
   import flash.events.EventDispatcher;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class SystemTimeHelper extends EventDispatcher
   {
      
      private var _id:int;
      
      private var _comeTimer:uint;
      
      public function SystemTimeHelper(param1:int)
      {
         super();
         this._id = param1;
      }
      
      public function start() : void
      {
         if(SystemTimeController.instance.checkSysTimeAchieve(this._id))
         {
            dispatchEvent(new SystimeEvent(SystimeEvent.STARTING));
         }
         else if(SystemTimeController.instance.checkSystemEndTime(this._id))
         {
            dispatchEvent(new SystimeEvent(SystimeEvent.NOT_START));
         }
         else
         {
            dispatchEvent(new SystimeEvent(SystimeEvent.HAS_END));
         }
         this.checkSystime();
      }
      
      private function checkSystime() : void
      {
         var _loc2_:Date = null;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Date = null;
         var _loc7_:Date = null;
         var _loc1_:SystemTimeInfo = SystemTimeXMLInfo.getSystemTimeInfoById(this._id);
         if(_loc1_)
         {
            _loc2_ = TimeUtil.getSeverDateObject();
            _loc3_ = this.getTodayArray(_loc1_);
            _loc4_ = this.getLastData(_loc3_[0]);
            _loc5_ = this.getLastData(_loc3_[1]);
            _loc6_ = _loc4_ ? _loc4_.date : null;
            _loc7_ = _loc5_ ? _loc5_.date : null;
            if(Boolean(_loc6_) && _loc6_ < _loc7_)
            {
               if(_loc6_)
               {
                  this._comeTimer = setTimeout(this.onTimeCome,_loc6_.time - _loc2_.time,true,_loc4_.index);
               }
            }
            else if(_loc7_)
            {
               this._comeTimer = setTimeout(this.onTimeCome,_loc7_.time - _loc2_.time,false,_loc5_.index);
            }
         }
      }
      
      private function onTimeCome(param1:Boolean, param2:int) : void
      {
         clearTimeout(this._comeTimer);
         var _loc3_:SystimeEvent = new SystimeEvent(SystimeEvent.TIME_COME);
         _loc3_.isStart = param1;
         _loc3_.index = param2;
         _loc3_.systemID = this._id;
         dispatchEvent(_loc3_);
         this._comeTimer = setTimeout(this.timeRest,2 * 1000);
      }
      
      private function timeRest() : void
      {
         clearTimeout(this._comeTimer);
         this.checkSystime();
      }
      
      public function destory() : void
      {
         clearTimeout(this._comeTimer);
      }
      
      private function getTodayArray(param1:SystemTimeInfo) : Array
      {
         var _loc8_:Array = null;
         var _loc9_:Date = null;
         var _loc10_:Array = null;
         var _loc11_:Date = null;
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Array = [_loc2_,_loc3_];
         var _loc5_:int = int(param1.startTime.length);
         var _loc6_:Date = TimeUtil.getSeverDateObject();
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            _loc8_ = param1.startTime[_loc7_];
            _loc9_ = new Date(_loc8_[0],_loc8_[1] - 1,_loc8_[2],0,0,0);
            _loc10_ = param1.endTime[_loc7_];
            _loc11_ = new Date(_loc10_[0],_loc10_[1] - 1,_loc10_[2],_loc10_[3],_loc10_[4],_loc10_[5]);
            if(_loc6_ > _loc9_ && _loc6_ < _loc11_)
            {
               _loc2_.push(_loc8_);
               _loc3_.push(_loc10_);
            }
            _loc7_++;
         }
         return _loc4_;
      }
      
      private function getLastData(param1:Array) : Object
      {
         var _loc4_:Date = null;
         var _loc5_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:Date = null;
         var _loc2_:int = int(param1.length);
         var _loc3_:Date = TimeUtil.getSeverDateObject();
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_)
         {
            _loc7_ = param1[_loc6_];
            _loc8_ = new Date(_loc3_.getFullYear(),_loc3_.getMonth(),_loc3_.getDate(),_loc7_[3],_loc7_[4],_loc7_[5]);
            if(_loc8_ >= _loc3_)
            {
               if(_loc4_ == null || _loc4_ > _loc8_)
               {
                  _loc4_ = _loc8_;
                  _loc5_ = _loc6_;
               }
            }
            _loc6_++;
         }
         if(_loc4_)
         {
            return {
               "date":_loc4_,
               "index":_loc5_
            };
         }
         return null;
      }
   }
}

