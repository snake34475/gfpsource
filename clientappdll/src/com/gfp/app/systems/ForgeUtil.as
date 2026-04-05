package com.gfp.app.systems
{
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.utils.EquipPart;
   
   public class ForgeUtil
   {
      
      public function ForgeUtil()
      {
         super();
      }
      
      public static function canStrengthen(param1:SingleEquipInfo) : Boolean
      {
         var _loc2_:uint = uint(param1.itemID);
         var _loc3_:uint = _loc2_ % 100000;
         if(ItemXMLInfo.isMagicWeapon(_loc2_))
         {
            return false;
         }
         if(ItemXMLInfo.getCatID(_loc2_) == 40)
         {
            return false;
         }
         if(param1.endTimeInSecond > 0 && param1.endTimeInSecond < uint.MAX_VALUE || _loc3_ >= 930 && _loc3_ <= 936 || _loc3_ >= 80007 && _loc3_ <= 80055)
         {
            return false;
         }
         var _loc4_:uint = uint(ItemXMLInfo.getEquipPart(_loc2_));
         if(_loc4_ != 2 && _loc4_ != 5 && _loc4_ != 10 && _loc4_ != 0 && _loc4_ != 11)
         {
            return true;
         }
         return false;
      }
      
      public static function canInlayJewelry(param1:SingleEquipInfo) : Boolean
      {
         var _loc2_:uint = uint(param1.itemID);
         var _loc3_:uint = _loc2_ % 100000;
         if(Boolean(ItemXMLInfo.isMagicWeapon(_loc2_)) || _loc3_ >= 80007 && _loc3_ <= 80055)
         {
            return false;
         }
         var _loc4_:uint = uint(ItemXMLInfo.getEquipPart(_loc2_));
         if(param1.endTimeInSecond == 0 && param1.qualityLevel > 1 && _loc4_ < 10 && _loc4_ != 2 && _loc4_ != 5)
         {
            return true;
         }
         return false;
      }
      
      public static function canAttachMagicWeapon(param1:SingleEquipInfo) : Boolean
      {
         var _loc2_:uint = uint(param1.itemID);
         var _loc3_:uint = _loc2_ % 100000;
         if(_loc3_ >= 80007 && _loc3_ <= 80055)
         {
            return false;
         }
         var _loc4_:uint = uint(ItemXMLInfo.getEquipPart(_loc2_));
         if(_loc4_ == EquipPart.WEAPON && param1.endTimeInSecond == 0 && ItemXMLInfo.getCatID(_loc2_) != ItemXMLInfo.CAT_MAGIC_WEAPON && ItemXMLInfo.getCatID(_loc2_) != 40)
         {
            return true;
         }
         return false;
      }
   }
}

