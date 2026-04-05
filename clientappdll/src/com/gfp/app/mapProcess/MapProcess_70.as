package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightAdded;
   import com.gfp.app.info.dialog.DialogInfoMultiple;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.app.toolBar.CityToolBar;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.FocusKeyController;
   import com.gfp.core.controller.KeyController;
   import com.gfp.core.controller.MouseController;
   import com.gfp.core.controller.ToolBarQuickKey;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.dailyActivity.ActivityExchangeAward;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.MagicChangeManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.TimeIntervalManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.SummonModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Direction;
   import com.gfp.core.utils.LineType;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_70 extends BaseMapProcess
   {
      
      private var _heroMeetMC:MovieClip;
      
      private var npc:SightModel;
      
      private var _notice:SimpleButton;
      
      private var _startMillSeconds:int;
      
      private var _startLeftCount:int;
      
      private var _timer:int;
      
      private var _swapIDs:Array;
      
      private var _washCount:int;
      
      private var originalPosition:Point;
      
      private var _willStart:Boolean;
      
      private var _areaBitmapDatas:Vector.<BitmapData>;
      
      private var _area:int;
      
      private var isWashing:Boolean;
      
      private var _rewards:HashMap;
      
      private var _timeMC:Sprite;
      
      private var _timeMC2:Sprite;
      
      public function MapProcess_70()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this.initHeroMC();
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            _mapModel.upLevel["area" + _loc1_].visible = false;
            _loc1_++;
         }
         this.npc = SightManager.getSightModel(10586);
         this.npc.addEventListener(MouseEvent.CLICK,this.onNpcClick,false,int.MAX_VALUE);
         MainManager.actorModel.addEventListener(MoveEvent.MOVE_END,this.onPlayerMoveEnd,false,int.MAX_VALUE);
         UserManager.addEventListener(UserEvent.BORN,this.onUserChange);
         UserManager.addEventListener(UserEvent.ROLE_VIEW_CHANGE,this.onUserChange);
         UserManager.addEventListener(UserEvent.ROLE_VIEW_CHANGE_OVER,this.onUserChange);
         this._timeMC2 = _mapModel.libManager.getSprite("TimerCutDown");
         _mapModel.upLevel.addChild(this._timeMC2);
         this._timeMC2.x = this.npc.x;
         this._timeMC2.y = this.npc.y - 150;
         var _loc2_:int = this.getLeftSwapCount() * 20;
         var _loc3_:int = int(uint(_loc2_ / 60));
         var _loc4_:int = _loc2_ % 60;
         this._timeMC2["timeMC0"].gotoAndStop(int(_loc3_ * 0.1) + 1);
         this._timeMC2["timeMC1"].gotoAndStop(_loc3_ % 10 + 1);
         this._timeMC2["timeMC2"].gotoAndStop(int(_loc4_ * 0.1) + 1);
         this._timeMC2["timeMC3"].gotoAndStop(_loc4_ % 10 + 1);
         ClientTempState.washGoldShovelType = 0;
         if(ActivityExchangeTimesManager.getTimes(10912) > 0)
         {
            ClientTempState.washGoldShovelType = 1;
         }
         if(ActivityExchangeTimesManager.getTimes(10913) > 0)
         {
            ClientTempState.washGoldShovelType = 2;
         }
         this._notice = _mapModel.contentLevel["notice"];
         this._notice.addEventListener(MouseEvent.CLICK,this.onNoticeBtnClick);
      }
      
      private function onUserChange(param1:UserEvent) : void
      {
         var _loc3_:UserInfo = null;
         var _loc4_:SummonModel = null;
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_)
         {
            _loc3_ = _loc2_.info;
            _loc4_ = SummonManager.getUserSummonModel(_loc3_.userID);
            if(_loc3_.monsterID == 10807)
            {
               if(_loc4_)
               {
                  _loc4_.hide();
               }
            }
            else if(_loc4_)
            {
               _loc4_.show();
            }
         }
      }
      
      private function onPlayerMoveEnd(param1:MoveEvent) : void
      {
         this.showTargetNpcDialog();
      }
      
      private function showTargetNpcDialog() : void
      {
         var _loc2_:Point = null;
         if(MapManager.mapInfo == null)
         {
            return;
         }
         if(MainManager.targetNpcId <= 0)
         {
            return;
         }
         if(MapManager.mapInfo.mapType != MapType.STAND)
         {
            return;
         }
         var _loc1_:SightModel = SightManager.getSightModel(MainManager.targetNpcId);
         if(_loc1_ != null)
         {
            _loc2_ = _loc1_.pos;
            if(Point.distance(MainManager.actorModel.pos,_loc2_) < 100)
            {
               if(MapManager.mapInfo.mapType == MapType.STAND)
               {
                  this.showStartDialog();
               }
            }
         }
      }
      
      private function showStartDialog() : void
      {
         var dialogs:String;
         var simpleDialog:DialogInfoMultiple;
         var leftSeconds:int = this.getLeftSwapCount() * 20;
         leftSeconds < 0 && (leftSeconds = 0);
         dialogs = "我在这片区域开拓了一块淘金区，里面埋藏了各种宝藏，只要租用我的铲子，小侠士就可以享受淘金的乐趣啦！ ";
         simpleDialog = new DialogInfoMultiple([dialogs],["马上租用","我已经有铲子啦 ，马上淘金"]);
         NpcDialogController.showForMultiple(simpleDialog,10586,function():void
         {
            ModuleManager.turnAppModule("WashGoldBuyShovelPanel");
         },function():void
         {
            if(ClientTempState.washGoldShovelType == 0)
            {
               AlertManager.showSimpleAlarm("小侠士，请先租用铲子！");
            }
            else
            {
               ModuleManager.turnAppModule("WashGoldSelectAreaPanel");
            }
         });
      }
      
      private function initHeroMC() : void
      {
         this._heroMeetMC = MapManager.currentMap.libManager.getMovieClip("statueMC");
         if(ClientConfig.clientType <= 1)
         {
            _mapModel.contentLevel.addChild(this._heroMeetMC);
            this._heroMeetMC.x = 1259;
            this._heroMeetMC.y = 667;
            switch(MainManager.loginInfo.lineType)
            {
               case LineType.LINE_TYPE_CT:
                  this._heroMeetMC.gotoAndStop(1);
                  break;
               case LineType.LINE_TYPE_CNC:
                  this._heroMeetMC.gotoAndStop(2);
                  break;
               default:
                  this._heroMeetMC.gotoAndStop(1);
            }
         }
      }
      
      override public function destroy() : void
      {
         UserManager.removeEventListener(UserEvent.BORN,this.onUserChange);
         UserManager.removeEventListener(UserEvent.ROLE_VIEW_CHANGE,this.onUserChange);
         UserManager.removeEventListener(UserEvent.ROLE_VIEW_CHANGE_OVER,this.onUserChange);
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE_END,this.onPlayerMoveEnd);
         this.npc.removeEventListener(MouseEvent.CLICK,this.onNpcClick);
         this.npc = null;
         this.doStopWash();
         this._notice.removeEventListener(MouseEvent.CLICK,this.onNoticeBtnClick);
         if(this._heroMeetMC)
         {
            DisplayUtil.removeForParent(this._heroMeetMC);
         }
         super.destroy();
      }
      
      private function onNoticeBtnClick(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("TeamFight3v3CityPanel");
      }
      
      private function onNpcClick(param1:Event) : void
      {
         var dialogs:String = null;
         var simpleDialog:DialogInfoMultiple = null;
         var e:Event = param1;
         if(this.isWashing)
         {
            dialogs = "小侠士，你确定要结束淘金么？ ";
            simpleDialog = new DialogInfoMultiple([dialogs],["嗯"]);
            NpcDialogController.showForMultiple(simpleDialog,10586,function():void
            {
               stopWash();
            });
            e.stopImmediatePropagation();
         }
         else
         {
            this.showStartDialog();
         }
      }
      
      public function startWash() : void
      {
         var _loc2_:BitmapData = null;
         if(MagicChangeManager.instance.getCurrentInfo())
         {
            TextAlert.show("正在变身中，不能进行该操作！",16711680);
            return;
         }
         this._area = int(Math.random() * 3);
         if(this.getLeftSwapCount() <= 0)
         {
            AlertManager.showSimpleAlarm("今日已到淘金上限，明天再来吧！");
         }
         else
         {
            this.originalPosition = new Point();
            this._swapIDs = ClientTempState.washGoldShovelType == 1 ? [10907,10908] : [10909,10910,10911];
            ActivityExchangeCommander.exchange(10914,10807);
            this._willStart = true;
            ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
         }
         this._areaBitmapDatas = new Vector.<BitmapData>();
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = new BitmapData(_mapModel.upLevel["area" + _loc1_].width,_mapModel.upLevel["area" + _loc1_].height,false,0);
            _loc2_.draw(_mapModel.upLevel["area" + _loc1_]);
            this._areaBitmapDatas[_loc1_] = _loc2_;
            _loc1_++;
         }
      }
      
      private function doStart() : void
      {
         ActivityExchangeAward.isTowerRush = true;
         MouseController.instance.clear();
         KeyController.instance.clear();
         FocusKeyController.instance.clear();
         ToolBarQuickKey.unsetup();
         FightAdded.hideToolbar();
         CityToolBar.instance.hide();
         DynamicActivityEntry.instance.hide();
         MainManager.addEventListener(Event.OPEN,this.onOpenOperateHandle);
         this._washCount = 0;
         this.originalPosition.x = MainManager.actorModel.x;
         this.originalPosition.y = MainManager.actorModel.y;
         var _loc1_:Point = this.getLegalPoint();
         MainManager.actorModel.x = _loc1_.x;
         MainManager.actorModel.y = _loc1_.y;
         this.synUserPosition(_loc1_);
         this._timeMC = _mapModel.libManager.getSprite("TimerCutDown");
         _mapModel.upLevel.addChild(this._timeMC);
         this._timeMC.x = _loc1_.x;
         this._timeMC.y = _loc1_.y - 145;
         this._timer = setInterval(this.onTimer,1000);
         this._startMillSeconds = getTimer();
         this._startLeftCount = this.getLeftSwapCount();
         this.onTimer();
         _mapModel.groundLevel.addEventListener(MouseEvent.CLICK,this.onGroundClickHandle);
         _mapModel.camera.upDateForTotalAreaPoint(_loc1_);
         this._rewards = new HashMap();
         this.isWashing = true;
         MainManager.setOperateDisable(true);
         FunctionManager.evtDispatch.addEventListener(FunctionManager.FUNCTION_DISABLED,this.functionDisabledHandler);
      }
      
      private function functionDisabledHandler(param1:Event) : void
      {
         AlertManager.showSimpleAlarm("小侠士，你正在淘金，不能进行该操作。");
      }
      
      private function onGroundClickHandle(param1:MouseEvent) : void
      {
         AlertManager.showSimpleAlert("小侠士，是否要终止淘金？",this.stopWash);
      }
      
      private function synUserPosition(param1:Point) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUnsignedInt(param1.x);
         _loc2_.writeUnsignedInt(param1.y);
         _loc2_.writeUnsignedInt(param1.x);
         _loc2_.writeUnsignedInt(param1.y);
         _loc2_.writeByte(Direction.strToIndex2(MainManager.actorModel.direction));
         _loc2_.writeUnsignedInt(TimeIntervalManager.calculateServer());
         _loc2_.writeUnsignedInt(TimeIntervalManager.calculateServerMillisecond());
         SocketConnection.send(CommandID.STAND,_loc2_);
         MainManager.actorInfo.lastWalkPoint = param1;
      }
      
      private function getLegalPoint() : Point
      {
         var _loc1_:Point = new Point();
         do
         {
            _loc1_.x = _mapModel.upLevel["area" + this._area].width * Math.random();
            _loc1_.y = _mapModel.upLevel["area" + this._area].height * Math.random();
         }
         while(this._areaBitmapDatas[this._area].getPixel32(_loc1_.x,_loc1_.y) == 0);
         _loc1_.x += _mapModel.upLevel["area" + this._area].x;
         _loc1_.y += _mapModel.upLevel["area" + this._area].y;
         return _loc1_;
      }
      
      private function onOpenOperateHandle(param1:Event) : void
      {
         MouseController.instance.clear();
         KeyController.instance.clear();
         FocusKeyController.instance.clear();
         ToolBarQuickKey.unsetup();
      }
      
      private function stopWash() : void
      {
         ActivityExchangeCommander.exchange(10914,0);
         this._willStart = false;
      }
      
      private function doStopWash() : void
      {
         ActivityExchangeAward.isTowerRush = false;
         if(ActivityExchangeTimesManager.getTimes(12539) == 0)
         {
            ActivityExchangeCommander.exchange(12539);
         }
         MainManager.removeEventListener(Event.OPEN,this.onOpenOperateHandle);
         MainManager.openOperate();
         FightAdded.showToolbar();
         CityToolBar.instance.show();
         DynamicActivityEntry.instance.show();
         if(this.isWashing && Boolean(this.originalPosition))
         {
            MainManager.actorModel.x = this.originalPosition.x;
            MainManager.actorModel.y = this.originalPosition.y;
            this.synUserPosition(this.originalPosition);
         }
         clearInterval(this._timer);
         _mapModel.groundLevel.removeEventListener(MouseEvent.CLICK,this.onGroundClickHandle);
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
         if(Boolean(this._rewards) && this._rewards.length > 0)
         {
            ModuleManager.turnAppModule("WashGoldResultPanel","正在加载..",this._rewards);
            this._rewards = null;
         }
         if(this._timeMC)
         {
            DisplayUtil.removeForParent(this._timeMC);
            this._timeMC = null;
         }
         MainManager.setOperateDisable(false);
         FunctionManager.evtDispatch.removeEventListener(FunctionManager.FUNCTION_DISABLED,this.functionDisabledHandler);
         this.isWashing = false;
      }
      
      private function onTimer() : void
      {
         if(int((getTimer() - this._startMillSeconds) / 20000) > this._washCount)
         {
            ActivityExchangeCommander.exchange(this._swapIDs[int(this._swapIDs.length * Math.random())]);
         }
         var _loc1_:int = this._startLeftCount * 20 - (getTimer() - this._startMillSeconds) * 0.001;
         if(_loc1_ <= 0)
         {
            _loc1_ = 0;
            ActivityExchangeCommander.exchange(11386);
         }
         var _loc2_:int = int(uint(_loc1_ / 60));
         var _loc3_:int = _loc1_ % 60;
         this._timeMC["timeMC0"].gotoAndStop(int(_loc2_ * 0.1) + 1);
         this._timeMC["timeMC1"].gotoAndStop(_loc2_ % 10 + 1);
         this._timeMC["timeMC2"].gotoAndStop(int(_loc3_ * 0.1) + 1);
         this._timeMC["timeMC3"].gotoAndStop(_loc3_ % 10 + 1);
         this._timeMC2["timeMC0"].gotoAndStop(int(_loc2_ * 0.1) + 1);
         this._timeMC2["timeMC1"].gotoAndStop(_loc2_ % 10 + 1);
         this._timeMC2["timeMC2"].gotoAndStop(int(_loc3_ * 0.1) + 1);
         this._timeMC2["timeMC3"].gotoAndStop(_loc3_ % 10 + 1);
      }
      
      private function onExchangeComplete(param1:ExchangeEvent) : void
      {
         var _loc2_:int = 0;
         if(this._swapIDs.indexOf(param1.info.id) != -1)
         {
            ++this._washCount;
            if(this.getLeftSwapCount() <= 0)
            {
               this.stopWash();
            }
            if(param1.info.addVec.length > 0)
            {
               _loc2_ = int(this._rewards.getValue(param1.info.addVec[0].id)) + param1.info.addVec[0].count;
               this._rewards.add(param1.info.addVec[0].id,_loc2_);
            }
         }
         else if(param1.info.id == 10914)
         {
            if(this._willStart)
            {
               this.doStart();
            }
            else
            {
               this.doStopWash();
            }
         }
      }
      
      private function getLeftSwapCount() : int
      {
         var _loc1_:int = 15 * 60 / 20;
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            _loc1_ -= ActivityExchangeTimesManager.getTimes(10907 + _loc2_);
            _loc2_++;
         }
         return _loc1_;
      }
   }
}

