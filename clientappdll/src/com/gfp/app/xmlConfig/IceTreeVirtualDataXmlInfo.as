package com.gfp.app.xmlConfig
{
   import com.gfp.app.info.IceTreeNodeInfo;
   import org.taomee.ds.HashMap;
   
   public class IceTreeVirtualDataXmlInfo
   {
      
      private static var _dataHash:HashMap;
      
      private static var _xmlClass:Class = IceTreeVirtualDataXmlInfo__xmlClass;
      
      setup();
      
      public function IceTreeVirtualDataXmlInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc1_:Vector.<IceTreeNodeInfo> = null;
         var _loc3_:IceTreeNodeInfo = null;
         var _loc4_:XML = null;
         _dataHash = new HashMap();
         var _loc2_:XML = XML(new _xmlClass());
         for each(_loc4_ in _loc2_.elements())
         {
            _loc3_ = new IceTreeNodeInfo();
            _loc1_ = _dataHash.getValue(int(_loc4_.@type));
            if(!_loc1_)
            {
               _loc1_ = new Vector.<IceTreeNodeInfo>();
               _dataHash.add(int(_loc4_.@type),_loc1_);
            }
            _loc3_["itemid"] = _loc4_.attribute("itemid");
            _loc3_["type"] = _loc4_.attribute("type");
            _loc3_["tv1"] = _loc4_.attribute("t1");
            _loc3_["tv2"] = _loc4_.attribute("t2");
            _loc3_["tv3"] = _loc4_.attribute("t3");
            _loc3_["tv4"] = _loc4_.attribute("t4");
            _loc3_["tv5"] = _loc4_.attribute("t5");
            _loc3_["tv6"] = _loc4_.attribute("t6");
            _loc3_["tv7"] = _loc4_.attribute("t7");
            _loc3_["tv8"] = _loc4_.attribute("t8");
            _loc3_["tv9"] = _loc4_.attribute("t9");
            _loc3_["tv10"] = _loc4_.attribute("t10");
            _loc1_.push(_loc3_);
         }
      }
      
      public static function getVirtualData(param1:int) : Vector.<IceTreeNodeInfo>
      {
         return _dataHash.getValue(param1) as Vector.<IceTreeNodeInfo>;
      }
   }
}

