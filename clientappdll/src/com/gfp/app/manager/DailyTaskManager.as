package com.gfp.app.manager
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.TollgateXMLInfo;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class DailyTaskManager
   {
      
      private static var _instance:DailyTaskManager;
      
      private static const _swapID:Array = [13070,13071,13072,13073,13074,13075,13076,13077,13078,13079,13080,13081];
      
      private static const _completeNumID:int = 13069;
      
      private var _taskOneID:int;
      
      private var _curTollgateID:int;
      
      public function DailyTaskManager()
      {
         super();
      }
      
      public static function get instance() : DailyTaskManager
      {
         if(_instance == null)
         {
            _instance = new DailyTaskManager();
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
      
      public static function setup() : void
      {
         instance.addEvent();
         instance.dynamicID();
      }
      
      private function dynamicID() : void
      {
         var _loc1_:int = int(MainManager.actorInfo.lv);
         if(_loc1_ < 90)
         {
            this._taskOneID = 101;
         }
         if(_loc1_ >= 90 && _loc1_ < 100)
         {
            this._taskOneID = 105;
         }
         if(_loc1_ >= 100 && _loc1_ < 110)
         {
            this._taskOneID = 115;
         }
         if(_loc1_ >= 110 && _loc1_ < 115)
         {
            this._taskOneID = 1132;
         }
         if(_loc1_ >= 115)
         {
            this._taskOneID = 1442;
         }
      }
      
      private function addEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.STAGE_QUIT,this.onQuit);
         FightManager.instance.addEventListener(FightEvent.QUITE,this.onQuite);
         SocketConnection.addCmdListener(CommandID.EQUIPT_STRENGTHEN,this.onStrenthen);
         SocketConnection.addCmdListener(CommandID.JEWELRY_UPGRADE,this.onJewelryUpgrade);
         SocketConnection.addCmdListener(CommandID.EQUIP_RONG_LIAN,this.onEquipRongLian);
         SocketConnection.addCmdListener(CommandID.MAKE_MAGIC_WEAPON,this.responseMake);
         SocketConnection.addCmdListener(CommandID.SUMMON_EXP_ASSIGN,this.onSummonExpAssign);
         SocketConnection.addCmdListener(CommandID.SUMMON_FEED,this.onFeedSummon);
         SocketConnection.addCmdListener(CommandID.SOUL_UPGRADE,this.onSoulUpgrade);
         SocketConnection.addCmdListener(CommandID.SOUL_WASH,this.onSoulWash);
      }
      
      private function removeEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.STAGE_QUIT,this.onQuit);
         FightManager.instance.removeEventListener(FightEvent.QUITE,this.onQuite);
         SocketConnection.removeCmdListener(CommandID.EQUIPT_STRENGTHEN,this.onStrenthen);
         SocketConnection.removeCmdListener(CommandID.JEWELRY_UPGRADE,this.onJewelryUpgrade);
         SocketConnection.removeCmdListener(CommandID.EQUIP_RONG_LIAN,this.onEquipRongLian);
         SocketConnection.removeCmdListener(CommandID.MAKE_MAGIC_WEAPON,this.responseMake);
         SocketConnection.removeCmdListener(CommandID.SUMMON_EXP_ASSIGN,this.onSummonExpAssign);
         SocketConnection.removeCmdListener(CommandID.SUMMON_FEED,this.onFeedSummon);
         SocketConnection.removeCmdListener(CommandID.SOUL_UPGRADE,this.onSoulUpgrade);
         SocketConnection.addCmdListener(CommandID.SOUL_WASH,this.onSoulWash);
      }
      
      private function onQuite(param1:FightEvent) : void
      {
         this._curTollgateID = MainManager.tollgateId;
      }
      
      private function onSoulWash(param1:SocketEvent) : void
      {
         if(this.getSwapNum(13081) < 1)
         {
            this.sendSwapID(13081);
         }
      }
      
      private function onSoulUpgrade(param1:SocketEvent) : void
      {
         if(this.getSwapNum(13080) < 1)
         {
            this.sendSwapID(13080);
         }
      }
      
      private function onFeedSummon(param1:SocketEvent) : void
      {
         if(this.getSwapNum(13079) < 1)
         {
            this.sendSwapID(13079);
         }
      }
      
      private function onSummonExpAssign(param1:SocketEvent) : void
      {
         if(this.getSwapNum(13078) < 1)
         {
            this.sendSwapID(13078);
         }
      }
      
      private function responseMake(param1:SocketEvent) : void
      {
         if(this.getSwapNum(13077) < 1)
         {
            this.sendSwapID(13077);
         }
      }
      
      private function onEquipRongLian(param1:SocketEvent) : void
      {
         if(this.getSwapNum(13076) < 1)
         {
            this.sendSwapID(13076);
         }
      }
      
      private function onJewelryUpgrade(param1:SocketEvent) : void
      {
         if(this.getSwapNum(13075) < 1)
         {
            this.sendSwapID(13075);
         }
      }
      
      private function onStrenthen(param1:SocketEvent) : void
      {
         if(this.getSwapNum(13074) < 1)
         {
            this.sendSwapID(13074);
         }
      }
      
      private function onQuit(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedByte();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         if(this.winTaskOne(_loc4_) && this.getSwapNum(13070) == 0)
         {
            this.sendSwapID(13070);
         }
         if(this.winDiomandTollgate(_loc4_) && this.getSwapNum(13071) == 0)
         {
            this.sendSwapID(13071);
         }
         if(this.winDaoMuBiJi(_loc4_) && this.getSwapNum(13072) == 0)
         {
            this.sendSwapID(13072);
         }
         if(this.winZhuanShengTollGate() && _loc4_ == 0 && this.getSwapNum(13073) == 0)
         {
            this.sendSwapID(13073);
         }
      }
      
      private function winTaskOne(param1:int) : Boolean
      {
         var _loc2_:int = int(MainManager.tollgateId);
         var _loc3_:Boolean = false;
         if((this._curTollgateID == this._taskOneID || [1414,1415,1429,1430,1431,1432].indexOf(this._curTollgateID) != -1) && param1 == 0)
         {
            _loc3_ = true;
         }
         return _loc3_;
      }
      
      private function winZhuanShengTollGate() : Boolean
      {
         var _loc1_:int = int(MainManager.tollgateId);
         return Boolean(TollgateXMLInfo.isTurnBackTollgate(this._curTollgateID));
      }
      
      private function winDaoMuBiJi(param1:int) : Boolean
      {
         var _loc4_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:int = int(MainManager.tollgateId);
         for each(_loc4_ in [1243,1244,1245,1246,1247,1251,1255,1257])
         {
            if(_loc4_ == this._curTollgateID && param1 == 0)
            {
               _loc2_ = true;
            }
         }
         return _loc2_;
      }
      
      private function winDiomandTollgate(param1:int) : Boolean
      {
         var _loc4_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:int = int(MainManager.tollgateId);
         for each(_loc4_ in [117,118,119,120,121])
         {
            if(_loc4_ == this._curTollgateID && param1 == 0)
            {
               _loc2_ = true;
            }
         }
         return _loc2_;
      }
      
      private function getSwapNum(param1:int) : int
      {
         return ActivityExchangeTimesManager.getTimes(param1);
      }
      
      private function sendSwapID(param1:int) : void
      {
         ActivityExchangeCommander.exchange(param1);
         ActivityExchangeCommander.exchange(9224);
      }
      
      public function destroy() : void
      {
         instance.removeEvent();
      }
   }
}

