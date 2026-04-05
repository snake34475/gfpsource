package com.gfp.app.toolBar.communityTips
{
   import com.gfp.app.toolBar.CommunityTipsEntry;
   import com.gfp.core.behavior.ChangeRideBehavior;
   import com.gfp.core.behavior.ClothBehavior;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.language.ModuleLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.IconQualityFrameManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.ui.ItemIcon;
   import com.gfp.core.ui.ItemInfoTip;
   import com.gfp.core.utils.EquipPart;
   import flash.events.MouseEvent;
   
   public class CommunityEquipTipsItem extends CommunityTipsItem
   {
      
      private var itemPart:uint;
      
      public function CommunityEquipTipsItem(param1:int, param2:Function = null)
      {
         _type = 1;
         super(param1,param2);
      }
      
      override protected function showICO() : void
      {
         var _loc1_:int = int(ItemXMLInfo.getQualityLevel(itemID));
         var _loc2_:ItemIcon = new ItemIcon();
         _loc2_.setID(itemID);
         _loc2_.x = 2;
         _loc2_.y = 1;
         icoMC.addChild(_loc2_);
         IconQualityFrameManager.add(_loc2_,itemID);
      }
      
      override public function initData(param1:Object) : void
      {
         super.initData(param1);
      }
      
      override protected function addEvents() : void
      {
         super.addEvents();
         icoMC.addEventListener(MouseEvent.MOUSE_OVER,this.icoOver);
         icoMC.addEventListener(MouseEvent.MOUSE_OUT,this.icoOut);
      }
      
      override protected function removeEvents() : void
      {
         super.removeEvents();
         icoMC.removeEventListener(MouseEvent.MOUSE_OVER,this.icoOver);
         icoMC.removeEventListener(MouseEvent.MOUSE_OUT,this.icoOut);
      }
      
      private function icoOver(param1:MouseEvent) : void
      {
         ItemInfoTip.setEquipIntervalComparisonTip(data as SingleEquipInfo);
      }
      
      private function icoOut(param1:MouseEvent) : void
      {
         ItemInfoTip.hide();
      }
      
      override protected function onClick(param1:MouseEvent) : void
      {
         super.onClick(param1);
         this.clothPutOnHandler(data as SingleEquipInfo);
         destory();
      }
      
      private function clothPutOnHandler(param1:SingleEquipInfo) : void
      {
         if(MapManager.curMapIsTradMap())
         {
            AlertManager.showSimpleAlarm("小侠士，交易房间不能更换装备！");
            return;
         }
         this.itemPart = uint(ItemXMLInfo.getEquipPart(param1.itemID)) - 1;
         if(this.itemPart == -1)
         {
            AlertManager.showSimpleAlarm(ModuleLanguageDefine.BAG_MSG_ARR[0]);
            return;
         }
         if(Boolean(ItemXMLInfo.getVipOnly(param1.itemID)) && MainManager.actorInfo.isVip == false)
         {
            AlertManager.showSimpleAlarm(ModuleLanguageDefine.BAG_MSG_ARR[1]);
            return;
         }
         if(ItemXMLInfo.getCatID(param1.itemID) == MainManager.roleType || ItemXMLInfo.getCatID(param1.itemID) == ItemXMLInfo.JEWELRY_CAT)
         {
            if(MainManager.actorInfo.lv >= ItemXMLInfo.getUserLevel(param1.itemID))
            {
               if(this.changeCloth(param1))
               {
                  this.putOnWear(param1);
               }
            }
            else
            {
               AlertManager.showSimpleAlarm(ModuleLanguageDefine.BAG_MSG_ARR[2]);
            }
         }
         else
         {
            AlertManager.showSimpleAlarm(ModuleLanguageDefine.BAG_MSG_ARR[3]);
         }
      }
      
      public function putOnWear(param1:SingleEquipInfo) : void
      {
         var _loc4_:uint = 0;
         if(param1.part == EquipPart.RIDE)
         {
            MainManager.actorModel.execBehavior(new ChangeRideBehavior(param1.itemID));
            return;
         }
         var _loc2_:Vector.<SingleEquipInfo> = MainManager.actorInfo.clothes.concat(MainManager.actorInfo.fashionClothes);
         _loc2_.fixed = false;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = uint(ItemXMLInfo.getEquipPart(_loc2_[_loc3_].itemID)) - 1;
            if(this.itemPart == _loc4_)
            {
               _loc2_.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
         _loc2_.push(param1);
         _loc2_.fixed = true;
         this.refreshTempPanel(_loc2_);
      }
      
      private function refreshTempPanel(param1:Vector.<SingleEquipInfo>) : void
      {
         MainManager.actorModel.execBehavior(new ClothBehavior(param1));
         ++CommunityTipsEntry.instance.needRequestBag;
      }
      
      public function changeCloth(param1:SingleEquipInfo, param2:Boolean = true) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if(this.itemPart < 0)
         {
            return false;
         }
         if(ItemXMLInfo.getUserLevel(param1.itemID) >= 90 && !MainManager.actorInfo.isSuperAdvc)
         {
            AlertManager.showSimpleAlarm("你还没有进阶为三转侠士，不能穿上此装备。");
            return false;
         }
         var _loc3_:int = int(ItemManager.getEquipAvailableCapacity());
         if(param2 && _loc3_ < 0)
         {
            AlertManager.showSimpleAlarm(ModuleLanguageDefine.BAG_FULL);
            return false;
         }
         return true;
      }
   }
}

