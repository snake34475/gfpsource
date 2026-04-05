package com.gfp.app.cartoon
{
   import com.gfp.app.toolBar.chat.MultiChatPanel;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.DailyActivityXMLInfo;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.DailyActiveAwardInfo;
   import com.gfp.core.info.dailyActivity.CostInfo;
   import com.gfp.core.info.dailyActivity.DailyActivityInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.info.item.SingleItemInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.TextFormatUtil;
   import com.gfp.core.utils.TextUtil;
   
   public class DailyActivityAward
   {
      
      public function DailyActivityAward()
      {
         super();
      }
      
      public static function addAward(param1:DailyActiveAwardInfo, param2:Boolean = true, param3:Function = null) : void
      {
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc11_:Boolean = false;
         var _loc12_:SingleItemInfo = null;
         var _loc13_:SingleEquipInfo = null;
         var _loc4_:int = int(param1.itemCount);
         var _loc5_:Array = param1.itemArr;
         var _loc6_:Array = param1.equiptArr;
         var _loc7_:int = int(param1.dailyActivityId);
         if(param1.type == DailyActivityXMLInfo.TYPE_REAP_MATERIAL)
         {
            _loc11_ = true;
         }
         _loc8_ = 0;
         while(_loc8_ < _loc4_)
         {
            _loc12_ = _loc5_[_loc8_];
            addItem(_loc12_.itemID,_loc12_.itemNum,param3,param2,_loc11_);
            _loc8_++;
         }
         var _loc10_:int = int(param1.equiptCount);
         _loc8_ = 0;
         while(_loc8_ < _loc10_)
         {
            _loc13_ = _loc6_[_loc8_];
            addEquipt(_loc13_,param3,param2);
            _loc8_++;
         }
         reduceCostItemNum(_loc7_);
      }
      
      private static function addItem(param1:int, param2:int, param3:Function, param4:Boolean = true, param5:Boolean = false) : void
      {
         var _loc7_:String = null;
         var _loc6_:String = AppLanguageDefine.VOID;
         if(param1 == 1)
         {
            MainManager.actorInfo.coins += param2;
            _loc6_ = AppLanguageDefine.SPECIAL_CHARACTER_SPACE[0] + AppLanguageDefine.GET_AWARD_COLLECTION[0];
         }
         else if(param1 == 2)
         {
            MainManager.actorInfo.exp += param2;
            _loc6_ = AppLanguageDefine.SPECIAL_CHARACTER_SPACE[1] + AppLanguageDefine.GET_AWARD_COLLECTION[1];
            MainManager.actorModel.dispatchEvent(new UserEvent(UserEvent.GROW_CHANGE,MainManager.actorInfo));
         }
         else if(param1 == 3)
         {
            MainManager.actorInfo.skillPoint += param2;
            _loc6_ = AppLanguageDefine.SPECIAL_CHARACTER_SPACE[1] + AppLanguageDefine.GET_AWARD_COLLECTION[2];
         }
         else if(param1 == 4)
         {
            MainManager.actorInfo.huntAward += param2;
            _loc6_ = AppLanguageDefine.SPECIAL_CHARACTER_SPACE[1] + AppLanguageDefine.GET_AWARD_COLLECTION[3];
         }
         else if(param1 == 7)
         {
            MainManager.actorInfo.honor += param2;
            _loc6_ = AppLanguageDefine.SPECIAL_CHARACTER_SPACE[1] + AppLanguageDefine.GET_AWARD_COLLECTION[5];
         }
         else if(param1 == 9)
         {
            _loc6_ = AppLanguageDefine.SPECIAL_CHARACTER_SPACE[1] + AppLanguageDefine.GET_AWARD_COLLECTION[6];
         }
         else
         {
            ItemManager.addItem(param1,param2);
         }
         if(param1 < 10)
         {
            _loc6_ = AppLanguageDefine.GET_AWARD + param2 + _loc6_;
            if(param4)
            {
               AlertManager.showSimpleAlarm(_loc6_,param3);
            }
            else
            {
               MultiChatPanel.instance.showSystemNotice(_loc6_);
               TextAlert.show(TextFormatUtil.getRedText(_loc6_));
            }
         }
         else
         {
            _loc7_ = ItemXMLInfo.getName(param1);
            if(_loc7_ == null)
            {
               Logger.error(null,param1 + "物品名称未获取");
            }
            if(param4)
            {
               _loc6_ = AppLanguageDefine.GET_AWARD + param2 + AppLanguageDefine.SPECIAL_CHARACTER_SPACE[0] + _loc7_;
               if(param5)
               {
                  TextAlert.show(_loc6_);
               }
               else
               {
                  AlertManager.showSimpleItemAlarm(_loc6_,ClientConfig.getItemIcon(param1),param3);
               }
            }
            else
            {
               _loc6_ = AppLanguageDefine.GET_AWARD + param2 + AppLanguageDefine.SPECIAL_CHARACTER_SPACE[0] + TextUtil.getCodeByItemId(param1);
               TextAlert.show(TextFormatUtil.getRedText(AppLanguageDefine.GET_AWARD + param2 + AppLanguageDefine.SPECIAL_CHARACTER_SPACE[0] + _loc7_));
               MultiChatPanel.instance.showSystemNotice(_loc6_);
            }
         }
      }
      
      private static function addEquipt(param1:SingleEquipInfo, param2:Function, param3:Boolean) : void
      {
         ItemManager.addEquip(param1);
         var _loc4_:String = "";
         if(param3)
         {
            _loc4_ = AppLanguageDefine.GET_AWARD_SPACE + ItemXMLInfo.getName(param1.itemID);
            AlertManager.showSimpleItemAlarm(_loc4_,ClientConfig.getItemIcon(param1.itemID),param2);
         }
         else
         {
            _loc4_ = AppLanguageDefine.GET_AWARD_SPACE + TextUtil.getCodeByItemId(param1.itemID);
            MultiChatPanel.instance.showSystemNotice(_loc4_);
            TextAlert.show(TextFormatUtil.getRedText(AppLanguageDefine.GET_AWARD_SPACE + ItemXMLInfo.getName(param1.itemID)));
         }
      }
      
      public static function reduceCostItemNum(param1:uint) : void
      {
         var _loc6_:CostInfo = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc2_:DailyActivityInfo = DailyActivityXMLInfo.getActivityById(param1);
         var _loc3_:Vector.<CostInfo> = _loc2_.costVect;
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            _loc7_ = int(_loc6_.id);
            _loc8_ = int(_loc6_.count);
            _loc9_ = int(_loc6_.type);
            if(_loc9_ == 1 || _loc9_ == 2)
            {
               if(ItemXMLInfo.isEquipt(_loc7_))
               {
                  ItemManager.removeEquipByIdOnce(_loc7_);
               }
               else
               {
                  ItemManager.removeItem(_loc7_,_loc8_);
               }
            }
            else if(_loc9_ == 3)
            {
               if(_loc7_ == 1)
               {
                  MainManager.actorInfo.coins -= _loc8_;
               }
               else if(_loc7_ == 2)
               {
                  MainManager.actorInfo.exp -= _loc8_;
               }
               else if(_loc7_ == 3)
               {
                  MainManager.actorInfo.skillPoint -= _loc8_;
               }
               else if(_loc7_ == 4)
               {
                  MainManager.actorInfo.huntAward -= _loc8_;
               }
               else if(_loc7_ == 7)
               {
                  MainManager.actorInfo.honor -= _loc8_;
               }
            }
            _loc5_++;
         }
      }
   }
}

