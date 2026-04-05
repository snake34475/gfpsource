package com.gfp.app.cmdl
{
   import com.gfp.app.daily.DailyAwardItem;
   import com.gfp.app.toolBar.EverydaySignEntry;
   import com.gfp.core.manager.MainManager;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import org.taomee.bean.BaseBean;
   
   public class DailyAwardCmdListener extends BaseBean
   {
      
      private static var _olTime:uint;
      
      private static const ONE_HOUR_SECOND:uint = 3600;
      
      private var _itemList:Array = new Array();
      
      private var _maxTimes:uint;
      
      private var _timer:Timer;
      
      public function DailyAwardCmdListener()
      {
         super();
      }
      
      public static function getTime() : uint
      {
         return _olTime;
      }
      
      override public function start() : void
      {
         finish();
      }
      
      private function initView() : void
      {
         this.addItem(new DailyAwardItem(0,0,0));
         this.addItem(new DailyAwardItem(1,ONE_HOUR_SECOND * 0.5,ONE_HOUR_SECOND * 0.5));
         var _loc1_:int = 1;
         while(_loc1_ <= 5)
         {
            this.addItem(new DailyAwardItem(_loc1_ + 1,_loc1_ * ONE_HOUR_SECOND,ONE_HOUR_SECOND));
            _loc1_++;
         }
      }
      
      private function addItem(param1:DailyAwardItem) : void
      {
         this._itemList.push(param1);
      }
      
      private function initTimer() : void
      {
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this._timer.start();
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         _olTime += 1;
         if(_olTime >= MainManager.battleTimeLimit)
         {
            this.stopTimer();
         }
         this.updateAwardItem();
      }
      
      private function updateAwardItem() : void
      {
         var _loc3_:DailyAwardItem = null;
         var _loc4_:DailyAwardItem = null;
         var _loc1_:int = int(this._itemList.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc4_ = this._itemList[_loc2_] as DailyAwardItem;
            _loc4_.updateView(_olTime);
            _loc2_++;
         }
         for each(_loc3_ in this._itemList)
         {
            if(_loc3_.getable)
            {
               EverydaySignEntry.instance.hasAwardAlert();
               return;
            }
         }
         EverydaySignEntry.instance.clearAwradAlert();
      }
      
      private function stopTimer() : void
      {
      }
   }
}

