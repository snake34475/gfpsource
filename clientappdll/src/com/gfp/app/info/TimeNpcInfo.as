package com.gfp.app.info
{
   import com.gfp.core.config.xml.NpcXMLInfo;
   import com.gfp.core.utils.TimeUtil;
   
   public class TimeNpcInfo
   {
      
      public var id:uint;
      
      public var npcId:uint;
      
      public var mapId:uint;
      
      public var visible:Boolean;
      
      private var _startTime:Array;
      
      private var _endTime:Array;
      
      public function TimeNpcInfo(param1:XML)
      {
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         super();
         this.id = uint(param1.@id);
         this.npcId = uint(param1.@npcId);
         this.mapId = NpcXMLInfo.getNpcMapId(this.npcId);
         this.visible = uint(param1.@visible) == 1;
         this._startTime = new Array();
         this._endTime = new Array();
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
                  return true;
               }
               if(_loc2_[6] == 1)
               {
                  _loc6_ = TimeUtil.getSeverDateObject();
                  _loc4_.setFullYear(_loc6_.getFullYear(),_loc6_.getMonth(),_loc6_.getDate());
                  _loc5_.setFullYear(_loc6_.getFullYear(),_loc6_.getMonth(),_loc6_.getDate());
                  if(TimeUtil.timeLimit(_loc4_,_loc5_))
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
                        _loc4_.setFullYear(_loc7_.getFullYear(),_loc7_.getMonth(),_loc7_.getDate());
                        _loc5_.setFullYear(_loc7_.getFullYear(),_loc7_.getMonth(),_loc7_.getDate());
                        if(TimeUtil.timeLimit(_loc4_,_loc5_))
                        {
                           return true;
                        }
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

