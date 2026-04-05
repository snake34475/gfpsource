package com.gfp.app.config.xml
{
   import com.gfp.app.info.ActivityMultiNodeInfo;
   import com.gfp.app.info.ActivityNodeInfo;
   
   public class DynamicActivityXMLInfo
   {
      
      public static var infos:Vector.<ActivityNodeInfo>;
      
      public static var announcement:Vector.<String>;
      
      private static var xmlClass:Class = DynamicActivityXMLInfo_xmlClass;
      
      setup();
      
      public function DynamicActivityXMLInfo()
      {
         super();
         setup();
      }
      
      private static function compareId(param1:ActivityNodeInfo, param2:ActivityNodeInfo) : int
      {
         if(param1.priority > param2.priority)
         {
            return 1;
         }
         if(param1.priority < param2.priority)
         {
            return -1;
         }
         return 0;
      }
      
      private static function setup() : void
      {
         var _loc1_:XML = null;
         var _loc2_:XMLList = null;
         var _loc3_:XML = null;
         var _loc4_:ActivityNodeInfo = null;
         _loc1_ = XML(new xmlClass());
         announcement = new Vector.<String>();
         _loc2_ = _loc1_.elements("Announcement");
         for each(_loc3_ in _loc2_)
         {
            announcement.push(_loc3_.toString());
         }
         _loc2_ = _loc1_.elements("node");
         infos = new Vector.<ActivityNodeInfo>();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.childNode.length() > 0)
            {
               _loc4_ = new ActivityMultiNodeInfo(_loc3_);
            }
            else
            {
               _loc4_ = new ActivityNodeInfo(_loc3_);
            }
            infos.push(_loc4_);
         }
         infos.sort(compareId);
      }
   }
}

