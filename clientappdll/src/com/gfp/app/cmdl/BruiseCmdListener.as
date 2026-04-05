package com.gfp.app.cmdl
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.manager.UserAddManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.BaseAction;
   import com.gfp.core.action.data.HitEffInfo;
   import com.gfp.core.action.net.NetBruiseAction;
   import com.gfp.core.action.net.NetFlightAction;
   import com.gfp.core.action.net.NetKnockFlyAction;
   import com.gfp.core.action.normal.BadAction;
   import com.gfp.core.action.normal.DieAction;
   import com.gfp.core.action.normal.ExplodeAction;
   import com.gfp.core.action.normal.SpecialBruiseAction;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.config.xml.SkillXMLInfo;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.fight.BruiseInfo;
   import com.gfp.core.info.fight.SkillConfigInfo;
   import com.gfp.core.info.fight.SkillLevelInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MonsterHpAlertManager;
   import com.gfp.core.manager.NumberManager;
   import com.gfp.core.manager.ScreenInfoManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.MapModel;
   import com.gfp.core.model.SummonModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.sound.SoundManager;
   import com.gfp.core.ui.UINumber;
   import com.gfp.core.utils.SpriteType;
   import flash.geom.Point;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class BruiseCmdListener extends BaseBean
   {
      
      private static var soundHits:Array;
      
      private static var soundHitLen:int;
      
      public function BruiseCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.ACTION_BRUISE,this.onEvent);
         finish();
      }
      
      private function onEvent(param1:SocketEvent) : void
      {
         var _loc4_:HitEffInfo = null;
         var _loc5_:uint = 0;
         var _loc2_:BruiseInfo = param1.data as BruiseInfo;
         var _loc3_:UserModel = UserManager.getModel(_loc2_.userID);
         if(_loc2_.decHP == 0)
         {
            if(_loc3_)
            {
               if(_loc2_.hp <= 0)
               {
                  if(_loc3_ is SummonModel)
                  {
                     this.execDie(_loc3_,_loc2_,this.getHitEffInfo(_loc2_));
                  }
                  else
                  {
                     this.execExplode(_loc3_,_loc2_);
                  }
               }
               else
               {
                  NumberManager.showMiss(_loc3_);
                  UserManager.dispatchEvent(new UserEvent(UserEvent.USER_DPS_HIT,_loc2_));
               }
            }
         }
         else
         {
            if(_loc3_)
            {
               _loc4_ = this.getHitEffInfo(_loc2_);
               switch(_loc2_.decType)
               {
                  case 0:
                     _loc3_.setDecHP(_loc2_.decHP);
                     _loc3_.setHP(_loc2_.hp,_loc2_.atkerID);
                     if(_loc2_.hp > 0)
                     {
                        if(!_loc3_.isHided && !_loc3_.isHideBloodBar)
                        {
                           _loc3_.showBloodBar();
                        }
                        else
                        {
                           _loc3_.hideBloodBar();
                        }
                        this.execBruise(_loc3_,_loc2_,_loc4_);
                        _loc5_ = Math.ceil(_loc2_.hp * 100 / _loc3_.getTotalHP());
                        MonsterHpAlertManager.instance.showForMonster(_loc2_.roleID,_loc5_);
                     }
                     else
                     {
                        this.execDie(_loc3_,_loc2_,_loc4_);
                     }
                     this.execShow(_loc3_,_loc2_);
                     break;
                  case 1:
                     if(_loc2_.hp <= 0)
                     {
                        this.execExplode(_loc3_,_loc2_);
                        break;
                     }
                     NumberManager.showAbsorb(_loc3_);
                     this.execBruise(_loc3_,_loc2_,_loc4_);
                     UserManager.dispatchEvent(new UserEvent(UserEvent.USER_DPS_HIT,_loc2_));
               }
            }
            if(_loc2_.atkerID == MainManager.actorID)
            {
               this.mapShock(_loc2_);
               if(_loc2_.hitCount > 0)
               {
                  ScreenInfoManager.showComboHit(_loc2_.hitCount);
                  TasksManager.dispatchParamsEvent(TaskActionEvent.TASK_HIT_HAPPENED,{
                     "hit":_loc2_.hitCount,
                     "stageId":PveEntry.instance.getStageID()
                  });
               }
               if(MainManager.actorInfo.fightRage < 100)
               {
                  ++MainManager.actorInfo.fightRage;
                  UserInfoManager.ed.dispatchEvent(new UserEvent(UserEvent.FIGHT_RAGE_CHANGED));
               }
               this.playSoundHit(_loc2_);
            }
            if(_loc2_.hp <= 0)
            {
               UserAddManager.removeMonster(_loc2_.userID);
            }
            PveEntry.instance.setMemberAttribute(_loc2_.userID,_loc2_.hp,-1);
         }
      }
      
      private function execBruise(param1:UserModel, param2:BruiseInfo, param3:HitEffInfo) : void
      {
         var _loc5_:BaseAction = null;
         var _loc6_:SkillConfigInfo = null;
         var _loc7_:UserModel = null;
         var _loc4_:int = 0;
         switch(param2.type)
         {
            case 0:
               _loc5_ = new NetBruiseAction(ActionXMLInfo.getInfo(40001),param3,param2.runDuration,param2.stiffDuration,param2.pos);
               _loc5_.viewEnabled = false;
               param1.execAction(_loc5_);
               break;
            case 1:
               this.updateOffPos(param1,param2);
               param1.execAction(new NetBruiseAction(ActionXMLInfo.getInfo(40001),param3,param2.runDuration,param2.stiffDuration,param2.pos));
               break;
            case 2:
               this.updateOffPos(param1,param2);
               if(param1.spriteType != SpriteType.PEOPLE || this.isOgerState(param1))
               {
                  _loc4_ = 40007;
               }
               else
               {
                  _loc4_ = 40002;
               }
               param1.execAction(new NetBruiseAction(ActionXMLInfo.getInfo(_loc4_),param3,param2.runDuration,param2.stiffDuration,param2.pos,false));
               break;
            case 3:
               param1.actionManager.clear();
               this.updateOffPos(param1,param2);
               if(param1.spriteType != SpriteType.PEOPLE || this.isOgerState(param1))
               {
                  _loc4_ = 40008;
               }
               else
               {
                  _loc4_ = 40006;
               }
               param1.execAction(new NetKnockFlyAction(ActionXMLInfo.getInfo(_loc4_),param3,param2.runDuration,param2.stiffDuration,param2.pos));
               break;
            case 4:
               this.updateOffPos(param1,param2);
               param1.execAction(new NetBruiseAction(ActionXMLInfo.getInfo(40001),param3,param2.runDuration,param2.stiffDuration,param2.pos));
               break;
            case 5:
               this.updateOffPos(param1,param2);
               break;
            case 6:
               this.updateOffPos(param1,param2);
               param1.execAction(new NetFlightAction(ActionXMLInfo.getInfo(40019),param3,param2.runDuration,param2.stiffDuration,param2.pos));
               break;
            case 7:
            case 8:
               _loc6_ = SkillXMLInfo.getInfo(param2.skillID);
               if((Boolean(_loc6_)) && Boolean(_loc6_.bruiseMonsterActionID))
               {
                  _loc7_ = UserManager.getModel(param2.atkerID);
                  if(_loc7_)
                  {
                     param1.execAction(new SpecialBruiseAction(_loc6_.bruiseMonsterActionID,param2));
                  }
               }
         }
         if(param2.atkerID == MainManager.actorID)
         {
            if(Math.random() < 0.3)
            {
               SoundManager.playSound(ClientConfig.getSoundBruise(RoleXMLInfo.getResID(param2.roleID)),0.3,false,0.5);
            }
         }
      }
      
      private function updateOffPos(param1:UserModel, param2:BruiseInfo) : void
      {
         var _loc3_:Point = MapManager.getEndPosForPos(param1.pos,param2.pos);
         if(_loc3_)
         {
            param2.pos = _loc3_;
            if(Boolean(param1.info) && param1.info.userID == MainManager.actorID)
            {
               MainManager.actorInfo.lastWalkPoint = _loc3_;
            }
         }
      }
      
      private function execExplode(param1:UserModel, param2:BruiseInfo) : void
      {
         if(param1.spriteType != SpriteType.PEOPLE)
         {
            UserManager.remove(param2.userID);
            param1.destroyBloodBar();
            param1.delayDestroy(1000);
         }
         UserManager.dispatchEvent(new UserEvent(UserEvent.EXPLODED,param1));
         param1.execAction(new ExplodeAction());
         SoundManager.playSound(ClientConfig.getSoundExplode(param2.roleID),0.3,false,0.5);
      }
      
      private function execDie(param1:UserModel, param2:BruiseInfo, param3:HitEffInfo) : void
      {
         var _loc4_:Array = null;
         FightManager.instance.dispatchEvent(new FightEvent(FightEvent.OGRE_DIEING,param1.info));
         if(param1.spriteType != SpriteType.PEOPLE && param1.spriteType != SpriteType.SUMMON)
         {
            UserManager.remove(param2.userID);
            param1.destroyBloodBar();
         }
         if(param1.spriteType == SpriteType.SOLID)
         {
            param1.execAction(new BadAction());
            param1.delayDestroy(5000);
         }
         else
         {
            this.updateOffPos(param1,param2);
            param1.execAction(new DieAction(ActionXMLInfo.getInfo(40004),param3,param2.pos));
            _loc4_ = [13999,14212,14213,14214,3255,3256];
            if(_loc4_.indexOf(param1.spriteID) != -1)
            {
               param1.hide();
            }
            else if(param1.spriteType != SpriteType.PEOPLE && param1.spriteType != SpriteType.SUMMON && !UserManager.isTeammate(param2.userID))
            {
               param1.delayDestroy(3000);
            }
            if(param2.atkerID == MainManager.actorID)
            {
               SoundManager.playSound(ClientConfig.getSoundDie(RoleXMLInfo.getResID(param2.roleID)),0.3,false,0.5);
            }
         }
         if(!PveEntry.instance.isInTowerStage())
         {
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_MONSTERWANTED,param1.info.roleType.toString());
         }
         if(FightManager.instance.hasEventListener(FightEvent.OGRE_DIE))
         {
            param1.info.pos.x = param1.x;
            param1.info.pos.y = param1.y;
            FightManager.instance.dispatchEvent(new FightEvent(FightEvent.OGRE_DIE,param1.info));
         }
      }
      
      private function execShow(param1:UserModel, param2:BruiseInfo) : void
      {
         var _loc3_:Boolean = false;
         if(param2.breakFlag)
         {
            _loc3_ = false;
            if(param2.userID == MainManager.actorInfo.userID)
            {
               _loc3_ = true;
            }
            if(param2.type != 3)
            {
               param1.actionManager.clear();
               param1.execStandAction(_loc3_);
            }
            NumberManager.showSkillBreak(param1);
         }
         if(param2.crit)
         {
            NumberManager.showCrit(param1,param2.decHP,param2.critMultiple);
         }
         else if(param2.userID == MainManager.actorID)
         {
            NumberManager.showSub(param1,param2.decHP,UINumber.PURPLE);
         }
         else
         {
            NumberManager.showSub(param1,param2.decHP,UINumber.RED);
         }
         UserManager.dispatchEvent(new UserEvent(UserEvent.USER_DPS_HIT,param2));
      }
      
      private function getHitEffInfo(param1:BruiseInfo) : HitEffInfo
      {
         var _loc2_:HitEffInfo = null;
         var _loc3_:UserModel = null;
         var _loc4_:SkillLevelInfo = null;
         if(param1.weaponEnchantedType > 0)
         {
            _loc2_ = new HitEffInfo();
            _loc2_.duration = 0.4;
            _loc2_.id = 20163 + param1.weaponEnchantedType;
            _loc2_.repeat = 1;
            _loc3_ = UserManager.getModel(param1.atkerID);
            if(_loc3_)
            {
               _loc2_.atkerDir = _loc3_.direction;
            }
         }
         else
         {
            _loc4_ = SkillXMLInfo.getLevelInfo(param1.skillID,param1.skillLv);
            if(_loc4_)
            {
               if(_loc4_.hitEffInfo)
               {
                  _loc2_ = _loc4_.hitEffInfo.clone();
                  _loc3_ = UserManager.getModel(param1.atkerID);
                  if(_loc3_)
                  {
                     _loc2_.atkerDir = _loc3_.direction;
                  }
               }
            }
         }
         return _loc2_;
      }
      
      private function mapShock(param1:BruiseInfo) : void
      {
         var _loc2_:MapModel = null;
         if(param1.crit)
         {
            _loc2_ = MapManager.currentMap;
            if(_loc2_)
            {
               _loc2_.shock();
            }
         }
      }
      
      private function playSoundHit(param1:BruiseInfo) : void
      {
         if(soundHits == null)
         {
            soundHits = RoleXMLInfo.soundHitMap.getValue(MainManager.roleType);
            soundHitLen = soundHits.length;
         }
         if(soundHitLen > 0)
         {
            SoundManager.playSound(ClientConfig.getSoundHit(soundHits[int(Math.random() * soundHitLen)]));
         }
      }
      
      private function isOgerState(param1:UserModel) : Boolean
      {
         var _loc2_:int = int(param1.info.skillMonsterID);
         if(_loc2_ > 0)
         {
            if(RoleXMLInfo.getStageEnable(_loc2_))
            {
               return true;
            }
         }
         return false;
      }
   }
}

