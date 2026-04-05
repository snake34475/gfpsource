package com.gfp.app.fight
{
   import com.gfp.core.Constant;
   import com.gfp.core.action.data.EffectInfo;
   import com.gfp.core.action.data.RemoteInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.PlayerOrgeConfig;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.config.xml.PlayerOrgeXMLInfo;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.config.xml.SkillXMLInfo;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.fight.SkillLevelInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.manager.DeffEquiptManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.model.SpriteModel;
   import com.gfp.core.sound.SoundManager;
   import com.gfp.core.utils.EquipPart;
   import com.gfp.core.utils.SkillType;
   import com.gfp.core.utils.SpriteType;
   import org.taomee.ds.HashMap;
   
   public class FightRes
   {
      
      public static const EQUIP:int = 1;
      
      public static const EFFECT:int = 2;
      
      public static const NPC:int = 3;
      
      public static const SOUND:int = 4;
      
      public static const DEFAULT_FIGHT_LOADING:int = 0;
      
      public static const PRIORITY_ARR:Array = [10002,40001,40006,40007,40008,10004,10005,40004];
      
      private static const NORMAL_ACTION_IDS:Array = [10001,10002,10003,10004,10005];
      
      private var _peopleActionList:Vector.<uint>;
      
      private var _npcActionList:Vector.<uint>;
      
      private var _waitList:Array;
      
      private var _soundWaitList:Array;
      
      private var _isPvpLoad:Boolean = false;
      
      private var _addNpcNum:int = 0;
      
      public function FightRes()
      {
         super();
         this._peopleActionList = ActionXMLInfo.peopleLoads.concat();
         this._npcActionList = ActionXMLInfo.npcLoads.concat();
         this._soundWaitList = new Array();
      }
      
      public function addPeopleActions(param1:Vector.<uint>) : void
      {
         this._peopleActionList = this._peopleActionList.concat(param1);
      }
      
      public function parseAll(param1:Array, param2:Array = null, param3:Boolean = false) : Array
      {
         var _loc4_:UserInfo = null;
         var _loc5_:int = 0;
         this._waitList = new Array();
         this._isPvpLoad = param3;
         for each(_loc4_ in param1)
         {
            this.parsePeopleInfo(_loc4_);
         }
         if(param2)
         {
            for each(_loc4_ in param2)
            {
               _loc5_ = int(SpriteModel.getSpriteType(_loc4_.roleType));
               if(_loc5_ == SpriteType.OGRE || _loc5_ == SpriteType.NPC)
               {
                  this.parseNpcInfo(_loc4_);
               }
               else if(_loc5_ == SpriteType.SUMMON)
               {
                  this.parseNpcInfo(_loc4_);
               }
               else if(_loc5_ == SpriteType.SOLID)
               {
                  this.parseSolidInfo(_loc4_);
               }
               else if(_loc5_ == SpriteType.PLAYER_OGRE)
               {
                  _loc4_ = PlayerOrgeConfig.getUserInfo(_loc4_);
                  this.parsePeopleInfo(_loc4_);
               }
            }
         }
         this.optimizeWaitList();
         return this._waitList;
      }
      
      private function parseNpcInfo(param1:UserInfo) : void
      {
         var _loc3_:KeyInfo = null;
         var _loc4_:uint = 0;
         var _loc5_:SkillLevelInfo = null;
         var _loc6_:RemoteInfo = null;
         var _loc2_:Vector.<KeyInfo> = param1.skills;
         for each(_loc3_ in _loc2_)
         {
            _loc5_ = SkillXMLInfo.getLevelInfo(_loc3_.dataID,_loc3_.lv);
            if(_loc5_)
            {
               if(_loc5_.actionID > 0)
               {
                  this.parseEffect(_loc5_.actionID);
               }
               if(_loc5_.hitEffInfo)
               {
                  if(_loc5_.hitEffInfo.id > 0)
                  {
                     this.addEffectWaitInfo(_loc5_.hitEffInfo.id);
                  }
               }
               if(_loc5_.remoteInfos)
               {
                  for each(_loc6_ in _loc5_.remoteInfos)
                  {
                     if(_loc6_.id > 0)
                     {
                        this.addEffectWaitInfo(_loc6_.id);
                     }
                  }
               }
            }
         }
         for each(_loc4_ in this._npcActionList)
         {
            this.parseEffect(_loc4_);
         }
      }
      
      public function parsePeopleInfo(param1:UserInfo) : void
      {
         var keyArr:Array;
         var def:HashMap = null;
         var itemID:int = 0;
         var userInfo:UserInfo = param1;
         var resID:uint = uint(RoleXMLInfo.getResID(userInfo.roleType));
         if(resID > Constant.MAX_ROLE_TYPE)
         {
            resID = uint(PlayerOrgeXMLInfo.getPlayerType(resID));
            userInfo.isSuperAdvc = true;
         }
         def = EquipPart.getDefFashionItems(resID,userInfo.defEquipType);
         if(!DeffEquiptManager.isDisplayDeffEquipt)
         {
            userInfo.fashionClothes.forEach(function(param1:SingleEquipInfo, param2:int, param3:Vector.<SingleEquipInfo>):void
            {
               var _loc4_:uint = uint(ItemXMLInfo.getEquipPart(param1.itemID));
               if(def.containsKey(_loc4_))
               {
                  def.add(_loc4_,param1.itemID);
               }
            },this);
         }
         keyArr = def.getValues();
         for each(itemID in keyArr)
         {
            if(!((ItemXMLInfo.getEquipPart(itemID) == EquipPart.BELT || ItemXMLInfo.getEquipPart(itemID) == EquipPart.FASHION_BELT) && resID < Constant.ROLE_TYPE_TIGER))
            {
               this.parsePeopleActionInfo(itemID,userInfo);
            }
         }
         this.parsePeopleSkillInfo(userInfo);
      }
      
      private function parsePeopleActionInfo(param1:uint, param2:UserInfo) : void
      {
         var _loc4_:uint = 0;
         if(param1 == 0)
         {
            return;
         }
         var _loc3_:Boolean = param2.userID == MainManager.actorID;
         for each(_loc4_ in this._peopleActionList)
         {
            if(!(_loc3_ && NORMAL_ACTION_IDS.indexOf(_loc4_) > -1))
            {
               this.parseEffect(_loc4_);
            }
         }
      }
      
      private function parsePeopleSkillInfo(param1:UserInfo) : void
      {
         var _loc3_:KeyInfo = null;
         var _loc4_:Boolean = false;
         var _loc5_:uint = 0;
         var _loc6_:SkillLevelInfo = null;
         var _loc7_:RemoteInfo = null;
         var _loc2_:Vector.<KeyInfo> = param1.skills;
         for each(_loc3_ in _loc2_)
         {
            _loc6_ = SkillXMLInfo.getLevelInfo(_loc3_.dataID,_loc3_.lv);
            if(_loc6_)
            {
               if(_loc6_.actionID > 0)
               {
                  this.parseEffect(_loc6_.actionID);
               }
               if(_loc6_.hitEffInfo)
               {
                  if(_loc6_.hitEffInfo.id > 0)
                  {
                     this.addEffectWaitInfo(_loc6_.hitEffInfo.id);
                  }
               }
               if(_loc6_.remoteInfos)
               {
                  for each(_loc7_ in _loc6_.remoteInfos)
                  {
                     if(_loc7_.id > 0)
                     {
                        this.addEffectWaitInfo(_loc7_.id);
                     }
                  }
               }
            }
         }
         _loc4_ = param1.userID == MainManager.actorID;
         for each(_loc5_ in this._peopleActionList)
         {
            if(!(_loc4_ && NORMAL_ACTION_IDS.indexOf(_loc5_) > -1))
            {
               this.parseEffect(_loc5_);
            }
         }
      }
      
      private function parseSolidInfo(param1:UserInfo) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:Vector.<uint> = ActionXMLInfo.solidLoads;
         for each(_loc3_ in _loc2_)
         {
            this.parseEffect(_loc3_);
         }
      }
      
      private function parseEffect(param1:uint) : void
      {
         var _loc3_:EffectInfo = null;
         var _loc2_:Array = ActionXMLInfo.getInfo(param1).effects;
         for each(_loc3_ in _loc2_)
         {
            this.addEffectWaitInfo(uint(_loc3_.id));
         }
      }
      
      private function addEffectWaitInfo(param1:uint) : void
      {
         var _loc2_:WaitInfo = new WaitInfo();
         _loc2_.type = EFFECT;
         _loc2_.itemID = param1;
         _loc2_.priorityLevel = 6;
         this.addResWaite(_loc2_);
      }
      
      private function optimizeWaitList() : void
      {
         var arr:Array;
         var item:WaitInfo = null;
         var b:Boolean = false;
         this._waitList = this._waitList.filter(function(param1:WaitInfo, param2:int, param3:Array):Boolean
         {
            if(param1.type == EQUIP || param1.type == NPC || param1.type == SOUND)
            {
               if(param1.url == null || param1.url == "")
               {
                  return false;
               }
            }
            else if(param1.type == EFFECT)
            {
               if(param1.itemID == 0)
               {
                  return false;
               }
            }
            return true;
         });
         arr = [];
         for each(item in this._waitList)
         {
            b = arr.some(function(param1:WaitInfo, param2:int, param3:Array):Boolean
            {
               if(item.itemID == param1.itemID && item.url == param1.url)
               {
                  return true;
               }
               return false;
            });
            if(!b)
            {
               arr.push(item);
            }
         }
         this._waitList = arr;
      }
      
      public function parseSoundAll(param1:Array, param2:Array = null) : Array
      {
         var _loc3_:UserInfo = null;
         for each(_loc3_ in param1)
         {
            this.parseSoundDie(_loc3_.roleType);
            this.parsePeopleSkillSound(_loc3_);
         }
         for each(_loc3_ in param2)
         {
            this.parseSoundBruise(_loc3_.roleType);
            this.parseSoundDie(_loc3_.roleType);
            this.parseSoundExplode(_loc3_.roleType);
         }
         this.parseActorSounds(MainManager.roleType);
         return this._soundWaitList;
      }
      
      private function parsePeopleSkillSound(param1:UserInfo) : void
      {
         var _loc3_:KeyInfo = null;
         var _loc4_:uint = 0;
         var _loc2_:Vector.<KeyInfo> = param1.skills;
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = uint(_loc3_.dataID);
            if(this.hasSkillAct(_loc4_,param1.isTurnBack))
            {
               this.parseSoundSkill(_loc4_);
               this.parseSoundRemote(_loc4_,_loc3_.lv);
            }
         }
      }
      
      private function hasSkillAct(param1:uint, param2:Boolean = false) : Boolean
      {
         var _loc3_:uint = uint(SkillXMLInfo.getType(param1));
         if(_loc3_ == SkillType.SKILL_TYPE_BE || _loc3_ == SkillType.SKILL_TYPE_BUFF || param1 == 500607)
         {
            return false;
         }
         if(param2 && _loc3_ == SkillType.SKILL_TYPE_NORM && param1 % 1000 == 506)
         {
            return false;
         }
         return true;
      }
      
      private function parseActorSounds(param1:uint) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:WaitInfo = null;
         var _loc2_:Array = RoleXMLInfo.soundHitMap.getValue(param1);
         for each(_loc3_ in _loc2_)
         {
            this.addSoundWaite(ClientConfig.getSoundHit(_loc3_));
         }
         _loc2_ = RoleXMLInfo.soundHowlMap.getValue(param1);
         for each(_loc3_ in _loc2_)
         {
            this.addSoundWaite(ClientConfig.getSoundHowl(_loc3_));
         }
      }
      
      private function parseSoundSkill(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(param1 > 0)
         {
            _loc2_ = uint(SkillXMLInfo.getSkillIconResId(param1));
            this.addSoundWaite(ClientConfig.getSoundSkill(_loc2_));
         }
      }
      
      private function parseSoundRemote(param1:uint, param2:uint) : void
      {
         var _loc3_:SkillLevelInfo = null;
         var _loc4_:RemoteInfo = null;
         if(param1 > 0 && param2 > 0)
         {
            _loc3_ = SkillXMLInfo.getLevelInfo(param1,param2);
            if(Boolean(_loc3_) && Boolean(_loc3_.remoteInfos))
            {
               for each(_loc4_ in _loc3_.remoteInfos)
               {
                  this.addSoundWaite(ClientConfig.getSoundRemote(_loc4_.id));
               }
            }
         }
      }
      
      private function parseSoundDie(param1:uint) : void
      {
         var _loc2_:uint = uint(RoleXMLInfo.getResID(param1));
         this.addSoundWaite(ClientConfig.getSoundDie(_loc2_));
      }
      
      private function parseSoundExplode(param1:uint) : void
      {
         var _loc2_:uint = uint(RoleXMLInfo.getResID(param1));
         if(_loc2_ == 11324)
         {
            this.addSoundWaite(ClientConfig.getSoundExplode(_loc2_));
         }
      }
      
      private function parseSoundBruise(param1:uint) : void
      {
         var _loc2_:uint = uint(RoleXMLInfo.getResID(param1));
         this.addSoundWaite(ClientConfig.getSoundBruise(_loc2_));
      }
      
      private function addSoundWaite(param1:String) : void
      {
         var _loc2_:WaitInfo = null;
         if(SoundManager.isMusicEnable)
         {
            if(param1.indexOf("?") != -1)
            {
               _loc2_ = new WaitInfo();
               _loc2_.type = SOUND;
               _loc2_.url = param1;
               this._soundWaitList.push(_loc2_);
            }
         }
      }
      
      private function addResWaite(param1:WaitInfo) : void
      {
         this._waitList.push(param1);
      }
      
      public function addWinReaSound(param1:uint) : void
      {
         this.addSoundWaite(ClientConfig.getSoundWinner(param1));
         this.addSoundWaite(ClientConfig.getSoundReason(param1));
      }
   }
}

