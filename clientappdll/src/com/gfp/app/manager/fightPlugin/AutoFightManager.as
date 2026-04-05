package com.gfp.app.manager.fightPlugin
{
   import com.gfp.app.manager.FightPluginManager;
   import com.gfp.core.Constant;
   import com.gfp.core.action.ActionInfo;
   import com.gfp.core.action.events.ActionEvent;
   import com.gfp.core.action.keyboard.KeyFuncProcess;
   import com.gfp.core.action.keyboard.KeySkillProcess;
   import com.gfp.core.action.normal.AimMoveAction;
   import com.gfp.core.buff.ActorOperateBuffManager;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.config.xml.SkillXMLInfo;
   import com.gfp.core.events.CDEvent;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.events.RideEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.info.SummonInfo;
   import com.gfp.core.info.fight.SkillInfo;
   import com.gfp.core.info.fight.SkillLevelInfo;
   import com.gfp.core.manager.CDManager;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.MagicChangeManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.RideManager;
   import com.gfp.core.manager.SkillManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.ActorModel;
   import com.gfp.core.model.HiddenModel;
   import com.gfp.core.model.SpriteModel;
   import com.gfp.core.model.SummonModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.utils.TroopType;
   import flash.geom.Point;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.algo.AStar;
   
   public class AutoFightManager
   {
      
      private static var _instance:AutoFightManager;
      
      private static var _unAutoSkills:Array = [800701,800801,800901,801001];
      
      private var _isAutoFighting:Boolean = false;
      
      public var skills:Array;
      
      private var _actorModel:ActorModel;
      
      private var _summonModel:SummonModel;
      
      private var _isTelShow:Boolean;
      
      private var _timeID:int;
      
      public function AutoFightManager()
      {
         var _loc1_:KeyInfo = null;
         super();
         if(this.skills == null)
         {
            this.skills = new Array();
            for each(_loc1_ in MainManager.actorInfo.skills)
            {
               this.skills.push(_loc1_.dataID);
            }
            SkillManager.getData();
         }
      }
      
      public static function get instance() : AutoFightManager
      {
         if(_instance == null)
         {
            _instance = new AutoFightManager();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
         }
         _instance = null;
      }
      
      public static function get isAutoFighting() : Boolean
      {
         return _instance ? _instance.isAutoFighting : false;
      }
      
      public function setup() : void
      {
         this._actorModel = MainManager.actorModel;
         this.addEvent();
         this._isAutoFighting = true;
      }
      
      private function addEvent() : void
      {
         MapManager.addEventListener(MapEvent.STAGE_USER_LISET_COMPLETE,this.onStageComplete);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,this.onMapSwitchOpen);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         UserManager.addEventListener(FightEvent.STAGETELEPORT_SHOW,this.aimTarget);
         this._actorModel.addEventListener(MoveEvent.MOVE_ENTER,this.onMoveEnter);
         this._actorModel.addEventListener(ActionEvent.ACTION_GOING,this.onActionGoing);
         CDManager.skillCD.addEventListener(CDEvent.CDED,this.onCdEndHandler);
         CDManager.skillCD.addEventListener(CDEvent.RUNED,this.onCdEndHandler);
         RideManager.addEventListener(RideEvent.RIDE_SKILL_APPEARED,this.onRideSkillAppeared);
      }
      
      private function removeEvent() : void
      {
         MapManager.removeEventListener(MapEvent.STAGE_USER_LISET_COMPLETE,this.onStageComplete);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,this.onMapSwitchOpen);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         UserManager.addEventListener(FightEvent.STAGETELEPORT_SHOW,this.aimTarget);
         if(this._actorModel)
         {
            this._actorModel.removeEventListener(MoveEvent.MOVE_ENTER,this.onMoveEnter);
            this._actorModel.removeEventListener(ActionEvent.ACTION_GOING,this.onActionGoing);
         }
         this.removeSummonEvent();
         CDManager.skillCD.removeEventListener(CDEvent.CDED,this.onCdEndHandler);
         CDManager.skillCD.removeEventListener(CDEvent.RUNED,this.onCdEndHandler);
         RideManager.removeEventListener(RideEvent.RIDE_SKILL_APPEARED,this.onRideSkillAppeared);
      }
      
      private function onStageComplete(param1:MapEvent) : void
      {
         this._summonModel = this._actorModel.fightSummonModel;
         this.addSummonEvent();
         this.aimTarget();
      }
      
      private function onMapSwitchOpen(param1:MapEvent) : void
      {
         this.removeSummonEvent();
      }
      
      private function addSummonEvent() : void
      {
         if(this._summonModel)
         {
            this._summonModel.addEventListener(UserEvent.SUMMONE_RAGE_CHANGE,this.onSummonRage);
            this._summonModel.addEventListener(UserEvent.SUMMONE_REVIVE,this.onSummonRevive);
         }
      }
      
      private function removeSummonEvent() : void
      {
         if(this._summonModel)
         {
            this._summonModel.removeEventListener(UserEvent.SUMMONE_RAGE_CHANGE,this.onSummonRage);
            this._summonModel.removeEventListener(UserEvent.SUMMONE_REVIVE,this.onSummonRevive);
         }
      }
      
      private function onSummonRage(param1:UserEvent) : void
      {
         var _loc3_:KeyInfo = null;
         var _loc2_:uint = uint(param1.data);
         if(FightPluginManager.instance.isAutoSummonSkill && _loc2_ >= SummonInfo.MAX_RAGE)
         {
            _loc3_ = new KeyInfo();
            _loc3_.funcID = 31;
            KeyFuncProcess.exec(this._actorModel,_loc3_);
         }
      }
      
      private function onSummonRevive(param1:UserEvent) : void
      {
         var _loc2_:KeyInfo = null;
         if(FightPluginManager.instance.isAutoSummonSkill && this._summonModel.summonInfo.rage >= SummonInfo.MAX_RAGE)
         {
            _loc2_ = new KeyInfo();
            _loc2_.funcID = 31;
            KeyFuncProcess.exec(this._actorModel,_loc2_);
         }
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
      }
      
      private function onMoveEnter(param1:MoveEvent = null) : void
      {
         if(this.isEnemyToAtk())
         {
            this.doAtk();
         }
      }
      
      private function doAtk() : void
      {
         var _loc1_:KeyInfo = this.getAvailableSkill();
         clearInterval(this._timeID);
         if(this.isOpreatClosed())
         {
            return;
         }
         if(_loc1_)
         {
            KeySkillProcess.exec(this._actorModel,_loc1_);
         }
         else
         {
            _loc1_ = new KeyInfo();
            _loc1_.funcID = 12;
            KeyFuncProcess.exec(this._actorModel,_loc1_);
            this._timeID = setInterval(this.onMoveEnter,200);
         }
      }
      
      private function getAvailableSkill() : KeyInfo
      {
         var _loc2_:uint = 0;
         var _loc3_:SkillInfo = null;
         var _loc4_:SkillLevelInfo = null;
         var _loc5_:KeyInfo = null;
         if(CDManager.skillCD.runContains())
         {
            return null;
         }
         var _loc1_:Array = this.skills;
         if(MainManager.actorInfo.magicID != 0)
         {
            _loc1_ = KeyManager.getSkillIds();
         }
         else if(MainManager.roleType == Constant.ROLE_TYPE_WOLF)
         {
            if(MainManager.actorInfo.secondTurnBackType == 1)
            {
               _loc1_ = KeySkillProcess.liyaChangeSkillState == 0 ? [800902,800903,800904,800905] : [800906,800907,800908,800909];
            }
            else if(MainManager.actorInfo.secondTurnBackType == 2)
            {
               _loc1_ = KeySkillProcess.liyaChangeSkillState == 0 ? [801002,801003,801004,801005] : [801006,801007,801008,801009];
            }
            else if(MainManager.actorInfo.isTurnBack)
            {
               _loc1_ = KeySkillProcess.liyaChangeSkillState == 0 ? [800802,800803,800804,800805] : [800806,800807,800808,800809];
            }
            else
            {
               _loc1_ = KeySkillProcess.liyaChangeSkillState == 0 ? [800702,800703,800704,800705] : [800706,800707,800708,800709];
            }
         }
         else
         {
            _loc1_ = this.skills;
         }
         for each(_loc2_ in _loc1_)
         {
            if(_unAutoSkills.indexOf(_loc2_) == -1)
            {
               if(SkillXMLInfo.getType(_loc2_) != 1)
               {
                  if(!(MainManager.roleType == Constant.ROLE_TYPE_TIGER && SkillXMLInfo.getType(_loc2_) == 5))
                  {
                     if(!this._actorModel.buffManager.isHaveSkillUnableBuff())
                     {
                        if(!CDManager.skillCD.cdContains(_loc2_))
                        {
                           _loc3_ = SkillManager.getSkillInfo(_loc2_);
                           if(_loc3_ == null && Boolean(MainManager.actorInfo.magicID))
                           {
                              _loc3_ = MagicChangeManager.instance.getCurrentSkillInfoById(_loc2_);
                              if(!_loc3_)
                              {
                                 continue;
                              }
                           }
                           if(_loc3_ != null)
                           {
                              _loc4_ = SkillXMLInfo.getLevelInfo(_loc2_,_loc3_.lv);
                              if(_loc4_)
                              {
                                 if(SkillXMLInfo.caculateMP(_loc2_,_loc3_.lv) <= this._actorModel.getMP())
                                 {
                                    if(_loc4_.hp <= this._actorModel.getHP())
                                    {
                                       _loc5_ = new KeyInfo();
                                       _loc5_.dataID = _loc2_;
                                       _loc5_.lv = _loc3_.lv;
                                       return _loc5_;
                                    }
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
         return null;
      }
      
      private function onCdEndHandler(param1:CDEvent) : void
      {
         this.onMoveEnter();
      }
      
      private function onActionGoing(param1:ActionEvent) : void
      {
         var _loc3_:SpriteModel = null;
         var _loc2_:ActionInfo = param1.info;
         if(_loc2_.actionID == 10001)
         {
            if(this.isEnemyToAtk())
            {
               this.doAtk();
            }
            else
            {
               if(this._actorModel == null)
               {
                  return;
               }
               if(this.isOpreatClosed())
               {
                  return;
               }
               _loc3_ = this.getAnyEnemy();
               if(_loc3_)
               {
                  this._actorModel.actionManager.clear();
                  this._actorModel.execAction(new AimMoveAction(ActionXMLInfo.getInfo(10003),_loc3_.pos));
               }
               else if(this.isTelShow)
               {
                  AutoTollgateTransManager.instance.enterNextRoom();
               }
            }
         }
      }
      
      public function aimTarget(param1:FightEvent = null) : void
      {
         if(this._actorModel == null)
         {
            return;
         }
         if(this.isOpreatClosed())
         {
            return;
         }
         var _loc2_:SpriteModel = this.getAnyEnemy();
         if(_loc2_)
         {
            this._actorModel.actionManager.clear();
            this._actorModel.execAction(new AimMoveAction(ActionXMLInfo.getInfo(10003),_loc2_.pos));
         }
         else
         {
            AutoTollgateTransManager.instance.enterNextRoom();
         }
         this.isTelShow = true;
      }
      
      private function getAnyEnemy() : UserModel
      {
         var _loc2_:UserModel = null;
         var _loc3_:uint = 0;
         var _loc1_:Array = UserManager.getModels();
         for each(_loc2_ in _loc1_)
         {
            if(!(_loc2_ is HiddenModel))
            {
               if(this.getAvailablePos(_loc2_.pos) != null)
               {
                  if(AStar.instance.find(this._actorModel.pos.clone(),_loc2_.pos.clone()) != null)
                  {
                     _loc3_ = uint(_loc2_.info.troop);
                     if(_loc3_ == TroopType.PLAYER_PvP || _loc3_ == TroopType.SOLID_ENEMY || _loc3_ == TroopType.ENEMY)
                     {
                        return _loc2_;
                     }
                  }
               }
            }
         }
         return null;
      }
      
      private function getAvailablePos(param1:Point) : Point
      {
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         if(!MapManager.currentMap.isBlock(param1))
         {
            return param1;
         }
         var _loc2_:Number = 75;
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < 8)
         {
            _loc5_ = Point.polar(_loc2_,_loc3_);
            _loc6_ = param1.add(_loc5_);
            if(!MapManager.currentMap.isBlock(_loc6_))
            {
               return _loc6_;
            }
            _loc3_ += 45;
            _loc4_++;
         }
         return null;
      }
      
      private function isEnemyToAtk() : Boolean
      {
         var _loc1_:Boolean = MainManager.roleType == 4 || MainManager.roleType == Constant.ROLE_TYPE_HORSE;
         var _loc2_:uint = _loc1_ ? 250 : 170;
         var _loc3_:uint = _loc1_ ? 45 : 60;
         if(Boolean(this._actorModel) && Boolean(UserManager.isAtkForAuto(this._actorModel.x,this._actorModel.y,MainManager.actorInfo.troop,_loc2_,_loc3_,this._actorModel.direction)))
         {
            return true;
         }
         return false;
      }
      
      private function isOpreatClosed() : Boolean
      {
         return Boolean(ActorOperateBuffManager.instance.operaterDisable) || Boolean(ActorOperateBuffManager.instance.checkFaint()) || Boolean(MainManager.isCloseOprate);
      }
      
      private function onRideSkillAppeared(param1:RideEvent) : void
      {
         var _loc2_:KeyInfo = new KeyInfo();
         _loc2_.funcID = 14;
         KeyFuncProcess.exec(this._actorModel,_loc2_);
      }
      
      public function destroy() : void
      {
         clearInterval(this._timeID);
         this.removeEvent();
         this._actorModel = null;
         this._summonModel = null;
         this._isAutoFighting = false;
      }
      
      public function get isAutoFighting() : Boolean
      {
         return this._isAutoFighting;
      }
      
      public function get isTelShow() : Boolean
      {
         return this._isTelShow;
      }
      
      public function set isTelShow(param1:Boolean) : void
      {
         this._isTelShow = param1;
      }
   }
}

