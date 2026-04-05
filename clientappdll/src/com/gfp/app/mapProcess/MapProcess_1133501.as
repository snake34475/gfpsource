package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.PvpEntry;
   import com.gfp.app.toolBar.FightToolBar;
   import com.gfp.app.toolBar.HeadSelfPanel;
   import com.gfp.core.action.keyboard.KeyFuncProcess;
   import com.gfp.core.action.keyboard.KeySkillProcess;
   import com.gfp.core.behavior.ClothBehavior;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.ActorModel;
   import com.gfp.core.utils.EquipPart;
   
   public class MapProcess_1133501 extends BaseMapProcess
   {
      
      private var _originalPower:int;
      
      private var _originalGildID:int;
      
      private var _originalLevel:int;
      
      private var _originalTurnBack:Boolean;
      
      private var _originalModel:ActorModel;
      
      private var _originalClothes:Vector.<SingleEquipInfo>;
      
      private var _originalSkills:Vector.<KeyInfo>;
      
      public function MapProcess_1133501()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc1_:Vector.<KeyInfo> = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:SingleEquipInfo = null;
         var _loc6_:KeyInfo = null;
         if(PvpEntry.pvpID == 72)
         {
            this._originalModel = MainManager.actorModel;
            this._originalTurnBack = MainManager.actorInfo.isTurnBack;
            this._originalLevel = MainManager.actorInfo.lv;
            this._originalPower = MainManager.actorInfo.fightPower;
            this._originalClothes = MainManager.actorInfo.clothes.concat(MainManager.actorInfo.fashionClothes);
            this._originalSkills = MainManager.actorInfo.skills.concat();
            _loc1_ = new Vector.<KeyInfo>();
            _loc2_ = int(MainManager.actorInfo.roleType);
            _loc3_ = 0;
            while(_loc3_ < MainManager.actorInfo.skills.length)
            {
               _loc6_ = new KeyInfo();
               _loc6_.dataID = MainManager.actorInfo.skills[_loc3_].dataID;
               _loc6_.funcID = MainManager.actorInfo.skills[_loc3_].funcID;
               _loc6_.lv = 10;
               _loc1_.push(_loc6_);
               _loc3_++;
            }
            KeyManager.reset();
            MainManager.actorInfo.skills = _loc1_;
            KeyManager.upDateSkillQuickKeys(_loc1_);
            MainManager.actorInfo.isTurnBack = true;
            MainManager.actorInfo.lv = 100;
            MainManager.actorInfo.fightPower = 200000;
            MainManager.actorModel.upDateNickText();
            _loc4_ = ItemManager.warCloth;
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_.part == EquipPart.WEAPON && ItemXMLInfo.isMagicWeapon(_loc5_.itemID) == false)
               {
                  this._originalGildID = _loc5_.gildSkillID;
                  _loc5_.gildSkillID = 4220801;
               }
            }
            FightToolBar.instance.getQickBar().resetGildSkill();
            UserManager.execBehavior(MainManager.actorID,new ClothBehavior(MainManager.actorInfo.clothes,false),true);
            HeadSelfPanel.instance.headIconEnabled = false;
            FightToolBar.instance.disabledBag();
            KeySkillProcess.liyaChangeSkillState = 0;
            HeadSelfPanel.instance.init(MainManager.actorModel);
            FightToolBar.instance.getQickBar().removeShentong();
            KeyFuncProcess.shentongSkillForbidden = true;
            MainManager.actorInfo.lv = this._originalLevel;
         }
      }
      
      override public function destroy() : void
      {
         var _loc1_:Array = null;
         var _loc2_:SingleEquipInfo = null;
         super.destroy();
         if(PvpEntry.pvpID == 72)
         {
            KeyManager.reset();
            MainManager.actorInfo.skills = this._originalSkills;
            KeyManager.upDateSkillQuickKeys(MainManager.actorInfo.skills);
            KeyManager.upDateItemQuickKeys(MainManager.actorInfo.items);
            MainManager.actorModel = this._originalModel;
            MainManager.actorInfo.lv = this._originalLevel;
            MainManager.actorInfo.fightPower = this._originalPower;
            MainManager.actorInfo.isTurnBack = this._originalTurnBack;
            UserManager.execBehavior(MainManager.actorID,new ClothBehavior(this._originalClothes,false),true);
            HeadSelfPanel.instance.headIconEnabled = true;
            FightToolBar.instance.enabledBag();
            MainManager.actorModel.upDateNickText();
            _loc1_ = ItemManager.warCloth;
            for each(_loc2_ in _loc1_)
            {
               if(_loc2_.part == EquipPart.WEAPON && ItemXMLInfo.isMagicWeapon(_loc2_.itemID) == false)
               {
                  _loc2_.gildSkillID = this._originalGildID;
               }
            }
            HeadSelfPanel.instance.init(MainManager.actorModel);
            KeyFuncProcess.shentongSkillForbidden = false;
         }
      }
   }
}

