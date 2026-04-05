package com.gfp.app.manager
{
   import com.gfp.app.fight.CustomEvent;
   import com.gfp.app.info.EquiptRepairInfo;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.info.SummonInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.language.ModuleLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.CustomEventMananger;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.alert.AlertInfo;
   import com.gfp.core.manager.alert.AlertType;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.TextFormatUtil;
   import com.gfp.core.utils.WallowUtil;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class RepairManager
   {
      
      private static var _equipNeedToRepairVec:Vector.<SingleEquipInfo>;
      
      private static var _summonEquipNeedToRepairVec:Vector.<SingleEquipInfo>;
      
      public function RepairManager()
      {
         super();
      }
      
      public static function repair() : void
      {
         var userCoin:int;
         var allPrice:int;
         var aInfo:AlertInfo;
         var alertStr:String;
         if(WallowUtil.isOverTime())
         {
            WallowUtil.showWallowMsg(ModuleLanguageDefine.WALLOW_MSG_ARR[5]);
            return;
         }
         _equipNeedToRepairVec = getEquipNeedToRepairVec();
         _summonEquipNeedToRepairVec = getEquipNeedToRepairVec(true);
         userCoin = int(MainManager.actorModel.info.coins);
         allPrice = getAllClothsRepairPrice();
         if(userCoin < allPrice)
         {
            AlertManager.showSimpleAlarm(ModuleLanguageDefine.COIN_EMPTY);
            return;
         }
         if(allPrice <= 0)
         {
            AlertManager.showSimpleAlarm(ModuleLanguageDefine.BAG_MSG_ARR[4]);
            return;
         }
         aInfo = new AlertInfo();
         aInfo.type = AlertType.ALERT;
         alertStr = TextFormatUtil.substitute(ModuleLanguageDefine.BAG_MSG_ARR[5],allPrice,userCoin);
         aInfo.str = alertStr;
         aInfo.applyFun = function():void
         {
            callReapair(createReapairArr(_equipNeedToRepairVec,_summonEquipNeedToRepairVec));
         };
         AlertManager.closeCurrentAlert();
         AlertManager.showForInfo(aInfo);
      }
      
      private static function callReapair(param1:ByteArray) : void
      {
         SocketConnection.addCmdListener(CommandID.EQUIP_SERVICE,repairCallBack);
         SocketConnection.send(CommandID.EQUIP_SERVICE,param1);
      }
      
      private static function repairCallBack(param1:SocketEvent) : void
      {
         var _loc4_:SingleEquipInfo = null;
         var _loc5_:SingleEquipInfo = null;
         SocketConnection.removeCmdListener(CommandID.EQUIP_SERVICE,repairCallBack);
         var _loc2_:EquiptRepairInfo = param1.data as EquiptRepairInfo;
         MainManager.actorInfo.coins = _loc2_.coins;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.count)
         {
            _loc4_ = _loc2_.repairArr[_loc3_];
            _loc5_ = getSingleEquipInfo(_loc4_.itemID,_loc4_.leftTime);
            if(_loc5_)
            {
               _loc5_.duration = _loc4_.duration * 50;
            }
            _loc3_++;
         }
         ItemManager.updateEquipDurability();
         AlertManager.show(AlertType.ALARM,ModuleLanguageDefine.BAG_MSG_ARR[6],"",LayerManager.topLevel);
         CustomEventMananger.dispatchEvent(new CustomEvent(CustomEvent.REPAIR_COMPLETE));
      }
      
      private static function vectorToArray(param1:Vector.<SingleEquipInfo>) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_.push(param1[_loc4_]);
            _loc4_++;
         }
         return _loc2_;
      }
      
      private static function getSingleEquipInfo(param1:int, param2:int) : SingleEquipInfo
      {
         var _loc7_:SingleEquipInfo = null;
         var _loc3_:Array = ItemManager.equipList.concat();
         var _loc4_:SummonInfo = SummonManager.getActorSummonInfo().currentSummonInfo;
         if((Boolean(_loc4_)) && Boolean(_loc4_.equips))
         {
            _loc3_ = _loc3_.concat(vectorToArray(_loc4_.equips));
         }
         var _loc5_:int = int(_loc3_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _loc3_[_loc6_];
            if(_loc7_.itemID == param1 && _loc7_.leftTime == param2)
            {
               return _loc7_;
            }
            _loc6_++;
         }
         return null;
      }
      
      private static function createReapairArr(param1:Vector.<SingleEquipInfo>, param2:Vector.<SingleEquipInfo>) : ByteArray
      {
         var _loc4_:SingleEquipInfo = null;
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeInt(param1.length);
         _loc3_.writeInt(param2.length);
         for each(_loc4_ in param1)
         {
            _loc3_.writeInt(_loc4_.itemID);
            _loc3_.writeInt(_loc4_.leftTime);
         }
         for each(_loc4_ in param2)
         {
            _loc3_.writeInt(_loc4_.itemID);
            _loc3_.writeInt(_loc4_.leftTime);
         }
         return _loc3_;
      }
      
      private static function getAllClothsRepairPrice() : int
      {
         var _loc3_:SingleEquipInfo = null;
         var _loc1_:Vector.<SingleEquipInfo> = _equipNeedToRepairVec.concat(_summonEquipNeedToRepairVec);
         var _loc2_:int = 0;
         for each(_loc3_ in _loc1_)
         {
            _loc2_ += getEquipRepairPrice(_loc3_);
         }
         return _loc2_;
      }
      
      private static function getEquipNeedToRepairVec(param1:Boolean = false) : Vector.<SingleEquipInfo>
      {
         var _loc2_:Vector.<SingleEquipInfo> = null;
         var _loc4_:SingleEquipInfo = null;
         if(param1)
         {
            if(Boolean(SummonManager.getActorSummonInfo().currentSummonInfo) && Boolean(SummonManager.getActorSummonInfo().currentSummonInfo.equips))
            {
               _loc2_ = SummonManager.getActorSummonInfo().currentSummonInfo.equips;
            }
            else
            {
               _loc2_ = new Vector.<SingleEquipInfo>();
            }
         }
         else
         {
            _loc2_ = MainManager.actorInfo.clothes;
         }
         var _loc3_:Vector.<SingleEquipInfo> = new Vector.<SingleEquipInfo>();
         for each(_loc4_ in _loc2_)
         {
            if(isEquipNeedToRepair(_loc4_))
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      private static function isEquipNeedToRepair(param1:SingleEquipInfo) : Boolean
      {
         var _loc2_:int = int(ItemXMLInfo.getDuration(param1.itemID));
         var _loc3_:int = generateEquipDuration(param1.duration,_loc2_);
         if(_loc2_ > _loc3_)
         {
            return true;
         }
         return false;
      }
      
      public static function generateEquipDuration(param1:int, param2:int) : int
      {
         var _loc3_:int = 50;
         var _loc4_:Number = param1 / (param2 * _loc3_);
         var _loc5_:int = 50;
         if(_loc4_ > 0.5)
         {
            _loc5_ = Math.ceil(param1 / _loc3_);
         }
         else
         {
            _loc5_ = Math.ceil(param1 / _loc3_);
         }
         return _loc5_;
      }
      
      private static function getEquipRepairPrice(param1:SingleEquipInfo) : int
      {
         var _loc2_:int = int(ItemXMLInfo.getDuration(param1.itemID));
         var _loc3_:int = generateEquipDuration(param1.duration,_loc2_);
         var _loc4_:int = int(ItemXMLInfo.getRepairPrice(param1.itemID));
         return (_loc2_ - _loc3_) * _loc4_;
      }
   }
}

