package com.gfp.app.ui.activity
{
   import com.gfp.app.config.xml.SystemTimeXMLInfo;
   import com.gfp.app.feature.SystimeComeFeather;
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.info.SystemTimeInfo;
   import com.gfp.app.time.SystimeEvent;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.utils.TimeUtil;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public class FengKuangDuoBaoButton extends BaseActivitySprite
   {
      
      private var _countDownFeather:SystimeComeFeather;
      
      private var _feather:SystimeComeFeather;
      
      private var _countDownInfo:SystemTimeInfo;
      
      private var _activeInfo:SystemTimeInfo;
      
      private var _timer:int;
      
      private var _countDownEndSeconds:int;
      
      public function FengKuangDuoBaoButton(param1:ActivityNodeInfo)
      {
         super(param1);
         this._countDownInfo = SystemTimeXMLInfo.getSystemTimeInfoById(214);
         this._activeInfo = SystemTimeXMLInfo.getSystemTimeInfoById(215);
         this._countDownFeather = new SystimeComeFeather([214]);
         this._countDownFeather.addEventListener(SystimeEvent.TIME_COME,this.onTimeCome);
         this._feather = new SystimeComeFeather([215]);
         this._feather.addEventListener(SystimeEvent.TIME_COME,this.onTimeCome);
         this.update();
      }
      
      protected function onTimeCome(param1:SystimeEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:Date = null;
         if(param1.currentTarget == this._countDownFeather)
         {
            if(param1.isStart)
            {
               _loc2_ = this._countDownInfo.checkTimeIndex();
               if(_loc2_ != -1)
               {
                  _loc3_ = this._countDownInfo.endTime[_loc2_];
                  _loc4_ = new Date(_loc3_[0],_loc3_[1] - 1,_loc3_[2],_loc3_[3],_loc3_[4],0,0);
                  this._countDownEndSeconds = _loc4_.time * 0.001;
                  this._timer = setInterval(this.onTimer,1000);
                  this.onTimer();
                  DynamicActivityEntry.instance.updateAlign();
               }
               else
               {
                  clearInterval(this._timer);
                  _sprite["timeLabel"].text = "00:00";
               }
            }
            else
            {
               clearInterval(this._timer);
               _sprite["timeLabel"].text = "00:00";
            }
         }
         else if(param1.isStart == false)
         {
            clearInterval(this._timer);
            setTimeout(DynamicActivityEntry.instance.updateAlign,1000);
         }
      }
      
      override public function executeShow() : Boolean
      {
         var _loc1_:Boolean = super.executeShow();
         if(_loc1_)
         {
            _loc1_ = this._countDownInfo.checkTime() || this._activeInfo.checkTime();
            if(_loc1_)
            {
               this.update();
            }
            return _loc1_;
         }
         return false;
      }
      
      private function update() : void
      {
         var _loc2_:Array = null;
         var _loc3_:Date = null;
         clearInterval(this._timer);
         var _loc1_:int = this._countDownInfo.checkTimeIndex();
         if(_loc1_ != -1)
         {
            _loc2_ = this._countDownInfo.endTime[_loc1_];
            _loc3_ = new Date(_loc2_[0],_loc2_[1] - 1,_loc2_[2],_loc2_[3],_loc2_[4],0,0);
            this._countDownEndSeconds = _loc3_.time * 0.001;
            this._timer = setInterval(this.onTimer,1000);
            this.onTimer();
         }
         else
         {
            clearInterval(this._timer);
            _sprite["timeLabel"].text = "00:00";
         }
      }
      
      private function onTimer() : void
      {
         var _loc1_:int = this._countDownEndSeconds - TimeUtil.getServerSecond();
         _sprite["timeLabel"].text = TimeUtil.formatSeconds(Math.max(0,_loc1_));
      }
   }
}

