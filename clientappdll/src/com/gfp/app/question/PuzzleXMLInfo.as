package com.gfp.app.question
{
   import org.taomee.ds.HashMap;
   
   public class PuzzleXMLInfo
   {
      
      private static var _dataMap:HashMap;
      
      private static var xmlClass:Class = PuzzleXMLInfo_xmlClass;
      
      setup();
      
      public function PuzzleXMLInfo()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc3_:XML = null;
         var _loc4_:PuzzleInfo = null;
         _dataMap = new HashMap();
         var _loc1_:XML = new XML(new xmlClass());
         var _loc2_:XMLList = _loc1_.elements("Question");
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = new PuzzleInfo(_loc3_);
            _dataMap.add(_loc4_.qID,_loc4_);
         }
      }
      
      public static function getPuzzleInfo(param1:uint) : PuzzleInfo
      {
         return _dataMap.getValue(param1);
      }
      
      public static function getPuzzleIDs() : Array
      {
         return _dataMap.getKeys();
      }
      
      public static function getPuzzleTime(param1:uint) : uint
      {
         var _loc2_:PuzzleInfo = _dataMap.getValue(param1);
         if(_loc2_)
         {
            return _loc2_.time;
         }
         return 0;
      }
      
      public static function getRandomPuzzleIDs(param1:uint) : Array
      {
         var _loc5_:uint = 0;
         var _loc2_:Array = [];
         var _loc3_:Array = getPuzzleIDs().concat();
         var _loc4_:uint = 0;
         while(_loc4_ < param1)
         {
            _loc5_ = uint(Math.random() * _loc3_.length);
            _loc2_.push(_loc3_[_loc5_]);
            _loc3_.splice(_loc5_,1);
            _loc4_++;
         }
         return _loc2_;
      }
   }
}

