package com.gfp.app.itemsUpgrade
{
   import com.gfp.app.info.ItemsUpgradeCompleteInfo;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.info.itemsUpgrade.ItemsLineInfo;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   
   public class ItemsUpgradeAward
   {
      
      public function ItemsUpgradeAward()
      {
         super();
      }
      
      public static function addAward(param1:ItemsUpgradeCompleteInfo) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ItemsLineInfo = null;
         var _loc4_:SingleEquipInfo = null;
         _loc2_ = 0;
         for(; _loc2_ < param1.delItemsVec.length; _loc2_++)
         {
            _loc3_ = param1.delItemsVec[_loc2_];
            if(_loc3_.type == 1)
            {
               _loc4_ = new SingleEquipInfo();
               _loc4_.leftTime = _loc3_.count;
               _loc4_.itemID = uint(_loc3_.id);
               ItemManager.removeEquip(_loc4_);
               continue;
            }
            if(_loc3_.type != 3)
            {
               ItemManager.removeItem(uint(_loc3_.id),_loc3_.count);
               continue;
            }
            switch(_loc3_.id)
            {
               case "1":
                  MainManager.actorInfo.coins -= _loc3_.count;
            }
         }
         _loc2_ = 0;
         for(; _loc2_ < param1.addItemsVec.length; _loc2_++)
         {
            _loc3_ = param1.addItemsVec[_loc2_];
            if(_loc3_.type == 1)
            {
               _loc4_ = new SingleEquipInfo();
               _loc4_.leftTime = _loc3_.count;
               _loc4_.itemID = uint(_loc3_.id);
               _loc4_.duration = ItemXMLInfo.getDuration(_loc4_.itemID) * 50;
               ItemManager.addEquip(_loc4_);
               continue;
            }
            if(_loc3_.type != 3)
            {
               ItemManager.addItem(uint(_loc3_.id),_loc3_.count);
               continue;
            }
            switch(_loc3_.id)
            {
               case "1":
                  MainManager.actorInfo.coins += _loc3_.count;
            }
         }
      }
   }
}

