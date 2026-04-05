package com.gfp.app.cmdl
{
   import com.gfp.app.fight.CustomEvent;
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.keyboard.KeyFuncProcess;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.config.xml.SummonXMLInfo;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.MagicChangeEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.info.MagicChangeInfo;
   import com.gfp.core.info.RoleInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.fight.SkillInfo;
   import com.gfp.core.manager.CustomEventMananger;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.MagicChangeManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.SummonModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.TimeUtil;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class ChangePlayerViewCmdListener extends BaseBean
   {
      
      private var _storeData:Array = [];
      
      public function ChangePlayerViewCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.PLAYER_CHANGE_VIEW,this.onChangeView);
         SocketConnection.addCmdListener(CommandID.CHANGE_TO_CARRIER_BACK,this.onChangeCarrier);
         SocketConnection.addCmdListener(CommandID.MONSTER_CHANGE,this.onMonsterChanged);
         SocketConnection.addCmdListener(CommandID.MAGIC_CHANGE_SCENE_USER_CHANGE,this.onMagicChange);
         SocketConnection.addCmdListener(CommandID.MAGIC_CHANGE_EQUIP_CHANGE,this.onMagicEquipChange);
         finish();
      }
      
      private function onMagicEquipChange(param1:SocketEvent) : void
      {
         var _loc11_:int = 0;
         var _loc12_:MagicChangeInfo = null;
         var _loc13_:UserModel = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:int = int(_loc2_.readUnsignedInt());
         var _loc6_:int = int(_loc2_.readUnsignedInt());
         var _loc7_:int = int(_loc2_.readUnsignedInt());
         var _loc8_:int = int(_loc2_.readUnsignedInt());
         var _loc9_:int = int(_loc2_.readUnsignedInt());
         var _loc10_:int = int(_loc2_.readUnsignedInt());
         if(_loc3_ == 0 || _loc3_ == MainManager.actorID)
         {
            _loc11_ = int(MainManager.actorInfo.magicID);
            _loc12_ = MagicChangeManager.instance.getInfo(_loc4_);
            if(_loc12_)
            {
               _loc12_.weaponID = _loc5_;
               _loc12_.clothID = _loc7_;
               _loc12_.jewelryID = _loc9_;
               if(_loc3_ == 0)
               {
                  MagicChangeManager.instance.dispatchEvent(new MagicChangeEvent(MagicChangeEvent.EQUIP_CHANGE,_loc4_));
               }
               else
               {
                  MainManager.actorModel.magicChange(_loc4_,_loc6_,_loc8_,_loc10_);
                  MagicChangeManager.instance.dispatchEvent(new MagicChangeEvent(MagicChangeEvent.CALL_FIGHT,_loc4_));
               }
            }
         }
         else
         {
            if(MapManager.currentMap == null)
            {
               return;
            }
            if(UserManager.contains(_loc3_))
            {
               _loc13_ = UserManager.getModel(_loc3_) as UserModel;
               if(_loc13_)
               {
                  _loc13_.magicChange(_loc4_,_loc6_,_loc8_,_loc10_);
               }
            }
         }
      }
      
      private function onMagicChange(param1:SocketEvent) : void
      {
         var _loc9_:MagicChangeInfo = null;
         var _loc10_:UserModel = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         _loc2_.readUnsignedInt();
         var _loc5_:int = int(_loc2_.readUnsignedInt());
         var _loc6_:int = int(_loc2_.readUnsignedInt());
         var _loc7_:int = int(_loc2_.readUnsignedInt());
         var _loc8_:int = int(_loc2_.readUnsignedInt());
         if(_loc3_ == 0 || _loc3_ == MainManager.actorID)
         {
            _loc9_ = MagicChangeManager.instance.getInfo(_loc4_);
            if(_loc9_)
            {
               _loc9_.endSenconds = _loc5_ == 0 ? int(TimeUtil.getServerSecond()) : _loc5_;
            }
            if(_loc5_ == 0)
            {
               _loc4_ = 0;
            }
            MainManager.actorModel.magicChange(_loc4_,_loc7_,_loc6_,_loc8_,true);
            MagicChangeManager.instance.updateActorSkillController();
            if(_loc4_)
            {
               MagicChangeManager.instance.dispatchEvent(new MagicChangeEvent(MagicChangeEvent.CALL_FIGHT,_loc4_));
            }
            else
            {
               MagicChangeManager.instance.dispatchEvent(new MagicChangeEvent(MagicChangeEvent.CALL_FIGHT_END,_loc4_));
            }
         }
         else
         {
            if(MapManager.currentMap == null)
            {
               return;
            }
            if(UserManager.contains(_loc3_))
            {
               _loc10_ = UserManager.getModel(_loc3_) as UserModel;
               if(_loc10_)
               {
                  _loc10_.magicChange(_loc5_ != 0 ? _loc4_ : 0,_loc7_,_loc6_,_loc8_,true);
               }
            }
         }
      }
      
      public function onMonsterChanged(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:int = int(_loc2_.readUnsignedInt());
         if(MapManager.isFightMap)
         {
            this.changeMonsterView(_loc3_,_loc4_,_loc5_);
            if(this._storeData.length == 0)
            {
               MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapChangeComplete);
               FightManager.instance.addEventListener(FightEvent.OGRE_DIEING,this.onOgreDie);
               CustomEventMananger.addEventLisnter(UserEvent.SUMMONE_REVIVE,this.onSummonRevive);
            }
            this._storeData.push({
               "id":_loc3_,
               "roleId":_loc4_,
               "uId":_loc5_
            });
         }
         else
         {
            if(this._storeData.length == 0)
            {
               MapManager.addEventListener(MapEvent.STAGE_USER_LISET_COMPLETE,this.onUserLoadComplete);
               MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapChangeComplete);
               FightManager.instance.addEventListener(FightEvent.OGRE_DIEING,this.onOgreDie);
               CustomEventMananger.addEventLisnter(UserEvent.SUMMONE_REVIVE,this.onSummonRevive);
            }
            this._storeData.push({
               "id":_loc3_,
               "roleId":_loc4_,
               "uId":_loc5_
            });
         }
      }
      
      private function onMapChangeComplete(param1:MapEvent) : void
      {
         if(!MapManager.isFightMap)
         {
            this._storeData = [];
            MapManager.removeEventListener(MapEvent.STAGE_USER_LISET_COMPLETE,this.onUserLoadComplete);
            MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapChangeComplete);
            FightManager.instance.removeEventListener(FightEvent.OGRE_DIEING,this.onOgreDie);
            CustomEventMananger.removeEventLisnter(UserEvent.SUMMONE_REVIVE,this.onSummonRevive);
         }
      }
      
      private function onSummonRevive(param1:CustomEvent) : void
      {
         var _loc3_:Object = null;
         var _loc2_:UserModel = param1.data as UserModel;
         if(this.hasSetView(_loc2_.info))
         {
            _loc3_ = this.getViewSet(_loc2_.info.createTime);
            this.changeMonsterView(_loc3_.id,_loc3_.roleId,_loc3_.uId);
         }
      }
      
      private function onOgreDie(param1:FightEvent) : void
      {
         var _loc3_:UserModel = null;
         var _loc2_:UserInfo = param1.data as UserInfo;
         if(this.hasSetView(_loc2_))
         {
            _loc3_ = UserManager.getModelByUid(_loc2_.createTime);
            if(_loc3_)
            {
               _loc3_.resetRoleView();
            }
         }
      }
      
      private function hasSetView(param1:UserInfo) : Boolean
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this._storeData)
         {
            if(_loc2_.uId == param1.createTime)
            {
               return true;
            }
         }
         return false;
      }
      
      private function getViewSet(param1:int) : Object
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this._storeData)
         {
            if(_loc2_.uId == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function onUserLoadComplete(param1:MapEvent) : void
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:int = int(this._storeData.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._storeData[_loc3_];
            _loc5_ = int(_loc4_.id);
            _loc6_ = int(_loc4_.roleId);
            _loc7_ = int(_loc4_.uId);
            this.changeMonsterView(_loc5_,_loc6_,_loc7_);
            _loc3_++;
         }
      }
      
      private function changeMonsterView(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:UserModel = UserManager.getModelByUid(param3) as UserModel;
         if(_loc4_)
         {
            if(_loc4_ is SummonModel && SummonXMLInfo.getSummonType(_loc4_.info.roleType) == 40641)
            {
               param2 = 14828 + param2 - 1;
            }
            _loc4_.changeRoleView(param2);
         }
      }
      
      public function onChangeView(param1:SocketEvent) : void
      {
         var _loc4_:UserModel = null;
         var _loc2_:int = int(param1.headInfo.userID);
         var _loc3_:int = int((param1.data as ByteArray).readUnsignedInt());
         if(_loc2_ == MainManager.actorID)
         {
            MainManager.actorModel.changeRoleView(_loc3_);
         }
         else
         {
            if(MapManager.currentMap == null)
            {
               return;
            }
            if(UserManager.contains(_loc2_))
            {
               _loc4_ = UserManager.getModel(_loc2_) as UserModel;
               if(_loc4_)
               {
                  _loc4_.changeRoleView(_loc3_);
               }
            }
         }
      }
      
      public function onChangeCarrier(param1:SocketEvent) : void
      {
         var _loc4_:RoleInfo = null;
         var _loc5_:Vector.<SkillInfo> = null;
         var _loc6_:Vector.<KeyInfo> = null;
         var _loc7_:int = 0;
         var _loc8_:KeyInfo = null;
         var _loc9_:UserModel = null;
         var _loc2_:int = int(param1.headInfo.userID);
         var _loc3_:int = int((param1.data as ByteArray).readUnsignedInt());
         if(_loc2_ == MainManager.actorID)
         {
            MainManager.actorModel.changeRoleView(_loc3_);
            MainManager.actorInfo.carrierID = _loc3_;
            if(_loc3_ != 0)
            {
               _loc4_ = RoleXMLInfo.getInfo(_loc3_);
               _loc5_ = _loc4_.monsterSkill;
               _loc6_ = new Vector.<KeyInfo>();
               _loc7_ = 0;
               while(_loc7_ < _loc5_.length)
               {
                  _loc8_ = new KeyInfo();
                  _loc8_.funcID = KeyManager.skillQuickKeys[_loc7_];
                  _loc8_.dataID = _loc5_[_loc7_].id;
                  _loc6_.push(_loc8_);
                  _loc7_++;
               }
               KeyManager.reset();
               KeyManager.upDateSkillQuickKeys(_loc6_);
               KeyManager.upDateItemQuickKeys(MainManager.actorInfo.items);
               if(_loc4_.skillID == 0)
               {
                  KeyFuncProcess.normalAttackForbidden = true;
               }
            }
            else
            {
               MainManager.actorInfo.carrierID = 0;
               KeyManager.reset();
               KeyManager.upDateSkillQuickKeys(MainManager.actorModel.info.skills);
               KeyManager.upDateItemQuickKeys(MainManager.actorInfo.items);
               KeyFuncProcess.normalAttackForbidden = false;
            }
         }
         else
         {
            if(MapManager.currentMap == null)
            {
               return;
            }
            if(UserManager.contains(_loc2_))
            {
               _loc9_ = UserManager.getModel(_loc2_) as UserModel;
               if(_loc9_)
               {
                  _loc9_.changeRoleView(_loc3_);
               }
            }
         }
      }
   }
}

