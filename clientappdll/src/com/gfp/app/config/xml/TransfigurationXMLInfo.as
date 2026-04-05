package com.gfp.app.config.xml
{
   import com.gfp.app.info.TransfigurationInfo;
   import com.gfp.app.info.TransfigurationItemInfo;
   import com.gfp.core.manager.Bridge;
   import flash.utils.Dictionary;
   
   public class TransfigurationXMLInfo
   {
      
      private static var hash:Dictionary;
      
      private static var array:Vector.<TransfigurationInfo>;
      
      private static var res:Object;
      
      private static var TransfigurationXML:Class = TransfigurationXMLInfo_TransfigurationXML;
      
      setup();
      
      public function TransfigurationXMLInfo()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc3_:TransfigurationInfo = null;
         hash = new Dictionary();
         array = new Vector.<TransfigurationInfo>();
         res = {};
         var _loc1_:XML = new XML(new TransfigurationXML());
         var _loc2_:XMLList = _loc1_.Method;
         for each(_loc1_ in _loc2_)
         {
            _loc3_ = new TransfigurationInfo();
            _loc3_.id = _loc1_.@PaperID;
            _loc3_.name = _loc1_.@Name;
            _loc3_.appID = _loc1_.@AppId;
            _loc3_.skillID = _loc1_.@SkillId;
            _loc3_.addHP = _loc1_.@AddHp;
            _loc3_.addMP = _loc1_.@addMp;
            _loc3_.addAtk = _loc1_.@addAtk;
            _loc3_.inItem = new TransfigurationItemInfo();
            _loc3_.inItem.id = _loc1_.InItem[0].@ID;
            _loc3_.inItem.count = _loc1_.InItem[0].@Cnt;
            _loc3_.inItem.useUniversal = int(_loc1_.InItem[0].@UseUniversal) == 1;
            _loc3_.outItem = new TransfigurationItemInfo();
            _loc3_.outItem.id = _loc1_.OutItem[0].@ID;
            _loc3_.outItem.count = _loc1_.OutItem[0].@Cnt;
            _loc3_.outItem.useUniversal = int(_loc1_.OutItem[0].@UseUniversal) == 1;
            _loc3_.resID = _loc1_.@ResID;
            if(_loc3_.resID != 0)
            {
               res[_loc3_.appID] = _loc3_.resID;
            }
            hash[_loc3_.id] = _loc3_;
            array.push(_loc3_);
         }
         Bridge.TransfigurationXMLInfo = TransfigurationXMLInfo;
      }
      
      public static function getResID(param1:int) : int
      {
         return res[param1];
      }
      
      public static function getTransfigurationByID(param1:int) : TransfigurationInfo
      {
         return hash[param1];
      }
      
      public static function getAllTransfigurations() : Vector.<TransfigurationInfo>
      {
         return array;
      }
      
      public static function getSkillID(param1:uint) : int
      {
         var _loc2_:TransfigurationInfo = null;
         for each(_loc2_ in array)
         {
            if(_loc2_.appID == param1)
            {
               return _loc2_.skillID;
            }
         }
         return 0;
      }
   }
}

