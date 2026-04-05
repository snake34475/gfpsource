package com.gfp.app.control
{
   import com.gfp.app.fight.FightWaitPanel;
   import com.gfp.app.fight.SinglePkManager;
   import com.gfp.app.time.CutDownTimePanel;
   import com.gfp.app.toolBar.Battery;
   import com.gfp.app.toolBar.MailSysEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.controller.SocketSendController;
   import com.gfp.core.events.HiddenEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.HiddenManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.KeyboardModel;
   import com.gfp.core.model.MapModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.model.sensemodels.TeleporterModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.HiddenState;
   import com.gfp.core.utils.PvpIDConstantUtil;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import com.gfp.core.utils.StringConstants;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class GloryFightControl
   {
      
      private static var _instance:GloryFightControl;
      
      private static var _isInit:Boolean = false;
      
      private var _enemyUserID:uint;
      
      private var _enemyCreatTime:uint;
      
      private var _isMatched:Boolean;
      
      private var _winTeamID:uint = 0;
      
      private var _boxNum:uint = 0;
      
      private const TEAM_DISTANCE:uint = 700;
      
      private const SWAP_IDS:Array = [1435,1436,1437,1438];
      
      private const POS_DATA:Array = [[564,222],[600,390],[873,228],[886,424],[1184,340],[1133,474]];
      
      public function GloryFightControl()
      {
         super();
      }
      
      public static function get instance() : GloryFightControl
      {
         if(_instance == null)
         {
            _instance = new GloryFightControl();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.addMapEvents();
      }
      
      private function addMapEvents() : void
      {
         MapManager.addEventListener(MapEvent.MAP_DESTROY,this.onMapDestroy);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,this.onMapSwitchOpen);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         SocketConnection.addCmdListener(CommandID.GLORY_FIGHT_APPLY,this.onGloryFightApply);
         SocketConnection.addCmdListener(CommandID.GLORY_FIGHT_ROOMINFO,this.onEnterFightRoom);
         SocketConnection.addCmdListener(CommandID.GLORY_FIGHT_CUTDOWN,this.onFightTimeCutDown);
         SocketConnection.addCmdListener(CommandID.GLORY_FIGHT_ROOMINFO_CHANGE,this.onFightRoomInfoChange);
         SocketConnection.addCmdListener(CommandID.GLORY_FIGHT_MATCH,this.onFightMatched);
         SocketConnection.addCmdListener(CommandID.GLORY_FIGHT_ROUND_END,this.onFightRoundEnd);
      }
      
      private function onMapDestroy(param1:MapEvent) : void
      {
         var _loc2_:MapModel = param1.mapModel;
         if(_loc2_.info.id == 1072001)
         {
         }
         if(CutDownTimePanel.instance.isRuning && !CutDownTimePanel.instance.alwaysShow)
         {
            CutDownTimePanel.destroy();
         }
      }
      
      private function onMapSwitchOpen(param1:MapEvent) : void
      {
         var _loc2_:MapModel = param1.mapModel;
         if(_loc2_.info.id < 1004)
         {
            this.gloryFightMapUnLimit();
            this._winTeamID = 0;
            this._boxNum = 0;
         }
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         var _loc2_:MapModel = param1.mapModel;
         if(_loc2_.info.id >= 1004 && _loc2_.info.id <= 1013)
         {
            if(!MapManager.isFightMap)
            {
               HiddenManager.addMoveEventForStandMap();
               HiddenManager.addEventListener(HiddenEvent.OPEN,this.onHidenOpen);
            }
            MapManager.currentMap.contentLevel["wallMC"].visible = false;
            this.gloryFightMapLimit();
            if(!_isInit)
            {
               if(this._winTeamID != 0 && this._winTeamID == MainManager.actorInfo.fightTeamId)
               {
                  this.initAward(this._boxNum);
                  this.showSighModel();
               }
               if(this._winTeamID == 0)
               {
                  this.initMapBlock();
               }
            }
         }
         else if(!MapManager.isFightMap)
         {
            HiddenManager.removeMoveEventForStandMap();
            HiddenManager.removeEventListener(HiddenEvent.OPEN,this.onHidenOpen);
         }
      }
      
      private function initMapBlock() : void
      {
         MapManager.currentMap.updatePathData(760,110,140,415,false);
         MapManager.currentMap.contentLevel["wallMC"].visible = true;
      }
      
      public function clearMapBlock() : void
      {
         MapManager.currentMap.updatePathData(760,110,140,415,true);
         MapManager.currentMap.contentLevel["wallMC"].visible = false;
      }
      
      public function gloryFightMapLimit() : void
      {
         MailSysEntry.instance.hide();
         Battery.instance.hide();
      }
      
      public function gloryFightMapUnLimit() : void
      {
         MailSysEntry.instance.show();
         Battery.instance.show();
      }
      
      public function showSighModel() : void
      {
         var _loc1_:XML = <node id="6" src="101" name="传送楼兰城" pos="840,300" tip="传送楼兰城">
					<materialInfo type="2" src="102"/>
					<funcInfo mapTo="41,0"/>
				</node>;
         var _loc2_:TeleporterModel = new TeleporterModel(_loc1_);
         _loc2_.initView();
         MapManager.currentMap.contentLevel.addChild(_loc2_);
      }
      
      public function initAward(param1:uint = 6) : void
      {
         var _loc3_:UserInfo = null;
         var _loc4_:KeyboardModel = null;
         var _loc2_:uint = 0;
         while(_loc2_ < param1)
         {
            _loc3_ = new UserInfo();
            _loc3_.roleType = 39008;
            _loc3_.userID = Math.random() * 1000000;
            _loc3_.pos = new Point(this.POS_DATA[_loc2_][0],this.POS_DATA[_loc2_][1]);
            _loc3_.nick = "宝箱";
            _loc4_ = new KeyboardModel(_loc3_);
            UserManager.add(_loc3_.userID,_loc4_);
            HiddenManager.add(_loc3_.userID,_loc4_);
            MapManager.currentMap.contentLevel.addChild(_loc4_);
            _loc2_++;
         }
      }
      
      private function onHidenOpen(param1:HiddenEvent) : void
      {
         var _loc2_:uint = uint(param1.state);
         var _loc3_:UserModel = param1.model;
         if(RoleXMLInfo.isKeyboardType(_loc3_.info.roleType))
         {
            if(_loc2_ == HiddenState.STATE_OPEN)
            {
               UserManager.remove(_loc3_.info.userID);
               HiddenManager.remove(_loc3_.info.userID);
               _loc3_.destroy();
               ActivityExchangeCommander.exchange(this.getActorSwapID());
            }
         }
      }
      
      private function getActorSwapID() : uint
      {
         return this.SWAP_IDS[MainManager.actorInfo.roleType - 1];
      }
      
      private function onGloryFightApply(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            AlertManager.showSimpleAlarm("恭喜你小侠士，你已在" + _loc3_ + "号服务器上报名侠士团荣誉之战。快带领你的侠士团参加战斗吧。");
         }
         else
         {
            AlertManager.showSimpleAlarm("对不起，所有服务器已经满了，请稍候再试。");
         }
      }
      
      private function onEnterFightRoom(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == -1)
         {
            AlertManager.showSimpleAlarm("对不起，你的团长还没有报名。");
            return;
         }
         if(_loc3_ > 0)
         {
            AlertManager.showSimpleAlarm("小侠士，请去" + _loc3_ + "号服务器参加战斗。");
            return;
         }
         if(!SystemTimeController.instance.checkSysTimeAchieve(24))
         {
            SystemTimeController.instance.showOutTimeAlert(24);
            return;
         }
         if(_loc4_ != 0)
         {
            if(_loc5_ == 1)
            {
               CityMap.instance.changeMap(_loc4_,0,1,new Point(500 + this.TEAM_DISTANCE,350));
            }
            else
            {
               CityMap.instance.changeMap(_loc4_);
            }
         }
         else
         {
            AlertManager.showSimpleAlarm("小侠士，你的团长还没报名，或不在团长报名参赛的服务器,如果已报名请稍候将为您匹配对战侠士团");
         }
      }
      
      private function onFightTimeCutDown(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         if(!CutDownTimePanel.instance.isRuning)
         {
            CutDownTimePanel.initDetailTime(_loc3_,MainManager.actorInfo.mapID,true);
            TextAlert.show("各团小侠士们请做好准备，比赛将在" + _loc3_ + "秒后开始...");
         }
      }
      
      private function onFightRoomInfoChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         this._boxNum = _loc2_.readUnsignedInt();
         if(_loc3_ == 2)
         {
            _isInit = true;
            CutDownTimePanel.destroy();
            this.clearMapBlock();
            TextAlert.show("比赛正式开始！，小侠士们，为了侠士团的荣誉战斗吧！");
         }
         else if(_loc3_ == 3)
         {
            _isInit = false;
            this._winTeamID = _loc4_;
            if(MainManager.actorInfo.fightTeamId == _loc4_)
            {
               AlertManager.showSimpleAlarm("恭喜你小侠士，你所在的侠士团获得了本次荣誉之战的胜利！快去分享你们的奖励吧。");
               if(!MapManager.isFightMap)
               {
                  this.initAward(this._boxNum);
                  this.showSighModel();
               }
            }
            else
            {
               AlertManager.showSimpleAlarm("很遗憾小侠士，你所在的侠士团没能获得本次荣誉之战的胜利！小侠士们要勤加练习武艺哦。");
            }
         }
      }
      
      private function onFightMatched(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         this._enemyUserID = _loc2_.readUnsignedInt();
         this._enemyCreatTime = _loc2_.readUnsignedInt();
         this._isMatched = true;
         UserManager.addUserListener(UserEvent.PVP_CHANGE,this._enemyUserID,this.initPvPState);
         this.invitePK();
      }
      
      private function invitePK() : void
      {
         SocketSendController.sendPvpInviteCMD(false,PvpIDConstantUtil.TEAM_GLORY_PVP_ID,PvpTypeConstantUtil.PVP_TYPE_INVITE,0);
      }
      
      private function initPvPState(param1:UserEvent) : void
      {
         var _loc2_:uint = uint(param1.type.split(StringConstants.SIGN)[2]);
         UserManager.removeUserListener(UserEvent.PVP_CHANGE,_loc2_,this.initPvPState);
         var _loc3_:uint = uint(int(param1.data));
         if(_loc3_ != 0 && _loc2_ != 0)
         {
            SinglePkManager.instance.openInviteBattery();
            FightWaitPanel.showWaitPanel();
            SocketConnection.send(CommandID.TEAM_INVITE_FRIEND,3,_loc2_,_loc3_,0,0);
         }
      }
      
      private function onFightRoundEnd(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         TextAlert.show(_loc3_ + "在与" + _loc4_ + "荣誉战对阵中获得了胜利。");
      }
      
      public function get enemyUserID() : uint
      {
         return this._enemyUserID;
      }
      
      public function set enemyUserID(param1:uint) : void
      {
         this._enemyUserID = param1;
      }
      
      public function get enemyCreatTime() : uint
      {
         return this._enemyCreatTime;
      }
      
      public function set enemyCreatTime(param1:uint) : void
      {
         this._enemyCreatTime = param1;
      }
      
      public function get isMatched() : Boolean
      {
         return this._isMatched;
      }
      
      public function set isMatched(param1:Boolean) : void
      {
         this._isMatched = param1;
      }
      
      public function isGloryFightMap() : Boolean
      {
         return MapManager.mapInfo.id >= 1004 && MapManager.mapInfo.id <= 1013;
      }
   }
}

