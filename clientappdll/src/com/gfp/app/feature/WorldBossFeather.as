package com.gfp.app.feature
{
   import com.gfp.app.control.OperateControl;
   import com.gfp.app.control.SystemTimeController;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.manager.WorldBossMananer;
   import com.gfp.app.ui.activity.WorldBossScorePanel;
   import com.gfp.app.ui.model.BossBlood;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.ActionInfo;
   import com.gfp.core.action.normal.PosMoveAction;
   import com.gfp.core.action.normal.RandomWalkAction;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.model.CustomUserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.LineType;
   import com.gfp.core.utils.TimeUtil;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class WorldBossFeather
   {
      
      private static const AWARD_TIME_ID:uint = 150;
      
      private var _bossModel:CustomUserModel;
      
      private var _goPoint:Array = [new Point(1037,402)];
      
      private var _tollgateIds:Array = [100589,100590];
      
      private var _bossNames:Array = ["牛魔王","牛魔王"];
      
      private var _bossLookLike:Array = [13874,13875];
      
      private var _bossStartTime:Array = [[14,0,0],[20,0,0]];
      
      private var _bossEndTime:Array = [[14,30,10],[20,30,10]];
      
      private var _stageIds:Array = [589,590];
      
      private var _currentPoint:Point;
      
      private var _moveTimer:int;
      
      private var _displayText:TextField;
      
      private var _minuteTimer:int;
      
      private var _secoundTimer:int;
      
      private var _currentBlood:int = totalBlood;
      
      private var _rankPanel:WorldBossScorePanel;
      
      private var _rankTimer:int;
      
      private var _blood:BossBlood;
      
      private var _getAwardTimer:int;
      
      private var _getAwardCount:int = 30;
      
      private var _awardBegin:Boolean = false;
      
      public function WorldBossFeather()
      {
         super();
         if(WorldBossMananer.isMorning && !SystemTimeController.instance.checkSysTimeAchieve(152))
         {
            return;
         }
         this.init();
         this.addEvent();
      }
      
      public static function get totalBlood() : int
      {
         if(MainManager.loginInfo.lineType == LineType.LINE_TYPE_CT)
         {
            return 1600;
         }
         if(MainManager.loginInfo.lineType == LineType.LINE_TYPE_CT2)
         {
            return 150;
         }
         return 600;
      }
      
      private function addEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.GET_WEDDING_LIFE,this.onGetNpcLifeHandler);
         SocketConnection.addCmdListener(CommandID.APPLY_COUNT,this.onBossBlood);
         SocketConnection.addCmdListener(CommandID.PRIVILEGE_81_INFO,this.requestInfoResult);
      }
      
      private function onGetNpcLifeHandler(param1:SocketEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         if(_loc3_ == 13)
         {
            _loc5_ = WorldBossMananer.isMorning ? uint(this._tollgateIds[0]) : uint(this._tollgateIds[1]);
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               _loc7_ = int(_loc2_.readUnsignedInt());
               _loc8_ = int(_loc2_.readUnsignedInt());
               if(_loc7_ == _loc5_)
               {
                  this._currentBlood = _loc8_;
                  this.updateBlood();
                  break;
               }
               _loc6_++;
            }
         }
      }
      
      private function onBossBlood(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:uint = WorldBossMananer.isMorning ? uint(this._tollgateIds[0]) : uint(this._tollgateIds[1]);
         if(_loc3_ == _loc5_)
         {
            this._currentBlood = _loc4_;
            this.updateBlood();
         }
      }
      
      private function updateBlood() : void
      {
         var _loc1_:Date = null;
         var _loc2_:Date = null;
         if(this._currentBlood == 0)
         {
            this.setBossBlood(this._currentBlood);
            this.killBoss();
         }
         else
         {
            _loc1_ = this.getBossEndTime();
            _loc2_ = TimeUtil.getSeverDateObject();
            if(_loc1_.time - 30 * 1000 > _loc2_.time)
            {
               if(!this._bossModel)
               {
                  this.initBoss(false);
               }
               this.setBossBlood(this._currentBlood);
            }
         }
      }
      
      private function setBossBlood(param1:int) : void
      {
         if(this._bossModel)
         {
            if(WorldBossMananer.isMorning)
            {
               this._blood.nickName = this._bossNames[0] + " (" + this._currentBlood + "/" + totalBlood + ")";
            }
            else
            {
               this._blood.nickName = this._bossNames[1] + " (" + this._currentBlood + "/" + totalBlood + ")";
            }
            this._blood.setBlood(this._currentBlood,totalBlood);
         }
      }
      
      private function killBoss() : void
      {
         this.destoryBoss();
         if(!this._awardBegin)
         {
            this.sendAward();
         }
      }
      
      private function getAwardTimerHandler() : void
      {
         if(this._getAwardCount <= 0)
         {
            this.setScreenText(null);
            clearInterval(this._getAwardTimer);
            SocketConnection.send(CommandID.PRIVILEGE_81_INFO);
            return;
         }
         this.setScreenText("奖励还有" + this._getAwardCount + "秒就发放哦,请稍等。");
         --this._getAwardCount;
      }
      
      private function sendAward() : void
      {
         if(this._rankPanel.ownPoint <= 0)
         {
            return;
         }
         var _loc1_:uint = WorldBossMananer.getAwardTimeSwap();
         if(ActivityExchangeTimesManager.getTimes(_loc1_) == 0 && SystemTimeController.instance.checkSysTimeAchieve(AWARD_TIME_ID))
         {
            this._awardBegin = true;
            this._getAwardTimer = setInterval(this.getAwardTimerHandler,1000);
         }
      }
      
      private function removeEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.APPLY_COUNT,this.onBossBlood);
         SocketConnection.removeCmdListener(CommandID.PRIVILEGE_81_INFO,this.requestInfoResult);
         SocketConnection.removeCmdListener(CommandID.GET_WEDDING_LIFE,this.onGetNpcLifeHandler);
         this.removeBossEvent();
      }
      
      private function requestInfoResult(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.PRIVILEGE_81_INFO,this.requestInfoResult);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         OperateControl.addCoin(_loc4_);
         OperateControl.addExp(_loc3_);
         if(MainManager.actorInfo.lv >= 100)
         {
            AlertManager.showSimpleAlarm("世界boss活动已结束。本次战斗你总共获得功夫豆" + _loc4_.toString());
         }
         else
         {
            AlertManager.showSimpleAlarm("世界boss活动已结束。本次战斗你总共获得功夫豆" + _loc4_.toString() + "，经验" + _loc3_.toString());
         }
         var _loc5_:uint = WorldBossMananer.getAwardTimeSwap();
         ActivityExchangeTimesManager.updataTimesByOnce(_loc5_);
      }
      
      private function removeBossEvent() : void
      {
         if(this._bossModel)
         {
            this._bossModel.removeEvent(MouseEvent.CLICK,this.onMouseClick);
         }
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         var stageID:uint = 0;
         var e:MouseEvent = param1;
         if(WorldBossMananer.isMorning)
         {
            stageID = uint(this._stageIds[0]);
            if(MainManager.actorInfo.lv < 100)
            {
               AlertManager.showSimpleAlarm("此牛魔王非彼牛魔王，不可小看，只有在陆半仙处参加了百级侠士团的玩家才可参与。");
               return;
            }
            if(!MainManager.actorInfo.isJoinTuan100)
            {
               AlertManager.showSimpleAlert("小侠士如此优秀却还未加入百级侠士团，是否要加入，加入后即可参战？",function():void
               {
                  ModuleManager.turnAppModule("LuBanXian100LevelPanel");
               });
               return;
            }
         }
         else
         {
            stageID = uint(this._stageIds[1]);
         }
         PveEntry.enterTollgate(stageID);
      }
      
      private function setScreenText(param1:String) : void
      {
         if(param1)
         {
            this._displayText.text = param1;
            this._displayText.visible = true;
            this._displayText.x = (LayerManager.stageWidth - this._displayText.width) / 2;
            this._displayText.y = (LayerManager.stageHeight - this._displayText.height) / 2;
         }
         else
         {
            this._displayText.visible = false;
         }
      }
      
      public function init() : void
      {
         this._displayText = new TextField();
         this._displayText.autoSize = TextFieldAutoSize.LEFT;
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.size = 26;
         _loc1_.color = 16777215;
         this._displayText.defaultTextFormat = _loc1_;
         this._displayText.setTextFormat(_loc1_);
         var _loc2_:GlowFilter = new GlowFilter();
         _loc2_.strength = 2;
         _loc2_.color = 0;
         _loc2_.blurX = 3;
         _loc2_.blurY = 3;
         this._displayText.filters = [_loc2_];
         this._displayText.visible = false;
         LayerManager.topLevel.addChild(this._displayText);
         this._rankPanel = new WorldBossScorePanel();
         this._rankPanel.x = 10;
         this._rankPanel.y = 120;
         this._rankPanel.requestData(WorldBossMananer.isMorning);
         LayerManager.topLevel.addChild(this._rankPanel);
         StageResizeController.instance.register(this.onStageRezise);
         this.enableClock();
         this.enableEndClock();
      }
      
      private function onStageRezise() : void
      {
         this._displayText.x = (LayerManager.stageWidth - this._displayText.width) / 2;
         this._displayText.y = (LayerManager.stageHeight - this._displayText.height) / 2;
      }
      
      private function startUpdating() : void
      {
         this._rankTimer = setInterval(this.requestRankData,20 * 1000);
      }
      
      private function endUpdating() : void
      {
         if(this._rankTimer != 0)
         {
            clearInterval(this._rankTimer);
            this._rankTimer = 0;
         }
      }
      
      private function requestRankData() : void
      {
         if(this._rankPanel)
         {
            this._rankPanel.requestData(WorldBossMananer.isMorning);
         }
      }
      
      private function initBoss(param1:Boolean = true) : void
      {
         this._blood = new BossBlood();
         LayerManager.toolsLevel.addChild(this._blood);
         var _loc2_:uint = WorldBossMananer.isMorning ? uint(this._bossLookLike[0]) : uint(this._bossLookLike[1]);
         this._bossModel = new CustomUserModel(_loc2_);
         this._blood.setIcon(_loc2_);
         this._currentPoint = this._goPoint[0];
         this._bossModel.show(this._currentPoint,null,true);
         this._bossModel.exeAction(new RandomWalkAction(ActionXMLInfo.getInfo(10002),_loc2_,1));
         this._bossModel.addEvent(MouseEvent.CLICK,this.onMouseClick);
         if(param1)
         {
            this.requestBossHealth();
         }
         this.startUpdating();
         DisplayUtil.align(this._blood,null,AlignType.BOTTOM_LEFT,new Point(320,-52));
         this.setBossBlood(this._currentBlood);
      }
      
      private function requestBossHealth() : void
      {
         SocketConnection.send(CommandID.APPLY_COUNT,WorldBossMananer.isMorning ? this._tollgateIds[0] : this._tollgateIds[1]);
      }
      
      private function destoryBoss() : void
      {
         this.endUpdating();
         this.removeBossEvent();
         if(this._bossModel)
         {
            this._bossModel.destroy();
         }
         if(this._moveTimer != 0)
         {
            clearTimeout(this._moveTimer);
         }
         this._bossModel = null;
         if(this._blood)
         {
            DisplayUtil.removeForParent(this._blood);
            this._blood = null;
         }
      }
      
      private function startMovie() : void
      {
         if(this._moveTimer != 0)
         {
            clearTimeout(this._moveTimer);
         }
         this._moveTimer = setTimeout(this.exeMoive,2000);
      }
      
      private function exeMoive() : void
      {
         var _loc1_:ActionInfo = ActionXMLInfo.getInfo(10002);
         var _loc2_:Point = this.randomPoint;
         var _loc3_:PosMoveAction = new PosMoveAction(_loc1_,_loc2_,false);
         this._bossModel.exeAction(_loc3_);
         this._currentPoint = _loc2_;
      }
      
      private function get randomPoint() : Point
      {
         var _loc3_:int = 0;
         var _loc1_:Array = this._goPoint.concat();
         if(this._currentPoint)
         {
            _loc3_ = _loc1_.indexOf(this._currentPoint);
            _loc1_.splice(_loc3_,1);
         }
         var _loc2_:int = Math.floor(Math.random() * _loc1_.length);
         return _loc1_[_loc2_];
      }
      
      public function destory() : void
      {
         this.destoryBoss();
         this.removeEvent();
         if(this._moveTimer != 0)
         {
            clearTimeout(this._moveTimer);
         }
         if(this._minuteTimer != 0)
         {
            clearInterval(this._minuteTimer);
         }
         if(this._secoundTimer != 0)
         {
            clearInterval(this._secoundTimer);
         }
         clearInterval(this._getAwardTimer);
         if(this._rankPanel)
         {
            DisplayUtil.removeForParent(this._rankPanel);
            this._rankPanel.destory();
            this._rankPanel = null;
         }
         if(this._displayText)
         {
            DisplayUtil.removeForParent(this._displayText);
            this._displayText = null;
         }
         StageResizeController.instance.unregister(this.onStageRezise);
      }
      
      private function onBossMoveEnd(param1:MoveEvent) : void
      {
      }
      
      private function checkSecoud() : void
      {
         this._secoundTimer = setInterval(function():void
         {
            var _loc1_:* = getLeftTime();
            if(_loc1_)
            {
               setScreenText("BOSS刷新还剩" + _loc1_.minutesUTC + "分" + _loc1_.secondsUTC + "秒，请勿离场！");
            }
            else
            {
               clearInterval(_secoundTimer);
               _secoundTimer = 0;
               setScreenText(null);
               if(!_bossModel)
               {
                  initBoss();
               }
            }
         },1000);
      }
      
      private function checkMinutes() : void
      {
         this._minuteTimer = setInterval(function():void
         {
            var _loc1_:* = getLeftTime();
            if(_loc1_)
            {
               if(_loc1_.hoursUTC == 0 && _loc1_.minutesUTC <= 4)
               {
                  clearInterval(_minuteTimer);
                  _minuteTimer = 0;
                  checkSecoud();
               }
            }
         },60 * 1000);
      }
      
      private function enableEndClock() : void
      {
         var _loc1_:Date = this.getBossEndTime();
         TimeUtil.checkTimeCallBack(_loc1_,this.bossHaveEnd);
      }
      
      private function bossHaveEnd() : void
      {
         if(this._bossModel)
         {
            if(!this._awardBegin)
            {
               this.sendAward();
            }
            this.destoryBoss();
         }
      }
      
      private function enableClock() : void
      {
         var _loc1_:Date = this.getLeftTime();
         if(_loc1_)
         {
            if(_loc1_.hoursUTC == 0 && _loc1_.minutesUTC <= 4)
            {
               this.checkSecoud();
            }
            else
            {
               TextAlert.show("距离世界boss出现还剩余" + _loc1_.hoursUTC + ":" + _loc1_.minutesUTC + ":" + _loc1_.secondsUTC + "，请小侠士准时到来哦。");
               this.setScreenText(null);
               this.checkMinutes();
            }
         }
         else
         {
            this.requestBossHealth();
            this.setScreenText(null);
         }
      }
      
      private function getBossEndTime() : Date
      {
         var _loc1_:Date = TimeUtil.getSeverDateObject();
         var _loc2_:Date = new Date();
         _loc2_.time = _loc1_.time;
         if(WorldBossMananer.isMorning)
         {
            _loc2_.hours = this._bossEndTime[0][0];
            _loc2_.minutes = this._bossEndTime[0][1];
            _loc2_.seconds = this._bossEndTime[0][2];
         }
         else
         {
            _loc2_.hours = this._bossEndTime[1][0];
            _loc2_.minutes = this._bossEndTime[1][1];
            _loc2_.seconds = this._bossEndTime[1][2];
         }
         return _loc2_;
      }
      
      public function getLeftTime() : Date
      {
         var _loc1_:Date = TimeUtil.getSeverDateObject();
         var _loc2_:Date = new Date();
         _loc2_.time = _loc1_.time;
         if(WorldBossMananer.isMorning)
         {
            _loc2_.hours = this._bossStartTime[0][0];
            _loc2_.minutes = this._bossStartTime[0][1];
            _loc2_.seconds = this._bossStartTime[0][2];
         }
         else
         {
            _loc2_.hours = this._bossStartTime[1][0];
            _loc2_.minutes = this._bossStartTime[1][1];
            _loc2_.seconds = this._bossStartTime[1][2];
         }
         var _loc3_:Date = new Date();
         var _loc4_:int = _loc2_.time - _loc1_.time;
         if(_loc4_ >= 0)
         {
            _loc3_.time = _loc4_;
            return _loc3_;
         }
         return null;
      }
   }
}

