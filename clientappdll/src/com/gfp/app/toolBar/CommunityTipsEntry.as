package com.gfp.app.toolBar
{
   import com.gfp.app.toolBar.communityTips.CommunityAnimalTipsItem;
   import com.gfp.app.toolBar.communityTips.CommunityEquipTipsItem;
   import com.gfp.app.toolBar.communityTips.CommunityOpenNoticeItem;
   import com.gfp.app.toolBar.communityTips.CommunityTipsItem;
   import com.gfp.core.config.xml.GodGuardXMLInfo;
   import com.gfp.core.config.xml.HeroSoulXMLInfo;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.config.xml.ModuleLevelLimitXMLInfo;
   import com.gfp.core.config.xml.NewComposeXMLInfo;
   import com.gfp.core.events.SummonEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.events.UserItemEvent;
   import com.gfp.core.info.ModuleOpenNoticeInfo;
   import com.gfp.core.info.SummonInfo;
   import com.gfp.core.info.item.ProductInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UserInfoManager;
   import flash.display.Sprite;
   
   public class CommunityTipsEntry
   {
      
      private static var _instance:CommunityTipsEntry;
      
      private var _mainUI:Sprite;
      
      public var needRequestBag:int = 0;
      
      private var _hasEquipChangeMap:Object;
      
      private var _hasEquipUpgradeItem:Boolean;
      
      public function CommunityTipsEntry()
      {
         super();
         this._mainUI = new Sprite();
      }
      
      public static function get instance() : CommunityTipsEntry
      {
         if(!_instance)
         {
            _instance = new CommunityTipsEntry();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._hasEquipChangeMap = {};
         ItemManager.addListener(UserItemEvent.ITEM_ADD,this.itemReflashHandler);
         ItemManager.addListener(UserItemEvent.EQUIP_ADD,this.itemReflashHandler);
         UserInfoManager.ed.addEventListener(UserEvent.LVL_CHANGE,this.onLevelChange);
         SummonManager.addEventListener(SummonEvent.SUMMON_HATCH,this.onSummonHatch);
         this.show();
      }
      
      public function uninstall() : void
      {
         ItemManager.removeListener(UserItemEvent.ITEM_ADD,this.itemReflashHandler);
         ItemManager.removeListener(UserItemEvent.EQUIP_ADD,this.itemReflashHandler);
         UserInfoManager.ed.removeEventListener(UserEvent.LVL_CHANGE,this.onLevelChange);
         SummonManager.removeEventListener(SummonEvent.SUMMON_HATCH,this.onSummonHatch);
         this.clean();
         if(this._mainUI.parent)
         {
            this._mainUI.parent.removeChild(this._mainUI);
         }
      }
      
      public function show() : void
      {
         LayerManager.topLevel.addChild(this._mainUI);
      }
      
      public function hide() : void
      {
         if(this._mainUI)
         {
            LayerManager.topLevel.removeChild(this._mainUI);
         }
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._mainUI.visible = param1;
      }
      
      public function clean() : void
      {
         var _loc1_:* = 0;
         _loc1_ = int(this._mainUI.numChildren - 1);
         while(_loc1_ >= 0)
         {
            this._mainUI.removeChildAt(_loc1_);
            _loc1_--;
         }
      }
      
      protected function onLevelChange(param1:UserEvent) : void
      {
         var _loc7_:SingleEquipInfo = null;
         var _loc8_:SingleEquipInfo = null;
         var _loc9_:CommunityOpenNoticeItem = null;
         var _loc2_:int = int(MainManager.actorInfo.lv);
         var _loc3_:int = _loc2_ - int(param1.data);
         var _loc4_:Vector.<SingleEquipInfo> = new Vector.<SingleEquipInfo>();
         var _loc5_:int = 1;
         while(_loc5_ <= 10)
         {
            _loc7_ = this.getPartEquip(_loc5_);
            _loc8_ = ItemManager.getMaxPowerEquipByType(_loc5_);
            if(_loc8_)
            {
               if(_loc7_ == null)
               {
                  this.showEquipReplace(_loc8_);
               }
               else if(ItemManager.calucEqpBv(_loc8_) > ItemManager.calucEqpBv(_loc7_))
               {
                  this.showEquipReplace(_loc8_);
               }
            }
            _loc5_++;
         }
         var _loc6_:Vector.<ModuleOpenNoticeInfo> = ModuleLevelLimitXMLInfo.getOpenNoticeInfos(_loc3_,_loc2_);
         while(_loc6_.length)
         {
            _loc9_ = new CommunityOpenNoticeItem(_loc6_.pop());
            this._mainUI.addChild(_loc9_);
            this.show();
         }
      }
      
      private function getPartEquip(param1:int) : SingleEquipInfo
      {
         var _loc3_:SingleEquipInfo = null;
         var _loc2_:Vector.<SingleEquipInfo> = MainManager.actorInfo.clothes;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.part == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      private function showEquipReplace(param1:SingleEquipInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:CommunityTipsItem = null;
         var _loc5_:SingleEquipInfo = null;
         var _loc6_:Vector.<SingleEquipInfo> = null;
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:uint = 0;
         var _loc4_:Array = [11];
         _loc4_.push(MainManager.actorInfo.roleType);
         if(_loc4_.indexOf(ItemXMLInfo.getEquipRole(param1.itemID)) != -1)
         {
            _loc6_ = MainManager.actorInfo.clothes;
            _loc6_.fixed = false;
            _loc7_ = uint(ItemXMLInfo.getEquipPart(param1.itemID)) - 1;
            if(_loc7_ > 19)
            {
               return;
            }
            _loc8_ = 0;
            while(_loc8_ < _loc6_.length)
            {
               _loc11_ = uint(ItemXMLInfo.getEquipPart(_loc6_[_loc8_].itemID)) - 1;
               if(_loc7_ == _loc11_)
               {
                  _loc5_ = _loc6_[_loc8_];
                  break;
               }
               _loc8_++;
            }
            _loc2_ = int(param1.itemID);
            if(_loc5_)
            {
               _loc9_ = int(ItemXMLInfo.getUserLevel(_loc5_.itemID));
            }
            else
            {
               _loc9_ = 0;
            }
            _loc10_ = int(ItemXMLInfo.getUserLevel(param1.itemID));
            if(_loc10_ <= MainManager.actorInfo.lv && ItemManager.calucEqpBv(param1) > ItemManager.calucEqpBv(_loc5_))
            {
               if(int(this._hasEquipChangeMap[_loc3_]) == 0)
               {
                  _loc3_ = new CommunityEquipTipsItem(_loc2_,this.executeWhenDestroyEquipChange);
                  _loc3_.initData(param1);
                  this._mainUI.addChild(_loc3_);
                  this.show();
                  this._hasEquipChangeMap[_loc3_] = 1;
               }
            }
         }
      }
      
      private function onSummonHatch(param1:SummonEvent) : void
      {
         var _loc3_:CommunityTipsItem = null;
         var _loc2_:SummonInfo = param1.data as SummonInfo;
         if(GodGuardXMLInfo.isShenTongRecommend(_loc2_.roleID))
         {
            _loc3_ = new CommunityAnimalTipsItem(_loc2_.roleID,_loc2_);
            (_loc3_ as CommunityAnimalTipsItem).clickType = 2;
            this._mainUI.addChild(_loc3_);
            this.show();
         }
      }
      
      private function itemReflashHandler(param1:UserItemEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:CommunityTipsItem = null;
         var _loc6_:int = 0;
         var _loc7_:SingleEquipInfo = null;
         var _loc8_:int = 0;
         var _loc9_:ProductInfo = null;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:Boolean = false;
         var _loc2_:SingleEquipInfo = param1.param as SingleEquipInfo;
         if(_loc2_)
         {
            _loc3_ = int(_loc2_.itemID);
            if(ItemXMLInfo.getRideID(_loc3_))
            {
               _loc5_ = new CommunityAnimalTipsItem(_loc3_);
               (_loc5_ as CommunityAnimalTipsItem).clickType = 5;
               this._mainUI.addChild(_loc5_);
               this.show();
            }
            else if(ItemXMLInfo.isFashionEquip(_loc3_))
            {
               _loc5_ = new CommunityEquipTipsItem(_loc3_);
               _loc5_.initData(_loc2_);
               this._mainUI.addChild(_loc5_);
               this.show();
            }
            else
            {
               this.showEquipReplace(_loc2_);
            }
         }
         else
         {
            _loc3_ = int(param1.param[0]);
            _loc6_ = int(ItemXMLInfo.getSummonID(_loc3_));
            if(_loc3_ != 1410161 && _loc3_ != 1410134 && _loc3_ != 1410006 && _loc3_ != 1410007 && _loc3_ != 1410008 && _loc3_ != 1410180 && Boolean(_loc6_))
            {
               _loc5_ = new CommunityAnimalTipsItem(_loc3_);
               (_loc5_ as CommunityAnimalTipsItem).clickType = HeroSoulXMLInfo.getSoulType(_loc6_) ? 4 : 0;
               this._mainUI.addChild(_loc5_);
               this.show();
               (_loc5_ as CommunityAnimalTipsItem).show();
            }
            else if(ItemXMLInfo.getGodId(_loc3_))
            {
               _loc5_ = new CommunityAnimalTipsItem(_loc3_);
               (_loc5_ as CommunityAnimalTipsItem).clickType = 1;
               this._mainUI.addChild(_loc5_);
               this.show();
            }
            else if(2740855 == _loc3_ || 2740873 == _loc3_ || _loc3_ <= 2500163 && _loc3_ >= 2500154)
            {
               _loc5_ = new CommunityAnimalTipsItem(_loc3_);
               (_loc5_ as CommunityAnimalTipsItem).clickType = 3;
               this._mainUI.addChild(_loc5_);
               this.show();
            }
            else if(2741245 == _loc3_ || ItemXMLInfo.getItemInfo(_loc3_).Open == 1)
            {
               _loc5_ = new CommunityAnimalTipsItem(_loc3_);
               (_loc5_ as CommunityAnimalTipsItem).clickType = 7;
               this._mainUI.addChild(_loc5_);
               this.show();
            }
            else if(this._hasEquipUpgradeItem == false)
            {
               for each(_loc7_ in MainManager.actorInfo.clothes)
               {
                  _loc8_ = int(NewComposeXMLInfo.getUpgradeMethodID(_loc7_.itemID));
                  if(_loc8_)
                  {
                     _loc9_ = NewComposeXMLInfo.getInfo(_loc8_);
                     if(_loc9_)
                     {
                        _loc10_ = false;
                        _loc11_ = 0;
                        while(_loc11_ < _loc9_.list.length)
                        {
                           if(_loc9_.list[_loc11_].itemID == _loc3_)
                           {
                              _loc10_ = true;
                              break;
                           }
                           _loc11_++;
                        }
                        if(_loc10_)
                        {
                           _loc12_ = true;
                           _loc11_ = 0;
                           while(_loc11_ < _loc9_.list.length)
                           {
                              if(ItemXMLInfo.isEquipt(_loc9_.list[_loc11_].itemID) == false && ItemManager.getItemCount(_loc9_.list[_loc11_].itemID) < _loc9_.list[_loc11_].itemNum)
                              {
                                 _loc12_ = false;
                                 break;
                              }
                              _loc11_++;
                           }
                           if(_loc12_)
                           {
                              this._hasEquipUpgradeItem = true;
                              _loc5_ = new CommunityAnimalTipsItem(_loc7_.itemID,null,this.executeWhenDestroyUpgrade);
                              (_loc5_ as CommunityAnimalTipsItem).clickType = 8;
                              (_loc5_ as CommunityAnimalTipsItem).initData(_loc7_);
                              this._mainUI.addChild(_loc5_);
                              this.show();
                              break;
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      private function executeWhenDestroyEquipChange(param1:int) : void
      {
         this._hasEquipChangeMap[param1] = null;
         delete this._hasEquipChangeMap[param1];
      }
      
      private function executeWhenDestroyUpgrade() : void
      {
         this._hasEquipUpgradeItem = false;
      }
   }
}

