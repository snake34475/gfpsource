package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.DailyActivityAward;
   import com.gfp.app.info.dialog.DialogInfoSimple;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.app.storyProcess.StoryProcess_1;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.mouse.MouseProcess;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.KeyController;
   import com.gfp.core.controller.MouseController;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.info.DailyActiveAwardInfo;
   import com.gfp.core.info.itemsUpgrade.ItemsLineInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.LoadingType;
   import com.gfp.core.utils.TimeUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import org.taomee.motion.TTween;
   import org.taomee.motion.easing.Expo;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_14 extends MapProcessAnimat
   {
      
      private var _npc10038:SightModel;
      
      private var _npc10053:SightModel;
      
      private var _npc10056:SightModel;
      
      private var _npc10039:SightModel;
      
      private var _npc10054:SightModel;
      
      private var _dirtyPool:MovieClip;
      
      private var _dirtyPoolAnimationCount:int;
      
      private var _wellAnimation:MovieClip;
      
      private var _wellAnimationShowAll:Boolean = false;
      
      private var _secretDoor:MovieClip;
      
      private var _netMC:MovieClip;
      
      private var _fireflyInterval:int = 0;
      
      private var _fireflyArr:Array;
      
      private var _fireflyNum:int = 0;
      
      private const FIREFLY_NEED_NUM:int = 10;
      
      private const MAX_FIREFLY_ARR_LEN:int = 10;
      
      private var _loader:UILoader;
      
      private var _mainMC1327:MovieClip;
      
      private var _stoneLanternMC:MovieClip;
      
      private var _stoneLantern:Sprite;
      
      private var _tollgateMap36:SightModel;
      
      private var _npc10148:SightModel;
      
      public function MapProcess_14()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.initSightModel();
         this.initAnimation();
         this.addTaskListener();
         this.finishTask17FirstStep();
         this.task18NotFinish();
         this.finishTask19SecondStep();
         this.processTask20();
         this.processTask22();
         this.showTollgate9();
         if(StoryProcess_1.instance.validate)
         {
            this.creatPoolListener();
         }
         this.initTask1104();
         this.initForTask1327();
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
      }
      
      private function addTaskListener() : void
      {
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
         TasksManager.addListener(TaskEvent.QUIT,this.onTaskCancel);
      }
      
      private function initForTask1327() : void
      {
         this._stoneLanternMC = MapManager.currentMap.contentLevel["stoneLanternMC"];
         this._stoneLanternMC.stop();
         DisplayUtil.removeForParent(this._stoneLanternMC);
         if(TasksManager.isCompleted(1327))
         {
         }
         if(TasksManager.isProcess(1327,1))
         {
            this.initTask1327_1();
         }
         if(TasksManager.isProcess(1327,0))
         {
            this._npc10148 = SightManager.getSightModel(10148);
            this._npc10148.addEventListener(MouseEvent.CLICK,this.onNPC10148Clicked);
         }
      }
      
      private function onNPC10148Clicked(param1:MouseEvent) : void
      {
         var _loc2_:DialogInfoSimple = new DialogInfoSimple(["叔叔派我来寻找宝藏，我费尽周折，探知，宝藏就在这一块地方。可是，我怎么也找不到藏宝图，只有叔叔给我的一把钥匙。你能帮帮我吗？"],"寻宝？哈哈，有意思。看我的！");
         NpcDialogController.showForSimple(_loc2_,10148,this.getKey);
      }
      
      private function getKey() : void
      {
         this._npc10148.removeEventListener(MouseEvent.CLICK,this.onNPC10148Clicked);
         SocketConnection.addCmdListener(CommandID.DAILY_ACTIVITY,this.onGetAward);
         SocketConnection.send(CommandID.DAILY_ACTIVITY,358);
      }
      
      private function initAnimation() : void
      {
         this._dirtyPool = _mapModel.downLevel["dirtyPool"];
         this.hideDirtyPool();
         this._wellAnimation = _mapModel.contentLevel["wellAnimation"];
         this._wellAnimation.buttonMode = true;
         this._wellAnimation.addEventListener(MouseEvent.CLICK,this.onWellClick);
         this._secretDoor = _mapModel.downLevel["secretDoor"];
         this._secretDoor.addEventListener(MouseEvent.CLICK,this.onDoorClick);
      }
      
      private function frameFunction() : void
      {
         this._wellAnimation.gotoAndPlay(1);
      }
      
      private function onWellClick(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = ItemManager.getItemCount(1400010) == 1;
         var _loc3_:Boolean = ItemManager.getItemCount(1400009) == 1;
         if(this._wellAnimationShowAll && !_loc2_ && !_loc3_)
         {
            this._wellAnimation.addFrameScript(77,null);
            this._wellAnimation.addEventListener(Event.ENTER_FRAME,this.onWellPlay);
         }
         else if(Boolean(TasksManager.isAccepted(22)) && !_loc2_)
         {
            this._wellAnimation.addFrameScript(77,null);
            this._wellAnimation.addEventListener(Event.ENTER_FRAME,this.onWellPlayKey);
         }
         else if(TasksManager.isAccepted(1104))
         {
            this._wellAnimation.addFrameScript(77,this.frameFunction);
            this._wellAnimation.addEventListener(Event.ENTER_FRAME,this.onWellEnter);
         }
         else
         {
            this._wellAnimation.addFrameScript(77,this.frameFunction);
         }
         this._wellAnimation.play();
      }
      
      private function onWellPlay(param1:Event) : void
      {
         if(this._wellAnimation.currentFrame == this._wellAnimation.totalFrames)
         {
            if(ItemManager.getItemAvailableCapacity() < 2)
            {
               AlertManager.showSimpleAlarm(AppLanguageDefine.BACKPACK_LESSTHAN);
               return;
            }
            if(ItemManager.getItemCount(1400009) == 0)
            {
               ItemManager.buyItem(1400009,false,1);
            }
            if(ItemManager.getItemCount(1400010) == 0)
            {
               ItemManager.buyItem(1400010,false,1);
            }
            this._wellAnimation.removeEventListener(Event.ENTER_FRAME,this.onWellPlay);
         }
      }
      
      private function onWellPlayKey(param1:Event) : void
      {
         if(this._wellAnimation.currentFrame == this._wellAnimation.totalFrames)
         {
            if(ItemManager.getItemAvailableCapacity() < 1)
            {
               AlertManager.showSimpleAlarm(AppLanguageDefine.BACKPACK_LESSTHAN);
               return;
            }
            if(ItemManager.getItemCount(1400010) == 0)
            {
               ItemManager.buyItem(1400010,false,1);
            }
            this._wellAnimation.removeEventListener(Event.ENTER_FRAME,this.onWellPlayKey);
         }
      }
      
      private function onDoorClick(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = ItemManager.getItemCount(1400010) >= 1;
         var _loc3_:Boolean = ItemManager.getItemCount(1500086) >= 3;
         if(_loc2_ && _loc3_)
         {
            this._secretDoor.addEventListener(Event.ENTER_FRAME,this.onDoorPlay);
            this._secretDoor.gotoAndPlay(51);
         }
      }
      
      private function onDoorPlay(param1:Event) : void
      {
         if(this._secretDoor.currentFrame == this._secretDoor.totalFrames)
         {
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_MAPCOLLECT,"secretDoor");
            NpcDialogController.showForNpc(10037);
            this._secretDoor.removeEventListener(Event.ENTER_FRAME,this.onDoorPlay);
         }
      }
      
      private function initSightModel() : void
      {
         this._npc10038 = SightManager.getSightModel(10038);
         this._npc10053 = SightManager.getSightModel(10053);
         this._npc10053.hide();
         this._npc10056 = SightManager.getSightModel(10056);
         this._npc10056.hide();
         this._npc10039 = SightManager.getSightModel(10039);
         this._npc10054 = SightManager.getSightModel(10054);
         this._npc10054.hide();
      }
      
      private function finishTask17FirstStep() : void
      {
         if(TasksManager.isTaskProComplete(17,0))
         {
            this._npc10039.hide();
            this._npc10038.hide();
            this._npc10054.show();
            this._npc10053.show();
            this.showDirtyPool();
         }
         if(TasksManager.isTaskProComplete(17,1))
         {
            this._npc10053.hide();
            this._npc10056.show();
            this.showDirtyPool();
         }
      }
      
      private function task18NotFinish() : void
      {
         if(TasksManager.isAccepted(18))
         {
            this._npc10039.hide();
            this._npc10038.hide();
            this._npc10054.show();
            this._npc10056.show();
            this.showDirtyPool();
         }
      }
      
      private function finishTask19SecondStep() : void
      {
         if(TasksManager.isTaskProComplete(19,0))
         {
            this._npc10039.hide();
            this._npc10038.hide();
            this._npc10054.show();
            this._npc10056.show();
            this.showDirtyPool();
         }
         if(TasksManager.isTaskProComplete(19,1))
         {
            this.initDirtyPoolEventListener();
         }
      }
      
      private function processTask20() : void
      {
         if(TasksManager.isAccepted(20))
         {
            this._wellAnimationShowAll = true;
         }
      }
      
      private function processTask22() : void
      {
         if(TasksManager.isTaskProComplete(22,1))
         {
            this._secretDoor.buttonMode = true;
            this._secretDoor.play();
         }
      }
      
      private function initDirtyPoolEventListener() : void
      {
         this._dirtyPool.buttonMode = true;
         this._dirtyPool.useHandCursor = true;
         this._dirtyPool.addEventListener(MouseEvent.CLICK,this.onDirtyPoolClick);
      }
      
      private function onDirtyPoolClick(param1:Event) : void
      {
         this._dirtyPool.gotoAndStop(2);
         this._dirtyPool.buttonMode = false;
         this._dirtyPool.useHandCursor = false;
         this._dirtyPool.removeEventListener(MouseEvent.CLICK,this.onDirtyPoolClick);
         this._dirtyPoolAnimationCount = 0;
         this._dirtyPool.addEventListener(Event.ENTER_FRAME,this.onDirtyPoolPlay);
      }
      
      private function onDirtyPoolPlay(param1:Event) : void
      {
         ++this._dirtyPoolAnimationCount;
         if(this._dirtyPoolAnimationCount >= 160)
         {
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_MAPCOLLECT,"dirtyPool");
            NpcDialogController.showForNpc(10056);
            this._dirtyPool.removeEventListener(Event.ENTER_FRAME,this.onDirtyPoolPlay);
         }
      }
      
      private function showTollgate9() : void
      {
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         var _loc2_:DialogInfoSimple = null;
         if(param1.taskID == 20)
         {
            this._wellAnimationShowAll = true;
         }
         else if(param1.taskID == 1100)
         {
            if(ItemManager.getItemAvailableCapacity() < 1)
            {
               _loc2_ = new DialogInfoSimple([AppLanguageDefine.NPC_DIALOG_MAP14[0]],AppLanguageDefine.NPC_DIALOG_MAP14[1]);
               NpcDialogController.showForSimple(_loc2_,10037);
               TasksManager.quit(1100);
            }
            else
            {
               this.initTask1100();
            }
         }
         else if(param1.taskID == 1327)
         {
            SocketConnection.addCmdListener(CommandID.DAILY_ACTIVITY,this.onGetAward);
            SocketConnection.send(CommandID.DAILY_ACTIVITY,358);
            this.initTask1327_1();
         }
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(TasksManager.isTaskProComplete(17,1))
         {
            this._npc10053.hide();
            this._npc10056.show();
         }
         if(TasksManager.isTaskProComplete(28,2))
         {
            NpcDialogController.showForNpc(10037);
         }
         if(TasksManager.isTaskProComplete(22,1))
         {
            this._secretDoor.buttonMode = true;
            this._secretDoor.play();
         }
      }
      
      private function onExchangeComplete(param1:ExchangeEvent) : void
      {
         var _loc2_:ItemsLineInfo = null;
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
         if(param1.info.addVec.length > 0)
         {
            for each(_loc2_ in param1.info.addVec)
            {
               if(_loc2_.id == "1410180")
               {
                  SummonManager.hatchSummon(1410180);
               }
            }
         }
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 19)
         {
            this.hideDirtyPool();
            if(ActivityExchangeTimesManager.getTimes(5633) == 0)
            {
               ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
               ActivityExchangeCommander.exchange(5633);
            }
         }
         else if(param1.taskID == 20)
         {
            this._wellAnimationShowAll = false;
         }
         else if(param1.taskID == 1327)
         {
            this.loadAnimat1327();
         }
      }
      
      private function initTask1327_1() : void
      {
         this._stoneLantern = MapManager.currentMap.contentLevel["stoneLantern"];
         this._stoneLantern.buttonMode = true;
         this._stoneLantern.addEventListener(MouseEvent.CLICK,this.onStoneLanternClicked);
      }
      
      private function onStoneLanternClicked(param1:MouseEvent) : void
      {
         this._stoneLantern.buttonMode = false;
         this._stoneLantern.removeEventListener(MouseEvent.CLICK,this.onStoneLanternClicked);
         MapManager.currentMap.contentLevel.addChild(this._stoneLanternMC);
         this._stoneLanternMC.addEventListener(Event.ENTER_FRAME,this.onStoneLanternEnterFrame);
         this._stoneLanternMC.gotoAndPlay(1);
         MainManager.closeOperate();
      }
      
      private function onStoneLanternEnterFrame(param1:Event) : void
      {
         if(this._stoneLanternMC.currentFrame == this._stoneLanternMC.totalFrames)
         {
            MainManager.openOperate();
            this._stoneLanternMC.removeEventListener(Event.ENTER_FRAME,this.onStoneLanternEnterFrame);
            this._stoneLanternMC.stop();
            DisplayUtil.removeForParent(this._stoneLanternMC);
            SocketConnection.addCmdListener(CommandID.DAILY_ACTIVITY,this.onGetAward);
            SocketConnection.send(CommandID.DAILY_ACTIVITY,359);
         }
      }
      
      private function onGetAward(param1:SocketEvent) : void
      {
         var _loc2_:DailyActiveAwardInfo = param1.data as DailyActiveAwardInfo;
         var _loc3_:uint = uint(_loc2_.dailyActivityId);
         if(_loc3_ == 358 || _loc3_ == 359)
         {
            SocketConnection.removeCmdListener(CommandID.DAILY_ACTIVITY,this.onGetAward);
            DailyActivityAward.addAward(_loc2_);
         }
      }
      
      private function loadAnimat1327() : void
      {
         this._loader = new UILoader(ClientConfig.getCartoon("task1327"),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         MainManager.closeOperate();
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         var _loc2_:Sprite = param1.uiloader.loader.content as Sprite;
         this._mainMC1327 = _loc2_["mc"];
         this._mainMC1327.x = 233;
         this._mainMC1327.y = 131;
         this._mainMC1327.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         LayerManager.topLevel.addChild(this._mainMC1327);
         this._mainMC1327.gotoAndPlay(1);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this._mainMC1327.currentFrame == this._mainMC1327.totalFrames)
         {
            this._mainMC1327.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            DisplayUtil.removeForParent(this._mainMC1327);
            MainManager.openOperate();
            this.dailog1317_1();
         }
      }
      
      private function dailog1317_1() : void
      {
         var _loc1_:Array = ["太好了，真不愧是小侠士。这下我们就能进入探宝了！根据藏宝图显示：<font color=\"#E59110\">周一至周四的11:00~13:00,19:00~21:00，周五至周日9:00~11:00,14:00~16：00,19：-21:00</font>你会找到珍贵的<font color=\"#E59110\">龙息玉佩</font>，其余时间只能找到古墓的<font color=\"#E59110\">七煞符石</font>。不过，这两样东西我都要。"];
         var _loc2_:String = "看在你给我的奖励份儿上，我可以试试。";
         var _loc3_:DialogInfoSimple = new DialogInfoSimple(_loc1_,_loc2_);
         NpcDialogController.showForSimple(_loc3_,10148,this.dailog1317_2);
      }
      
      private function dailog1317_2() : void
      {
         var _loc1_:Array = ["哦，等等。我这里还有更好的奖励，只要你花上<font color=\"#E59110\">8通宝</font>买上一个<font color=\"#E59110\">纯净之心</font>……"];
         var _loc2_:String = "真不愧是猪谷立的侄子，都是钻进钱眼儿里去的家伙。";
         var _loc3_:DialogInfoSimple = new DialogInfoSimple(_loc1_,_loc2_);
         NpcDialogController.showForSimple(_loc3_,10148);
      }
      
      private function onTaskCancel(param1:TaskEvent) : void
      {
         if(param1.taskID == 1100)
         {
            this.clearNetMC();
         }
      }
      
      private function hideDirtyPool() : void
      {
         this._dirtyPool.gotoAndStop(3);
      }
      
      private function showDirtyPool() : void
      {
         this._dirtyPool.gotoAndStop(1);
         this._dirtyPool.visible = true;
      }
      
      private function creatPoolListener() : void
      {
         this._dirtyPool.buttonMode = true;
         this._dirtyPool.useHandCursor = true;
         this._dirtyPool.addEventListener(MouseEvent.CLICK,this.onPoolClickForGame);
      }
      
      private function checkhasReward() : Boolean
      {
         var _loc1_:uint = uint(TimeUtil.getSeverWeekIndex());
         var _loc2_:uint = uint(TimeUtil.getSeverDateObject().getHours());
         if(_loc1_ == 6 || _loc1_ == 0)
         {
            if(_loc2_ >= 14 && _loc2_ < 16)
            {
               return true;
            }
            this.showTimeLimitAlarm();
            return false;
         }
         if(_loc2_ == 12 || _loc2_ == 19)
         {
            return true;
         }
         this.showTimeLimitAlarm();
         return false;
      }
      
      private function showTimeLimitAlarm() : void
      {
         AlertManager.showSimpleAlarm(AppLanguageDefine.NPC_DIALOG_MAP14[2]);
      }
      
      private function onPoolClickForGame(param1:Event) : void
      {
         if(this.checkhasReward())
         {
            if(ItemManager.getItemCount(1500331) > 0 || ItemManager.getItemCount(1700060) > 0)
            {
               ModuleManager.turnModule(ClientConfig.getGameModule("IceWaterQET"),AppLanguageDefine.LOAD_MATTER_COLLECTION[5]);
            }
            else
            {
               AlertManager.showSimpleAlarm(AppLanguageDefine.NPC_DIALOG_MAP14[3]);
            }
         }
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         this.initTask1100();
      }
      
      private function initTask1100() : void
      {
         var _loc1_:DialogInfoSimple = null;
         if(Boolean(TasksManager.isAccepted(1100)) && ItemManager.getItemCount(1400015) == 0 && ItemManager.getItemAvailableCapacity() == 0)
         {
            _loc1_ = new DialogInfoSimple([AppLanguageDefine.NPC_DIALOG_MAP14[0]],AppLanguageDefine.NPC_DIALOG_MAP14[1]);
            NpcDialogController.showForSimple(_loc1_,10037);
            return;
         }
         if(Boolean(TasksManager.isAccepted(1100)) && ItemManager.getItemCount(1400015) < this.FIREFLY_NEED_NUM)
         {
            MouseController.instance.clear();
            KeyController.instance.clear();
            _mapModel.contentLevel.mouseChildren = false;
            MouseProcess.execWalk(MainManager.actorModel,new Point(1350,250),true);
            this._netMC = _mapModel.libManager.getMovieClip("NetMC");
            LayerManager.topLevel.addChild(this._netMC);
            this._netMC.addEventListener(Event.ENTER_FRAME,this.onNetEnterFrame);
            LayerManager.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onNetClick);
            Mouse.hide();
            this._fireflyArr = new Array();
         }
      }
      
      private function onNetEnterFrame(param1:Event) : void
      {
         this._netMC.x = LayerManager.topLevel.mouseX;
         this._netMC.y = LayerManager.topLevel.mouseY;
         if(this._fireflyInterval <= 0)
         {
            this.createFirefly();
            this._fireflyInterval = 50 + Math.random() * 100;
         }
         else
         {
            --this._fireflyInterval;
         }
      }
      
      private function createFirefly() : void
      {
         var _loc1_:MovieClip = _mapModel.libManager.getMovieClip("FireflyMC");
         _loc1_.x = 1100 + Math.random() * 300;
         _loc1_.y = -200;
         _mapModel.upLevel.addChild(_loc1_);
         this._fireflyArr.push(_loc1_);
         if(this._fireflyArr.length > this.MAX_FIREFLY_ARR_LEN)
         {
            DisplayUtil.removeForParent(this._fireflyArr.shift());
         }
      }
      
      private function onNetClick(param1:MouseEvent) : void
      {
         if(this._netMC)
         {
            this._netMC.play();
            this.catchFirefly();
         }
      }
      
      private function catchFirefly() : void
      {
         var _loc1_:int = int(this._fireflyArr.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(this._netMC.hitTestObject(this._fireflyArr[_loc2_]))
            {
               _mapModel.upLevel.removeChild(this._fireflyArr[_loc2_]);
               ++this._fireflyNum;
               this.playEffect();
               break;
            }
            _loc2_++;
         }
         this.checkFireflyNum();
      }
      
      private function checkFireflyNum() : void
      {
         if(this._fireflyNum >= this.FIREFLY_NEED_NUM)
         {
            this.clearNetMC();
            ItemManager.buyItem(1400015,false,this.FIREFLY_NEED_NUM);
         }
      }
      
      private function playEffect() : void
      {
         var _loc1_:MovieClip = _mapModel.libManager.getMovieClip("FireflyEffectMC");
         _loc1_.x = LayerManager.toolsLevel.mouseX;
         _loc1_.y = LayerManager.toolsLevel.mouseY;
         LayerManager.toolsLevel.addChild(_loc1_);
         var _loc2_:TTween = new TTween(_loc1_);
         _loc2_.init({
            "x":670,
            "y":530
         },{
            "x":Expo.easeIn,
            "y":Expo.easeIn
         },1000);
         _loc2_.start();
      }
      
      private function clearNetMC() : void
      {
         if(this._netMC)
         {
            DisplayUtil.removeForParent(this._netMC);
            this._netMC.removeEventListener(Event.ENTER_FRAME,this.onNetEnterFrame);
            LayerManager.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onNetClick);
            Mouse.show();
            MouseController.instance.init();
            KeyController.instance.init();
            _mapModel.contentLevel.mouseChildren = true;
            this._netMC = null;
         }
      }
      
      private function initTask1104() : void
      {
         var _loc1_:int = 0;
         if(TasksManager.isAccepted(1104))
         {
            _loc1_ = 0;
            while(_loc1_ < 3)
            {
               if(!TasksManager.isTaskProComplete(1104,_loc1_))
               {
                  return;
               }
               this.addFullBarrel(_loc1_);
               _loc1_++;
            }
         }
      }
      
      private function onWellEnter(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(this._wellAnimation.currentFrame == 77)
         {
            this._wellAnimation.removeEventListener(Event.ENTER_FRAME,this.onWellEnter);
            _loc2_ = 0;
            while(_loc2_ < 3)
            {
               if(!TasksManager.isTaskProComplete(1104,_loc2_))
               {
                  this.addFullBarrel(_loc2_,true);
                  TasksManager.dispatchActionEvent(TaskActionEvent.TASK_MAPCOLLECT,"barrel_" + _loc2_);
                  return;
               }
               _loc2_++;
            }
         }
      }
      
      private function addFullBarrel(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:MovieClip = _mapModel.libManager.getMovieClip("Full_barrel");
         _loc3_.x = 1392 + param1 * 60;
         _loc3_.y = 617;
         var _loc4_:int = param2 ? 2 : _loc3_.totalFrames;
         _loc3_.gotoAndPlay(_loc4_);
         _mapModel.contentLevel.addChild(_loc3_);
      }
      
      override public function destroy() : void
      {
         if(this._npc10148)
         {
            this._npc10148.removeEventListener(MouseEvent.CLICK,this.onNPC10148Clicked);
            this._npc10148 = null;
         }
         this._stoneLanternMC = null;
         if(this._stoneLantern)
         {
            this._stoneLantern.removeEventListener(MouseEvent.CLICK,this.onStoneLanternClicked);
            this._stoneLantern = null;
         }
         this._mainMC1327 = null;
         if(this._loader)
         {
            this._loader.destroy();
            this._loader = null;
         }
         SocketConnection.removeCmdListener(CommandID.DAILY_ACTIVITY,this.onGetAward);
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         this.removeTaskListener();
         this._dirtyPool.removeEventListener(Event.ENTER_FRAME,this.onDirtyPoolPlay);
         this._wellAnimation.removeEventListener(MouseEvent.CLICK,this.onWellClick);
         this._wellAnimation.removeEventListener(Event.ENTER_FRAME,this.onWellPlay);
         this._secretDoor.removeEventListener(MouseEvent.CLICK,this.onDoorClick);
         this._secretDoor.removeEventListener(Event.ENTER_FRAME,this.onDoorPlay);
         this.clearNetMC();
         super.destroy();
      }
      
      private function removeTaskListener() : void
      {
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
         TasksManager.removeListener(TaskEvent.QUIT,this.onTaskCancel);
      }
   }
}

