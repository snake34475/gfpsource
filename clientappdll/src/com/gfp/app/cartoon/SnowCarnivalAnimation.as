package com.gfp.app.cartoon
{
   public class SnowCarnivalAnimation
   {
      
      private static const TIME_LIMIT_MIN:Array = [2011,11,30,0,0,0];
      
      private static const TIME_LIMIT_MAX:Array = [2012,1,5,23,59,59];
      
      public function SnowCarnivalAnimation()
      {
         super();
      }
      
      public static function whenTimerHandler() : void
      {
      }
      
      private static function getDate(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : Date
      {
         var _loc7_:Date = new Date();
         _loc7_.setFullYear(param1,param2 - 1,param3);
         _loc7_.setHours(param4,param5,param6);
         return _loc7_;
      }
   }
}

