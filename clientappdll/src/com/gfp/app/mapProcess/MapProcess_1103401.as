package com.gfp.app.mapProcess
{
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.app.toolBar.FightToolBar;
   import com.gfp.app.toolBar.HeadSelfPanel;
   import com.gfp.core.behavior.ClothBehavior;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.ActorModel;
   import com.gfp.core.utils.EquipPart;
   
   public class MapProcess_1103401 extends BaseMapProcess
   {
      
      private var _config:Array = [[100801,100802,100803,100804,100806],[],[300801,300802,300803,300804,300805],[],[500802,500803,500804,500805,500806]];
      
      private var _originalRoleType:int;
      
      private var _originalTurnBack:Boolean;
      
      private var _originalModel:ActorModel;
      
      private var _originalClothes:Vector.<SingleEquipInfo>;
      
      public function MapProcess_1103401()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc7_:KeyInfo = null;
         var _loc8_:SingleEquipInfo = null;
         this._originalModel = MainManager.actorModel;
         this._originalTurnBack = MainManager.actorInfo.isTurnBack;
         this._originalRoleType = MainManager.actorInfo.roleType;
         this._originalClothes = MainManager.actorInfo.clothes.concat(MainManager.actorInfo.fashionClothes);
         var _loc1_:Vector.<KeyInfo> = new Vector.<KeyInfo>();
         var _loc2_:int = ClientTempState.skillRevolutionRoleType;
         var _loc3_:int = 0;
         while(_loc3_ < 5)
         {
            _loc7_ = new KeyInfo();
            _loc7_.funcID = KeyManager.skillQuickKeys[_loc3_];
            _loc7_.dataID = this._config[_loc2_ - 1][_loc3_];
            _loc7_.lv = 20;
            _loc1_.push(_loc7_);
            _loc3_++;
         }
         KeyManager.reset();
         KeyManager.upDateSkillQuickKeys(_loc1_);
         MainManager.actorInfo.isTurnBack = true;
         MainManager.actorInfo.roleType = _loc2_;
         MainManager.actorModel.spriteID = _loc2_;
         var _loc4_:Vector.<SingleEquipInfo> = new Vector.<SingleEquipInfo>();
         var _loc5_:Array = EquipPart.getDefItems(_loc2_,MainManager.actorInfo.defEquipType).getValues();
         var _loc6_:uint = _loc5_.length;
         _loc3_ = 0;
         while(_loc3_ < _loc6_)
         {
            _loc8_ = new SingleEquipInfo();
            _loc8_.itemID = _loc5_[_loc3_];
            _loc4_[_loc3_] = _loc8_;
            _loc3_++;
         }
         UserManager.execBehavior(MainManager.actorID,new ClothBehavior(_loc4_,false),true);
         HeadSelfPanel.instance.headIconEnabled = false;
         FightToolBar.instance.disabledBag();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         KeyManager.reset();
         KeyManager.upDateSkillQuickKeys(MainManager.actorInfo.skills);
         KeyManager.upDateItemQuickKeys(MainManager.actorInfo.items);
         MainManager.actorModel = this._originalModel;
         MainManager.actorModel.spriteID = this._originalRoleType;
         MainManager.actorInfo.roleType = this._originalRoleType;
         MainManager.actorInfo.isTurnBack = this._originalTurnBack;
         UserManager.execBehavior(MainManager.actorID,new ClothBehavior(this._originalClothes,false),true);
         HeadSelfPanel.instance.headIconEnabled = true;
         FightToolBar.instance.enabledBag();
      }
   }
}

