package com.gfp.app.cmdl
{
   import com.gfp.app.control.ActorMoveEventControl;
   import com.gfp.app.fight.FightGo;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.FightOgreManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.manager.CatchSummonManager;
   import com.gfp.app.manager.EscortManager;
   import com.gfp.app.manager.fightPlugin.AutoFightManager;
   import com.gfp.app.toolBar.HeadSummonPanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.SummonInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.HeroSoulManager;
   import com.gfp.core.manager.HiddenManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.OgreModel;
   import com.gfp.core.model.SpriteModel;
   import com.gfp.core.model.SummonModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.FightBloodBar;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Direction;
   import com.gfp.core.utils.FightMode;
   import com.gfp.core.utils.SpriteType;
   import com.gfp.core.utils.TroopType;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class StageUserListCmdListener extends BaseBean
   {
      
      public function StageUserListCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.STAGE_USER_LIST,this.onUserList);
         SocketConnection.addCmdListener(CommandID.FIGHT_MONSTER_BORN,this.onMonsterBorn);
         SocketConnection.addCmdListener(CommandID.FIGHT_MONSTER_RECYCLE,this.onMonsterRecycle);
         SocketConnection.addCmdListener(CommandID.STAGE_HIDDEN_STATE_CHANGE,this.onHiddenStateChange);
         SocketConnection.addCmdListener(CommandID.FIGHT_MONSTER_DIALOG,this.onMonsterDialog);
         finish();
      }
      
      private function onUserList(param1:SocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc7_:UserInfo = null;
         var _loc8_:uint = 0;
         var _loc9_:SummonInfo = null;
         var _loc10_:SummonModel = null;
         var _loc11_:SummonModel = null;
         var _loc12_:int = 0;
         var _loc13_:UserInfo = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         FightOgreManager.resetCount();
         if(MainManager.actorModel.fightSummonModel)
         {
            MainManager.actorModel.fightSummonModel.destroyAIwords();
         }
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:Array = [];
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc7_ = UserInfoManager.creatInfo();
            UserInfo.setForStageInfo(_loc7_,_loc2_);
            _loc7_.serverID = MainManager.serverID;
            if(SpriteModel.getSpriteType(_loc7_.roleType) == SpriteType.SUMMON)
            {
               _loc9_ = new SummonInfo();
               _loc9_.masterID = _loc7_.masterID;
               _loc9_.uniqueID = _loc7_.createTime;
               _loc9_.roleID = _loc7_.roleType;
               _loc9_.stageID = _loc7_.userID;
               _loc9_.quality = _loc7_.quality;
               _loc9_.lv = _loc7_.lv;
               _loc9_.nick = _loc7_.nick;
               _loc9_.exp = _loc7_.exp;
               _loc9_.troop = _loc7_.troop;
               _loc9_.pos = _loc7_.pos;
               _loc9_.hp = _loc7_.hp;
               _loc9_.hpMax = _loc7_.maxHp;
               _loc9_.mp = _loc7_.mp;
               _loc9_.mpMax = _loc7_.maxMp;
               _loc9_.troop = MainManager.actorInfo.troop;
               _loc9_.serverSpeed = _loc7_.serverSpeed;
               _loc9_.rage = _loc7_.fightRage;
               _loc9_.isTurnBack = _loc7_.isTurnBack;
               _loc9_.direction = _loc7_.direction;
               _loc10_ = new SummonModel(_loc9_,null);
               _loc11_ = MainManager.actorModel.fightSummonModel;
               if(_loc7_.masterID == MainManager.actorID && (_loc11_ == null || _loc7_.userID == _loc11_.summonInfo.stageID))
               {
                  MainManager.actorModel.fightSummonModel = _loc10_;
                  HeadSummonPanel.instance.init(_loc10_);
                  HeadSummonPanel.instance.show();
                  _loc10_.fightWord();
               }
               _loc10_.setBloodBar(new FightBloodBar(FightBloodBar.COLOR_SELF));
               _loc10_.initHP(_loc9_.hpMax);
               _loc10_.setHP(_loc9_.hp);
               _loc10_.initMP(_loc9_.mpMax);
               _loc10_.setMP(_loc9_.mp);
               MapManager.currentMap.addUser(_loc7_.userID,_loc10_);
               SummonManager.setupForStage(_loc7_.masterID,_loc9_);
               if(_loc7_.masterID == 0 && _loc9_.stageID != CatchSummonManager.instance.stageID)
               {
                  CatchSummonManager.instance.setCatchableSummon(_loc9_.stageID,_loc9_.roleID);
               }
            }
            _loc8_ = _loc2_.readUnsignedShort();
            if(_loc7_.userID == MainManager.actorID && FightManager.fightMode != FightMode.WATCH)
            {
               this.initActor(_loc7_);
               _loc12_ = int(MainManager.actorInfo.monsterID);
               if(_loc12_ > 0)
               {
                  if(!RoleXMLInfo.getStageEnable(_loc12_) || EscortManager.instance.escortPathId != 0)
                  {
                     MainManager.actorModel.resetRoleView();
                  }
               }
            }
            else
            {
               _loc4_.push(_loc7_);
            }
            _loc5_++;
         }
         var _loc6_:int = 0;
         if(PveEntry.instance.getStageID() == 1043)
         {
            _loc6_ = this.getSummonLevel();
         }
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc13_ = _loc4_[_loc5_];
            if(_loc6_ > 0 && SpriteModel.getSpriteType(_loc7_.roleType) != SpriteType.SUMMON)
            {
               _loc13_.lv = _loc6_;
            }
            FightOgreManager.addUser(_loc13_);
            if(_loc13_.troop == MainManager.actorInfo.troop || _loc13_.troop == TroopType.NEUTRAL_PLAYER)
            {
               FightOgreManager.addMemberInfo(_loc13_);
            }
            _loc5_++;
         }
         FightOgreManager.init();
         if(FightManager.isTeamFight)
         {
            PveEntry.instance.initMemberHead();
         }
         HiddenManager.creatCmdListener();
         ActorMoveEventControl.instance.setup();
         MapManager.dispatchEvent(new MapEvent(MapEvent.STAGE_USER_LISET_COMPLETE,MapManager.currentMap));
      }
      
      private function getSummonLevel() : int
      {
         var _loc1_:SummonInfo = SummonManager.getActorSummonInfo().currentSummonInfo;
         if(_loc1_ == null || _loc1_.summonType != 1031)
         {
            return 160;
         }
         if(_loc1_.lv >= 100)
         {
            return 110;
         }
         return 160 - (_loc1_.lv - 1) / 2;
      }
      
      private function onMonsterBorn(param1:SocketEvent) : void
      {
         var _loc5_:SummonInfo = null;
         var _loc6_:SummonModel = null;
         var _loc7_:int = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:UserInfo = UserInfoManager.creatInfo();
         UserInfo.setForStageInfo(_loc3_,_loc2_,false);
         _loc3_.serverID = MainManager.serverID;
         if(SpriteModel.getSpriteType(_loc3_.roleType) == SpriteType.SUMMON)
         {
            _loc5_ = new SummonInfo();
            _loc5_.masterID = _loc3_.masterID;
            _loc5_.uniqueID = _loc3_.createTime;
            _loc5_.roleID = _loc3_.roleType;
            _loc5_.stageID = _loc3_.userID;
            _loc5_.quality = _loc3_.quality;
            _loc5_.lv = _loc3_.lv;
            _loc5_.nick = _loc3_.nick;
            _loc5_.exp = _loc3_.exp;
            _loc5_.troop = _loc3_.troop;
            _loc5_.pos = _loc3_.pos;
            _loc5_.hp = _loc3_.hp;
            _loc5_.hpMax = _loc3_.maxHp;
            _loc5_.mp = _loc3_.mp;
            _loc5_.serverSpeed = _loc3_.serverSpeed;
            _loc6_ = new SummonModel(_loc5_,null);
            if(MainManager.actorModel.fightSummonModel == null)
            {
               MainManager.actorModel.fightSummonModel = _loc6_;
               HeadSummonPanel.instance.clearCutDown();
               HeadSummonPanel.instance.init(_loc6_);
               HeadSummonPanel.instance.show();
            }
            MapManager.currentMap.addUser(_loc3_.userID,_loc6_);
            SummonManager.setupForStage(_loc3_.masterID,_loc5_);
         }
         else
         {
            _loc7_ = 0;
            if(PveEntry.instance.getStageID() == 1043)
            {
               _loc7_ = this.getSummonLevel();
            }
            if(_loc7_ > 0)
            {
               _loc3_.lv = _loc7_;
            }
         }
         if(SpriteModel.getSpriteType(_loc3_.roleType) == SpriteType.SOUL && MainManager.actorInfo.heroSoulType == _loc3_.roleType)
         {
            HeroSoulManager.getActorHeroSoulInfo().currentHeroSoulInfo.stageID = _loc3_.userID;
         }
         var _loc4_:uint = _loc2_.readUnsignedShort();
         FightOgreManager.addUser(_loc3_,this.checkBornEffect(_loc3_.roleType));
         if(_loc3_.roleType == 12069)
         {
            TextAlert.show("调皮的弱亚出现！");
         }
         AutoFightManager.instance.isTelShow = false;
         FightOgreManager.init();
         FightGo.destroy();
      }
      
      private function checkBornEffect(param1:uint) : Boolean
      {
         var _loc2_:uint = uint(SpriteModel.getSpriteType(param1));
         switch(_loc2_)
         {
            case SpriteType.PEOPLE:
            case SpriteType.Z_HIDDEN_STOP:
            case SpriteType.Z_HIDDEN_ANIMAT:
            case SpriteType.HIDDEN_STOP:
            case SpriteType.HIDDEN_ANIMAT:
            case SpriteType.TREASURE_BOX:
            case SpriteType.CARRIER:
               return false;
            default:
               return true;
         }
      }
      
      private function onMonsterRecycle(param1:SocketEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:UserModel = UserManager.remove(_loc3_);
         if(_loc4_)
         {
            _loc5_ = uint(_loc4_.spriteType);
            switch(_loc4_.spriteType)
            {
               case SpriteType.Z_HIDDEN_STOP:
               case SpriteType.Z_HIDDEN_ANIMAT:
               case SpriteType.HIDDEN_STOP:
               case SpriteType.HIDDEN_ANIMAT:
               case SpriteType.TREASURE_BOX:
               case SpriteType.CARRIER:
                  HiddenManager.remove(_loc3_);
            }
            UserManager.addDispatcher(new UserEvent(UserEvent.RECYCLE,_loc4_));
            _loc4_.destroy();
         }
      }
      
      private function onHiddenStateChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         HiddenManager.executeStateChange(_loc3_,_loc4_);
      }
      
      private function onMonsterDialog(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = uint(param1.headInfo.userID);
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:OgreModel = UserManager.getModel(_loc3_) as OgreModel;
         if(_loc5_)
         {
            _loc5_.showDialog(_loc4_);
         }
      }
      
      private function initActor(param1:UserInfo) : void
      {
         MainManager.actorModel.pos = param1.pos;
         MainManager.actorInfo.troop = param1.troop;
         MainManager.actorModel.initHP(param1.maxHp);
         MainManager.actorModel.setHP(param1.hp);
         MainManager.actorModel.initMP(param1.maxMp);
         MainManager.actorModel.setMP(param1.mp);
         MainManager.actorModel.setTroop(param1.troop);
         MainManager.actorModel.direction = Direction.indexToStr2(param1.direction);
         MainManager.actorModel.info.changeClothID = param1.changeClothID;
         MainManager.actorModel.info.ridedID = param1.ridedID;
         MainManager.actorInfo.fightRage = param1.fightRage;
         UserInfoManager.ed.dispatchEvent(new UserEvent(UserEvent.FIGHT_RAGE_CHANGED));
         SummonManager.updateSummonView(param1.userID);
      }
   }
}

