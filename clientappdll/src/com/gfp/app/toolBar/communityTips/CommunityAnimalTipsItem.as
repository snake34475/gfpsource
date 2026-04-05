package com.gfp.app.toolBar.communityTips
{
   import com.gfp.core.action.keyboard.KeyItemProcess;
   import com.gfp.core.config.xml.GodGuardXMLInfo;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.events.SummonEvent;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.info.RectInfo;
   import com.gfp.core.info.SummonInfo;
   import com.gfp.core.info.SummonShenTongInfo;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.BatSwapManager;
   import com.gfp.core.manager.GodManager;
   import com.gfp.core.manager.HeroSoulManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.SummonShenTongManager;
   import com.gfp.core.ui.SummonIconTip;
   import com.gfp.core.ui.controller.GuideAdapter;
   import com.gfp.core.xmlconfig.GuideXmlInfo;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class CommunityAnimalTipsItem extends CommunityTipsItem
   {
      
      private var _clickType:int = 0;
      
      private var _summonInfo:SummonInfo;
      
      public function CommunityAnimalTipsItem(param1:int, param2:SummonInfo = null, param3:Function = null)
      {
         _type = 1;
         this._summonInfo = param2;
         super(param1,param3);
         if(param2)
         {
            name_txt.text = RoleXMLInfo.getName(param1);
         }
      }
      
      private function getBtnRect(param1:Sprite) : RectInfo
      {
         var _loc2_:Rectangle = param1.getRect(LayerManager.stage);
         var _loc3_:RectInfo = new RectInfo();
         _loc3_.isHoCenter = true;
         _loc3_.isVeCenter = true;
         _loc3_.hoValue = _loc2_.x - LayerManager.stageWidth / 2;
         _loc3_.veValue = _loc2_.y - LayerManager.stageHeight / 2;
         _loc3_.width = _loc2_.width;
         _loc3_.height = _loc2_.height;
         return _loc3_;
      }
      
      override protected function onClick(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:SummonShenTongInfo = null;
         var _loc4_:KeyInfo = null;
         super.onClick(param1);
         switch(this._clickType)
         {
            case 0:
               SummonManager.addEventListener(SummonEvent.SUMMON_HATCH,this.onSummonHatch);
               SummonManager.hatchSummon(itemID);
               break;
            case 1:
               GodManager.instance.callGod(itemID);
            case 2:
               if(this._summonInfo)
               {
                  _loc3_ = GodGuardXMLInfo.getShenTongByRoleID(this._summonInfo.roleID);
                  if(_loc3_)
                  {
                     if(param1.target.name == "shen0")
                     {
                        SummonShenTongManager.setShenTong(_loc3_,0);
                        break;
                     }
                     if(param1.target.name == "shen1")
                     {
                        SummonShenTongManager.setShenTong(_loc3_,1);
                     }
                  }
               }
               break;
            case 3:
            case 7:
               _loc2_ = uint(ItemXMLInfo.getBatSwapID(itemID));
               if(_loc2_ > 0 && !ItemManager.BAT_ITEM[itemID])
               {
                  BatSwapManager.execSwap(_loc2_,1);
                  break;
               }
               _loc4_ = new KeyInfo();
               _loc4_.dataID = itemID;
               KeyItemProcess.exec(MainManager.actorModel,_loc4_);
               break;
            case 4:
               HeroSoulManager.hatchSoul(itemID);
               break;
            case 5:
               ModuleManager.turnAppModule("NewRideInfoPanel");
               break;
            case 8:
               ModuleManager.turnAppModule("EquipCastingPanel","正在加载..",{
                  "index":7,
                  "info":data
               });
         }
         destory();
      }
      
      override protected function showICO() : void
      {
         var _loc1_:SummonIconTip = null;
         if(this._summonInfo)
         {
            _loc1_ = new SummonIconTip(40,40);
            _loc1_.setInfo(this._summonInfo);
            icoMC.addChild(_loc1_);
         }
         else
         {
            super.showICO();
         }
      }
      
      private function onSummonHatch(param1:SummonEvent) : void
      {
         SummonManager.removeEventListener(SummonEvent.SUMMON_HATCH,this.onSummonHatch);
         var _loc2_:SummonInfo = param1.data as SummonInfo;
         AlertManager.showSimpleAlarm("恭喜小侠士成功获得" + SummonManager.getQualityName(_loc2_.quality) + "品质的" + _loc2_.nick + "。");
      }
      
      public function get clickType() : int
      {
         return this._clickType;
      }
      
      public function set clickType(param1:int) : void
      {
         this._clickType = param1;
         btnMC.gotoAndStop(2 + param1);
         tipsMC.gotoAndStop(2 + param1);
      }
      
      public function show() : void
      {
         var _loc1_:RectInfo = null;
         var _loc2_:GuideAdapter = null;
         if(itemID == 1400047 && MainManager.actorInfo.lv < 40)
         {
            _loc1_ = this.getBtnRect(btnMC);
            GuideXmlInfo.setInfoRect(19,1,_loc1_);
            _loc2_ = new GuideAdapter(19);
            _loc2_.show();
         }
      }
   }
}

