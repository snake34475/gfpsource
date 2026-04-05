package com.gfp.app.manager
{
   import com.gfp.core.CommandID;
   import com.gfp.core.config.AttributeConfig;
   import com.gfp.core.events.CommEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.net.SocketConnection;
   import flash.events.Event;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public class DaZhuoWhenLeft5MinManager
   {
      
      private static var _waitTimeId:uint;
      
      private static var _getAwardId:uint;
      
      private static var _currentExp:int;
      
      private static var _isStart:Boolean;
      
      private static var _isFull:Boolean;
      
      private static var _callBack:Function;
      
      private static const WAIT_TIME:int = 5 * 60 * 1000;
      
      private static const AWARD_TIME:int = 10 * 1000;
      
      private static const IGNORE_COMMAND_IDS:Array = [CommandID.SWAPACTION_TIMES,CommandID.LINK_HOLD,CommandID.STAND];
      
      private static const IGNORE_SWAP_IDS:Array = [AWARD_SWAP,LEFT_TIME_SWAP,EXP_VALUE_SWAP,EXP_PERCENT_SWAP];
      
      public static const LEFT_TIME_SWAP:int = 9248;
      
      public static const EXP_VALUE_SWAP:int = 9249;
      
      public static const EXP_PERCENT_SWAP:int = 9250;
      
      public static const AWARD_SWAP:int = 9262;
      
      public static var isDaZhuoPanelOpen:Boolean = false;
      
      public function DaZhuoWhenLeft5MinManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         SocketConnection.addEventListener(CommEvent.HAVE_SEND,onCommandSend);
         _currentExp = ActivityExchangeTimesManager.getTimes(EXP_VALUE_SWAP);
      }
      
      public static function get currentExp() : int
      {
         return _currentExp;
      }
      
      public static function requestExp(param1:Function) : void
      {
         _callBack = param1;
         ActivityExchangeTimesManager.addEventListener(EXP_VALUE_SWAP,onExpValueBack);
         ActivityExchangeTimesManager.getActiviteTimeInfo(EXP_VALUE_SWAP);
      }
      
      private static function onExpValueBack(param1:Event) : void
      {
         _currentExp = ActivityExchangeTimesManager.getTimes(EXP_VALUE_SWAP);
         ActivityExchangeTimesManager.removeEventListener(EXP_VALUE_SWAP,onExpValueBack);
         if(_callBack != null)
         {
            _callBack(_currentExp);
         }
      }
      
      private static function onCommandSend(param1:CommEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = int(param1.data.cmdID);
         if(_loc2_ == 2629)
         {
            _loc3_ = int(param1.data.args[0]);
            if(IGNORE_SWAP_IDS.indexOf(_loc3_) == -1)
            {
               reset();
            }
            return;
         }
         if(IGNORE_COMMAND_IDS.indexOf(_loc2_) == -1)
         {
            reset();
            return;
         }
      }
      
      public static function reset() : void
      {
         clearTimeout(_waitTimeId);
         _waitTimeId = setTimeout(startCaculate,WAIT_TIME);
         stopCaculate();
      }
      
      public static function startCaculate() : void
      {
         if(MapManager.currentMap.info.mapType == MapType.STAND && !noNeedToChange())
         {
            clearTimeout(_waitTimeId);
            _getAwardId = setInterval(sendAward,AWARD_TIME);
            MainManager.actorModel.changeRoleView(10529);
            _isStart = true;
            if(DaZhuoWhenLeft5MinManager.isDaZhuoPanelOpen == false)
            {
               ModuleManager.turnAppModule("ZuiQiangLeiGongPanel");
            }
         }
         else
         {
            reset();
         }
      }
      
      public static function isStart() : Boolean
      {
         return _isStart;
      }
      
      private static function stopCaculate() : void
      {
         var timer:uint = 0;
         clearInterval(_getAwardId);
         if(_isStart)
         {
            timer = setTimeout(function():void
            {
               clearTimeout(timer);
               MainManager.actorModel.changeRoleView(0);
               _isStart = false;
            },0);
         }
      }
      
      private static function dispose() : void
      {
         clearTimeout(_waitTimeId);
         stopCaculate();
         SocketConnection.removeEventListener(CommEvent.HAVE_SEND,onCommandSend);
      }
      
      private static function noNeedToChange() : Boolean
      {
         if(MainManager.actorInfo.magicID != 0)
         {
            return true;
         }
         if(LayerManager.root.parent == null)
         {
            return true;
         }
         if(MainManager.actorModel.info.monsterID != 0 && MainManager.actorModel.info.monsterID != 10529)
         {
            return true;
         }
         if(MapManager.currentMap.info.id == 1056)
         {
            return true;
         }
         return false;
      }
      
      private static function sendAward() : void
      {
         var _loc1_:int = 0;
         if(checkEnd())
         {
            if(_isFull == false)
            {
               _isFull = true;
            }
         }
         if(noNeedToChange())
         {
            return;
         }
         ActivityExchangeCommander.exchange(AWARD_SWAP);
         if(_isFull == false)
         {
            _loc1_ = int(AttributeConfig.calcCurrentLvExp(MainManager.actorInfo.roleType,MainManager.actorInfo.lv + 1,MainManager.actorInfo.isTurnBack));
            if(MainManager.actorInfo.lv == MainManager.activedMaxLevel())
            {
               _loc1_ = 0;
            }
            _currentExp += _loc1_ * 0.001;
         }
      }
      
      public static function checkEnd() : Boolean
      {
         if(ActivityExchangeTimesManager.getTimes(EXP_PERCENT_SWAP) >= 5000)
         {
            return true;
         }
         if(_currentExp >= 500 * 10000)
         {
            return true;
         }
         return false;
      }
   }
}

