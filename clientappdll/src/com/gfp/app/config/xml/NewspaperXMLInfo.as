package com.gfp.app.config.xml
{
   import com.gfp.app.info.NewsPaperTitleInfo;
   
   public class NewspaperXMLInfo
   {
      
      public static var newsPaperTitleVec:Vector.<NewsPaperTitleInfo>;
      
      public static var newsPaperItems:Object;
      
      public static var _curDate:Array;
      
      public static var _nextDate:Array;
      
      public static var voteURL:String;
      
      private static var newsPaperClass:Class = NewspaperXMLInfo_newsPaperClass;
      
      setup();
      
      public function NewspaperXMLInfo()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc3_:XML = null;
         var _loc4_:XMLList = null;
         var _loc5_:XML = null;
         var _loc6_:Array = null;
         var _loc7_:XMLList = null;
         var _loc8_:XML = null;
         var _loc9_:NewsPaperTitleInfo = null;
         var _loc1_:XML = XML(new newsPaperClass());
         newsPaperTitleVec = new Vector.<NewsPaperTitleInfo>();
         newsPaperItems = {};
         _curDate = _loc1_.descendants("curDate").toString().split("-");
         _nextDate = _loc1_.descendants("nextDate").toString().split("-");
         voteURL = _loc1_.descendants("voteURL").toString();
         var _loc2_:XMLList = _loc1_.descendants("page");
         for each(_loc3_ in _loc2_)
         {
            _loc6_ = [];
            _loc7_ = _loc3_.descendants("item");
            for each(_loc8_ in _loc7_)
            {
               _loc6_.push(_loc8_.toString());
            }
            newsPaperItems[_loc3_.@type] = _loc6_;
         }
         _loc4_ = _loc1_.descendants("subtitle");
         for each(_loc5_ in _loc4_)
         {
            _loc9_ = new NewsPaperTitleInfo(_loc5_);
            _loc9_.url = newsPaperItems[_loc9_.type][_loc9_.index];
            newsPaperTitleVec.push(_loc9_);
         }
      }
   }
}

