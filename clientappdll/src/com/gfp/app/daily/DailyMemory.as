package com.gfp.app.daily
{
   public class DailyMemory
   {
      
      private static var _instance:DailyMemory = new DailyMemory();
      
      private var hasAward:Boolean;
      
      public function DailyMemory()
      {
         super();
      }
      
      public static function get getAwardAble() : Boolean
      {
         return _instance.hasAward;
      }
      
      public static function set getAwardAble(param1:Boolean) : void
      {
         _instance.hasAward = param1;
      }
   }
}

