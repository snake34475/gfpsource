package com.gfp.app.manager.fightPlugin
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.manager.FightPluginManager;
   import com.gfp.app.toolBar.FightToolBar;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.keyboard.KeyItemProcess;
   import com.gfp.core.buff.ActorOperateBuffManager;
   import com.gfp.core.buff.BuffInfo;
   import com.gfp.core.buff.movie.FlashBuff;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.config.xml.TollgateXMLInfo;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.events.UserItemEvent;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.info.item.SingleItemInfo;
   import com.gfp.core.info.mall.MallStoreInfo;
   import com.gfp.core.info.mall.MallXmlInfo;
   import com.gfp.core.manager.CDManager;
   import com.gfp.core.manager.EquipDurabilityAlertManager;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SOManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.ActorModel;
   import com.gfp.core.model.SummonModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.FightMode;
   import com.gfp.core.utils.KeyCodeType;
   import flash.events.Event;
   import flash.net.SharedObject;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   
   public class AutoRecoverManager
   {
      
      private static var _instance:AutoRecoverManager;
      
      public static var VipAutoHp:Boolean;
      
      public static var VipAutoMp:Boolean;
      
      private var _isVipAuto:Boolean = false;
      
      private var _actorModel:ActorModel;
      
      private var _summonModel:SummonModel;
      
      private var _timeOutID:uint;
      
      private var _gfCoinNum:int;
      
      public function AutoRecoverManager()
      {
         super();
      }
      
      public static function get instance() : AutoRecoverManager
      {
         if(_instance == null)
         {
            _instance = new AutoRecoverManager();
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
      
      public function setup() : void
      {
         this._actorModel = MainManager.actorModel;
         FunctionManager.disabledFightRevive = true;
         this.addEvent();
      }
      
      public function vipSetup() : void
      {
         this._actorModel = MainManager.actorModel;
         var _loc1_:SharedObject = SOManager.getActorSO("AutoRecoverManager" + MainManager.actorID + MainManager.actorInfo.nick);
         if(Boolean(_loc1_) && _loc1_.data.hasOwnProperty("VipAutoHp"))
         {
            if(_loc1_.data["VipAutoHp"])
            {
               this._actorModel.addEventListener(UserEvent.HP_CHANGE,this.onActorHpChange);
            }
         }
         else
         {
            this._actorModel.addEventListener(UserEvent.HP_CHANGE,this.onActorHpChange);
         }
         if(Boolean(_loc1_) && _loc1_.data.hasOwnProperty("VipAutoMp"))
         {
            if(_loc1_.data["VipAutoMp"])
            {
               this._actorModel.addEventListener(UserEvent.MP_CHANGE,this.onActorMpChange);
            }
         }
         else
         {
            this._actorModel.addEventListener(UserEvent.MP_CHANGE,this.onActorMpChange);
         }
         this._isVipAuto = true;
      }
      
      public function vipSetupHP() : void
      {
         this._actorModel = MainManager.actorModel;
         this._actorModel.addEventListener(UserEvent.HP_CHANGE,this.onActorHpChange);
         var _loc1_:SharedObject = SOManager.getActorSO("AutoRecoverManager" + MainManager.actorID + MainManager.actorInfo.nick);
         if(_loc1_)
         {
            _loc1_.data["VipAutoHp"] = true;
            _loc1_.flush();
         }
      }
      
      public function vipSetupMp() : void
      {
         this._actorModel = MainManager.actorModel;
         this._actorModel.addEventListener(UserEvent.MP_CHANGE,this.onActorMpChange);
         var _loc1_:SharedObject = SOManager.getActorSO("AutoRecoverManager" + MainManager.actorID + MainManager.actorInfo.nick);
         if(_loc1_)
         {
            _loc1_.data["VipAutoMp"] = true;
            _loc1_.flush();
         }
      }
      
      private function addEvent() : void
      {
         MapManager.addEventListener(MapEvent.STAGE_USER_LISET_COMPLETE,this.onStageComplete);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,this.onMapSwitchOpen);
         this._actorModel.addEventListener(UserEvent.HP_CHANGE,this.onActorHpChange);
         this._actorModel.addEventListener(UserEvent.MP_CHANGE,this.onActorMpChange);
         this._actorModel.addEventListener(UserEvent.DIE,this.onActorDie);
         ItemManager.addListener(UserItemEvent.USE_MEDICINE,this.onUseMedicine);
         EquipDurabilityAlertManager.addEventListener(EquipDurabilityAlertManager.DURABILITY_ALERT_START,this.onDurAlert);
      }
      
      private function removeEvent() : void
      {
         MapManager.removeEventListener(MapEvent.STAGE_USER_LISET_COMPLETE,this.onStageComplete);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,this.onMapSwitchOpen);
         if(this._actorModel)
         {
            this._actorModel.removeEventListener(UserEvent.HP_CHANGE,this.onActorHpChange);
            this._actorModel.removeEventListener(UserEvent.MP_CHANGE,this.onActorMpChange);
            this._actorModel.removeEventListener(UserEvent.DIE,this.onActorDie);
         }
         if(this._summonModel)
         {
            this._summonModel.removeEventListener(UserEvent.MP_CHANGE,this.onSummonMpChange);
         }
         EquipDurabilityAlertManager.addEventListener(EquipDurabilityAlertManager.DURABILITY_ALERT_START,this.onDurAlert);
         ItemManager.removeListener(UserItemEvent.USE_MEDICINE,this.onUseMedicine);
         SocketConnection.removeCmdListener(CommandID.GET_GF_COINS,this.onGetUserGfCoins);
         SocketConnection.removeCmdListener(CommandID.BUY_MALL_ITEMS,this.onBuyItemSuccess);
      }
      
      private function onStageComplete(param1:MapEvent) : void
      {
         if(this._actorModel)
         {
            this._summonModel = this._actorModel.fightSummonModel;
         }
         if(this._summonModel)
         {
            this._summonModel.addEventListener(UserEvent.MP_CHANGE,this.onSummonMpChange);
         }
      }
      
      private function onMapSwitchOpen(param1:MapEvent) : void
      {
         if(this._summonModel)
         {
            this._summonModel.removeEventListener(UserEvent.MP_CHANGE,this.onSummonMpChange);
         }
      }
      
      private function onActorHpChange(param1:UserEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:KeyInfo = null;
         var _loc5_:SharedObject = null;
         if(Boolean(MainManager.isCloseOprate) || Boolean(ActorOperateBuffManager.instance.operaterDisable))
         {
            return;
         }
         var _loc2_:Number = FightPluginManager.instance.baseHpPer / 100;
         if(this._actorModel.info.hp > 0 && this._actorModel.info.hp < this._actorModel.info.maxHp * _loc2_)
         {
            _loc3_ = this.getAddHpItem();
            if(_loc3_ != 0)
            {
               _loc4_ = new KeyInfo();
               _loc4_.dataID = _loc3_;
               KeyItemProcess.useItem(_loc4_);
               if(this.isVipAuto && Boolean(MainManager.actorInfo.isVip) && !FightManager.isTeamFight && MainManager.pveTollgateId != 0 && Boolean(TollgateXMLInfo.isCanUserAddHp(MainManager.pveTollgateId)))
               {
                  _loc5_ = SOManager.getActorSO("TollgateRecoverEff" + MainManager.actorID + MainManager.actorInfo.nick);
                  if((Boolean(_loc5_)) && !_loc5_.data[MainManager.pveTollgateId])
                  {
                     _loc5_.data[MainManager.pveTollgateId] = true;
                     SOManager.flush(_loc5_);
                     FightToolBar.instance.showRecoverEff();
                  }
               }
            }
         }
      }
      
      private function getAddHpItem() : uint
      {
         var arr:Array = null;
         var result:uint = 0;
         var tmpArr:Array = null;
         var itemInfo:SingleItemInfo = null;
         var itemID:uint = 0;
         var hp:uint = 0;
         var hpPer:uint = 0;
         var hpAdd:uint = 0;
         arr = ItemManager.getItemsByCatID(ItemXMLInfo.MEDICINE_CAT);
         var addHp:uint = 0;
         if(CDManager.itemCD.hasAddHpCD)
         {
            return 0;
         }
         tmpArr = [];
         KeyManager.itemQuickKeys.forEach(function(param1:uint, param2:int, param3:Vector.<uint>):void
         {
            var _loc5_:SingleItemInfo = null;
            var _loc4_:KeyInfo = KeyManager.getSingleInfoForFuncID(param1);
            if(_loc4_.type == KeyCodeType.ITEM)
            {
               for each(_loc5_ in arr)
               {
                  if(_loc5_.itemID == _loc4_.dataID)
                  {
                     tmpArr.push(_loc5_);
                  }
               }
            }
         });
         for each(itemInfo in tmpArr)
         {
            itemID = uint(itemInfo.itemID);
            hp = uint(ItemXMLInfo.getHPRecover(itemID));
            hpPer = uint(ItemXMLInfo.getHPPerentRecover(itemID));
            hpAdd = hpPer * MainManager.actorInfo.maxHp / 100;
            hpAdd = hpAdd > hp ? hpAdd : hp;
            if(hpAdd > addHp && !CDManager.itemCD.cdContains(itemID) && ItemXMLInfo.getUserLevel(itemID) < MainManager.actorInfo.lv)
            {
               addHp = hpAdd;
               result = itemID;
            }
         }
         return result;
      }
      
      private function onActorMpChange(param1:UserEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:KeyInfo = null;
         var _loc5_:SharedObject = null;
         if(Boolean(MainManager.isCloseOprate) || Boolean(ActorOperateBuffManager.instance.operaterDisable))
         {
            return;
         }
         var _loc2_:Number = FightPluginManager.instance.baseMpPer / 100;
         if(this._actorModel.info.hp > 0 && this._actorModel.info.mp < this._actorModel.info.maxMp * _loc2_)
         {
            _loc3_ = this.getAddMpItem();
            if(_loc3_ != 0)
            {
               _loc4_ = new KeyInfo();
               _loc4_.dataID = _loc3_;
               KeyItemProcess.useItem(_loc4_);
               if(this.isVipAuto && Boolean(MainManager.actorInfo.isVip) && !FightManager.isTeamFight && MainManager.pveTollgateId != 0 && Boolean(TollgateXMLInfo.isCanUserAddHp(MainManager.pveTollgateId)))
               {
                  _loc5_ = SOManager.getActorSO("TollgateRecoverEff" + MainManager.actorID + MainManager.actorInfo.nick);
                  if((Boolean(_loc5_)) && !_loc5_.data[MainManager.pveTollgateId])
                  {
                     _loc5_.data[MainManager.pveTollgateId] = true;
                     SOManager.flush(_loc5_);
                     FightToolBar.instance.showRecoverEff();
                  }
               }
            }
         }
      }
      
      private function getAddMpItem() : uint
      {
         var arr:Array = null;
         var result:uint = 0;
         var tmpArr:Array = null;
         var itemInfo:SingleItemInfo = null;
         var itemID:uint = 0;
         var mp:uint = 0;
         var mpPer:uint = 0;
         var mpAdd:uint = 0;
         arr = ItemManager.getItemsByCatID(ItemXMLInfo.MEDICINE_CAT);
         var addMp:uint = 0;
         if(CDManager.itemCD.hasAddMpCD)
         {
            return 0;
         }
         tmpArr = [];
         KeyManager.itemQuickKeys.forEach(function(param1:uint, param2:int, param3:Vector.<uint>):void
         {
            var _loc5_:SingleItemInfo = null;
            var _loc4_:KeyInfo = KeyManager.getSingleInfoForFuncID(param1);
            if(_loc4_.type == KeyCodeType.ITEM)
            {
               for each(_loc5_ in arr)
               {
                  if(_loc5_.itemID == _loc4_.dataID)
                  {
                     tmpArr.push(_loc5_);
                  }
               }
            }
         });
         for each(itemInfo in tmpArr)
         {
            itemID = uint(itemInfo.itemID);
            mp = uint(ItemXMLInfo.getMPRecover(itemID));
            mpPer = uint(ItemXMLInfo.getMPPerentRecover(itemID));
            mpAdd = mpPer * MainManager.actorInfo.maxMp / 100;
            mpAdd = mpAdd > mp ? mpAdd : mp;
            if(mpAdd > addMp && !CDManager.itemCD.cdContains(itemID) && ItemXMLInfo.getUserLevel(itemID) < MainManager.actorInfo.lv)
            {
               addMp = mpAdd;
               result = itemID;
            }
         }
         return result;
      }
      
      private function onSummonMpChange(param1:UserEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:KeyInfo = null;
         if(Boolean(MainManager.isCloseOprate) || Boolean(ActorOperateBuffManager.instance.operaterDisable))
         {
            return;
         }
         var _loc2_:Number = FightPluginManager.instance.baseSummonMp / 100;
         if(this._summonModel.info.hp > 0 && this._summonModel.info.mp < this._summonModel.info.maxMp * _loc2_)
         {
            _loc3_ = this.getSummonMpItem();
            if(_loc3_ != 0)
            {
               _loc4_ = new KeyInfo();
               _loc4_.dataID = _loc3_;
               KeyItemProcess.useItem(_loc4_);
            }
         }
      }
      
      private function getSummonMpItem() : uint
      {
         var _loc3_:uint = 0;
         var _loc4_:SingleItemInfo = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc1_:Array = ItemManager.getItemsByCatID(ItemXMLInfo.SUMMON_FOOD);
         var _loc2_:uint = 0;
         if(CDManager.itemCD.runContains())
         {
            return 0;
         }
         for each(_loc4_ in _loc1_)
         {
            _loc5_ = uint(_loc4_.itemID);
            _loc6_ = uint(ItemXMLInfo.getMPRecover(_loc5_));
            _loc7_ = uint(ItemXMLInfo.getMPPerentRecover(_loc5_));
            _loc8_ = _loc7_ * MainManager.actorInfo.maxMp / 100;
            _loc8_ = _loc8_ > _loc6_ ? _loc8_ : _loc6_;
            if(_loc8_ > _loc2_ && !CDManager.itemCD.cdContains(_loc5_))
            {
               _loc3_ = _loc5_;
            }
         }
         return _loc3_;
      }
      
      private function onDurAlert(param1:Event) : void
      {
         if(FightPluginManager.instance.isAutoRepair && ItemManager.getItemCount(1703003) > 0)
         {
            this.useRepairItem();
         }
      }
      
      private function useRepairItem() : void
      {
         var _loc1_:KeyInfo = new KeyInfo();
         _loc1_.dataID = 1703003;
         KeyItemProcess.exec(MainManager.actorModel,_loc1_);
      }
      
      private function onActorDie(param1:UserEvent = null) : void
      {
         var _loc3_:int = 0;
         if(FightManager.fightMode == FightMode.PVE)
         {
            _loc3_ = int(TollgateXMLInfo.getMaxReviveCount(PveEntry.instance.getStageID()));
            if(_loc3_ != 0 && (_loc3_ == 999999 || FightManager.actorDiedCount >= _loc3_ + 1))
            {
               return;
            }
         }
         var _loc2_:uint = this.getReviveItem();
         if(_loc2_ != 0)
         {
            clearTimeout(this._timeOutID);
            this._timeOutID = setTimeout(this.doRevive,6000);
         }
         else if(FightPluginManager.instance.isAutoBuyRevive)
         {
            SocketConnection.addCmdListener(CommandID.GET_GF_COINS,this.onGetUserGfCoins);
            SocketConnection.send(CommandID.GET_GF_COINS);
         }
         else
         {
            FunctionManager.disabledFightRevive = false;
         }
      }
      
      private function getReviveItem() : uint
      {
         if(!FightPluginManager.instance.isAutoRevive)
         {
            return 0;
         }
         if(ItemManager.getItemCount(1302000) > 0)
         {
            return 1302000;
         }
         if(ItemManager.getItemCount(1302001) > 0)
         {
            return 1302001;
         }
         return 0;
      }
      
      private function doRevive() : void
      {
         clearTimeout(this._timeOutID);
         ItemManager.useItem(this.getReviveItem());
         ItemManager.addListener(UserItemEvent.USE_MEDICINE,this.onUseMedicine);
      }
      
      private function onUseMedicine(param1:UserItemEvent) : void
      {
         var _loc2_:uint = uint(param1.param);
         if(_loc2_ == 1302000 || _loc2_ == 1302001)
         {
            ItemManager.removeListener(UserItemEvent.USE_MEDICINE,this.onUseMedicine);
            PveEntry.onActorRevive();
            this.showReviveAnimat();
            AutoFightManager.instance.aimTarget();
         }
      }
      
      private function showReviveAnimat() : void
      {
         var _loc1_:BuffInfo = new BuffInfo();
         _loc1_.id = 1;
         _loc1_.duration = 3000;
         if(this._actorModel)
         {
            this._actorModel.execBuff(new FlashBuff(_loc1_,false));
         }
      }
      
      private function onGetUserGfCoins(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GET_GF_COINS,this.onGetUserGfCoins);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         this._gfCoinNum = _loc2_.readUnsignedInt() * 0.01;
         var _loc3_:MallStoreInfo = MallXmlInfo.getStoreById(1302000).stores[0] as MallStoreInfo;
         if(this._gfCoinNum < _loc3_.price)
         {
            FunctionManager.disabledFightRevive = false;
            return;
         }
         SocketConnection.addCmdListener(CommandID.BUY_MALL_ITEMS,this.onBuyItemSuccess);
         SocketConnection.send(CommandID.BUY_MALL_ITEMS,_loc3_.storeID,1,1,1302000);
      }
      
      private function onBuyItemSuccess(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.BUY_MALL_ITEMS,this.onBuyItemSuccess);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         var _loc7_:uint = _loc2_.readUnsignedInt();
         ItemManager.addItem(_loc6_,_loc7_);
         this.onActorDie();
      }
      
      public function vipDestroyHP() : void
      {
         this._actorModel.removeEventListener(UserEvent.HP_CHANGE,this.onActorHpChange);
         var _loc1_:SharedObject = SOManager.getActorSO("AutoRecoverManager" + MainManager.actorID + MainManager.actorInfo.nick);
         if(_loc1_)
         {
            _loc1_.data["VipAutoHp"] = false;
            _loc1_.flush();
         }
      }
      
      public function vipDestroyMP() : void
      {
         this._actorModel.removeEventListener(UserEvent.MP_CHANGE,this.onActorMpChange);
         var _loc1_:SharedObject = SOManager.getActorSO("AutoRecoverManager" + MainManager.actorID + MainManager.actorInfo.nick);
         if(_loc1_)
         {
            _loc1_.data["VipAutoMp"] = false;
            _loc1_.flush();
         }
      }
      
      public function vipDestroy() : void
      {
         if(this._actorModel)
         {
            this._actorModel.removeEventListener(UserEvent.HP_CHANGE,this.onActorHpChange);
            this._actorModel.removeEventListener(UserEvent.MP_CHANGE,this.onActorMpChange);
            this._actorModel = null;
         }
         this._isVipAuto = false;
      }
      
      public function destroy() : void
      {
         this.removeEvent();
         this._actorModel = null;
         this._summonModel = null;
      }
      
      public function get isVipAuto() : Boolean
      {
         return this._isVipAuto;
      }
   }
}

