package com.gfp.app.config.xml
{
   import com.gfp.app.info.LvlUpAlertInfo;
   import com.gfp.core.Constant;
   import com.gfp.core.manager.MainManager;
   import org.taomee.ds.HashMap;
   
   public class LvInformXMLInfo
   {
      
      private static var _dataHash:HashMap;
      
      private static var _alertList:Array;
      
      public static var lastActivityLv:int;
      
      private static var xmlClass:Class = LvInformXMLInfo_xmlClass;
      
      private static const ALL_ROLETYPE_ARR:Array = [1,2,3,4];
      
      setup();
      
      public function LvInformXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc3_:XML = null;
         var _loc4_:XMLList = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc1_:XML = XML(new xmlClass());
         var _loc2_:XMLList = _loc1_.elements("node");
         _dataHash = new HashMap();
         for each(_loc3_ in _loc2_)
         {
            _loc5_ = new Object();
            _loc5_.lv = uint(_loc3_.@lv);
            _loc5_.npcID = uint(_loc3_.@npcID);
            _loc5_.msg = String(_loc3_.@msg);
            _loc6_ = _loc3_.@roleType;
            addInfoForRoleType(_loc6_,_loc5_);
         }
         _loc4_ = _loc1_.elements("alert");
         _alertList = new Array();
         for each(_loc3_ in _loc4_)
         {
            _alertList.push(new LvlUpAlertInfo(_loc3_));
         }
      }
      
      private static function addInfoForRoleType(param1:String, param2:Object) : void
      {
         var _loc3_:Array = param1.split(Constant.CHAR_LINE);
         if(param1 == "0")
         {
            _loc3_ = ALL_ROLETYPE_ARR;
         }
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            _dataHash.add(param2.lv + Constant.CHAR_UNDERLINE + _loc3_[_loc5_],param2);
            _loc5_++;
         }
      }
      
      private static function getKey(param1:uint) : String
      {
         return param1 + Constant.CHAR_UNDERLINE + MainManager.roleType;
      }
      
      private static function getInfoByLv(param1:int) : Object
      {
         var _loc2_:String = getKey(param1);
         return _dataHash.getValue(_loc2_);
      }
      
      public static function contains(param1:uint) : Boolean
      {
         return _dataHash.containsKey(getKey(param1));
      }
      
      public static function getNpcID(param1:uint) : uint
      {
         var _loc2_:Object = getInfoByLv(param1);
         if(_loc2_)
         {
            return _loc2_.npcID;
         }
         return 0;
      }
      
      public static function getMsg(param1:uint) : String
      {
         var _loc2_:Object = getInfoByLv(param1);
         if(_loc2_)
         {
            return _loc2_.msg;
         }
         return "";
      }
      
      public static function getAlertByLv(param1:uint, param2:uint = 0) : Array
      {
         var _loc4_:LvlUpAlertInfo = null;
         var _loc3_:Array = new Array();
         for each(_loc4_ in _alertList)
         {
            if(param1 == _loc4_.lv && (param2 == 0 || _loc4_.roleType == 0 || param2 == _loc4_.roleType))
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      public static function getAlertRange(param1:int, param2:int) : Array
      {
         var _loc5_:LvlUpAlertInfo = null;
         var _loc3_:int = int(MainManager.roleType);
         var _loc4_:Array = new Array();
         for each(_loc5_ in _alertList)
         {
            if(param1 <= _loc5_.lv && param2 >= _loc5_.lv && (_loc3_ == 0 || _loc5_.roleType == 0 || _loc3_ == _loc5_.roleType))
            {
               _loc4_.push(_loc5_);
            }
         }
         return _loc4_;
      }
   }
}

