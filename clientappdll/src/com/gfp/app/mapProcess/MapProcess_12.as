package com.gfp.app.mapProcess
{
   import com.gfp.app.control.SystemTimeController;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.manager.EscortManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_12 extends BaseMapProcess
   {
      
      private static var LastZujiCount:int;
      
      private static var hasHint:Boolean;
      
      private static var WinHint:Boolean;
      
      private static var ReasonHint:Boolean;
      
      public static var updateTimeBackFunc:Function;
      
      public static var updateTimeCount:int = 0;
      
      private var _tuduiPosArr:Array = [[646,404],[1007,366],[1438,658]];
      
      private var _tuduiArr:Array;
      
      private var _timerCheckCount:int;
      
      private var _tuduiIntervalID:int;
      
      private var _zujiCount:int;
      
      private var _zujiCheckEndBoo:Boolean;
      
      private var _hasCheckTudui_0:Boolean;
      
      private var _hasCheckTudui_1:Boolean;
      
      private var _hasCheckTudui_2:Boolean;
      
      private var _currSnakeMovie:MovieClip;
      
      private var _zujiAwardID:int = 2232;
      
      private var _tuduiFlipIDArr:Array = [2243,2244,2245];
      
      private var _updateTimeID:int = 2259;
      
      private var _updateTuduiFlipID:int = 2246;
      
      private var _checkZujiCountID:int = 2231;
      
      public function MapProcess_12()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addTaskEventListener();
         EscortManager.instance.addEventListener(EscortManager.ESCORT_COMPLETE,this.onEscortEndHandle);
      }
      
      private function onEscortEndHandle(param1:DataEvent) : void
      {
         if(int(param1.data) == 36)
         {
            ModuleManager.turnAppModule("TransportIcePanel");
         }
      }
      
      private function getBuffInfo_1() : void
      {
         SocketConnection.addCmdListener(CommandID.GET_BUFF_TIME,this.onGetTime_1);
         SocketConnection.send(CommandID.GET_BUFF_TIME);
      }
      
      private function onGetTime_1(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GET_BUFF_TIME,this.onGetTime_1);
         this.updateCD_1(param1.data as ByteArray);
      }
      
      private function updateCD_1(param1:ByteArray) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         param1.position = 0;
         var _loc2_:uint = param1.readUnsignedInt();
         var _loc3_:Boolean = false;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = param1.readUnsignedInt();
            _loc6_ = param1.readUnsignedInt();
            if(_loc5_ == int("90" + this._updateTimeID))
            {
               this._timerCheckCount = _loc6_;
               _loc3_ = true;
               break;
            }
            _loc4_++;
         }
         if(!_loc3_)
         {
            this.setAllTuduiVisible(false);
         }
         param1.position = 0;
      }
      
      private function setTudui() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         if(!this._tuduiArr)
         {
            this._tuduiArr = [];
            _loc2_ = 0;
            while(_loc2_ < 3)
            {
               _loc1_.buttonMode = true;
               this._setTuduiPos(_loc1_,_loc2_);
               ToolTipManager.add(_loc1_,"土堆");
               _loc1_.name = "tudui_" + _loc2_;
               this._tuduiArr[_loc2_] = _loc1_;
               _loc1_.visible = !this.checkHasFlip(int(this._tuduiFlipIDArr[0] + _loc2_));
               _loc1_.addEventListener(MouseEvent.CLICK,this.onTuduiClickHandler);
               _mapModel.contentLevel.addChild(_loc1_);
               _loc1_.visible = false;
               _loc2_++;
            }
         }
      }
      
      private function _setTuduiPos(param1:MovieClip, param2:int) : void
      {
         param1.x = this._tuduiPosArr[param2][0];
         param1.y = this._tuduiPosArr[param2][1];
      }
      
      private function checkZuji() : void
      {
         this._zujiCheckEndBoo = this.checkHasFlip(this._zujiAwardID);
         if(this._zujiCheckEndBoo)
         {
            this.initTudui();
            return;
         }
         ActivityExchangeTimesManager.addEventListener(this._checkZujiCountID,this.zujiCheck);
         ActivityExchangeTimesManager.getActiviteTimeInfo(this._checkZujiCountID);
      }
      
      private function initTudui() : void
      {
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeCompleteHandler);
         ActivityExchangeTimesManager.addEventListener(this._tuduiFlipIDArr[0],this.tuduiCheck);
         ActivityExchangeTimesManager.addEventListener(this._tuduiFlipIDArr[1],this.tuduiCheck);
         ActivityExchangeTimesManager.addEventListener(this._tuduiFlipIDArr[2],this.tuduiCheck);
         this._hasCheckTudui_0 = this._hasCheckTudui_1 = this._hasCheckTudui_2 = false;
         ActivityExchangeTimesManager.getActiviteTimeInfo(this._tuduiFlipIDArr[0]);
         ActivityExchangeTimesManager.getActiviteTimeInfo(this._tuduiFlipIDArr[1]);
         ActivityExchangeTimesManager.getActiviteTimeInfo(this._tuduiFlipIDArr[2]);
      }
      
      private function zujiCheck(param1:DataEvent) : void
      {
         ActivityExchangeTimesManager.removeEventListener(this._checkZujiCountID,this.zujiCheck);
         if(this._zujiCount >= 5 || MapProcess_12["LastZujiCount"] >= 5 || Boolean(MapProcess_12["hasHint"]))
         {
            return;
         }
         this._zujiCount = ActivityExchangeTimesManager.getTimes(this._checkZujiCountID);
         if(this._zujiCount > MapProcess_12["LastZujiCount"] && !MapProcess_12["hasHint"])
         {
            if(MapProcess_12["WinHint"])
            {
               AlertManager.showSimpleAlarm("小侠士，恭喜你找到了一个年兽的足迹，调查成功。");
               FightManager.instance.removeEventListener(FightEvent.WINNER,this.onFightWinnerHandler);
               FightManager.instance.removeEventListener(FightEvent.REASON,this.onFightReasonHandler);
               if(this._zujiCount >= 5)
               {
                  MapProcess_12["hasHint"] = true;
               }
            }
         }
         else if(MapProcess_12["ReasonHint"])
         {
            AlertManager.showSimpleAlarm("小侠士，你被年兽的爪牙击败了，没有完成调查，请加油吧。");
            FightManager.instance.removeEventListener(FightEvent.WINNER,this.onFightWinnerHandler);
            FightManager.instance.removeEventListener(FightEvent.REASON,this.onFightReasonHandler);
         }
         MapProcess_12["WinHint"] = MapProcess_12["ReasonHint"] = false;
         MapProcess_12["LastZujiCount"] = this._zujiCount;
         this.initTudui();
      }
      
      private function unInitTudui() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         if(this._tuduiArr)
         {
            _loc1_ = 0;
            _loc2_ = int(this._tuduiArr.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = this._tuduiArr[_loc1_];
               _mapModel.contentLevel.removeChild(_loc3_);
               _loc3_.removeEventListener(MouseEvent.CLICK,this.onTuduiClickHandler);
               _loc1_++;
            }
            this._tuduiArr.length = 0;
            this._tuduiArr = null;
         }
         clearInterval(this._tuduiIntervalID);
         ActivityExchangeTimesManager.removeEventListener(this._checkZujiCountID,this.zujiCheck);
         ActivityExchangeTimesManager.removeEventListener(this._tuduiFlipIDArr[0],this.tuduiCheck);
         ActivityExchangeTimesManager.removeEventListener(this._tuduiFlipIDArr[1],this.tuduiCheck);
         ActivityExchangeTimesManager.removeEventListener(this._tuduiFlipIDArr[2],this.tuduiCheck);
      }
      
      private function tuduiCheck(param1:DataEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         if(param1.type.indexOf(String(this._tuduiFlipIDArr[0])) > -1)
         {
            this._hasCheckTudui_0 = true;
         }
         else if(param1.type.indexOf(String(this._tuduiFlipIDArr[1])) > -1)
         {
            this._hasCheckTudui_1 = true;
         }
         else if(param1.type.indexOf(String(this._tuduiFlipIDArr[2])) > -1)
         {
            this._hasCheckTudui_2 = true;
         }
         if(this._hasCheckTudui_0 && this._hasCheckTudui_1 && this._hasCheckTudui_2)
         {
            if(this._timerCheckCount <= 0)
            {
               if(this.checkHasFlip(this._tuduiFlipIDArr[0],this._tuduiFlipIDArr[1],this._tuduiFlipIDArr[2]))
               {
                  ActivityExchangeCommander.exchange(this._updateTuduiFlipID);
               }
            }
            else
            {
               this.getBuffInfo();
            }
            _loc2_ = 0;
            _loc3_ = int(this._tuduiArr.length);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc4_ = this._tuduiArr[_loc2_];
               _loc4_.visible = !this.checkHasFlip(int(this._tuduiFlipIDArr[0] + _loc2_)) && !this._zujiCheckEndBoo;
               _loc2_++;
            }
         }
      }
      
      private function timerCheck() : void
      {
         --this._timerCheckCount;
         if(this._timerCheckCount < 0)
         {
            this._timerCheckCount = 0;
            clearInterval(this._tuduiIntervalID);
            this._hasCheckTudui_0 = this._hasCheckTudui_1 = this._hasCheckTudui_2 = false;
            ActivityExchangeTimesManager.getActiviteTimeInfo(this._tuduiFlipIDArr[0]);
            ActivityExchangeTimesManager.getActiviteTimeInfo(this._tuduiFlipIDArr[1]);
            ActivityExchangeTimesManager.getActiviteTimeInfo(this._tuduiFlipIDArr[2]);
         }
         updateTimeCount = this._timerCheckCount;
         this.updateGlobalTime(this._timerCheckCount);
      }
      
      private function updateGlobalTime(param1:int) : void
      {
         if(updateTimeBackFunc != null)
         {
            updateTimeBackFunc(param1,1);
         }
      }
      
      private function reTuduiCheck() : void
      {
         var _loc3_:MovieClip = null;
         var _loc1_:int = 0;
         var _loc2_:int = int(this._tuduiArr.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this._tuduiArr[_loc1_];
            this._setTuduiPos(_loc3_,_loc1_);
            _loc3_.visible = true;
            _loc1_++;
         }
      }
      
      private function onExchangeCompleteHandler(param1:ExchangeEvent) : void
      {
         if(param1.info.id != this._updateTimeID)
         {
            if(param1.info.id == this._tuduiFlipIDArr[0] || param1.info.id == this._tuduiFlipIDArr[1] || param1.info.id == this._tuduiFlipIDArr[2])
            {
               if(this.checkHasFlip(this._tuduiFlipIDArr[0]) && this.checkHasFlip(this._tuduiFlipIDArr[1]) && this.checkHasFlip(this._tuduiFlipIDArr[2]))
               {
                  ActivityExchangeCommander.exchange(this._updateTimeID);
                  this.getBuffInfo();
               }
            }
            else if(param1.info.id == this._updateTuduiFlipID)
            {
               this._hasCheckTudui_0 = this._hasCheckTudui_1 = this._hasCheckTudui_2 = false;
               ActivityExchangeTimesManager.getActiviteTimeInfo(this._tuduiFlipIDArr[0]);
               ActivityExchangeTimesManager.getActiviteTimeInfo(this._tuduiFlipIDArr[1]);
               ActivityExchangeTimesManager.getActiviteTimeInfo(this._tuduiFlipIDArr[2]);
            }
         }
      }
      
      private function checkHasFlip(... rest) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(rest.length);
         var _loc4_:Boolean = true;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ActivityExchangeTimesManager.getTimes(int(rest[_loc2_])) > 0;
            if(!_loc4_)
            {
               break;
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      protected function onTuduiClickHandler(param1:MouseEvent = null) : void
      {
         var dep:int;
         var tmpMC:MovieClip = null;
         var event:MouseEvent = param1;
         var mc:MovieClip = event.currentTarget as MovieClip;
         var nameArr:Array = mc.name.split("_");
         mc.visible = false;
         if(this._zujiCount >= 5)
         {
            AlertManager.showSimpleAlarm("亲爱的小侠士，你已经找到了足够的年兽足迹了！");
            return;
         }
         if(this._zujiCheckEndBoo)
         {
            AlertManager.showSimpleAlarm("亲爱的小侠士，你已经调查过年兽足迹了哦！");
            return;
         }
         if(!SystemTimeController.instance.checkSysTimeAchieve(102))
         {
            SystemTimeController.instance.showOutTimeAlert(102);
            return;
         }
         ActivityExchangeCommander.exchange(int(this._tuduiFlipIDArr[0] + int(nameArr[1])));
         dep = mc.parent.getChildIndex(mc) + 1;
         if(Math.random() > 0.75)
         {
         }
         tmpMC.x = mc.x - 41;
         tmpMC.y = mc.y - 52;
         _mapModel.contentLevel.addChildAt(tmpMC,dep);
         MainManager.closeOperate(true);
         this._currSnakeMovie = tmpMC;
         tmpMC.addFrameScript(tmpMC.totalFrames - 1,function():void
         {
            tmpMC.stop();
            tmpMC.addFrameScript(tmpMC.totalFrames - 1,null);
            MainManager.openOperate();
            if(tmpMC)
            {
               destroy();
               FightManager.instance.addEventListener(FightEvent.WINNER,onFightWinnerHandler);
               FightManager.instance.addEventListener(FightEvent.REASON,onFightReasonHandler);
               PveEntry.instance.enterTollgate(662);
            }
            else
            {
               AlertManager.showSimpleAlarm("小侠士，很遗憾，你找到的是一堆便便。");
               tmpMC.parent.removeChild(tmpMC);
            }
         });
      }
      
      private function onFightWinnerHandler(param1:FightEvent) : void
      {
         MapProcess_12["WinHint"] = true;
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onFightWinnerHandler);
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onFightReasonHandler);
      }
      
      private function onFightReasonHandler(param1:FightEvent) : void
      {
         MapProcess_12["ReasonHint"] = true;
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onFightWinnerHandler);
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onFightReasonHandler);
      }
      
      private function getBuffInfo() : void
      {
         SocketConnection.addCmdListener(CommandID.GET_BUFF_TIME,this.onGetTime);
         SocketConnection.send(CommandID.GET_BUFF_TIME);
      }
      
      private function onGetTime(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GET_BUFF_TIME,this.onGetTime);
         this.updateCD(param1.data as ByteArray);
      }
      
      private function updateCD(param1:ByteArray) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         param1.position = 0;
         var _loc2_:uint = param1.readUnsignedInt();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.readUnsignedInt();
            _loc5_ = param1.readUnsignedInt();
            if(_loc4_ == int("90" + this._updateTimeID))
            {
               this._timerCheckCount = _loc5_;
               clearInterval(this._tuduiIntervalID);
               this._tuduiIntervalID = setInterval(this.timerCheck,1000);
               break;
            }
            _loc3_++;
         }
         param1.position = 0;
      }
      
      private function setAllTuduiVisible(param1:Boolean) : void
      {
         var _loc4_:MovieClip = null;
         var _loc2_:int = 0;
         var _loc3_:int = int(this._tuduiArr.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this._tuduiArr[_loc2_];
            _loc4_.visible = param1;
            _loc2_++;
         }
      }
      
      private function addTaskEventListener() : void
      {
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
      }
      
      private function removeTaskEventListener() : void
      {
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(TasksManager.isTaskProComplete(21,2))
         {
            TasksManager.taskComplete(21);
            if(TasksManager.isAcceptable(22))
            {
               TasksManager.accept(22);
            }
         }
      }
      
      override public function destroy() : void
      {
         if(this._currSnakeMovie)
         {
            this._currSnakeMovie.stop();
            this._currSnakeMovie.addFrameScript(this._currSnakeMovie.totalFrames - 1,null);
            if(this._currSnakeMovie.parent)
            {
               this._currSnakeMovie.parent.removeChild(this._currSnakeMovie);
            }
            this._currSnakeMovie = null;
         }
         EscortManager.instance.removeEventListener(EscortManager.ESCORT_COMPLETE,this.onEscortEndHandle);
         this.unInitTudui();
         this.removeTaskEventListener();
         MainManager.openOperate();
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeCompleteHandler);
         super.destroy();
      }
   }
}

