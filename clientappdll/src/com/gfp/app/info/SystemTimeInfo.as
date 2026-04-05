package com.gfp.app.info
{
   import com.gfp.core.utils.TextUtil;
   import com.gfp.core.utils.TimeUtil;
   
   public class SystemTimeInfo
   {
      
      public var id:uint;
      
      private var desc:String;
      
      private var _startTime:Array;
      
      private var _endTime:Array;
      
      public var outTimeMsg:String = "";
      
      public var displayTimeStr:String;
      
      public var outAppModuleType:int;
      
      public var outAppModuleSrc:String = "";
      
      public var outLinkStr:String = "";
      
      public function SystemTimeInfo(param1:XML)
      {
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         super();
         this.id = uint(param1.@id);
         this.desc = param1.@desc;
         this.outTimeMsg = param1.@outTimeMsg;
         this.displayTimeStr = param1.@displayTimeStr;
         this._startTime = new Array();
         this._endTime = new Array();
         this.outAppModuleType = int(param1.@outAppModuleType);
         this.outAppModuleSrc = param1.@outAppModuleSrc;
         this.outLinkStr = param1.@outLinkStr;
         var _loc2_:XMLList = param1.descendants("time");
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = int(_loc3_.@type);
            _loc5_ = [];
            if(String(_loc3_.@week))
            {
               _loc5_ = String(_loc3_.@week).split("|");
            }
            this._startTime.push(this.formatTime(String(_loc3_.@startTime).split("-"),_loc4_,_loc5_));
            this._endTime.push(this.formatTime(String(_loc3_.@endTime).split("-"),_loc4_,_loc5_));
         }
         if(this.outAppModuleType != 0 && this.outAppModuleSrc != "")
         {
            _loc6_ = TextUtil.getAppModelHref(this.outAppModuleType,this.outAppModuleSrc,this.outLinkStr);
            this.outTimeMsg += _loc6_;
         }
      }
      
      private function formatTime(param1:Array, param2:int, param3:Array) : Array
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         if(param1)
         {
            _loc4_ = [0,0,0,0,0,0,param2,param3];
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               _loc4_[_loc5_] = param1[_loc5_];
               _loc5_++;
            }
         }
         return _loc4_;
      }
      
      public function get startTime() : Array
      {
         return this._startTime;
      }
      
      public function get endTime() : Array
      {
         return this._endTime;
      }
      
      public function checkTime() : Boolean
      {
         return this.checkTimeIndex() != -1;
      }
      
      public function checkTimeIndex() : int
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Date = null;
         var _loc5_:Date = null;
         var _loc6_:Date = null;
         var _loc7_:Date = null;
         var _loc8_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this._startTime.length)
         {
            _loc2_ = this._startTime[_loc1_];
            _loc3_ = this._endTime[_loc1_];
            _loc4_ = new Date(_loc2_[0],_loc2_[1] - 1,_loc2_[2],_loc2_[3],_loc2_[4],_loc2_[5]);
            _loc5_ = new Date(_loc3_[0],_loc3_[1] - 1,_loc3_[2],_loc3_[3],_loc3_[4],_loc3_[5]);
            if(TimeUtil.timeLimit(_loc4_,_loc5_))
            {
               if(_loc2_[6] == 0)
               {
                  return _loc1_;
               }
               if(_loc2_[6] == 1)
               {
                  _loc6_ = TimeUtil.getSeverDateObject();
                  _loc4_.setFullYear(_loc6_.getFullYear(),_loc6_.getMonth(),_loc6_.getDate());
                  _loc5_.setFullYear(_loc6_.getFullYear(),_loc6_.getMonth(),_loc6_.getDate());
                  if(TimeUtil.timeLimit(_loc4_,_loc5_))
                  {
                     return _loc1_;
                  }
               }
               else if(_loc2_[6] == 2)
               {
                  _loc7_ = TimeUtil.getSeverDateObject();
                  _loc4_.setFullYear(_loc7_.getFullYear(),_loc7_.getMonth(),_loc7_.getDate());
                  _loc5_.setFullYear(_loc7_.getFullYear(),_loc7_.getMonth(),_loc7_.getDate());
                  _loc8_ = 0;
                  while(_loc8_ < _loc2_[7].length)
                  {
                     if(_loc2_[7][_loc8_] == _loc7_.getDay() && Boolean(TimeUtil.timeLimit(_loc4_,_loc5_)))
                     {
                        return _loc1_;
                     }
                     _loc8_++;
                  }
               }
            }
            _loc1_++;
         }
         return -1;
      }
      
      public function checkTimeForOffer(param1:Date) : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Date = null;
         var _loc6_:Date = null;
         var _loc7_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._startTime.length)
         {
            _loc3_ = this._startTime[_loc2_];
            _loc4_ = this._endTime[_loc2_];
            _loc5_ = new Date(_loc3_[0],_loc3_[1] - 1,_loc3_[2],_loc3_[3],_loc3_[4],_loc3_[5]);
            _loc6_ = new Date(_loc4_[0],_loc4_[1] - 1,_loc4_[2],_loc4_[3],_loc4_[4],_loc4_[5]);
            if(TimeUtil.specificTimeLimit(param1,_loc5_,_loc6_))
            {
               if(_loc3_[6] == 0)
               {
                  return true;
               }
               if(_loc3_[6] == 1)
               {
                  _loc5_.setFullYear(param1.getFullYear(),param1.getMonth(),param1.getDate());
                  _loc6_.setFullYear(param1.getFullYear(),param1.getMonth(),param1.getDate());
                  if(TimeUtil.specificTimeLimit(param1,_loc5_,_loc6_))
                  {
                     return true;
                  }
               }
               else if(_loc3_[6] == 2)
               {
                  _loc5_.setFullYear(param1.getFullYear(),param1.getMonth(),param1.getDate());
                  _loc6_.setFullYear(param1.getFullYear(),param1.getMonth(),param1.getDate());
                  if(!TimeUtil.specificTimeLimit(param1,_loc5_,_loc6_))
                  {
                     return false;
                  }
                  _loc7_ = 0;
                  while(_loc7_ < _loc3_[7].length)
                  {
                     if(_loc3_[7][_loc7_] == param1.getDay())
                     {
                        return true;
                     }
                     _loc7_++;
                  }
               }
            }
            _loc2_++;
         }
         return false;
      }
      
      public function checkStartTime() : Boolean
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Date = null;
         var _loc5_:Date = null;
         var _loc6_:Date = null;
         var _loc7_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this._startTime.length)
         {
            _loc2_ = this._startTime[_loc1_];
            _loc3_ = this._endTime[_loc1_];
            _loc4_ = new Date(_loc2_[0],_loc2_[1] - 1,_loc2_[2],_loc2_[3],_loc2_[4],_loc2_[5]);
            if(!TimeUtil.endTimeLimit(_loc4_))
            {
               if(_loc2_[6] == 0)
               {
                  return true;
               }
               if(_loc2_[6] == 1)
               {
                  _loc5_ = TimeUtil.getSeverDateObject();
                  _loc4_.setFullYear(_loc5_.getFullYear(),_loc5_.getMonth(),_loc5_.getDate());
                  if(!TimeUtil.endTimeLimit(_loc4_))
                  {
                     return true;
                  }
               }
               else if(_loc2_[6] == 2)
               {
                  _loc6_ = TimeUtil.getSeverDateObject();
                  _loc7_ = 0;
                  while(_loc7_ < _loc2_[7].length)
                  {
                     if(_loc2_[7][_loc7_] == _loc6_.getDay())
                     {
                        return true;
                     }
                     _loc7_++;
                  }
               }
            }
            _loc1_++;
         }
         return false;
      }
      
      public function checkEndTime() : Boolean
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Date = null;
         var _loc5_:Date = null;
         var _loc6_:Date = null;
         var _loc7_:Date = null;
         var _loc8_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this._startTime.length)
         {
            _loc2_ = this._startTime[_loc1_];
            _loc3_ = this._endTime[_loc1_];
            _loc4_ = new Date(_loc2_[0],_loc2_[1] - 1,_loc2_[2],_loc2_[3],_loc2_[4],_loc2_[5]);
            _loc5_ = new Date(_loc3_[0],_loc3_[1] - 1,_loc3_[2],_loc3_[3],_loc3_[4],_loc3_[5]);
            if(TimeUtil.endTimeLimit(_loc5_))
            {
               if(_loc2_[6] == 0)
               {
                  return true;
               }
               if(_loc2_[6] == 1)
               {
                  _loc6_ = TimeUtil.getSeverDateObject();
                  _loc4_.setFullYear(_loc6_.getFullYear(),_loc6_.getMonth(),_loc6_.getDate());
                  _loc5_.setFullYear(_loc6_.getFullYear(),_loc6_.getMonth(),_loc6_.getDate());
                  if(TimeUtil.endTimeLimit(_loc5_))
                  {
                     return true;
                  }
               }
               else if(_loc2_[6] == 2)
               {
                  _loc7_ = TimeUtil.getSeverDateObject();
                  _loc8_ = 0;
                  while(_loc8_ < _loc2_[7].length)
                  {
                     if(_loc2_[7][_loc8_] == _loc7_.getDay())
                     {
                        return true;
                     }
                     _loc8_++;
                  }
               }
            }
            _loc1_++;
         }
         return false;
      }
   }
}

