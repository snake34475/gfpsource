package com.gfp.app.manager
{
   import com.gfp.app.fight.CustomEvent;
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.GodGuardXMLInfo;
   import com.gfp.core.info.GodInstanceInfo;
   import com.gfp.core.info.JuDianNodeInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.CustomEventMananger;
   import com.gfp.core.manager.GodManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.xmlconfig.JuDianXmlInfo;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class JuDianManager
   {
      
      public static var currentFightDianId:int;
      
      public static var currentRecordPosition:int;
      
      public static var currentRecordMapId:int;
      
      public static var currentRecordMonsters:int;
      
      public static var currentRecordBoxs:int;
      
      public static var currentMaxGodCount:int;
      
      private static var _moveCallBack:Function;
      
      public static var isMoving:Boolean;
      
      private static var _fightCallBack:Function;
      
      public static var isFighting:Boolean;
      
      public static var isLockMoving:Boolean;
      
      private static var _selectGods:Vector.<GodInstanceInfo> = new Vector.<GodInstanceInfo>();
      
      setup();
      
      public function JuDianManager()
      {
         super();
      }
      
      private static function setup() : void
      {
         _selectGods = new Vector.<GodInstanceInfo>();
         _selectGods.length = 5;
         _selectGods.fixed = true;
         loadData();
         refreshFromServer(false);
      }
      
      public static function removeGod(param1:int) : void
      {
         var _loc2_:int = int(_selectGods.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(Boolean(_selectGods[_loc3_]) && _selectGods[_loc3_].roleType == param1)
            {
               _selectGods[_loc3_] = null;
            }
            _loc3_++;
         }
      }
      
      private static function loadData() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:GodInstanceInfo = null;
         var _loc1_:Array = ClientTempState.getShareObject("JuDianSelectGodInfos",2) as Array;
         if(_loc1_)
         {
            _loc2_ = int(_loc1_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = int(_loc1_[_loc3_]);
               if(_loc4_)
               {
                  _loc5_ = GodManager.instance.getGodInfoByGodId(_loc4_);
                  if(_loc5_)
                  {
                     _selectGods[_loc3_] = _loc5_;
                  }
                  else
                  {
                     _selectGods[_loc3_] = null;
                  }
               }
               _loc3_++;
            }
         }
      }
      
      private static function refreshFromServer(param1:Boolean = true) : void
      {
         currentMaxGodCount = ActivityExchangeTimesManager.getTimes(6545);
         if(currentMaxGodCount == 0)
         {
            currentMaxGodCount = 2;
         }
         currentRecordPosition = ActivityExchangeTimesManager.getTimes(6541);
         currentRecordMapId = ActivityExchangeTimesManager.getTimes(6542);
         currentRecordMonsters = ActivityExchangeTimesManager.getTimes(6543);
         currentRecordBoxs = ActivityExchangeTimesManager.getTimes(6544);
         if(param1 && JuDianManager.getJuDianProcess(currentRecordMapId) >= 100 && JuDianManager.isCurrentDoingId() == JuDianManager.currentRecordMapId + 1)
         {
            currentFightDianId = JuDianManager.isCurrentDoingId();
            JuDianManager.currentRecordMapId = JuDianManager.isCurrentDoingId();
            currentRecordMonsters = 0;
            currentRecordBoxs = 0;
            currentRecordPosition = 0;
         }
         if(param1)
         {
            CustomEventMananger.dispatchEvent(new CustomEvent(CustomEvent.JU_DIAN_DATA_REFRESH_COMPLETE));
         }
      }
      
      public static function getJuDianProcess(param1:int) : int
      {
         var _loc2_:JuDianNodeInfo = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 < currentRecordMapId)
         {
            return 100;
         }
         if(param1 > currentRecordMapId)
         {
            return 0;
         }
         _loc2_ = JuDianXmlInfo.getInfo(currentRecordMapId);
         if(_loc2_)
         {
            _loc3_ = 0;
            _loc5_ = 0;
            while(_loc5_ < _loc2_.monsterCount)
            {
               _loc4_ = 1 << _loc5_;
               if((currentRecordMonsters & _loc4_) == _loc4_)
               {
                  _loc3_++;
               }
               _loc5_++;
            }
            _loc5_ = 0;
            while(_loc5_ < _loc2_.boxCount)
            {
               _loc4_ = 1 << _loc5_;
               if((currentRecordBoxs & _loc4_) == _loc4_)
               {
                  _loc3_++;
               }
               _loc5_++;
            }
            return _loc3_ * 100 / (_loc2_.monsterCount + _loc2_.boxCount);
         }
         return 0;
      }
      
      public static function isCurrentDoingId() : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:JuDianNodeInfo = null;
         if(currentRecordMapId == 0)
         {
            return 1;
         }
         var _loc1_:JuDianNodeInfo = JuDianXmlInfo.getInfo(currentRecordMapId);
         if(_loc1_)
         {
            _loc2_ = 1;
            _loc3_ = 1;
            while(_loc3_ < _loc1_.monsterCount)
            {
               _loc2_ |= _loc2_ << 1;
               _loc3_++;
            }
            _loc4_ = 1;
            _loc3_ = 1;
            while(_loc3_ < _loc1_.boxCount)
            {
               _loc4_ |= _loc4_ << 1;
               _loc3_++;
            }
            if(currentRecordMonsters == _loc2_ && currentRecordBoxs == _loc4_)
            {
               _loc5_ = currentRecordMapId + 1;
               _loc6_ = JuDianXmlInfo.getInfo(_loc5_);
               if(_loc6_)
               {
                  return currentRecordMapId + 1;
               }
               return currentRecordMapId;
            }
            return currentRecordMapId;
         }
         return 0;
      }
      
      public static function updateFromServer() : void
      {
         SocketConnection.addCmdListener(CommandID.ACTIVITY_EXCHANGE_TIMES,scoreBack);
         SocketConnection.send(CommandID.ACTIVITY_EXCHANGE_TIMES);
      }
      
      private static function scoreBack(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.ACTIVITY_EXCHANGE_TIMES,scoreBack);
         ActivityExchangeTimesManager.readForLogin(param1.data as ByteArray);
         refreshFromServer();
      }
      
      public static function isDoorCanBeOpen(param1:int) : Boolean
      {
         var _loc2_:Vector.<int> = JuDianXmlInfo.getDoorNeeds(currentFightDianId,param1);
         return isBossBeKilled(_loc2_);
      }
      
      public static function getDoorStillNeedIds(param1:int) : Vector.<int>
      {
         var _loc4_:int = 0;
         var _loc2_:Vector.<int> = new Vector.<int>();
         var _loc3_:Vector.<int> = JuDianXmlInfo.getDoorNeeds(currentFightDianId,param1);
         for each(param1 in _loc3_)
         {
            _loc4_ = 1 << param1 - 1;
            if((_loc4_ & currentRecordMonsters) != _loc4_)
            {
               _loc2_.push(param1);
            }
         }
         return _loc2_;
      }
      
      public static function isBossBeKilled(param1:Vector.<int>) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         for each(_loc2_ in param1)
         {
            _loc3_ = 1 << _loc2_ - 1;
            if((_loc3_ & currentRecordMonsters) != _loc3_)
            {
               return false;
            }
         }
         return true;
      }
      
      public static function killBoss(param1:int) : void
      {
         var _loc2_:int = 1 << param1 - 1;
         currentRecordMonsters |= _loc2_;
      }
      
      public static function pickBox(param1:int) : void
      {
         var _loc2_:int = 1 << param1 - 1;
         currentRecordBoxs |= _loc2_;
      }
      
      public static function addSelectGod(param1:GodInstanceInfo, param2:int) : void
      {
         _selectGods[param2] = param1;
         saveData();
      }
      
      private static function saveData() : void
      {
         var _loc1_:int = int(_selectGods.length);
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            if(_selectGods[_loc3_])
            {
               _loc2_.push(_selectGods[_loc3_].roleType);
            }
            else
            {
               _loc2_.push(0);
            }
            _loc3_++;
         }
         ClientTempState.addShareObject("JuDianSelectGodInfos",_loc2_,2);
      }
      
      public static function getSelectGods() : Vector.<GodInstanceInfo>
      {
         return _selectGods;
      }
      
      public static function getSelectGodCount() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = int(_selectGods.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_selectGods[_loc3_])
            {
               _loc1_++;
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public static function isGodExist(param1:int) : Boolean
      {
         var _loc2_:GodInstanceInfo = null;
         for each(_loc2_ in _selectGods)
         {
            if(Boolean(_loc2_) && _loc2_.roleType == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function getTotalDps() : int
      {
         var _loc2_:GodInstanceInfo = null;
         var _loc1_:int = 0;
         for each(_loc2_ in _selectGods)
         {
            if(_loc2_)
            {
               _loc1_ += _loc2_.dps;
            }
         }
         return _loc1_;
      }
      
      public static function getTotalHp() : int
      {
         var _loc2_:GodInstanceInfo = null;
         var _loc1_:int = 0;
         for each(_loc2_ in _selectGods)
         {
            if(_loc2_)
            {
               _loc1_ += _loc2_.hp;
            }
         }
         return _loc1_;
      }
      
      public static function getTotalFightPower() : int
      {
         var _loc2_:GodInstanceInfo = null;
         var _loc1_:int = 0;
         for each(_loc2_ in _selectGods)
         {
            if(_loc2_)
            {
               _loc1_ += GodGuardXMLInfo.getGodFightPower(_loc2_.roleType);
            }
         }
         return _loc1_;
      }
      
      public static function move(param1:int, param2:int, param3:Function) : void
      {
         if(isMoving)
         {
            return;
         }
         isMoving = true;
         _moveCallBack = param3;
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeUnsignedInt(param1);
         _loc4_.writeUnsignedInt(currentFightDianId);
         _loc4_.writeUnsignedInt(param2);
         SocketConnection.addCmdListener(CommandID.JU_DIAN_GOD_MOVE,onJuDianMove);
         SocketConnection.send(CommandID.JU_DIAN_GOD_MOVE,_loc4_);
      }
      
      private static function onJuDianMove(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.JU_DIAN_GOD_MOVE,onJuDianMove);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:int = int(_loc2_.readUnsignedInt());
         var _loc6_:int = int(_loc2_.readUnsignedInt());
         if(_moveCallBack != null)
         {
            _moveCallBack(_loc3_,_loc4_,_loc5_,_loc6_);
         }
         isMoving = false;
      }
      
      public static function fight(param1:int, param2:int, param3:int, param4:Function) : void
      {
         if(isFighting)
         {
            return;
         }
         isFighting = true;
         _fightCallBack = param4;
         var _loc5_:ByteArray = new ByteArray();
         _loc5_.writeUnsignedInt(param1);
         _loc5_.writeUnsignedInt(currentFightDianId);
         _loc5_.writeUnsignedInt(param2);
         _loc5_.writeUnsignedInt(param3);
         var _loc6_:Vector.<GodInstanceInfo> = getOnlySelectGod();
         var _loc7_:int = int(_loc6_.length);
         _loc5_.writeUnsignedInt(_loc7_);
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc5_.writeUnsignedInt(_loc6_[_loc8_].roleType);
            _loc8_++;
         }
         SocketConnection.addCmdListener(CommandID.JU_DIAN_GOD_FIGHT,onJuDianFight);
         SocketConnection.send(CommandID.JU_DIAN_GOD_FIGHT,_loc5_);
      }
      
      private static function getOnlySelectGod() : Vector.<GodInstanceInfo>
      {
         var _loc1_:Vector.<GodInstanceInfo> = new Vector.<GodInstanceInfo>();
         var _loc2_:int = int(_selectGods.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_selectGods[_loc3_])
            {
               _loc1_.push(_selectGods[_loc3_]);
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      private static function onJuDianFight(param1:SocketEvent) : void
      {
         var _loc9_:Object = null;
         SocketConnection.removeCmdListener(CommandID.JU_DIAN_GOD_FIGHT,onJuDianFight);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:Array = [];
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_.push(_loc2_.readUnsignedInt() == 1);
            _loc5_++;
         }
         var _loc6_:int = int(_loc2_.readUnsignedInt());
         var _loc7_:Array = [];
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc9_ = new Object();
            _loc9_.itemId = _loc2_.readUnsignedInt();
            _loc9_.count = _loc2_.readUnsignedInt();
            ItemManager.addItem(_loc9_.itemId,_loc9_.count);
            _loc7_.push(_loc9_);
            _loc5_++;
         }
         var _loc8_:Boolean = _loc2_.readUnsignedInt() <= 0;
         if(_fightCallBack != null)
         {
            _fightCallBack(_loc3_,_loc7_,_loc8_);
         }
         isFighting = false;
      }
   }
}

