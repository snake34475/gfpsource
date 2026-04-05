package com.gfp.app.manager
{
   import com.gfp.app.control.SystemTimeController;
   import com.gfp.app.feature.SystimeComeFeather;
   import com.gfp.app.time.SystimeEvent;
   import com.gfp.core.manager.CustomEventMananger;
   
   public class GongFuTimeManager
   {
      
      private static var _feather:SystimeComeFeather;
      
      public static const SYSTIME_IDS:Array = [205,206,207,208,209,210,211,212];
      
      setup();
      
      public function GongFuTimeManager()
      {
         super();
      }
      
      private static function setup() : void
      {
         _feather = new SystimeComeFeather(SYSTIME_IDS);
         _feather.addEventListener(SystimeEvent.TIME_COME,onTimeCome);
      }
      
      private static function onTimeCome(param1:SystimeEvent) : void
      {
         CustomEventMananger.dispatchEvent(param1);
      }
      
      public static function getFlashIds() : Array
      {
         var _loc4_:int = 0;
         var _loc1_:Array = [];
         var _loc2_:int = int(GongFuTimeManager.SYSTIME_IDS.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = int(GongFuTimeManager.SYSTIME_IDS[_loc3_]);
            if(SystemTimeController.instance.checkSysTimeAchieve(_loc4_))
            {
               _loc1_.push(_loc3_);
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public static function getUnStartIds() : Array
      {
         var _loc4_:int = 0;
         var _loc1_:Array = [];
         var _loc2_:int = int(GongFuTimeManager.SYSTIME_IDS.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = int(GongFuTimeManager.SYSTIME_IDS[_loc3_]);
            if(SystemTimeController.instance.checkSystemStartTime(_loc4_))
            {
               _loc1_.push(_loc3_);
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public static function getPassedIds() : Array
      {
         var _loc4_:int = 0;
         var _loc1_:Array = [];
         var _loc2_:int = int(GongFuTimeManager.SYSTIME_IDS.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = int(GongFuTimeManager.SYSTIME_IDS[_loc3_]);
            if(!SystemTimeController.instance.checkSystemEndTime(_loc4_))
            {
               _loc1_.push(_loc3_);
            }
            _loc3_++;
         }
         return _loc1_;
      }
   }
}

