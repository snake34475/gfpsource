package com.gfp.app.config.xml
{
   import com.gfp.app.info.SystemTimeInfo;
   import org.taomee.ds.HashMap;
   
   public class SystemTimeXMLInfo
   {
      
      private static var xmlClass:Class = SystemTimeXMLInfo_xmlClass;
      
      private static var _sysTimes:HashMap = new HashMap();
      
      setup();
      
      public function SystemTimeXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc3_:XML = null;
         var _loc1_:XML = XML(new xmlClass());
         var _loc2_:XMLList = _loc1_.descendants("systime");
         for each(_loc3_ in _loc2_)
         {
            if(_sysTimes.containsKey(uint(_loc3_.@id)))
            {
               throw new Error("系统时间限制中出现重复ID，请修改。(systime.xml)");
            }
            _sysTimes.add(uint(_loc3_.@id),new SystemTimeInfo(_loc3_));
         }
      }
      
      public static function getSystemTimeInfoById(param1:uint) : SystemTimeInfo
      {
         return _sysTimes.getValue(param1) as SystemTimeInfo;
      }
   }
}

