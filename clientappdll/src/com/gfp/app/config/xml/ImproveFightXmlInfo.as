package com.gfp.app.config.xml
{
   import com.gfp.app.info.fight.ImproveFightEquipInfo;
   import com.gfp.app.info.fight.ImproveFightTranInfo;
   import com.gfp.app.info.fight.ImproveFightUiInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.utils.XmlLoaderHelper;
   import flash.utils.Dictionary;
   
   public class ImproveFightXmlInfo
   {
      
      public static var isLoaded:Boolean;
      
      public static var isLoading:Boolean;
      
      private static var uiListInfo:Dictionary;
      
      private static var suitableEquipInfo:Dictionary;
      
      private static var _callBack:Function;
      
      public static const IMPROVE_TYPE_LEVEL:int = 1;
      
      public static const IMPROVE_TYPE_EQUIP:int = 2;
      
      public static const IMPROVE_TYPE_MONSTOR:int = 3;
      
      public static const IMPROVE_TYPE_GOD:int = 4;
      
      public function ImproveFightXmlInfo()
      {
         super();
      }
      
      public static function getImproveUiInfo(param1:int) : ImproveFightUiInfo
      {
         return uiListInfo[param1];
      }
      
      public static function getSuitableEquipByArray(param1:Array) : Vector.<ImproveFightEquipInfo>
      {
         var _loc7_:ImproveFightEquipInfo = null;
         var _loc2_:int = int(MainManager.actorInfo.lv);
         var _loc3_:int = int(MainManager.roleType);
         var _loc4_:Vector.<ImproveFightEquipInfo> = suitableEquipInfo[0];
         var _loc5_:Vector.<ImproveFightEquipInfo> = suitableEquipInfo[_loc3_];
         if(_loc4_)
         {
            _loc5_ = _loc5_.concat(_loc4_);
         }
         var _loc6_:Vector.<ImproveFightEquipInfo> = new Vector.<ImproveFightEquipInfo>();
         for each(_loc7_ in _loc5_)
         {
            if(param1.indexOf(_loc7_.part) != -1 && _loc2_ >= _loc7_.min && _loc2_ <= _loc7_.max)
            {
               _loc6_.push(_loc7_);
            }
         }
         return _loc6_;
      }
      
      public static function getSuitableEquip(param1:int) : Vector.<ImproveFightEquipInfo>
      {
         var _loc7_:ImproveFightEquipInfo = null;
         var _loc2_:int = int(MainManager.actorInfo.lv);
         var _loc3_:int = int(MainManager.roleType);
         var _loc4_:Vector.<ImproveFightEquipInfo> = suitableEquipInfo[0];
         var _loc5_:Vector.<ImproveFightEquipInfo> = suitableEquipInfo[_loc3_];
         _loc5_ = _loc5_.concat(_loc4_);
         var _loc6_:Vector.<ImproveFightEquipInfo> = new Vector.<ImproveFightEquipInfo>();
         for each(_loc7_ in _loc5_)
         {
            if(param1 == _loc7_.part && _loc2_ >= _loc7_.min && _loc2_ <= _loc7_.max)
            {
               _loc6_.push(_loc7_);
            }
         }
         return _loc6_;
      }
      
      public static function setup(param1:Function = null) : void
      {
         _callBack = param1;
         var _loc2_:XmlLoaderHelper = new XmlLoaderHelper();
         var _loc3_:String = ClientConfig.getResPath("xml/improve_fight.xml");
         _loc2_.load(_loc3_,loadComplete);
         isLoading = true;
      }
      
      private static function loadComplete(param1:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:XMLList = null;
         var _loc5_:XML = null;
         var _loc6_:ImproveFightUiInfo = null;
         var _loc7_:XMLList = null;
         var _loc8_:XML = null;
         var _loc9_:XMLList = null;
         var _loc10_:XML = null;
         var _loc11_:ImproveFightTranInfo = null;
         var _loc12_:Vector.<ImproveFightEquipInfo> = null;
         var _loc13_:XMLList = null;
         var _loc14_:XML = null;
         var _loc15_:ImproveFightEquipInfo = null;
         isLoaded = true;
         isLoading = false;
         uiListInfo = new Dictionary();
         var _loc2_:XMLList = param1.uis[0].ui;
         for each(_loc3_ in _loc2_)
         {
            _loc6_ = new ImproveFightUiInfo();
            _loc6_.type = parseInt(_loc3_.@type);
            _loc6_.max = parseInt(_loc3_.@max);
            _loc6_.text = _loc3_.@text;
            _loc7_ = _loc3_.row;
            for each(_loc8_ in _loc7_)
            {
               _loc9_ = _loc8_.tran;
               for each(_loc10_ in _loc9_)
               {
                  _loc11_ = new ImproveFightTranInfo();
                  _loc11_.icon = _loc10_.@icon;
                  _loc11_.tip = _loc10_.@tip;
                  _loc11_.url = _loc10_.@url;
                  _loc6_.addInfo(_loc11_);
               }
            }
            uiListInfo[_loc6_.type] = _loc6_;
         }
         suitableEquipInfo = new Dictionary();
         _loc4_ = param1.equips[0].role;
         for each(_loc5_ in _loc4_)
         {
            _loc12_ = new Vector.<ImproveFightEquipInfo>();
            _loc13_ = _loc5_.equip;
            for each(_loc14_ in _loc13_)
            {
               _loc15_ = new ImproveFightEquipInfo();
               _loc15_.id = parseInt(_loc14_.@id);
               _loc15_.part = parseInt(_loc14_.@part);
               _loc15_.min = parseInt(_loc14_.@min);
               _loc15_.max = parseInt(_loc14_.@max);
               _loc12_.push(_loc15_);
            }
            suitableEquipInfo[parseInt(_loc5_.@id)] = _loc12_;
         }
         if(_callBack != null)
         {
            _callBack();
            _callBack = null;
         }
      }
   }
}

