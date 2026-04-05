package com.gfp.app.question
{
   import org.taomee.ds.HashMap;
   
   public class QuestionXMLinfo
   {
      
      private static var _dataMap:HashMap;
      
      private static var xmlClass:Class = QuestionXMLinfo_xmlClass;
      
      setup();
      
      public function QuestionXMLinfo()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc3_:XML = null;
         var _loc4_:HashMap = null;
         var _loc5_:XMLList = null;
         var _loc6_:XML = null;
         var _loc7_:QuestionOptionsInfo = null;
         _dataMap = new HashMap();
         var _loc1_:XML = new XML(new xmlClass());
         var _loc2_:XMLList = _loc1_.descendants("questions");
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = new HashMap();
            _dataMap.add(int(_loc3_.@ID),_loc4_);
            _loc5_ = _loc3_.descendants("question");
            for each(_loc6_ in _loc5_)
            {
               _loc7_ = new QuestionOptionsInfo(_loc6_);
               _loc4_.add(_loc7_.id,_loc7_);
            }
         }
      }
      
      public static function getQuestionByID(param1:int) : HashMap
      {
         return _dataMap.getValue(param1);
      }
   }
}

