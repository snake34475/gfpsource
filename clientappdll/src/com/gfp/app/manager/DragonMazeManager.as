package com.gfp.app.manager
{
   import com.gfp.app.dragonMaze.DragonMazeOperatePanel;
   import com.gfp.app.dragonMaze.DragonMazeRankInfo;
   import com.gfp.app.dragonMaze.DragonMazeRankPanel;
   import com.gfp.app.dragonMaze.ThreeBloodBar;
   import com.gfp.app.fight.FightCountDown;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.info.dialog.DialogInfoMultiple;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.app.toolBar.AmbassadorEntry;
   import com.gfp.app.toolBar.Battery;
   import com.gfp.app.toolBar.CityQuickBar;
   import com.gfp.app.toolBar.CityToolBar;
   import com.gfp.app.toolBar.CommunityTipsEntry;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.app.toolBar.EverydaySignEntry;
   import com.gfp.app.toolBar.HonorPanelEntry;
   import com.gfp.app.toolBar.LvlUpAlertEntry;
   import com.gfp.app.toolBar.MailSysEntry;
   import com.gfp.app.toolBar.MallEntry;
   import com.gfp.app.toolBar.MapInfoShow;
   import com.gfp.app.toolBar.RoleHeadEntry;
   import com.gfp.app.toolBar.RoleItemMenu;
   import com.gfp.app.toolBar.TaskTrackPanel;
   import com.gfp.app.toolBar.VipNewEntry;
   import com.gfp.app.toolBar.WuLinFightEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.ScenceItemAddEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.CustomBoxModel;
   import com.gfp.core.model.CustomSightModel;
   import com.gfp.core.model.PeopleModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.model.sensemodels.TeleporterModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.Delegate;
   import org.taomee.utils.DisplayUtil;
   
   public class DragonMazeManager
   {
      
      private static var _instance:DragonMazeManager;
      
      private var _isStart:Boolean;
      
      private var _isEnd:Boolean;
      
      private var _mazeID:uint = 1048;
      
      private var _boxID:uint = 30036;
      
      private var _npcIDs:Array = [10511,10512,10515];
      
      private var _bossBlood:Array = [3,3];
      
      private var _mazeFloor:uint = 1;
      
      private var _rankPanel:DragonMazeRankPanel;
      
      private var _bloodBar:ThreeBloodBar;
      
      private var _npcModule:CustomSightModel;
      
      private var _moonCakeModel:CustomSightModel;
      
      private var _hasWished:Boolean;
      
      public function DragonMazeManager()
      {
         super();
      }
      
      public static function get instance() : DragonMazeManager
      {
         if(_instance == null)
         {
            _instance = new DragonMazeManager();
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
         this._bloodBar = new ThreeBloodBar();
         this._bloodBar.bloodTotal = 3;
         this._hasWished = false;
         this.addEvent();
         CityMap.instance.changeMap(this._mazeID);
      }
      
      private function addEvent() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         MapManager.addEventListener(MapEvent.USER_LIST_COMPLETE,this.onUserListUpdate);
         SocketConnection.addCmdListener(CommandID.MAZE_RANK_INFO,this.onRankInfo);
         SocketConnection.addCmdListener(CommandID.DRAGON_MAZE_STATUS,this.onGameStatus);
         SocketConnection.addCmdListener(CommandID.DRAGON_MAZE_BOX,this.onBoxOpen);
         SocketConnection.addCmdListener(CommandID.MAZE_BOSS_BLOOD,this.onBossBlood);
      }
      
      private function removeEvent() : void
      {
         MapManager.removeEventListener(MapEvent.USER_ENTER_MAP,this.onUserListUpdate);
         MapManager.removeEventListener(MapEvent.USER_LEAVE_MAP,this.onUserListUpdate);
         MapManager.removeEventListener(MapEvent.USER_LIST_COMPLETE,this.onUserListUpdate);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         ChallengeSummonManager.removeEventListener(ScenceItemAddEvent.ITEM_STATUS_INFO,this.onItemStatusInfo);
         FightCountDown.ed.removeEventListener(FightCountDown.COUNT_DOWN_COMPLETE,this.onCountDownComplete);
         SocketConnection.removeCmdListener(CommandID.MAZE_RANK_INFO,this.onRankInfo);
         SocketConnection.removeCmdListener(CommandID.DRAGON_MAZE_STATUS,this.onGameStatus);
         SocketConnection.removeCmdListener(CommandID.DRAGON_MAZE_FLOOR,this.onMazeFloorInfo);
         SocketConnection.removeCmdListener(CommandID.DRAGON_MAZE_BOX,this.onBoxOpen);
         SocketConnection.removeCmdListener(CommandID.MAZE_BOSS_BLOOD,this.onBossBlood);
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         if(MapManager.mapInfo.mapType == MapType.PVE)
         {
            return;
         }
         if(MapManager.mapInfo.id != this._mazeID)
         {
            DragonMazeManager.destroy();
            return;
         }
         if(this._isStart)
         {
            this.gameHide();
            if(this._mazeFloor >= 20)
            {
               this.changeTeleporter(false);
            }
            if(this._isEnd)
            {
               this.gameEnd();
            }
         }
         else
         {
            MapInfoShow.instance.showInSummonRoom();
            DragonMazeOperatePanel.instance.show();
            DynamicActivityEntry.instance.hide();
            MapManager.addEventListener(MapEvent.USER_ENTER_MAP,this.onUserListUpdate);
            MapManager.addEventListener(MapEvent.USER_LEAVE_MAP,this.onUserListUpdate);
            this._rankPanel = new DragonMazeRankPanel();
            this._rankPanel.show(LayerManager.topLevel);
            this.onUserListUpdate();
            this.changeTeleporter(false);
         }
      }
      
      private function onMazeFloorInfo(param1:SocketEvent) : void
      {
         var _loc4_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt() + 1;
         if(this._mazeFloor > _loc3_)
         {
            _loc4_ = this._mazeFloor - _loc3_;
            TextAlert.show("走错路啦，倒退" + _loc4_ + "层！");
         }
         else if(this._mazeFloor == _loc3_)
         {
            TextAlert.show("走错路拉！！");
         }
         else
         {
            TextAlert.show("恭喜顺利进入下一层!");
         }
         this._mazeFloor = _loc3_;
         if(this._isStart)
         {
            MapInfoShow.instance.setRoomText("龙宫探险",this._mazeFloor);
         }
         if(this._mazeFloor >= 20)
         {
            this.changeTeleporter(false);
         }
      }
      
      private function onUserListUpdate(param1:MapEvent = null) : void
      {
         var infoArr:Array = null;
         var event:MapEvent = param1;
         var left:uint = 10 - UserManager.length - 1;
         MapInfoShow.instance.setRoomText("等待" + left + "名侠士加入",this._mazeFloor);
         infoArr = new Array();
         infoArr.push(MainManager.actorInfo);
         UserManager.getModels().forEach(function(param1:UserModel, param2:int, param3:Array):void
         {
            if(param1 is PeopleModel)
            {
               infoArr.push(param1.info);
            }
         });
         this._rankPanel.setInfo(infoArr);
      }
      
      private function onRankInfo(param1:SocketEvent) : void
      {
         var _loc6_:DragonMazeRankInfo = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = new DragonMazeRankInfo(_loc2_);
            _loc4_.push(_loc6_);
            _loc5_++;
         }
         _loc4_.sortOn("floor",Array.NUMERIC | Array.DESCENDING);
         this._rankPanel.setData(_loc4_);
      }
      
      private function onGameStatus(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == 2)
         {
            this.gameStart();
         }
         else if(_loc3_ == 3)
         {
            this._isEnd = true;
            if(MapManager.mapInfo.mapType != MapType.PVE)
            {
               this.gameEnd();
            }
         }
      }
      
      private function gameStart() : void
      {
         this._isStart = true;
         this.gameHide();
         this.gameLimit(true);
         MapInfoShow.instance.hideRoomMC();
         MapInfoShow.instance.setRoomText("龙宫探险",1);
         this.changeTeleporter(true);
         MapManager.removeEventListener(MapEvent.USER_ENTER_MAP,this.onUserListUpdate);
         MapManager.removeEventListener(MapEvent.USER_LEAVE_MAP,this.onUserListUpdate);
         MapManager.removeEventListener(MapEvent.USER_LIST_COMPLETE,this.onUserListUpdate);
         ChallengeSummonManager.addEventListner(ScenceItemAddEvent.ITEM_STATUS_INFO,this.onItemStatusInfo);
         SocketConnection.addCmdListener(CommandID.DRAGON_MAZE_FLOOR,this.onMazeFloorInfo);
         MainManager.actorModel.execStandAction();
         MainManager.closeOperate(true);
         this.onUserListUpdate();
         FightCountDown.ed.addEventListener(FightCountDown.COUNT_DOWN_COMPLETE,this.onCountDownComplete);
         FightCountDown.play();
      }
      
      private function onCountDownComplete(param1:Event) : void
      {
         FightCountDown.ed.removeEventListener(FightCountDown.COUNT_DOWN_COMPLETE,this.onCountDownComplete);
         MainManager.openOperate();
      }
      
      private function gameEnd() : void
      {
         MainManager.closeOperate();
         this._rankPanel.setStatus(true);
         DragonMazeOperatePanel.instance.onShow();
      }
      
      private function onItemStatusInfo(param1:ScenceItemAddEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc2_:uint = uint(param1.status);
         var _loc3_:uint = uint(param1.itemID);
         var _loc4_:Point = param1.position;
         if(_loc3_ == this._boxID)
         {
            _loc5_ = this._mazeFloor * 100000 + this._boxID;
            if(_loc2_ == 1)
            {
               this.createBox(this._boxID,_loc5_,_loc4_);
            }
            else
            {
               this.deletBox(_loc5_);
            }
         }
         else
         {
            _loc6_ = this._npcIDs.indexOf(_loc3_);
            if(_loc6_ != -1 && _loc6_ < 2)
            {
               this._bossBlood[_loc6_] = _loc2_;
               if(_loc2_ > 0)
               {
                  this._bloodBar.bloodCurrent = _loc2_;
                  this.creatNPC(_loc3_,_loc4_);
               }
               else
               {
                  this.deletNPC();
               }
            }
            else if(_loc6_ == 2)
            {
               this.creatMoonCake(_loc3_,_loc4_);
            }
         }
      }
      
      private function onBoxOpen(param1:SocketEvent) : void
      {
         var _loc4_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt() + 1;
         if(this._mazeFloor == _loc3_)
         {
            _loc4_ = this._mazeFloor * 100000 + this._boxID;
            this.deletBox(_loc4_);
         }
      }
      
      private function createBox(param1:uint, param2:uint, param3:Point) : void
      {
         var _loc4_:UserInfo = new UserInfo();
         _loc4_.roleType = param1;
         _loc4_.userID = param2;
         _loc4_.pos = param3;
         var _loc5_:CustomBoxModel = new CustomBoxModel(_loc4_,Delegate.create(this.openBox,_loc4_.userID));
         UserManager.add(param2,_loc5_);
         MapManager.currentMap.contentLevel.addChild(_loc5_);
      }
      
      private function openBox(param1:uint) : void
      {
         var userID:uint = param1;
         setTimeout(function():void
         {
            SocketConnection.send(CommandID.DRAGON_MAZE_BOX);
         },500);
      }
      
      private function deletBox(param1:uint) : void
      {
         var _loc2_:UserModel = UserManager.remove(param1);
         if(_loc2_)
         {
            _loc2_.destroy();
            _loc2_ = null;
         }
      }
      
      private function onBossBlood(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         this._bossBlood[0] = _loc2_.readUnsignedInt();
         this._bossBlood[1] = _loc2_.readUnsignedInt();
         var _loc3_:int = 0;
         while(_loc3_ < 2)
         {
            if(Boolean(this._npcModule) && this._npcModule.roleType == this._npcIDs[_loc3_])
            {
               this._bloodBar.bloodCurrent = this._bossBlood[_loc3_];
               if(this._bossBlood[_loc3_] <= 0)
               {
                  this._npcModule.destroy();
               }
            }
            _loc3_++;
         }
      }
      
      private function creatNPC(param1:uint, param2:Point) : void
      {
         if(this._npcModule)
         {
            this._npcModule.destroy();
            this._npcModule = null;
         }
         this._npcModule = new CustomSightModel(Delegate.create(this.onNpcClickHandler,param1));
         this._npcModule.roleType = param1;
         this._npcModule.pos = param2;
         this._npcModule.show();
         this._npcModule.addBloodBar(this._bloodBar);
      }
      
      private function creatMoonCake(param1:uint, param2:Point) : void
      {
         if(this._moonCakeModel)
         {
            this._moonCakeModel.destroy();
            this._moonCakeModel = null;
         }
         this._moonCakeModel = new CustomSightModel(Delegate.create(this.onNpcClickHandler,param1));
         this._moonCakeModel.roleType = param1;
         this._moonCakeModel.pos = param2;
         this._moonCakeModel.show();
      }
      
      private function onNpcClickHandler(param1:uint) : void
      {
         var tollgateID:uint = 0;
         var dialogs:Array = null;
         var selects:Array = null;
         var multiDialog:DialogInfoMultiple = null;
         var npcID:uint = param1;
         var index:int = this._npcIDs.indexOf(npcID);
         switch(index)
         {
            case 0:
               tollgateID = 556;
               dialogs = ["身手不凡，小侠士，让我看看你的拳脚功夫如何。打赢我就能赢取大量奖励哦！"];
               break;
            case 1:
               tollgateID = 557;
               dialogs = ["探险纯爷们，铁血真汉子！既然这么快就能到达20层，就接受我最后的考验吧!"];
               break;
            case 2:
               dialogs = ["找到我证明你我很有缘分，我就实现你一个中秋心愿吧！"];
         }
         if(tollgateID > 0)
         {
            selects = ["请指教"];
            multiDialog = new DialogInfoMultiple(dialogs,selects);
            NpcDialogController.showForMultiple(multiDialog,npcID,function():void
            {
               PveEntry.instance.enterTollgate(tollgateID);
            });
         }
         else
         {
            selects = ["我要许愿"];
            multiDialog = new DialogInfoMultiple(dialogs,selects);
            NpcDialogController.showForMultiple(multiDialog,npcID,function():void
            {
               ModuleManager.turnAppModule("MoonCakeWishPanel");
            });
         }
      }
      
      private function deletNPC() : void
      {
         this._npcModule.destroy();
      }
      
      private function changeTeleporter(param1:Boolean) : void
      {
         var isVisible:Boolean = param1;
         SightManager.getSightModelList().forEach(function(param1:SightModel, param2:int, param3:Array):void
         {
            if(param1 is TeleporterModel)
            {
               param1.visible = isVisible;
            }
         });
      }
      
      private function gameHide() : void
      {
         MallEntry.instance.hide();
         AmbassadorEntry.instance.hide();
         Battery.instance.hide();
         HonorPanelEntry.instance.hide();
         EverydaySignEntry.instance.hide();
         VipNewEntry.instance.hide();
         MailSysEntry.instance.hide();
         CityQuickBar.instance.hide();
         WuLinFightEntry.instance.hide();
         RoleHeadEntry.hide();
         RoleItemMenu.destory();
         DynamicActivityEntry.instance.hide();
         TaskTrackPanel.instance.hide();
         LvlUpAlertEntry.instance.hide();
         CommunityTipsEntry.instance.visible = false;
         CityToolBar.instance.hide();
         MapInfoShow.instance.showInSummonRoom();
      }
      
      private function gameLimit(param1:Boolean) : void
      {
         FunctionManager.disabledDemonreCorded = param1;
         FunctionManager.disabledFightTeam = param1;
         FunctionManager.disabledMsg = param1;
         FunctionManager.disabledNewspaper = param1;
         FunctionManager.disabledTask = param1;
         FunctionManager.disabledStorehouse = param1;
         FunctionManager.disabledPvp = param1;
         FunctionManager.disabledTradeHouse = param1;
         FunctionManager.disabledMail = param1;
         FunctionManager.disabledGuaranteeTrade = param1;
         FunctionManager.disabledMap = param1;
      }
      
      private function gameEndShow() : void
      {
         EverydaySignEntry.instance.show();
         VipNewEntry.instance.show();
         MallEntry.instance.show();
         AmbassadorEntry.instance.show();
         Battery.instance.show();
         HonorPanelEntry.instance.show();
         MailSysEntry.instance.show();
         CityQuickBar.instance.show();
         WuLinFightEntry.instance.show();
         TaskTrackPanel.instance.show();
         DynamicActivityEntry.instance.show();
         LvlUpAlertEntry.instance.show();
         CommunityTipsEntry.instance.visible = true;
         CityToolBar.instance.show();
         MapInfoShow.instance.hideOutSummonRoom();
      }
      
      public function quit() : void
      {
         CityMap.instance.changeMap(7);
      }
      
      public function set hasWished(param1:Boolean) : void
      {
         this._hasWished = param1;
      }
      
      public function get hasWished() : Boolean
      {
         return this._hasWished;
      }
      
      public function destroy() : void
      {
         this._isStart = false;
         this._isEnd = false;
         this._hasWished = false;
         this.removeEvent();
         this.changeTeleporter(true);
         this.gameEndShow();
         this.gameLimit(false);
         if(this._rankPanel)
         {
            DisplayUtil.removeForParent(this._rankPanel);
            this._rankPanel.destroy();
            this._rankPanel = null;
         }
         if(this._moonCakeModel)
         {
            this._moonCakeModel.destroy();
            this._moonCakeModel = null;
         }
         this._bloodBar.destroy();
         DragonMazeOperatePanel.destroy();
      }
   }
}

