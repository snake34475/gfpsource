package com.gfp.app.manager
{
   import com.gfp.app.cityWar.CityWarBoxController;
   import com.gfp.app.cityWar.CityWarHeadList;
   import com.gfp.app.cityWar.CityWarMatchingPanel;
   import com.gfp.app.cityWar.CityWarOperatePanel;
   import com.gfp.app.cityWar.CityWarPkController;
   import com.gfp.app.cityWar.CityWarType;
   import com.gfp.app.cityWar.TowerController;
   import com.gfp.app.time.CutDownTimePanel;
   import com.gfp.app.toolBar.ActivitySuggestionEntry;
   import com.gfp.app.toolBar.AmbassadorEntry;
   import com.gfp.app.toolBar.Battery;
   import com.gfp.app.toolBar.CityToolBar;
   import com.gfp.app.toolBar.CityWarDataEntry;
   import com.gfp.app.toolBar.CityWarMiniMapEntry;
   import com.gfp.app.toolBar.CommunityTipsEntry;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.app.toolBar.EverydaySignEntry;
   import com.gfp.app.toolBar.GroupHeadInfoEntry;
   import com.gfp.app.toolBar.HonorPanelEntry;
   import com.gfp.app.toolBar.LvlUpAlertEntry;
   import com.gfp.app.toolBar.MailSysEntry;
   import com.gfp.app.toolBar.MallEntry;
   import com.gfp.app.toolBar.TaskTrackPanel;
   import com.gfp.app.toolBar.VipNewEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.data.HitEffInfo;
   import com.gfp.core.action.normal.DieAction;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.controller.MouseController;
   import com.gfp.core.events.CommEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.UserSummonInfos;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.FightMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.PeopleModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.Direction;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import org.taomee.ds.HashMap;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class CityWarManager
   {
      
      private static var _instance:CityWarManager;
      
      public static const MAP_BASE_ID:uint = 1020;
      
      public static const MAP_MAX_ID:uint = 1036;
      
      public static const RED_BASE_MAP:uint = 1035;
      
      public static const BLUE_BASE_MAP:uint = 1036;
      
      public static const CUT_DOWN_MINUTE:uint = 20;
      
      private var _cityWarType:uint;
      
      private var _memberHash:HashMap;
      
      private var _enemyHash:HashMap;
      
      private var _ed:EventDispatcher;
      
      private var _isInCityWar:Boolean;
      
      private var _serveID:uint;
      
      private var _roomID:uint;
      
      private var _teamID:uint;
      
      private var _newMapID:uint;
      
      private var _firstEntry:Boolean = true;
      
      private var _cutDownMc:MovieClip;
      
      private var _waitUserList:HashMap;
      
      public function CityWarManager()
      {
         super();
      }
      
      public static function get instance() : CityWarManager
      {
         if(_instance == null)
         {
            _instance = new CityWarManager();
         }
         return _instance;
      }
      
      public static function isInCityWar() : Boolean
      {
         if(_instance)
         {
            return !_instance._firstEntry;
         }
         return false;
      }
      
      public static function addEventListner(param1:String, param2:Function) : void
      {
         instance.addEventListner(param1,param2);
      }
      
      public static function removeEventListner(param1:String, param2:Function) : void
      {
         instance.removeEventListner(param1,param2);
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
         }
         _instance = null;
      }
      
      public function setup(param1:uint = 0) : void
      {
         this._cityWarType = param1;
         this._isInCityWar = true;
         this._memberHash = new HashMap();
         this._enemyHash = new HashMap();
         this._waitUserList = new HashMap();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,this.onMapSwitchOpen);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         SocketConnection.addCmdListener(CommandID.JOIN_CITY_WAR,this.onWarJoin);
         SocketConnection.addCmdListener(CommandID.CITY_WAR_MEMBER,this.onWarMember);
         SocketConnection.addCmdListener(CommandID.CITY_WAR_BEGIN,this.onFightBegin);
         SocketConnection.addCmdListener(CommandID.CITY_WAR_END,this.onCityWarEnd);
         SocketConnection.addCmdListener(CommandID.CITY_WAR_MAP_ENTER,this.onMapEnter);
         SocketConnection.addCmdListener(CommandID.CITY_WAR_USER_LIST,this.onUserList);
         SocketConnection.addCmdListener(CommandID.CITY_WAR_LEAVE_MAP,this.onLeaveMap);
      }
      
      private function removeEvent() : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,this.onMapSwitchOpen);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         SocketConnection.removeCmdListener(CommandID.JOIN_CITY_WAR,this.onWarJoin);
         SocketConnection.removeCmdListener(CommandID.CITY_WAR_BEGIN,this.onFightBegin);
         SocketConnection.removeCmdListener(CommandID.CITY_WAR_END,this.onCityWarEnd);
         SocketConnection.removeCmdListener(CommandID.CITY_WAR_MAP_ENTER,this.onMapEnter);
         SocketConnection.removeCmdListener(CommandID.CITY_WAR_USER_LIST,this.onUserList);
         SocketConnection.removeCmdListener(CommandID.CITY_WAR_LEAVE_MAP,this.onLeaveMap);
      }
      
      public function signCityWar(param1:uint = 0) : void
      {
         SocketConnection.send(CommandID.JOIN_CITY_WAR,param1);
         this._cityWarType = param1;
      }
      
      private function onMapSwitchOpen(param1:MapEvent) : void
      {
         var _loc2_:uint = uint(FightMap.instance.newMapID);
         if(_loc2_ == 0)
         {
            if(this._firstEntry)
            {
               CityWarMatchingPanel.destroy();
            }
            _loc2_ = this._newMapID;
            SocketConnection.send(CommandID.CITY_WAR_MAP_ENTER,_loc2_);
         }
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         var _loc2_:UserInfo = null;
         if(MapManager.mapInfo.mapType == MapType.STAND)
         {
            if(this._firstEntry)
            {
               this._firstEntry = false;
               if(this._cityWarType != CityWarType.TEAM_TYPE)
               {
                  CityWarHeadList.instance.setup(this._memberHash.getValues());
               }
               this._cutDownMc = new Fight_CountDown_Five();
               LayerManager.topLevel.addChild(this._cutDownMc);
               DisplayUtil.align(this._cutDownMc,null,AlignType.MIDDLE_CENTER);
               this._cutDownMc.gotoAndPlay(1);
               this._cutDownMc.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            }
            else
            {
               MainManager.openOperate();
               MouseController.instance.clear();
            }
            MapManager.currentMap.closeLoading();
            _loc2_ = this._waitUserList.remove(MapManager.mapInfo.id);
            if(_loc2_)
            {
               this.addUserModel(_loc2_,0);
            }
            this.cityWarLimit();
            CityWarBoxController.instance.checkPeopleBuff(MainManager.actorModel);
            SocketConnection.send(CommandID.CITY_WAR_USER_LIST,this._newMapID);
         }
      }
      
      private function onWarJoin(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:UserInfo = new UserInfo();
         _loc6_.overHeadState = _loc2_.readUnsignedInt();
         _loc6_.userID = _loc2_.readUnsignedInt();
         _loc6_.roleType = _loc2_.readUnsignedInt();
         _loc6_.lv = _loc2_.readUnsignedInt();
         _loc6_.nick = _loc2_.readUTFBytes(16);
         if(_loc5_ != this._cityWarType)
         {
            this.quit();
            return;
         }
         if(_loc6_.userID == MainManager.actorID)
         {
            this._serveID = _loc3_;
            this._roomID = _loc4_;
            MainManager.actorInfo.overHeadState = _loc6_.overHeadState;
            this._teamID = _loc6_.overHeadState;
            SocketConnection.send(CommandID.CITY_WAR_MEMBER);
            if(this._cityWarType == CityWarType.TEAM_TYPE)
            {
               TeamCityWarManager.dispatchEvent(new CommEvent(TeamCityWarManager.TEAM_FIGHT_WAIT_DESTORY));
               ModuleManager.turnAppModule("TeamCityWarMatchPanel");
            }
            else if(FightGroupManager.instance.groupId != 0)
            {
               FightGroupManager.instance.ed.dispatchEvent(new CommEvent(FightGroupManager.FIGHT_GROUP_WAIT_DESTORY));
            }
         }
         else if(_loc6_.overHeadState == MainManager.actorInfo.overHeadState)
         {
            this._memberHash.add(_loc6_.userID,_loc6_);
         }
         else
         {
            this._enemyHash.add(_loc6_.userID,_loc6_);
         }
         if(this._cityWarType != CityWarType.TEAM_TYPE)
         {
            CityWarMatchingPanel.instance.addMember(_loc6_);
         }
      }
      
      private function onWarMember(param1:SocketEvent) : void
      {
         var _loc5_:UserInfo = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new UserInfo();
            _loc5_.overHeadState = _loc2_.readUnsignedInt();
            _loc5_.userID = _loc2_.readUnsignedInt();
            _loc5_.roleType = _loc2_.readUnsignedInt();
            _loc5_.lv = _loc2_.readUnsignedInt();
            _loc5_.nick = _loc2_.readUTFBytes(16);
            if(_loc5_.userID != MainManager.actorID)
            {
               if(_loc5_.overHeadState == MainManager.actorInfo.overHeadState)
               {
                  this._memberHash.add(_loc5_.userID,_loc5_);
               }
               else
               {
                  this._enemyHash.add(_loc5_.userID,_loc5_);
               }
               if(this._cityWarType != CityWarType.TEAM_TYPE)
               {
                  CityWarMatchingPanel.instance.addMember(_loc5_);
               }
            }
            _loc4_++;
         }
      }
      
      private function onFightBegin(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         ModuleManager.closeAllModule();
         var _loc5_:uint = MainManager.actorInfo.overHeadState == 1 ? RED_BASE_MAP : BLUE_BASE_MAP;
         this.changeMap(_loc5_);
         TowerController.instance.setup();
         CityWarPkController.instance.setup();
         CityWarMiniMapEntry.instance.setup();
         CityWarOperatePanel.instance.setup();
         CityWarDataEntry.instance.setup();
         CityWarBoxController.instance.setup();
      }
      
      public function changeMap(param1:uint) : void
      {
         this._newMapID = param1;
         CityMap.instance.changeMap(this._newMapID);
      }
      
      public function quit() : void
      {
         SocketConnection.send(CommandID.CITY_WAR_END);
      }
      
      private function onCityWarEnd(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         if(_loc6_ == MainManager.actorID)
         {
            this.destroy();
         }
         else
         {
            CityWarMatchingPanel.removeMember(_loc6_);
            if(this._cityWarType != CityWarType.TEAM_TYPE)
            {
               CityWarHeadList.removeHeadPanel(_loc6_);
            }
            this.removeFromCityWar(_loc6_);
         }
      }
      
      private function onMapEnter(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:UserInfo = UserInfoManager.creatInfo();
         var _loc4_:uint = this.praseMapUser(_loc3_,_loc2_);
         if(_loc3_.userID == MainManager.actorID)
         {
            CityMap.instance.initMap(false);
            MainManager.actorInfo.pos = _loc3_.pos;
            MainManager.actorModel.pos = _loc3_.pos;
            MainManager.actorModel.direction = Direction.indexToStr2(_loc3_.direction);
            MainManager.actorInfo.mapType = MapType.STAND;
            MainManager.actorInfo.mapID = this._newMapID;
         }
         else if(MapManager.currentMap)
         {
            this.addUserModel(_loc3_,_loc4_);
         }
         else
         {
            this._waitUserList.add(this._newMapID,_loc3_);
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this._cutDownMc.currentFrame == this._cutDownMc.totalFrames)
         {
            this._cutDownMc.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            DisplayUtil.removeForParent(this._cutDownMc);
            this._cutDownMc = null;
            CityWarMatchingPanel.destroy();
            MainManager.openOperate();
            MouseController.instance.clear();
            if(!CutDownTimePanel.instance.isRuning)
            {
               CutDownTimePanel.initDetailTime(CUT_DOWN_MINUTE * 60,0,true,true);
               CutDownTimePanel.instance.setPos(110,0);
            }
         }
         else
         {
            MainManager.closeOperate(true);
         }
      }
      
      private function onUserList(param1:SocketEvent) : void
      {
         var _loc6_:UserInfo = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Point = null;
         var _loc10_:Boolean = false;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc6_ = UserInfoManager.creatInfo();
            _loc7_ = this.praseMapUser(_loc6_,_loc2_);
            if(_loc6_.userID != MainManager.actorID)
            {
               this.addUserModel(_loc6_,_loc7_);
            }
            _loc4_++;
         }
         var _loc5_:uint = _loc2_.readUnsignedInt();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_ = _loc2_.readUnsignedInt();
            _loc9_ = new Point();
            _loc9_.x = _loc2_.readUnsignedInt();
            _loc9_.y = _loc2_.readUnsignedInt();
            _loc10_ = _loc2_.readUnsignedInt() == 0;
            if(_loc10_)
            {
               CityWarBoxController.instance.creatBox(_loc8_,_loc9_);
            }
            _loc4_++;
         }
      }
      
      private function praseMapUser(param1:UserInfo, param2:IDataInput) : uint
      {
         var _loc4_:UserSummonInfos = null;
         UserInfo.setForCityWarInfo(param1,param2);
         var _loc3_:uint = param2.readUnsignedInt();
         if(param1.userID != MainManager.actorID)
         {
            _loc4_ = new UserSummonInfos(param1.userID);
            _loc4_.readForShow(param2);
            if(_loc4_.currentSummonInfo)
            {
               SummonManager.setupUserSummonInfo(param1.userID,_loc4_);
            }
         }
         else
         {
            ByteArray(param2).position = ByteArray(param2).position + 32;
         }
         UserInfo.readSimpleEquiptInfo(param1,param2);
         return _loc3_;
      }
      
      private function addUserModel(param1:UserInfo, param2:uint) : void
      {
         var _loc3_:PeopleModel = null;
         if(MapManager.mapInfo.mapType == MapType.STAND)
         {
            if(!UserManager.contains(param1.userID))
            {
               _loc3_ = new PeopleModel(param1);
               if(param2 == 5)
               {
                  MapManager.currentMap.upLevel.addChild(_loc3_);
                  UserManager.add(param1.userID,_loc3_);
               }
               else
               {
                  MapManager.currentMap.addUser(param1.userID,_loc3_);
               }
               if(param2 == 6)
               {
                  _loc3_.actionManager.clear();
                  _loc3_.execAction(new DieAction(ActionXMLInfo.getInfo(40004),new HitEffInfo(),_loc3_.pos));
               }
               if(param2 == 4)
               {
                  _loc3_.changeOverHeadSprite(2);
               }
               CityWarBoxController.instance.checkPeopleBuff(_loc3_);
            }
         }
      }
      
      private function onLeaveMap(param1:SocketEvent) : void
      {
         var _loc5_:UserModel = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         if(_loc4_ != MainManager.actorID)
         {
            if(Boolean(MapManager.mapInfo) && _loc3_ == MapManager.mapInfo.id)
            {
               _loc5_ = UserManager.remove(_loc4_);
               if(_loc5_)
               {
                  _loc5_.destroy();
               }
               _loc5_ = null;
            }
         }
      }
      
      private function cityWarLimit() : void
      {
         MainManager.actorModel.clickEnabled = false;
         GroupHeadInfoEntry.instance.setHeadListVisable(false);
         FunctionManager.disabledTradeHouse = true;
         FunctionManager.disabledMsg = true;
         FunctionManager.disabledFightAwardPanel = true;
         FunctionManager.disabledFightRevive = true;
         CityToolBar.instance.hide();
         ActivitySuggestionEntry.instance.activityShowOrHide(false);
         MallEntry.instance.hide();
         AmbassadorEntry.instance.hide();
         Battery.instance.hide();
         HonorPanelEntry.instance.hide();
         EverydaySignEntry.instance.hide();
         VipNewEntry.instance.hide();
         MailSysEntry.instance.hide();
         DynamicActivityEntry.instance.hide();
         TaskTrackPanel.instance.hide();
         LvlUpAlertEntry.instance.hide();
         CommunityTipsEntry.instance.visible = false;
      }
      
      private function cityWarUnlimit() : void
      {
         MainManager.actorModel.clickEnabled = true;
         GroupHeadInfoEntry.instance.setHeadListVisable(true);
         FunctionManager.disabledTradeHouse = false;
         FunctionManager.disabledMsg = false;
         FunctionManager.disabledFightAwardPanel = false;
         FunctionManager.disabledFightRevive = false;
         CityToolBar.show();
         EverydaySignEntry.instance.show();
         VipNewEntry.instance.show();
         ActivitySuggestionEntry.instance.activityShowOrHide(true);
         MallEntry.instance.show();
         AmbassadorEntry.instance.show();
         Battery.instance.show();
         HonorPanelEntry.instance.show();
         MailSysEntry.instance.show();
         TaskTrackPanel.instance.show();
         DynamicActivityEntry.instance.show();
         LvlUpAlertEntry.instance.show();
         CommunityTipsEntry.instance.visible = true;
      }
      
      public function getUserInfo(param1:uint) : UserInfo
      {
         if(param1 == MainManager.actorID)
         {
            return MainManager.actorInfo;
         }
         if(this._memberHash.containsKey(param1))
         {
            return this._memberHash.getValue(param1);
         }
         if(this._enemyHash.containsKey(param1))
         {
            return this._enemyHash.getValue(param1);
         }
         return null;
      }
      
      public function removeFromCityWar(param1:uint) : void
      {
         if(this._memberHash.containsKey(param1))
         {
            this._memberHash.remove(param1);
         }
         else if(this._enemyHash.containsKey(param1))
         {
            this._enemyHash.remove(param1);
         }
         var _loc2_:UserModel = UserManager.remove(param1);
         if(_loc2_)
         {
            _loc2_.destroy();
            _loc2_ = null;
         }
      }
      
      public function set newMapID(param1:uint) : void
      {
         this._newMapID = param1;
      }
      
      public function get teamID() : uint
      {
         return this._teamID;
      }
      
      public function get cityWarType() : uint
      {
         return this._cityWarType;
      }
      
      public function containMember(param1:uint) : Boolean
      {
         return this._memberHash.containsKey(param1);
      }
      
      private function clearUserList() : void
      {
         this._memberHash.clear();
         this._memberHash = null;
         this._enemyHash.clear();
         this._enemyHash = null;
      }
      
      public function addEventListner(param1:String, param2:Function) : void
      {
         this.ed.addEventListener(param1,param2);
      }
      
      public function removeEventListner(param1:String, param2:Function) : void
      {
         this.ed.removeEventListener(param1,param2);
      }
      
      public function dispatchEvent(param1:Event) : void
      {
         this.ed.dispatchEvent(param1);
      }
      
      private function get ed() : EventDispatcher
      {
         if(this._ed == null)
         {
            this._ed = new EventDispatcher();
         }
         return this._ed;
      }
      
      public function destroy() : void
      {
         this._firstEntry = true;
         this.removeEvent();
         this.cityWarUnlimit();
         this.clearUserList();
         CutDownTimePanel.destroy();
         CityWarHeadList.destroy();
         TowerController.destroy();
         CityWarPkController.destroy();
         CityWarOperatePanel.destroy();
         CityWarMiniMapEntry.destroy();
         CityWarDataEntry.destroy();
         CityWarBoxController.destroy();
         FightGroupManager.instance.groupFightOver();
         MainManager.actorInfo.overHeadState = 0;
         if(MapManager.mapInfo.id >= MAP_BASE_ID && MapManager.mapInfo.id <= MAP_MAX_ID)
         {
            ModuleManager.closeAllModule();
            CityMap.instance.changeMap(30);
         }
      }
   }
}

