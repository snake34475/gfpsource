package com.gfp.app.config.xml
{
   import com.gfp.app.info.ActivityTansInfo;
   
   public class ActivityTransportXMLInfo
   {
      
      private static var _transList:Array;
      
      private static var xmlClass:Class = ActivityTransportXMLInfo_xmlClass;
      
      setup();
      
      public function ActivityTransportXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc3_:XML = null;
         var _loc1_:XML = XML(new xmlClass());
         _transList = new Array();
         var _loc2_:XMLList = _loc1_.descendants("transport");
         for each(_loc3_ in _loc2_)
         {
            _transList.push(new ActivityTansInfo(_loc3_));
         }
         _transList.sortOn("prio",Array.DESCENDING | Array.NUMERIC);
      }
      
      public static function getAllTansport() : Array
      {
         return _transList;
      }
   }
}

