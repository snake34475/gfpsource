package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.manager.TimeChangeManager;
   import com.gfp.core.utils.TimeUtil;
   import flash.events.Event;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class HunDunFreeGetButton extends BaseActivitySprite
   {
      
      private var _timer:int;
      
      public function HunDunFreeGetButton(param1:ActivityNodeInfo)
      {
         super(param1);
         TimeChangeManager.getInstance().addEventListener(TimeChangeManager.MINUTE_CHANGE,this.timeChangeHandle);
      }
      
      override public function addEvent() : void
      {
         super.addEvent();
         this._timer = setInterval(this.onTimer,1000);
      }
      
      override public function removeEvent() : void
      {
         super.removeEvent();
         clearInterval(this._timer);
      }
      
      private function timeChangeHandle(param1:Event) : void
      {
         var _loc2_:Date = TimeUtil.getSeverDateObject();
         var _loc3_:Boolean = _loc2_.month == 0 && _loc2_.date == 23 || _loc2_.date == 24;
         if(_loc3_ != visible)
         {
            DynamicActivityEntry.instance.updateAlign();
         }
         var _loc4_:Date = new Date(2016,0,24,1,23,0,0);
         if(_loc2_.time > _loc4_.time)
         {
            TimeChangeManager.getInstance().removeEventListener(TimeChangeManager.MINUTE_CHANGE,this.timeChangeHandle);
         }
      }
      
      private function onTimer() : void
      {
         _sprite["txtTime"].text = TimeUtil.formatSeconds(this.getCD());
      }
      
      private function getCD() : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:Date = TimeUtil.getSeverDateObject();
         if(_loc1_.month == 0 && _loc1_.date == 23 || _loc1_.date == 24)
         {
            _loc2_ = 10 - _loc1_.minutes % 10;
            if(_loc1_.hours == 12 && _loc1_.minutes >= 20 && _loc1_.minutes < 30)
            {
               _loc3_ = 29 - _loc1_.minutes;
               _loc4_ = 60 - _loc1_.seconds;
            }
            else if((_loc1_.hours == 12 && _loc1_.minutes >= 30 || _loc1_.hours == 13 && _loc1_.minutes < 28) && _loc2_ <= 7 && _loc2_ > 0)
            {
               _loc3_ = _loc2_ - 1;
               _loc4_ = 60 - _loc1_.seconds;
            }
            return _loc3_ * 60 + _loc4_;
         }
         return 0;
      }
      
      override public function executeShow() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:Date = TimeUtil.getSeverDateObject();
         if(_loc2_.month == 0 && _loc2_.date == 23 || _loc2_.date == 24)
         {
            _loc1_ = super.executeShow();
         }
         return _loc1_;
      }
   }
}

