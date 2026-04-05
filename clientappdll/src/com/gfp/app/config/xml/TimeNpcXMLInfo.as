package com.gfp.app.config.xml
{
   import com.gfp.app.info.TimeNpcInfo;
   import org.taomee.ds.HashMap;
   
   public class TimeNpcXMLInfo
   {
      
      private static var xmlClass:Class = TimeNpcXMLInfo_xmlClass;
      
      private static var _timeNpcs:HashMap = new HashMap();
      
      setup();
      
      public function TimeNpcXMLInfo()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc3_:XML = null;
         var _loc4_:TimeNpcInfo = null;
         var _loc1_:XML = XML(new xmlClass());
         var _loc2_:XMLList = _loc1_.descendants("timeNpc");
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = new TimeNpcInfo(_loc3_);
            _timeNpcs.add(_loc4_.id,_loc4_);
         }
      }
      
      public static function getNpcTimeByMapId(param1:uint) : Array
      {
         var _loc4_:TimeNpcInfo = null;
         var _loc2_:Array = [];
         var _loc3_:Array = _timeNpcs.getValues();
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.mapId == param1)
            {
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
      
      public static function getAllNpcTime() : Array
      {
         return _timeNpcs.getValues();
      }
   }
}

