package com.gfp.app.skillBook
{
   import com.gfp.core.action.data.EffectInfo;
   import com.gfp.core.action.data.RemoteInfo;
   import com.gfp.core.cache.ActionSpngInfo;
   import com.gfp.core.cache.CommonCache;
   import com.gfp.core.cache.EffectBitmapCache;
   import com.gfp.core.cache.SoundCache;
   import com.gfp.core.cache.SoundInfo;
   import com.gfp.core.cache.SpngInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.config.xml.SkillXMLInfo;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.fight.SkillLevelInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.LoadingManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.sound.SoundManager;
   import com.gfp.core.ui.loading.ILoading;
   import com.gfp.core.ui.loading.LoadingType;
   import com.gfp.core.utils.EquipPart;
   import com.gfp.core.utils.Logger;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.ds.HashMap;
   import org.taomee.net.SocketEvent;
   
   public class SkillLoader extends EventDispatcher
   {
      
      public static var isLoading:Boolean = false;
      
      private static const EQUIP:int = 1;
      
      private static const EFFECT:int = 2;
      
      private static const NPC:int = 3;
      
      private static const SOUND:int = 4;
      
      private var _waitList:Array;
      
      private var _loading:ILoading;
      
      private var _total:int;
      
      private var _peopleList:Vector.<uint>;
      
      private var _npcList:Vector.<uint>;
      
      private var _currInfo:WaitInfo;
      
      private var _invTime:Number = 0;
      
      public function SkillLoader()
      {
         super();
         this._waitList = [];
         this._peopleList = ActionXMLInfo.peopleLoads.concat();
         this._npcList = ActionXMLInfo.npcLoads.concat();
      }
      
      public function destroy() : void
      {
         if(this._currInfo)
         {
            if(this._currInfo.type == EQUIP)
            {
               CommonCache.cancelByUrl(this._currInfo.url,this.onEquipComplete);
            }
            else if(this._currInfo.type == EFFECT)
            {
               EffectBitmapCache.cancel(ClientConfig.getEffectBmp(this._currInfo.itemID),this.onEffectComplete);
            }
            else if(this._currInfo.type == NPC)
            {
               CommonCache.cancelByUrl(this._currInfo.url,this.onNpcComplete);
            }
            else if(this._currInfo.type == SOUND)
            {
               SoundCache.cancel(this._currInfo.url,this.onSoundComplete);
            }
         }
         if(this._loading)
         {
            this._loading.destroy();
            this._loading = null;
         }
         this._waitList = null;
         this._peopleList = null;
         this._npcList = null;
         isLoading = false;
      }
      
      private function onLoadingProgress(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
      }
      
      public function loadTollgate() : void
      {
         var _loc4_:uint = 0;
         var _loc5_:KeyInfo = null;
         isLoading = true;
         var _loc1_:UserInfo = new UserInfo();
         _loc1_.roleType = MainManager.actorInfo.roleType;
         _loc1_.skills = new Vector.<KeyInfo>();
         _loc1_.clothes = MainManager.actorInfo.clothes;
         _loc1_.fashionClothes = MainManager.actorInfo.fashionClothes;
         var _loc2_:Array = SkillBookData.skillArray[_loc1_.roleType - 1];
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = uint(_loc2_[_loc3_]);
            if(_loc4_)
            {
               _loc5_ = new KeyInfo();
               _loc5_.dataID = _loc4_;
               _loc5_.lv = 1;
               _loc1_.skills.push(_loc5_);
            }
            _loc3_++;
         }
         this.parseAll([_loc1_]);
         this.optimizeWaitList();
         this._total = this._waitList.length;
         this._loading = LoadingManager.getLoading(LoadingType.TITLE_AND_PERCENT,LayerManager.topLevel,"加载技能书动画...");
         this._loading.closeEnabled = false;
         this._loading.show();
         this.nextLoad();
      }
      
      private function parseAll(param1:Array) : void
      {
         var _loc2_:UserInfo = null;
         for each(_loc2_ in param1)
         {
            this.parsePeopleInfo(_loc2_);
         }
         this.parseActorSounds(MainManager.roleType);
      }
      
      private function parseActorSounds(param1:uint) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:WaitInfo = null;
         var _loc2_:Array = RoleXMLInfo.soundHitMap.getValue(param1);
         _loc2_ = RoleXMLInfo.soundHowlMap.getValue(param1);
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = new WaitInfo();
            _loc4_.type = SOUND;
            _loc4_.url = ClientConfig.getSoundHowl(_loc3_);
            this._waitList.push(_loc4_);
         }
      }
      
      private function parsePeopleInfo(param1:UserInfo) : void
      {
         var def:HashMap = null;
         var userInfo:UserInfo = param1;
         var resID:uint = uint(RoleXMLInfo.getResID(userInfo.roleType));
         def = EquipPart.getDefItems(resID);
         var cloths:Vector.<SingleEquipInfo> = userInfo.fashionClothes;
         cloths.forEach(function(param1:SingleEquipInfo, param2:int, param3:Vector.<SingleEquipInfo>):void
         {
            var _loc4_:uint = uint(ItemXMLInfo.getEquipPart(param1.itemID));
            if(def.containsKey(_loc4_))
            {
               def.add(_loc4_,param1.itemID);
            }
         },this);
         def.eachValue(function(param1:uint):void
         {
            var _loc3_:KeyInfo = null;
            var _loc4_:uint = 0;
            var _loc5_:SkillLevelInfo = null;
            var _loc6_:RemoteInfo = null;
            var _loc2_:Vector.<KeyInfo> = userInfo.skills;
            for each(_loc3_ in _loc2_)
            {
               parseSoundSkill(_loc3_.dataID);
               parseSoundRemote(_loc3_.dataID,_loc3_.lv);
               _loc5_ = SkillXMLInfo.getLevelInfo(_loc3_.dataID,_loc3_.lv);
               if(_loc5_)
               {
                  if(_loc5_.actionID > 0)
                  {
                     parseEquip(_loc5_.actionID,param1);
                     parseEffect(_loc5_.actionID);
                  }
                  if(_loc5_.hitEffInfo)
                  {
                     if(_loc5_.hitEffInfo.id > 0)
                     {
                        addEffectWaitInfo(_loc5_.hitEffInfo.id);
                     }
                  }
                  if(_loc5_.remoteInfos)
                  {
                     for each(_loc6_ in _loc5_.remoteInfos)
                     {
                        if(_loc6_.id > 0)
                        {
                           addEffectWaitInfo(_loc6_.id);
                        }
                     }
                  }
               }
            }
            for each(_loc4_ in _peopleList)
            {
               parseEquip(_loc4_,param1);
               parseEffect(_loc4_);
            }
         });
      }
      
      private function parseEquip(param1:uint, param2:uint) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:WaitInfo = null;
         var _loc3_:Array = ActionXMLInfo.getViewIDs(param1);
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = new WaitInfo();
            _loc5_.type = EQUIP;
            _loc5_.url = ItemXMLInfo.getItemActionPath(_loc4_,param2);
            this._waitList.push(_loc5_);
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
      
      private function parseNpc(param1:uint, param2:uint) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:WaitInfo = null;
         var _loc3_:Array = ActionXMLInfo.getViewIDs(param1);
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = new WaitInfo();
            _loc5_.type = NPC;
            _loc5_.url = RoleXMLInfo.getRoleActionPath(_loc4_,param2);
            this._waitList.push(_loc5_);
         }
      }
      
      private function parseSoundSkill(param1:uint) : void
      {
         var _loc2_:WaitInfo = null;
         if(param1 > 0)
         {
            _loc2_ = new WaitInfo();
            _loc2_.type = SOUND;
            _loc2_.url = ClientConfig.getSoundSkill(param1);
            this._waitList.push(_loc2_);
         }
      }
      
      private function parseSoundRemote(param1:uint, param2:uint) : void
      {
         var _loc3_:SkillLevelInfo = null;
         var _loc4_:RemoteInfo = null;
         var _loc5_:WaitInfo = null;
         if(param1 > 0 && param2 > 0)
         {
            _loc3_ = SkillXMLInfo.getLevelInfo(param1,param2);
            if(Boolean(_loc3_) && Boolean(_loc3_.remoteInfos))
            {
               for each(_loc4_ in _loc3_.remoteInfos)
               {
                  _loc5_ = new WaitInfo();
                  _loc5_.type = SOUND;
                  _loc5_.url = ClientConfig.getSoundRemote(_loc4_.id);
                  this._waitList.push(_loc5_);
               }
            }
         }
      }
      
      private function parseSoundDie(param1:uint) : void
      {
         var _loc2_:WaitInfo = new WaitInfo();
         _loc2_.type = SOUND;
         _loc2_.url = ClientConfig.getSoundDie(param1);
         this._waitList.push(_loc2_);
      }
      
      private function parseSoundBruise(param1:uint) : void
      {
         var _loc2_:WaitInfo = new WaitInfo();
         _loc2_.type = SOUND;
         _loc2_.url = ClientConfig.getSoundBruise(param1);
         this._waitList.push(_loc2_);
      }
      
      private function addEffectWaitInfo(param1:uint) : void
      {
         var _loc2_:WaitInfo = new WaitInfo();
         _loc2_.type = EFFECT;
         _loc2_.itemID = param1;
         this._waitList.push(_loc2_);
      }
      
      private function optimizeWaitList() : void
      {
         var arr:Array;
         var item:WaitInfo = null;
         var b:Boolean = false;
         this._waitList = this._waitList.filter(function(param1:WaitInfo, param2:int, param3:Array):Boolean
         {
            if(param1.type == EQUIP || param1.type == NPC)
            {
               if(param1.actionID == 0 && param1.itemID == 0)
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
            else if(param1.type == SOUND)
            {
               if(param1.url == "" || param1.url == null)
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
               if(item.type == param1.type && item.actionID == param1.actionID && item.itemID == param1.itemID && item.url == param1.url)
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
      
      private function nextLoad() : void
      {
         var _loc1_:int = int(this._waitList.length);
         if(this._loading)
         {
            this._loading.setPercent(this._total - _loc1_,this._total);
         }
         Logger.info(this,"nextLoad():" + _loc1_);
         if(_loc1_ > 0)
         {
            this._currInfo = this._waitList.pop();
            if(this._currInfo.type == EQUIP)
            {
               Logger.info(this,"_currInfo.type == EQUIP");
               CommonCache.getSpngInfoByUrl(this._currInfo.url,this.onEquipComplete,this.onEquipError);
            }
            else if(this._currInfo.type == EFFECT)
            {
               Logger.info(this,"_currInfo.type == EFFECT");
               EffectBitmapCache.getSpngInfoByUrl(ClientConfig.getEffectBmp(this._currInfo.itemID),this.onEffectComplete,this.onEffectError);
            }
            else if(this._currInfo.type == NPC)
            {
               Logger.info(this,"_currInfo.type == NPC");
               CommonCache.getSpngInfoByUrl(this._currInfo.url,this.onNpcComplete,this.onNpcError);
            }
            else if(this._currInfo.type == SOUND)
            {
               Logger.info(this,"_currInfo.type == SOUND");
               if(SoundManager.isMusicEnable)
               {
                  SoundCache.load(this._currInfo.url,this.onSoundComplete,this.onSoundError);
               }
               else
               {
                  this.nextLoad();
               }
            }
         }
         else
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function onEquipComplete(param1:ActionSpngInfo) : void
      {
         Logger.info(this,"装扮加载完成: actionId:" + param1.actionArr[0] + " resID:" + param1.itemID);
         this.nextLoad();
      }
      
      private function onEquipError(param1:uint, param2:uint) : void
      {
         Logger.error(this,"装扮加载失败：actionId:" + param1 + "itemID" + param2);
         this.nextLoad();
      }
      
      private function onEffectComplete(param1:SpngInfo) : void
      {
         Logger.info(this,"特效加载完成:" + param1.url);
         this.nextLoad();
      }
      
      private function onEffectError(param1:String) : void
      {
         Logger.error(this,"特效加载失败：" + param1);
         this.nextLoad();
      }
      
      private function onNpcComplete(param1:ActionSpngInfo) : void
      {
         Logger.info(this,"NPC加载完成:" + param1.actionArr[0] + param1.itemID);
         this.nextLoad();
      }
      
      private function onNpcError(param1:uint) : void
      {
         Logger.error(this,"NPC加载失败：" + param1);
         this.nextLoad();
      }
      
      private function onSoundComplete(param1:SoundInfo) : void
      {
         Logger.info(this,"声音加载完成:" + param1.url);
         this.nextLoad();
      }
      
      private function onSoundError(param1:String) : void
      {
         Logger.error(this,"声音加载失败：" + param1);
         this.nextLoad();
      }
   }
}

class WaitInfo
{
   
   public var type:int;
   
   public var itemID:uint;
   
   public var actionID:uint;
   
   public var url:String;
   
   public function WaitInfo()
   {
      super();
   }
}
