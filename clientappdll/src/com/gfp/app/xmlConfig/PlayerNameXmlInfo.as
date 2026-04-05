package com.gfp.app.xmlConfig
{
   import org.taomee.ds.HashMap;
   
   public class PlayerNameXmlInfo
   {
      
      private static var _dataHash:HashMap;
      
      private static var _xmlClass:Class = PlayerNameXmlInfo__xmlClass;
      
      private static const DEFAULT_NAME:Array = ["派派","伊尔","大竹","敖天","大奔","雪灵"];
      
      setup();
      
      public function PlayerNameXmlInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc3_:XML = null;
         _dataHash = new HashMap();
         var _loc1_:XML = XML(new _xmlClass());
         var _loc2_:XMLList = _loc1_.elements("name");
         for each(_loc3_ in _loc2_)
         {
            addName(_loc3_);
         }
      }
      
      private static function addName(param1:XML) : void
      {
         var _loc2_:uint = uint(param1.@type);
         var _loc3_:Array = _dataHash.getValue(_loc2_);
         if(_loc3_ == null)
         {
            _loc3_ = new Array();
         }
         _loc3_.push(param1.@des);
         _dataHash.add(_loc2_,_loc3_);
      }
      
      public static function getRandName(param1:uint = 0) : String
      {
         var _loc2_:uint = uint(Math.random() * 10);
         if(_loc2_ < 3 && param1 > 0)
         {
            return DEFAULT_NAME[param1 - 1];
         }
         return getNameByPart(1) + getNameByPart(2);
      }
      
      private static function getNameByPart(param1:uint) : String
      {
         var _loc3_:uint = 0;
         var _loc2_:Array = _dataHash.getValue(param1);
         if(_loc2_)
         {
            _loc3_ = uint(Math.random() * _loc2_.length);
            return _loc2_[_loc3_];
         }
         return "    ";
      }
   }
}

