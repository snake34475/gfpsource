package com.gfp.app
{
   import com.gfp.app.cmdl.ChatCmdListener;
   import com.gfp.app.cmdl.InformCmdListener;
   import com.gfp.app.cmdl.SystemMessageCmdListener;
   import com.gfp.app.config.xml.LvInformXMLInfo;
   import com.gfp.app.config.xml.TransfigurationXMLInfo;
   import com.gfp.app.control.PuzzleControl;
   import com.gfp.app.control.TimeNpcController;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.fightpower.FightPowerChangShow;
   import com.gfp.app.manager.AccountSafeManager;
   import com.gfp.app.manager.CatchBigGhostManager;
   import com.gfp.app.manager.CatchSummonManager;
   import com.gfp.app.manager.DaZhuoWhenLeft5MinManager;
   import com.gfp.app.manager.DailyTaskManager;
   import com.gfp.app.manager.DirtyWordManager;
   import com.gfp.app.manager.DpsManager;
   import com.gfp.app.manager.ErrorCodeManager;
   import com.gfp.app.manager.EveryDayLuckManager;
   import com.gfp.app.manager.FightGroupManager;
   import com.gfp.app.manager.FourYearGiveTbTimeManager;
   import com.gfp.app.manager.InviteManager;
   import com.gfp.app.manager.MysteryClipManager;
   import com.gfp.app.manager.OfflineExpManager;
   import com.gfp.app.manager.OldBackManager;
   import com.gfp.app.manager.PvpKillPointManager;
   import com.gfp.app.manager.PvpManager;
   import com.gfp.app.manager.ShareObjectManager;
   import com.gfp.app.manager.TeamCityWarManager;
   import com.gfp.app.manager.TeamTaskManager;
   import com.gfp.app.manager.UserLevelUpActionManager;
   import com.gfp.app.manager.WanShenDianManager;
   import com.gfp.app.plugins.PluginManager;
   import com.gfp.app.systems.BenderLoader;
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.app.systems.DefEquipLoader;
   import com.gfp.app.systems.WallowRemindChild;
   import com.gfp.app.toolBar.ActivityPromptEntry;
   import com.gfp.app.toolBar.AmbassadorEntry;
   import com.gfp.app.toolBar.Battery;
   import com.gfp.app.toolBar.CityQuickBar;
   import com.gfp.app.toolBar.CityToolBar;
   import com.gfp.app.toolBar.CommunityTipsEntry;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.app.toolBar.EverydaySignEntry;
   import com.gfp.app.toolBar.GroupHeadInfoEntry;
   import com.gfp.app.toolBar.HeadSelfPanel;
   import com.gfp.app.toolBar.HonorPanelEntry;
   import com.gfp.app.toolBar.HornPanel;
   import com.gfp.app.toolBar.MailSysEntry;
   import com.gfp.app.toolBar.MallEntry;
   import com.gfp.app.toolBar.MapInfoShow;
   import com.gfp.app.toolBar.RedBlueMasterEntry;
   import com.gfp.app.toolBar.RookieTaskPrizePanel;
   import com.gfp.app.toolBar.TaskTrackPanel;
   import com.gfp.app.toolBar.TootalExpBar;
   import com.gfp.app.toolBar.TurnBackTaskIco;
   import com.gfp.app.toolBar.VipNewEntry;
   import com.gfp.app.toolBar.WuLinFightEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.Constant;
   import com.gfp.core.behavior.ClothBehavior;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.config.xml.SkillXMLInfo;
   import com.gfp.core.controller.KeyController;
   import com.gfp.core.controller.LoginSOController;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.GfpEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.info.MapInfo;
   import com.gfp.core.info.SysMsgInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.dailyActivity.SwapTimesInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.info.subCareer.SubCareerInfo;
   import com.gfp.core.info.subCareer.SubCareerType;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.Bridge;
   import com.gfp.core.manager.ConfigLoaderManager;
   import com.gfp.core.manager.DeffEquiptManager;
   import com.gfp.core.manager.EquipDurabilityAlertManager;
   import com.gfp.core.manager.ErrorReportManager;
   import com.gfp.core.manager.GodGuardManager;
   import com.gfp.core.manager.GodManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.LoadingManager;
   import com.gfp.core.manager.MagicChangeManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MasterManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.OnHookManager;
   import com.gfp.core.manager.PayPasswordManager;
   import com.gfp.core.manager.RelationManager;
   import com.gfp.core.manager.SOManager;
   import com.gfp.core.manager.ServerBuffManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.SummonShenTongManager;
   import com.gfp.core.manager.SystemMessageManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.TeamsRelationManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.manager.VipAwardManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.AppModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.sound.SoundManager;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.ILoading;
   import com.gfp.core.ui.loading.LoadingType;
   import com.gfp.core.utils.ByteArrayUtil;
   import com.gfp.core.utils.ChatUtil;
   import com.gfp.core.utils.ClientType;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.OtherInfoHelper;
   import com.gfp.core.utils.StatisticsType;
   import com.gfp.core.utils.StrengthenNumUtil;
   import com.gfp.core.utils.TimeUtil;
   import com.taomee.analytics.Analytics;
   import com.taomee.analytics.type.ErrorTypes;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.SecurityErrorEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import org.taomee.algo.AStar;
   import org.taomee.bean.BeanEvent;
   import org.taomee.bean.BeanManager;
   import org.taomee.cache.QueueLoader;
   import org.taomee.component.manager.MComponentManager;
   import org.taomee.manager.PopUpManager;
   import org.taomee.manager.TaomeeManager;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.net.SocketEvent;
   import org.taomee.stat.StatisticsManager;
   import org.taomee.utils.Tick;
   
   public class MainEntry
   {
      
      private static var _isConnectProxy:Boolean;
      
      private static var _socketTimeOutId:int;
      
      public static const SOCKET_TIMEOUT_NUM:int = 3000;
      
      private var _timer:uint;
      
      private var _loadingView:ILoading;
      
      private var bender:BenderLoader;
      
      private var lt:uint;
      
      private var _isShowNext:Boolean = false;
      
      private const NAME_UI:String = "ui";
      
      private const NAME_ICON:String = "taskIcon";
      
      private var _loader:UILoader;
      
      private var _equipLoader:DefEquipLoader;
      
      private var allBeanIsComplete:Boolean;
      
      private var _sendInterGameSucc:Boolean = false;
      
      private var _setSecQuesSwapId:int = 4948;
      
      private var _isOffLine:Boolean;
      
      private var _offLineData:Object;
      
      private var isMainUserInfoIsComplete:Boolean;
      
      private var _helpURL:String = "http://www.61.com/news/clear_cache.html";
      
      public function MainEntry()
      {
         super();
      }
      
      public function setup(param1:Sprite) : void
      {
         Tick.timeRate = MainManager.timeRate;
         LayerManager.setup(param1);
         MComponentManager.setup(param1,14);
         TaomeeManager.setup(param1,param1.stage);
         TaomeeManager.stageSize(LayerManager.stageWidth,LayerManager.stageHeight);
         ErrorReportManager.setup(param1.stage);
         this.setStageQuality();
         this._loadingView = LoadingManager.getLoading(LoadingType.TITLE_AND_PERCENT,LayerManager.topLevel,"正在加载配表..");
         this._loadingView.show();
         this._loadingView.setPercent(0,100);
         ConfigLoaderManager.instance.addEventListener(Event.COMPLETE,this.onConfigLoaded);
         ConfigLoaderManager.instance.setup();
         FightPowerChangShow.getInstance().setup();
      }
      
      protected function onConfigLoaded(param1:Event) : void
      {
         this._loadingView.title = "连接服务器";
         this._loadingView.setPercent(30,100);
         MainManager.actorID = MainManager.loginInfo.userID;
         MainManager.actorPass = MainManager.loginInfo.pwd;
         ClassRegister.setup();
         RelationManager.init(MainManager.loginInfo.friendList,MainManager.loginInfo.blackList);
         this.bender = new BenderLoader();
         this.bender.addEventListener(Event.COMPLETE,this.onBenderComplete);
         this.bender.load();
         Bridge.TransfigurationXMLInfo = TransfigurationXMLInfo;
         ConfigLoaderManager.instance.removeEventListener(Event.COMPLETE,this.onConfigLoaded);
         ItemXMLInfo.setup(null);
      }
      
      private function onBenderComplete(param1:Event) : void
      {
         SocketConnection.fuckNum.value = this.bender.fuckNum;
         SocketConnection.shitNum.value = this.bender.shitNum;
         new ChatCmdListener().start();
         new InformCmdListener().start();
         new SystemMessageCmdListener().start();
         SocketConnection.mainSocket.userId = MainManager.loginInfo.userID;
         SocketConnection.mainSocket.addEventListener(Event.CONNECT,this.onConnect);
         SocketConnection.mainSocket.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         try
         {
            SocketConnection.mainSocket.connect(MainManager.loginInfo.ip,MainManager.loginInfo.port);
         }
         catch(e:SecurityError)
         {
         }
         LoginSOController.isSave = MainManager.loginInfo.isSave;
         StatisticsManager.sendHttpStat("登陆加载","初始化成功");
      }
      
      private function onIOError(param1:IOErrorEvent) : void
      {
         this.onSocketSecurity(null);
      }
      
      private function onSocketSecurity(param1:SecurityErrorEvent) : void
      {
         if(_isConnectProxy)
         {
            return;
         }
         _isConnectProxy = true;
         clearTimeout(_socketTimeOutId);
         SocketConnection.mainSocket.addEventListener(Event.CONNECT,this.onConnect);
         SocketConnection.mainSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSocketSecurity);
         SocketConnection.mainSocket.connect(ClientConfig.timeOutProxyIP,ClientConfig.timeOutProxyPort);
      }
      
      private function onConnect(param1:Event) : void
      {
         var _loc4_:ByteArray = null;
         StatisticsManager.sendHttpStat("_newtrans_","fSocketOnline","前端建立Socket连接到Online成功",MainManager.loginInfo.userID);
         this.lt = getTimer();
         this._loadingView.setPercent(30,100);
         this._loadingView.title = "加载个人信息";
         clearTimeout(_socketTimeOutId);
         if(Boolean(ClientConfig.isRelease()) && ExternalInterface.available)
         {
            ExternalInterface.addCallback("pageRefresh",this.pageRefresh);
         }
         SocketConnection.mainSocket.removeEventListener(Event.CONNECT,this.onConnect);
         SocketConnection.mainSocket.addEventListener(Event.CLOSE,this.onSocketClose);
         SocketConnection.addCmdListener(CommandID.LOGIN_IN,this.onLogin);
         SocketConnection.addCmdListener(CommandID.CHECK_IS_ADULT,this.checkIsAdultHandler);
         SocketConnection.addCmdListener(CommandID.MING_REN_TANG,this.onMingRenTang);
         var _loc2_:int = ClientConfig.isAdult ? 1 : 0;
         if(_isConnectProxy)
         {
            _loc4_ = new ByteArray();
            _loc4_.writeBytes(this.ipToBytes(MainManager.loginInfo.ip));
            _loc4_.writeShort(MainManager.loginInfo.port + 1);
            SocketConnection.send(CommandID.CONNECT_PROXY,_loc4_);
         }
         var _loc3_:ByteArray = ByteArrayUtil.getStringByteArray(MainManager.loginInfo.tad,64);
         SocketConnection.mainSocket.blockEncrypt(CommandID.LOGIN_IN);
         SocketConnection.send(CommandID.LOGIN_IN,MainManager.loginInfo.session,MainManager.loginInfo.roleTime,ClientConfig.serverVersion(),ClientConfig.clientType,_loc2_,MainManager.loginInfo.fromeGameID,_loc3_);
         SocketConnection.send(CommandID.HONOR_LIST,MainManager.loginInfo.userID,MainManager.loginInfo.roleTime);
         StatisticsManager.sendHttpStat("_newtrans_","fSend1001Req","前端发送1001登陆协议",MainManager.loginInfo.userID);
         StatisticsManager.sendHttpStat("首页统计及新手数据","登录流程","前端发送1001登陆协议",MainManager.loginInfo.userID);
      }
      
      private function onMingRenTang(param1:SocketEvent) : void
      {
         this._isShowNext = true;
         this._timer = setTimeout(this.showMingRenTangPanel,3000);
      }
      
      private function showMingRenTangPanel() : void
      {
         clearTimeout(this._timer);
         ModuleManager.turnAppModule("FamousGongFuPeoplePanel");
      }
      
      private function ipToBytes(param1:String) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         var _loc3_:Array = param1.split(".");
         _loc2_.writeByte(_loc3_[0]);
         _loc2_.writeByte(_loc3_[1]);
         _loc2_.writeByte(_loc3_[2]);
         _loc2_.writeByte(_loc3_[3]);
         return _loc2_;
      }
      
      private function pageRefresh() : void
      {
         Logger.error(this,"页面刷新，断开连接");
      }
      
      private function onLogin(param1:SocketEvent) : void
      {
         StatisticsManager.sendHttpStat("_newtrans_","fOnlineSucc","前端成功进入online服务器",MainManager.loginInfo.userID);
         StatisticsManager.sendHttpStat("首页统计及新手数据","登录流程","前端成功进入online服务器",MainManager.loginInfo.userID);
         this._loadingView.setPercent(60,100);
         this._loadingView.title = "初始化。。。";
         WebTraceLog.log("[MainEntry]登录成功" + (getTimer() - this.lt));
         SocketConnection.removeCmdListener(CommandID.LOGIN_IN,this.onLogin);
         SocketConnection.addEventListener(SocketEvent.SOCKET_ERROR,this.onSocketError);
         MainManager.setup(param1.headInfo.userID,param1.data as ByteArray);
         TasksManager.setupTaskCompleteCount();
         SocketConnection.addCmdListener(CommandID.ACTIVITY_EXCHANGE_TIMES,this.onGetSwapActionTime);
         SocketConnection.send(CommandID.ACTIVITY_EXCHANGE_TIMES);
         if(!MainManager.actorInfo.isAdvanced)
         {
            MasterManager.instance.getMasterInfo();
         }
         else
         {
            MasterManager.instance.getApprenticeList();
         }
      }
      
      private function checkIsAdultHandler(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.CHECK_IS_ADULT,this.checkIsAdultHandler);
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:Boolean = _loc2_.readUnsignedInt() == 1;
         MainManager.actorInfo.isAdult = _loc3_;
      }
      
      private function onGetSwapActionTime(param1:SocketEvent) : void
      {
         this._loadingView.setPercent(100,100);
         this._loadingView.destroy();
         this._loadingView = null;
         SocketConnection.removeCmdListener(CommandID.ACTIVITY_EXCHANGE_TIMES,this.onGetSwapActionTime);
         ActivityExchangeTimesManager.readForLogin(param1.data as ByteArray);
         this.loaderUILib();
      }
      
      private function loaderUILib() : void
      {
         Logger.info(this,"Progress-1：开始加载UI资源" + ClientConfig.getUI(this.NAME_UI));
         this._loader = new UILoader(ClientConfig.getUI(this.NAME_UI),LayerManager.stage,LoadingType.TITLE_AND_PERCENT,AppLanguageDefine.LOAD_MATTER_COLLECTION[31],true,true);
         this._loader.closeEnabled = false;
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadUI);
         this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.onFailLoadUI);
         this._loader.load();
      }
      
      private function onLoadUI(param1:UILoadEvent) : void
      {
         AlertManager.isInited = true;
         UIManager.setup(param1.uiloader.loader);
         if(TasksManager.getTaskStatus(this.getTuCompleteTaskId()) == TasksManager.COMPLETE)
         {
            this.destoryLoader();
         }
         else
         {
            SkillXMLInfo.emptyFunction();
            SocketConnection.addCmdListener(CommandID.FIGHT_READY,this.onReady);
         }
         QueueLoader.instance.addEventListener(QueueLoader.QUEUE_LOADER_TIMEOUT,this.onQueueLoaderTimeout);
         this.beginInit();
         StatisticsManager.sendHttpStat("_newtrans_","fLoadInfoSucc","加载资源成功",MainManager.actorID);
      }
      
      private function onReady(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.FIGHT_READY,this.onReady);
         this.destoryLoader();
      }
      
      private function destoryLoader() : void
      {
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadUI);
         this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onFailLoadUI);
         this._loader.destroy();
      }
      
      private function onEquipComplete(param1:Event) : void
      {
         this._equipLoader.removeEventListener(Event.COMPLETE,this.onEquipComplete);
         this._equipLoader.destroy();
         this._equipLoader = null;
         this.beginInit();
      }
      
      private function beginInit() : void
      {
         MainManager.creatActor();
         ItemManager.setup();
         ToolTipManager.setup(UIManager.getSprite("Tooltip_Background"));
         PopUpManager.container = LayerManager.topLevel;
         RelationManager.setup();
         LoginSOController.saveSo();
         this.initBean();
      }
      
      private function initBean() : void
      {
         Logger.info(this,"Progress-6：执行BEAN控制");
         BeanManager.addEventListener(BeanEvent.COMPLETE,this.onAllBeanComplete);
         BeanManager.start();
      }
      
      private function onAllBeanComplete(param1:Event) : void
      {
         var _loc2_:uint = 0;
         BeanManager.removeEventListener(BeanEvent.COMPLETE,this.onAllBeanComplete);
         AStar.instance.maxTry = 2000;
         switch(MainManager.roleType)
         {
            case Constant.ROLE_TYPE_MONKEY:
            case Constant.ROLE_TYPE_RABBIT:
            case Constant.ROLE_TYPE_PANDA:
            case Constant.ROLE_TYPE_DARGON:
            case Constant.ROLE_TYPE_TIGER:
            case Constant.ROLE_TYPE_CAT:
            case Constant.ROLE_TYPE_HORSE:
            case Constant.ROLE_TYPE_WOLF:
               if(TasksManager.getTaskStatus(this.getTuCompleteTaskId()) == TasksManager.COMPLETE)
               {
                  this.startGame();
                  break;
               }
               this.startNewbieTutorial();
               _loc2_ = 5;
               MainManager.actorInfo.mapID = _loc2_;
               FightManager.outToMapID = _loc2_;
               break;
            case Constant.ROLE_TYPE_DARGON:
               if(TasksManager.getTaskStatus(45) == TasksManager.COMPLETE)
               {
                  this.startGame();
                  break;
               }
               this.startDragonNewbieTutorial();
               _loc2_ = 31;
               MainManager.actorInfo.mapID = _loc2_;
               break;
            case Constant.ROLE_TYPE_TIGER:
            case Constant.ROLE_TYPE_CAT:
               if(TasksManager.isCompleted(199))
               {
                  this.startGame();
                  break;
               }
               this.startTigerCatTutorial();
               _loc2_ = 65;
               MainManager.actorInfo.mapID = _loc2_;
               break;
            case Constant.ROLE_TYPE_HORSE:
               if(TasksManager.isCompleted(299))
               {
                  this.startGame();
                  break;
               }
               this.startHouseTutorial();
               _loc2_ = 1058;
               MainManager.actorInfo.mapID = _loc2_;
         }
         this.allBeanIsComplete = true;
      }
      
      private function startGame() : void
      {
         ClientTempState.StartTime = getTimer();
         Logger.info(this,"Progress-7：开始游戏");
         ActivityExchangeCommander.instance;
         CatchSummonManager.instance.setup();
         this.showDefUI();
         if(MapManager.mapInfo == null)
         {
            MapManager.mapInfo = new MapInfo();
         }
         MapManager.mapInfo.id = MainManager.actorInfo.mapID;
         MapManager.mapInfo.mapType = MainManager.actorInfo.mapType;
         EquipDurabilityAlertManager.setup();
         SystemMessageManager.setupUI();
         if(TasksManager.isAcceptable(1108))
         {
            TasksManager.accept(1108);
         }
         if(ClientConfig.clientType != ClientType.KAIXIN)
         {
            WallowRemindChild.instance.update();
         }
         ServerBuffManager.instance.addReadyListener(ServerBuffManager.SERVER_BUFF_READY,this.onSeverBuffReady);
         ServerBuffManager.instance.setup();
         TeamsRelationManager.instance.setup();
         PuzzleControl.instance.setup();
         TimeNpcController.setup();
         this.reportFlashVersion();
         this.reportScreenSize();
         GodManager.instance.setup();
         if(MainManager.actorInfo.lv >= 20)
         {
            GodGuardManager.instance.getGodGuardInfo();
         }
         VipAwardManager.getSwapTimes();
         DirtyWordManager.start();
         ShareObjectManager.instance.showTipPanel();
         EveryDayLuckManager.instance.setup();
         UserInfoManager.upDateMoreInfo(MainManager.actorInfo,this.onGetMainUserInfo);
         FightGroupManager.instance.setup();
         GroupHeadInfoEntry.instance.setup();
         TeamCityWarManager.instance.setup();
         TeamTaskManager.instance.setup();
         ModuleManager.initEscKey();
         CatchBigGhostManager.instance.setup();
         MagicChangeManager.instance.requestInfo();
         HeadSelfPanel.instance.setup();
         ErrorCodeManager.setup();
         PvpKillPointManager.setup();
         WanShenDianManager.setup();
         DpsManager.getInstance().setup();
         DaZhuoWhenLeft5MinManager.setup();
         UserLevelUpActionManager.instance.setup();
         LvInformXMLInfo.lastActivityLv = MainManager.actorInfo.lv;
         InviteManager.instance.init();
         PluginManager.instance.installPlugin("Praise32TimesPlugin");
         PluginManager.instance.installPlugin("AutoUpgradeSkillPlugin");
         PluginManager.instance.installPlugin("TaskTrackGuidePlugin");
         var _loc1_:OtherInfoHelper = new OtherInfoHelper();
         _loc1_.getValue(101,this.sideInfoBack);
         var _loc2_:OtherInfoHelper = new OtherInfoHelper();
         _loc2_.getValue(107,this.killPointBack);
         var _loc3_:OtherInfoHelper = new OtherInfoHelper();
         _loc3_.getValue(111,this.tuan100Back);
         StatisticsManager.sendHttpStat("登陆加载","进入功夫派");
         this.checkToEnterMapOrStartNewTutorials();
         AccountSafeManager.instance.init();
         DailyTaskManager.setup();
         StrengthenNumUtil.buildStrenthenFactor();
      }
      
      private function checkToEnterMapOrStartNewTutorials() : void
      {
         var timer:int = 0;
         if(!TasksManager.isAccepted(2))
         {
            timer = int(setTimeout(function():void
            {
               clearTimeout(timer);
               KeyManager.autoAddItemQuick(1300017,ItemXMLInfo.getUserLevel(1300017));
               KeyManager.autoAddItemQuick(1300116,ItemXMLInfo.getUserLevel(1300116));
            },5000));
         }
         CityMap.instance.changeMap(MainManager.actorInfo.mapID,MainManager.actorInfo.mapType,LoadingType.TITLE_AND_PERCENT,MainManager.actorInfo.pos);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchConplete);
      }
      
      private function tuan100Back(param1:int) : void
      {
         MainManager.actorInfo.isWorldBoss = param1 >= 2;
         MainManager.actorInfo.isJoinTuan100 = param1 >= 1;
      }
      
      private function killPointBack(param1:int) : void
      {
         MainManager.actorInfo.killPoint = param1;
      }
      
      private function sideInfoBack(param1:int) : void
      {
         MainManager.actorInfo.side = param1;
         PvpManager.init();
         PvpManager.setup(param1);
      }
      
      private function reportFlashVersion() : void
      {
         if(Capabilities.isDebugger)
         {
            SocketConnection.send(CommandID.STATISTICS,StatisticsType.IS_DEBUGGER,1,1);
         }
         var _loc1_:String = Capabilities.version;
         var _loc2_:Array = _loc1_.split(" ");
         _loc1_ = _loc2_[1];
         if(_loc1_)
         {
            _loc2_ = _loc1_.split(",");
            SocketConnection.send(CommandID.STATISTICS,int(_loc2_[0]) == 10 ? StatisticsType.PLAYER_VISION10 : StatisticsType.PLAYER_VISION11,1,1);
         }
      }
      
      private function reportScreenSize() : void
      {
         var _loc1_:int = Capabilities.screenResolutionX > 1024 ? int(StatisticsType.SCREEN_MORE_THEN_1024) : (Capabilities.screenResolutionX == 1024 ? int(StatisticsType.SCREEN_EQUAL_1024) : int(StatisticsType.SCREEN_LESS_THEN_1024));
         SocketConnection.send(CommandID.STATISTICS,_loc1_,1,1);
      }
      
      private function sendGameSucc() : void
      {
         if(!this._sendInterGameSucc)
         {
            this._sendInterGameSucc = true;
            StatisticsManager.sendHttpStat("_newtrans_","fInterGameSucc","前端进入游戏主界面",MainManager.actorID);
         }
      }
      
      private function onMapSwitchConplete(param1:MapEvent) : void
      {
         var so:SharedObject;
         var num:uint;
         var haveSummon:Boolean;
         var needToShowEquip:Boolean;
         var applyFun:Function;
         var event:MapEvent = param1;
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchConplete);
         if(MainManager.loginInfo.flag == 6 || MainManager.loginInfo.flag == 7)
         {
            ModuleManager.turnAppModule("UnusuallyLoginAlertPanel","加载登录异常面板");
         }
         if(MainManager.lastLoginTime > 0)
         {
            if(this.checkSwap() && MainManager.actorInfo.lv >= 35)
            {
               if(ActivityExchangeTimesManager.getTimes(3299) > 0)
               {
                  ModuleManager.turnAppModule("OldUserAwardPanel");
               }
            }
         }
         so = SOManager.getActorSO("AdPanel");
         if(Boolean(MainManager.actorInfo.lv >= 80) && Boolean(so) && Boolean(so.data["20170428"]) == false)
         {
            so.data["20170428"] = true;
            so.flush();
         }
         so = SOManager.getActorSO("AccountSafePanel");
         if(Boolean(MainManager.actorInfo.lv >= 80) && Boolean(so) && Boolean(so.data["20151202"]) == false)
         {
            so.data["20151202"] = true;
            so.flush();
            ModuleManager.turnAppModule("AccountSafePanel");
         }
         SocketConnection.send(CommandID.GET_MIMI_CREATE_TIME);
         SocketConnection.addCmdListener(CommandID.GET_MIMI_CREATE_TIME,this.onGetCreateTime);
         if(MainManager.actorInfo.lv >= 20 && MainManager.actorInfo.getSubCareer(SubCareerType.TYPE_NEW_COMPOSE) == null)
         {
            SocketConnection.addCmdListener(CommandID.SUB_CAREER_APPLY,this.onApplySuccess);
            SocketConnection.send(CommandID.SUB_CAREER_APPLY,SubCareerType.TYPE_NEW_COMPOSE);
         }
         num = uint(ActivityExchangeTimesManager.getTimes(3232));
         haveSummon = Boolean(SummonManager.getActorSummonInfo().getSummonInfoBySummonType(8001)) || Boolean(SummonManager.getActorSummonInfo().getSummonInfoBySummonType(8011)) || Boolean(SummonManager.getActorSummonInfo().getSummonInfoBySummonType(8021));
         if(num == 1 && !haveSummon)
         {
            applyFun = function():void
            {
               ModuleManager.turnAppModule("KirinTengsnakeFreePanel","加载拯救麒麟腾蛇来就送面板......");
            };
            AlertManager.showSimpleAlert("小侠士，免费时限已到，你可以在本周的活动中永久得到这只仙兽，现在就去吗？",applyFun);
            ActivityExchangeCommander.exchange(3232);
         }
         this.offLine();
         this.openSignPanel();
         this.taskDeadCode();
         setTimeout(MysteryClipManager.addListener,2000);
         ActivityExchangeTimesManager.addEventListener(this._setSecQuesSwapId,this.onGetFlagResult);
         ActivityExchangeTimesManager.getActiviteTimeInfo(this._setSecQuesSwapId);
         needToShowEquip = ActivityExchangeTimesManager.getTimes(5498) <= 0;
         if(this.hasChecked() == false && MainManager.actorInfo.lv >= 60)
         {
            ModuleManager.turnAppModule("AWeekSignPanel");
         }
         OldBackManager.inst.init();
         if(MainManager.actorInfo.expired)
         {
            ChatUtil.addSystemMsg("小侠士，您背包内的过期物品已被回收");
         }
         this.checkFromOtherGameAward();
         FourYearGiveTbTimeManager.instance().setup();
         SummonShenTongManager.getDataAsy(null);
         if(MainManager.actorInfo.lv < 80 && Boolean(MainManager.actorInfo.isTurnBack))
         {
            if(ActivityExchangeTimesManager.getTimes(7765) == 0)
            {
               ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onTurnBackAwardComplete);
               ActivityExchangeCommander.exchange(7765);
            }
         }
         if(MapManager.currentMap.info.id == 2)
         {
            if(MapManager.currentMap.isBlockXY(MainManager.actorModel.pos.x,MainManager.actorModel.pos.y))
            {
               MainManager.actorModel.pos = new Point(455,500);
               MainManager.actorModel.execStandAction(false);
            }
         }
         if(MainManager.olToday < 20)
         {
            ModuleManager.turnAppModule("OnlineGiftCarnivalPanel");
         }
         this.sendGameSucc();
      }
      
      private function onTurnBackAwardComplete(param1:ExchangeEvent) : void
      {
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onTurnBackAwardComplete);
         AlertManager.showSimpleAlarm("转生大改版啦！恭喜小侠士直升80级！");
      }
      
      private function checkFromOtherGameAward() : void
      {
         var awardType:int = 0;
         var timer:int = 0;
         if(ClientConfig.fromUid == MainManager.actorID)
         {
            awardType = 0;
            if(ClientConfig.fromGameId == 2)
            {
               awardType = 4;
            }
            else if(ClientConfig.fromGameId == 4 || ClientConfig.fromGameId == 16)
            {
               awardType = 5;
            }
            if(awardType != 0 && ActivityExchangeTimesManager.getTimes(5216) == 0)
            {
               timer = int(setTimeout(function():void
               {
                  clearTimeout(timer);
                  if(ClientConfig.fromGameId == 2)
                  {
                     StatisticsManager.sendHttpStat("代签统计","赛尔号","参与的人数",MainManager.actorID);
                  }
               },2000));
            }
         }
      }
      
      private function hasChecked() : Boolean
      {
         return ActivityExchangeTimesManager.getTimes(13388) > 0;
      }
      
      private function onGetFlagResult(param1:DataEvent) : void
      {
         var _loc3_:SysMsgInfo = null;
         ActivityExchangeTimesManager.removeEventListener(this._setSecQuesSwapId,this.onGetFlagResult);
         var _loc2_:int = int((param1.data as SwapTimesInfo).times);
         if(_loc2_ >= 1)
         {
            _loc3_ = new SysMsgInfo();
            _loc3_.npcID = 100001;
            SystemMessageManager.addInfo(_loc3_);
         }
      }
      
      private function writeDateToLocal() : void
      {
         var _loc1_:SharedObject = SOManager.getUserSO(SOManager.OPEN_GRANTSUM_FLAG);
         _loc1_ = SOManager.getUserSO(SOManager.OPEN_GRANTSUM_FLAG);
         _loc1_.data[SOManager.OPEN_GRANTSUM_FLAG] = TimeUtil.getSeverDateObject();
         SOManager.flush(_loc1_);
         if(MainManager.actorInfo.lv < 10)
         {
            return;
         }
         if(this._isShowNext)
         {
         }
      }
      
      private function offLine() : void
      {
         if(this._isOffLine)
         {
            return;
         }
         ActivityExchangeTimesManager.addEventListener(4482,this.getOfflineExpFlag);
         ActivityExchangeTimesManager.getActiviteTimeInfo(4482);
      }
      
      private function getOfflineExpFlag(param1:DataEvent) : void
      {
         ActivityExchangeTimesManager.removeEventListener(4482,this.getOfflineExpFlag);
         var _loc2_:int = int((param1.data as SwapTimesInfo).times);
         if(this.allBeanIsComplete && this.isMainUserInfoIsComplete && !MainManager.isLvFull() && _loc2_ <= 0)
         {
            this._isOffLine = true;
            SocketConnection.addCmdListener(CommandID.GET_OFFLINE_EXP,this.onGetOfflineExpData);
            SocketConnection.send(CommandID.GET_OFFLINE_EXP,0,0,0);
         }
      }
      
      private function onGetOfflineExpData(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GET_OFFLINE_EXP,this.onGetOfflineExpData);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         this._offLineData = {};
         this._offLineData.type = _loc2_.readUnsignedInt();
         this._offLineData.time = _loc2_.readUnsignedInt();
         OfflineExpManager.getInstance().haveTime = this._offLineData.time;
      }
      
      private function openSignPanel() : void
      {
      }
      
      private function setStageQuality() : void
      {
         var _loc1_:SharedObject = SOManager.getCommonSO(SOManager.STAGE_QUALITY);
         var _loc2_:String = _loc1_.data.quality;
         if(_loc2_ != null && Boolean(_loc2_.length))
         {
            LayerManager.stage.quality = _loc2_;
         }
      }
      
      private function taskDeadCode() : void
      {
         var _loc1_:Array = null;
         var _loc2_:uint = 0;
         if(Boolean(OnHookManager.hookInfo) && Boolean(OnHookManager.isOnHookIng()))
         {
            return;
         }
         if(TasksManager.isCompleted(2090))
         {
            _loc1_ = [2085,2086,2087,2088,2089];
            for each(_loc2_ in _loc1_)
            {
               if(!TasksManager.isCompleted(_loc2_))
               {
                  TasksManager.taskComplete(_loc2_);
               }
            }
         }
      }
      
      private function checkSwap() : Boolean
      {
         var _loc1_:Array = [3294,3295,3296,3297];
         var _loc2_:uint = _loc1_.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(ActivityExchangeTimesManager.getTimes(_loc1_[_loc3_]) > 0)
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      private function onGetCreateTime(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GET_MIMI_CREATE_TIME,this.onGetCreateTime);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         MainManager.mimiCreateTime = _loc2_.readUnsignedInt();
      }
      
      private function onApplySuccess(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.SUB_CAREER_APPLY,this.onApplySuccess);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:SubCareerInfo = new SubCareerInfo();
         _loc5_.type = _loc4_;
         _loc5_.exp = 0;
         MainManager.actorInfo.addSubCareer(_loc5_);
      }
      
      private function onSeverBuffReady(param1:Event) : void
      {
         KeyController.changeControl(ServerBuffManager.instance.keyBoardControlType);
         SoundManager.setMusicEnable(ServerBuffManager.instance.isMusicEnable);
         DeffEquiptManager.initEquiptDisplayType(ServerBuffManager.instance.isDisplayDeffaultEquipt);
         PayPasswordManager.instance.isOpenPayPassword = ServerBuffManager.instance.isOpenPayPassword;
      }
      
      private function startNewbieTutorial() : void
      {
         this.sendGameSucc();
         TasksManager.accept(this.getTuCompleteTaskId());
         FightManager.instance.addEventListener(FightEvent.QUITE,this.onFightQuit);
         PveEntry.enterTollgate(1045);
      }
      
      private function onFightQuit(param1:Event) : void
      {
         FightManager.instance.removeEventListener(FightEvent.QUITE,this.onFightQuit);
         this.onNewBieTutorial();
      }
      
      private function startDragonNewbieTutorial() : void
      {
         TasksManager.accept(45);
         var _loc1_:AppModel = new AppModel(ClientConfig.getGameModule("NewbieTutorialDragon"),AppLanguageDefine.LOAD_MATTER_COLLECTION[34]);
         _loc1_.init({
            "userInfo":MainManager.actorInfo,
            "stageID":998
         });
         _loc1_.show();
         _loc1_.addEventListener(GfpEvent.DESTROY,this.onNewBieTutorial);
      }
      
      private function startTigerCatTutorial() : void
      {
         if(TasksManager.isAcceptable(199))
         {
            TasksManager.accept(199);
         }
         var _loc1_:AppModel = new AppModel(ClientConfig.getGameModule("NewTutorialTigerCat"),AppLanguageDefine.LOAD_MATTER_COLLECTION[34]);
         _loc1_.init({
            "userInfo":MainManager.actorInfo,
            "stageID":1002
         });
         _loc1_.show();
         _loc1_.addEventListener(GfpEvent.DESTROY,this.onNewBieTutorial);
      }
      
      private function startHouseTutorial() : void
      {
         if(TasksManager.isAcceptable(299))
         {
            TasksManager.accept(299);
         }
         var _loc1_:AppModel = new AppModel(ClientConfig.getGameModule("NewTutorialHouse"),AppLanguageDefine.LOAD_MATTER_COLLECTION[34]);
         _loc1_.init({
            "userInfo":MainManager.actorInfo,
            "stageID":1002
         });
         _loc1_.show();
         _loc1_.addEventListener(GfpEvent.DESTROY,this.onNewBieTutorial);
      }
      
      private function onNewBieTutorial(param1:Event = null) : void
      {
         if(param1)
         {
            param1.target.removeEventListener(GfpEvent.DESTROY,this.onNewBieTutorial);
         }
         switch(MainManager.roleType)
         {
            case Constant.ROLE_TYPE_DARGON:
               MainManager.isDragonFirstLogin = true;
               break;
            case Constant.ROLE_TYPE_TIGER:
            case Constant.ROLE_TYPE_CAT:
               MainManager.isFirstLogin = true;
               break;
            case Constant.ROLE_TYPE_HORSE:
         }
         var _loc2_:uint = uint(this.getTuCompleteTaskId());
         TasksManager.taskComplete(_loc2_);
         TasksManager.setTaskStatus(_loc2_,TasksManager.COMPLETE);
         this.startGame();
      }
      
      private function getTuCompleteTaskId() : int
      {
         var _loc1_:uint = 1;
         switch(MainManager.roleType)
         {
            case Constant.ROLE_TYPE_DARGON:
               _loc1_ = 45;
               break;
            case Constant.ROLE_TYPE_TIGER:
            case Constant.ROLE_TYPE_CAT:
               _loc1_ = 199;
               break;
            case Constant.ROLE_TYPE_HORSE:
               _loc1_ = 299;
               break;
            default:
               _loc1_ = 1;
         }
         return _loc1_;
      }
      
      private function onFailLoadUI(param1:IOErrorEvent) : void
      {
         throw new Error(AppLanguageDefine.SYSTEM_ERROR_COLLECTION[5]);
      }
      
      private function showDefUI() : void
      {
         CityToolBar.show();
         Battery.instance.show();
         CityQuickBar.instance.show();
         EverydaySignEntry.instance.show();
         VipNewEntry.instance.show();
         MapInfoShow.instance.show();
         DynamicActivityEntry.instance.show();
         RookieTaskPrizePanel.show();
         TaskTrackPanel.instance.setup();
         AmbassadorEntry.instance.show();
         MailSysEntry.instance.show();
         MallEntry.instance.show();
         HornPanel.instance.show();
         HonorPanelEntry.instance.show();
         WuLinFightEntry.instance.show();
         RedBlueMasterEntry.instance.show();
         CommunityTipsEntry.instance.setup();
         ActivityPromptEntry.instance.setup();
         TurnBackTaskIco.instance.setup();
      }
      
      private function onGetMainUserInfo(param1:UserInfo) : void
      {
         TootalExpBar.instance.hide();
         HeadSelfPanel.instance.init(MainManager.actorModel);
         HeadSelfPanel.instance.showForCity();
         this.isMainUserInfoIsComplete = true;
         this.offLine();
      }
      
      private function onSocketError(param1:SocketEvent) : void
      {
         if(param1.headInfo.error == 10004)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.SYSTEM_ERROR_COLLECTION[11],this.unLink);
            SocketConnection.mainSocket.removeEventListener(Event.CLOSE,this.onSocketClose);
            Analytics.submitErrorInfo(ErrorTypes.DISCONNECTION_ONLINE,AppLanguageDefine.SYSTEM_ERROR_COLLECTION[7]);
         }
         else
         {
            ParseSocketError.parse(param1.headInfo);
         }
      }
      
      private function onSocketClose(param1:Event) : void
      {
         var e:Event = param1;
         Logger.fatal(this,"////////////////////////////////////////////////////////\r//\r//\t\t\t\t socket was closed \r//\r////////////////////////////////////////////////////////");
         try
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.SYSTEM_ERROR_COLLECTION[6] + MainManager.serverID.toString(),this.unLink);
         }
         catch(e:Error)
         {
            if(_loadingView == null)
            {
               _loadingView = LoadingManager.getLoading(LoadingType.TITLE_AND_PERCENT,LayerManager.topLevel,AppLanguageDefine.SYSTEM_ERROR_COLLECTION[6]);
            }
            _loadingView.title = "服务器断开连接";
            _loadingView.show();
            LayerManager.stage.addEventListener(MouseEvent.CLICK,unLink);
            Logger.fatal(this,"还没加载UI资源");
         }
         Analytics.submitErrorInfo(ErrorTypes.DISCONNECTION_ONLINE,AppLanguageDefine.SYSTEM_ERROR_COLLECTION[7]);
      }
      
      private function unLink(param1:MouseEvent = null) : void
      {
         if(ClientConfig.isRelease())
         {
            navigateToURL(new URLRequest(ClientConfig.mainURL()),"_self");
         }
      }
      
      private function checkVipCloth() : void
      {
         var _loc1_:Vector.<SingleEquipInfo> = null;
         var _loc2_:Vector.<SingleEquipInfo> = null;
         var _loc3_:SingleEquipInfo = null;
         if(!MainManager.actorInfo.isVip)
         {
            if(MainManager.actorInfo.roleType == Constant.ROLE_TYPE_HORSE)
            {
               return;
            }
            _loc1_ = MainManager.actorInfo.clothes.concat(MainManager.actorInfo.fashionClothes);
            _loc2_ = new Vector.<SingleEquipInfo>();
            for each(_loc3_ in _loc1_)
            {
               if(!ItemXMLInfo.getVipOnly(_loc3_.itemID))
               {
                  _loc2_.push(_loc3_);
               }
            }
            MainManager.actorModel.execBehavior(new ClothBehavior(_loc2_,true));
         }
      }
      
      private function onQueueLoaderTimeout(param1:Event) : void
      {
         AlertManager.showSimpleAlarm(AppLanguageDefine.SYSTEM_ERROR_COLLECTION[9] + "<br><br><a href=\'" + this._helpURL + "\'><font color=\'#FF0000\'>" + this._helpURL + "</font></a>",this.unLink);
      }
   }
}

