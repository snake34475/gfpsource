package com.gfp.app.config.xml
{
   import com.gfp.app.info.EquipTransformInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.manager.MainManager;
   import org.taomee.ds.HashMap;
   
   public class EquipTransformXMLInfo
   {
      
      private static var _dataHash:HashMap;
      
      private static var xmlClass:Class = EquipTransformXMLInfo_xmlClass;
      
      setup();
      
      public function EquipTransformXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc2_:XML = null;
         var _loc3_:EquipTransformInfo = null;
         var _loc1_:XMLList = XML(new xmlClass()).elements("TransInfo");
         _dataHash = new HashMap();
         for each(_loc2_ in _loc1_)
         {
            _loc3_ = new EquipTransformInfo(_loc2_);
            _dataHash.add(_loc3_.id,_loc3_);
         }
      }
      
      public static function getInfo(param1:uint) : EquipTransformInfo
      {
         return _dataHash.getValue(param1);
      }
      
      public static function getInfoByEquip(param1:SingleEquipInfo) : EquipTransformInfo
      {
         var result:EquipTransformInfo = null;
         var data:SingleEquipInfo = param1;
         _dataHash.eachValue(function(param1:EquipTransformInfo):void
         {
            if(param1.roleType == MainManager.actorInfo.roleType)
            {
               if(MainManager.actorInfo.lv >= int(param1.equipLvRegion[0]) && MainManager.actorInfo.lv <= int(param1.equipLvRegion[1]))
               {
                  if(data.part == param1.part)
                  {
                     result = param1;
                  }
               }
            }
         });
         return result;
      }
   }
}

