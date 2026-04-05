package com.gfp.app.ui.activity
{
   import com.gfp.app.config.xml.SystemTimeXMLInfo;
   import com.gfp.app.feature.SystimeComeFeather;
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.info.SystemTimeInfo;
   import com.gfp.app.time.SystimeEvent;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.utils.TimeUtil;
   import flash.text.TextField;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public class MultiFoldExpButton extends BaseActivitySprite
   {
      
      private var _timeLabel:TextField;
      
      private var _sysTimeInfo:SystemTimeInfo;
      
      private var _startSeconds:int;
      
      private var _endSeconds:int;
      
      private var _dateIndex:int;
      
      private var _timer:int;
      
      private var _startCutDown:Boolean;
      
      private var _feather:SystimeComeFeather;
      
      public function MultiFoldExpButton(param1:ActivityNodeInfo)
      {
         super(param1);
         this._sysTimeInfo = SystemTimeXMLInfo.getSystemTimeInfoById(117);
         var _loc2_:int = TimeUtil.getSeverDateObject().date - 1;
         if(_loc2_ > 2)
         {
            _loc2_ = 0;
         }
         var _loc3_:Array = this._sysTimeInfo.startTime[_loc2_];
         var _loc4_:Date = new Date(_loc3_[0],_loc3_[1] - 1,_loc3_[2],_loc3_[3],_loc3_[4],_loc3_[5]);
         this._startSeconds = _loc4_.time * 0.001;
         _loc3_ = this._sysTimeInfo.endTime[_loc2_];
         _loc4_ = new Date(_loc3_[0],_loc3_[1] - 1,_loc3_[2],_loc3_[3],_loc3_[4],_loc3_[5]);
         this._endSeconds = _loc4_.time * 0.001;
         this._timeLabel = _sprite["timeLabel"] as TextField;
         this._feather = new SystimeComeFeather([117]);
         this._feather.addEventListener(SystimeEvent.TIME_COME,this.onTimeCome);
         if(this._sysTimeInfo.checkTime())
         {
            this._timer = setInterval(this.onTimer,1000);
            this.onTimer();
         }
      }
      
      protected function onTimeCome(param1:SystimeEvent) : void
      {
         if(param1.isStart)
         {
            this._timer = setInterval(this.onTimer,1000);
            this.onTimer();
            DynamicActivityEntry.instance.updateAlign();
         }
         else
         {
            clearInterval(this._timer);
            setTimeout(DynamicActivityEntry.instance.updateAlign,1000);
         }
      }
      
      override public function executeShow() : Boolean
      {
         var _loc2_:Array = null;
         var _loc1_:Boolean = super.executeShow();
         if(_loc1_)
         {
            this._dateIndex = this._sysTimeInfo.checkTimeIndex();
            if(this._dateIndex != -1)
            {
               _loc2_ = this._sysTimeInfo.endTime[this._dateIndex];
               this._endSeconds = new Date(_loc2_[0],_loc2_[1] - 1,_loc2_[2],_loc2_[3],_loc2_[4],_loc2_[5]).time * 0.001;
               this.onTimer();
            }
            return this._dateIndex != -1;
         }
         return false;
      }
      
      private function update() : void
      {
         clearInterval(this._timer);
         if(TimeUtil.getServerSecond() < this._endSeconds)
         {
            this._timer = setInterval(this.onTimer,1000);
            this.onTimer();
         }
      }
      
      private function onTimer() : void
      {
         var _loc1_:int = this._endSeconds - TimeUtil.getServerSecond();
         this._timeLabel.text = TimeUtil.formatSeconds(Math.max(0,_loc1_),true);
      }
   }
}

