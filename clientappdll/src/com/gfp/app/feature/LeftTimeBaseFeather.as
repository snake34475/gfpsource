package com.gfp.app.feature
{
   import com.gfp.core.utils.TextUtil;
   import com.gfp.core.utils.TimeUtil;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   
   public class LeftTimeBaseFeather
   {
      
      private var _timer:uint;
      
      private var _totalTime:int;
      
      private var _startTime:int;
      
      private var _type:int = 0;
      
      private var _callBack:Function;
      
      private var _isHour:Boolean;
      
      protected var _isDown:Boolean;
      
      public function LeftTimeBaseFeather(param1:int, param2:Function, param3:int = 1, param4:Boolean = false)
      {
         super();
         this._type = param3;
         this._totalTime = param1;
         this._callBack = param2;
         this._isHour = param4;
      }
      
      public function start() : void
      {
         this.clear();
         if(this._isHour)
         {
            this._timer = setInterval(this.onTimer,60000);
         }
         else
         {
            this._timer = setInterval(this.onTimer,1000);
         }
         this._startTime = TimeUtil.getSeverDateObject().time;
         this.onTimer();
      }
      
      public function clear() : void
      {
         if(this._type == 1)
         {
            this.setScreenText("00:00");
         }
         else
         {
            this.setScreenText("0");
         }
         clearTimeout(this._timer);
      }
      
      private function onTimer() : void
      {
         var _loc4_:String = null;
         var _loc1_:int = TimeUtil.getSeverDateObject().time - this._startTime;
         var _loc2_:Date = new Date();
         var _loc3_:int = this._totalTime - _loc1_;
         _loc2_.time = _loc3_;
         if(_loc3_ > 0)
         {
            if(this._isHour)
            {
               _loc4_ = TextUtil.completeString(_loc2_.hoursUTC.toString()) + ":" + TextUtil.completeString(_loc2_.minutesUTC.toString());
            }
            else
            {
               _loc4_ = TextUtil.completeString(_loc2_.minutesUTC.toString()) + ":" + TextUtil.completeString(_loc2_.secondsUTC.toString());
            }
            if(this._type == 1)
            {
               this.setScreenText(_loc4_);
            }
            else
            {
               this.setScreenText((_loc3_ / 1000).toString());
            }
         }
         else
         {
            this.clear();
            if(this._callBack != null)
            {
               this._callBack();
            }
         }
      }
      
      protected function setScreenText(param1:String) : void
      {
      }
      
      public function destroy() : void
      {
         this.clear();
      }
   }
}

