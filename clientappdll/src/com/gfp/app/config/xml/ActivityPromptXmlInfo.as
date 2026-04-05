package com.gfp.app.config.xml
{
   import com.gfp.app.info.ActivityPromptInfo;
   import org.taomee.ds.HashMap;
   
   public class ActivityPromptXmlInfo
   {
      
      private static var _activityHash:HashMap;
      
      private static var xmlClass:Class = ActivityPromptXmlInfo_xmlClass;
      
      setup();
      
      public function ActivityPromptXmlInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc3_:XML = null;
         var _loc4_:ActivityPromptInfo = null;
         var _loc1_:XML = XML(new xmlClass());
         _activityHash = new HashMap();
         var _loc2_:XMLList = _loc1_.elements("node");
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = new ActivityPromptInfo(_loc3_);
            _activityHash.add(_loc4_.id,_loc4_);
         }
      }
      
      public static function getActivityInfo(param1:int) : ActivityPromptInfo
      {
         return _activityHash.getValue(param1);
      }
      
      public static function getActivityList() : Array
      {
         var _loc1_:Array = _activityHash.getValues();
         _loc1_.sortOn("id",Array.NUMERIC);
         return _loc1_;
      }
      
      public static function removeActivity(param1:uint) : void
      {
         _activityHash.remove(param1);
      }
   }
}

