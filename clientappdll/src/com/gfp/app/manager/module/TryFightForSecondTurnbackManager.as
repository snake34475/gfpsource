package com.gfp.app.manager.module
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.toolBar.FightToolBar;
   import com.gfp.app.toolBar.HeadSelfPanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.keyboard.KeyFuncProcess;
   import com.gfp.core.action.keyboard.KeySkillProcess;
   import com.gfp.core.behavior.ClothBehavior;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.config.xml.SkillXMLInfo;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.info.CDInfo;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.info.SummonShenTongInfo;
   import com.gfp.core.info.SummonShenTongStepInfo;
   import com.gfp.core.info.fight.SkillLevelInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.manager.CDManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonShenTongManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.model.ActorModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.EquipPart;
   import org.taomee.net.SocketEvent;
   
   public class TryFightForSecondTurnbackManager
   {
      
      private static var _originalRoleType:int;
      
      private static var _originalSpriteID:int;
      
      private static var _originalPower:int;
      
      private static var _originalGildID:int;
      
      private static var _originalLevel:int;
      
      private static var _originalTurnBack:Boolean;
      
      private static var _originalSecondTurnBackType:int;
      
      private static var _originalModel:ActorModel;
      
      private static var _originalClothes:Vector.<SingleEquipInfo>;
      
      private static var _originalSkills:Vector.<KeyInfo>;
      
      public static var roleType:int;
      
      public static var secondChangeType:int;
      
      private static var _skills:Array = [[[100901,100902,100903,100904,100905,100906,100907,100908],[101001,101002,101003,101004,101005,101006,101007,101008]],[[200901,200902,200903,200904,200905,200906,200907,200908],[201001,201002,201003,201004,201005,201006,201007,201008]],[[300901,300902,300903,300904,300905,300906,300907,300908],[301001,301002,301003,301004,301005,301006,301007,301008]],[[400901,400902,400903,400904,400905,400906,400907,400908],[401001,401002,401003,401004,401005,401006,401007,401008]],[[500901,500902,500903,500904,500905,500906,500907,500908],[501001,501002,501003,501004,501005,501006,501007,501008]],[[600901,600902,600903,600904,600905,600906,600907,600908],[601001,601002,601003,601004,601005,601006,601007,601008]],[[700901,700902,700903,700904,700905,700906,700907,700908],[701001,701002,701003,701004,701005,701006,701007,701008]],[[800901,800902,800903,800904,800905,800910,800911,800912,800906,800907,800908,800909],[801001,801002,801003,801004,801005,801010,801011,801012
      ,801006,801007,801008,801009]]];
      
      public function TryFightForSecondTurnbackManager()
      {
         super();
      }
      
      public static function init() : void
      {
         var _loc2_:SingleEquipInfo = null;
         _originalRoleType = MainManager.actorInfo.roleType;
         _originalModel = MainManager.actorModel;
         _originalSpriteID = _originalModel.spriteID;
         _originalTurnBack = MainManager.actorInfo.isTurnBack;
         _originalSecondTurnBackType = MainManager.actorInfo.secondTurnBackType;
         _originalLevel = MainManager.actorInfo.lv;
         _originalPower = MainManager.actorInfo.fightPower;
         _originalClothes = MainManager.actorInfo.clothes.concat(MainManager.actorInfo.fashionClothes);
         _originalSkills = MainManager.actorInfo.skills.concat();
         var _loc1_:Array = ItemManager.warCloth;
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.part == EquipPart.WEAPON && ItemXMLInfo.isMagicWeapon(_loc2_.itemID) == false)
            {
               _originalGildID = _loc2_.gildSkillID;
               _loc2_.gildSkillID = 4220801;
            }
         }
         FightManager.instance.addEventListener(FightEvent.BEGIN,onFightBegin);
         SocketConnection.addCmdListener(CommandID.STAGE_QUIT,onQuit);
      }
      
      private static function onQuit(param1:SocketEvent) : void
      {
         destroy();
      }
      
      private static function onFightBegin(param1:FightEvent) : void
      {
         var _loc6_:int = 0;
         var _loc7_:SingleEquipInfo = null;
         var _loc8_:KeyInfo = null;
         MainManager.actorInfo.roleType = roleType;
         MainManager.actorInfo.isTurnBack = true;
         MainManager.actorInfo.secondTurnBackType = secondChangeType;
         MainManager.actorInfo.lv = 120;
         MainManager.actorInfo.fightPower = 600000;
         var _loc2_:Vector.<SingleEquipInfo> = new Vector.<SingleEquipInfo>();
         var _loc3_:Array = EquipPart.getDefItems(roleType,MainManager.actorInfo.defEquipType).getValues();
         var _loc4_:uint = _loc3_.length;
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = new SingleEquipInfo();
            _loc7_.itemID = _loc3_[_loc6_];
            _loc2_[_loc6_] = _loc7_;
            _loc6_++;
         }
         MainManager.actorInfo.clothes = _loc2_;
         MainManager.actorModel.refreshRole();
         MainManager.actorModel.upDateNickText();
         MainManager.actorModel.spriteID = roleType;
         var _loc5_:Vector.<KeyInfo> = new Vector.<KeyInfo>();
         _loc6_ = 0;
         while(_loc6_ < _skills[roleType - 1][secondChangeType - 1].length)
         {
            _loc8_ = new KeyInfo();
            if(_loc6_ < 8)
            {
               _loc8_.funcID = KeyManager.skillQuickKeys[_loc6_];
            }
            _loc8_.dataID = _skills[roleType - 1][secondChangeType - 1][_loc6_];
            _loc8_.lv = 10;
            _loc5_.push(_loc8_);
            _loc6_++;
         }
         KeyManager.reset();
         MainManager.actorInfo.skills = _loc5_;
         KeyManager.upDateSkillQuickKeys(_loc5_);
         resetSkillCD();
         FightToolBar.instance.getQickBar().resetGildSkill();
         UserManager.execBehavior(MainManager.actorID,new ClothBehavior(MainManager.actorInfo.clothes,false),true);
         HeadSelfPanel.instance.headIconEnabled = false;
         FightToolBar.instance.disabledBag();
         KeySkillProcess.liyaChangeSkillState = 0;
         HeadSelfPanel.instance.init(MainManager.actorModel);
         FightToolBar.instance.getQickBar().removeShentong();
         KeyFuncProcess.shentongSkillForbidden = true;
      }
      
      public static function destroy() : void
      {
         var _loc2_:SingleEquipInfo = null;
         FightManager.instance.removeEventListener(FightEvent.BEGIN,onFightBegin);
         SocketConnection.removeCmdListener(CommandID.STAGE_QUIT,onQuit);
         MainManager.actorInfo.roleType = _originalRoleType;
         MainManager.actorInfo.isTurnBack = _originalTurnBack;
         MainManager.actorInfo.secondTurnBackType = _originalSecondTurnBackType;
         MainManager.actorModel = _originalModel;
         MainManager.actorInfo.lv = _originalLevel;
         MainManager.actorInfo.fightPower = _originalPower;
         MainManager.actorModel.refreshRole();
         MainManager.actorModel.spriteID = _originalRoleType;
         KeyManager.reset();
         MainManager.actorInfo.skills = _originalSkills;
         KeyManager.upDateSkillQuickKeys(MainManager.actorInfo.skills);
         KeyManager.upDateItemQuickKeys(MainManager.actorInfo.items);
         UserManager.execBehavior(MainManager.actorID,new ClothBehavior(_originalClothes,false),true);
         HeadSelfPanel.instance.headIconEnabled = true;
         FightToolBar.instance.enabledBag();
         MainManager.actorModel.upDateNickText();
         var _loc1_:Array = ItemManager.warCloth;
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.part == EquipPart.WEAPON && ItemXMLInfo.isMagicWeapon(_loc2_.itemID) == false)
            {
               _loc2_.gildSkillID = _originalGildID;
            }
         }
         HeadSelfPanel.instance.init(MainManager.actorModel);
         KeyFuncProcess.shentongSkillForbidden = false;
      }
      
      private static function resetSkillCD() : void
      {
         var data:Vector.<SummonShenTongInfo>;
         var cd:CDInfo = null;
         var activitySkills:Vector.<KeyInfo> = null;
         var length:int = 0;
         var index:int = 0;
         var i:int = 0;
         var step:SummonShenTongStepInfo = null;
         var level:SkillLevelInfo = null;
         KeyManager.skillQuickKeys.forEach(function(param1:uint, param2:int, param3:Vector.<uint>):void
         {
            var _loc4_:KeyInfo = KeyManager.getSingleInfoForFuncID(param1);
            var _loc5_:SkillLevelInfo = SkillXMLInfo.getLevelInfo(_loc4_.dataID,_loc4_.lv);
            if((Boolean(_loc5_)) && Boolean(_loc5_.cdFlag))
            {
               if(_loc5_.cd > 0)
               {
                  cd = new CDInfo();
                  cd.id = _loc4_.dataID;
                  cd.runTime = _loc5_.duration;
                  cd.cdTime = _loc5_.cd;
                  CDManager.skillCD.add(cd);
               }
            }
         });
         data = SummonShenTongManager.getData();
         if(data)
         {
            activitySkills = SummonShenTongManager.getActiveSkill();
            length = int(data.length);
            i = 0;
            while(i < length)
            {
               if(Boolean(data[i]) && Boolean(data[i].getMatchShenTong()))
               {
                  step = data[i].getMatchShenTong();
                  level = SkillXMLInfo.getLevelInfo(step.skillId,step.skillLevel);
                  if(Boolean(level) && Boolean(level.cdFlag))
                  {
                     if(level.cd > 0)
                     {
                        cd = new CDInfo();
                        cd.id = step.skillId;
                        cd.runTime = level.duration;
                        cd.cdTime = level.cd;
                        CDManager.skillCD.add(cd);
                     }
                  }
               }
               i++;
            }
         }
      }
   }
}

