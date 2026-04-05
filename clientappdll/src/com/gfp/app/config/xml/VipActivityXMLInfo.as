package com.gfp.app.config.xml
{
   import com.gfp.app.info.VipActivityInfo;
   import org.taomee.ds.HashMap;
   
   public class VipActivityXMLInfo
   {
      
      private static var _dataHash:HashMap;
      
      private static var _SuggestedActivityVec:Vector.<uint>;
      
      private static var xmlClass:Class = VipActivityXMLInfo_xmlClass;
      
      setup();
      
      public function VipActivityXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc3_:XML = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:VipActivityInfo = null;
         var _loc1_:XML = XML(new xmlClass());
         var _loc2_:XMLList = _loc1_.elements("Activity");
         _dataHash = new HashMap();
         for each(_loc3_ in _loc2_)
         {
            _loc7_ = uint(_loc3_.@id);
            _loc8_ = new VipActivityInfo(_loc3_);
            _dataHash.add(_loc7_,_loc8_);
         }
         _SuggestedActivityVec = new Vector.<uint>();
         _loc4_ = String(_loc1_.elements("SuggestedActivities")[0].@id);
         _loc5_ = _loc4_.split("|");
         _loc6_ = 0;
         while(_loc6_ < _loc5_.length)
         {
            _SuggestedActivityVec.push(uint(_loc5_[_loc6_]));
            _loc6_++;
         }
      }
      
      public static function getSuggested() : Vector.<uint>
      {
         return _SuggestedActivityVec;
      }
      
      public static function getInfo(param1:uint) : VipActivityInfo
      {
         return _dataHash.getValue(param1) as VipActivityInfo;
      }
   }
}

