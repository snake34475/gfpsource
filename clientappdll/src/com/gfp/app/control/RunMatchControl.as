package com.gfp.app.control
{
   import com.gfp.app.arrowTip.RunDirectionArrow;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.info.RunMatchInfo;
   import com.gfp.core.CommandID;
   import com.gfp.core.buff.BuffInfo;
   import com.gfp.core.buff.IBuff;
   import com.gfp.core.buff.movie.IconBuff;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.NpcXMLInfo;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.config.xml.SkillXMLInfo;
   import com.gfp.core.events.HiddenEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.fight.BuffConfigInfo;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.HiddenManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.KeyboardModel;
   import com.gfp.core.model.MapModel;
   import com.gfp.core.model.SpriteModel;
   import com.gfp.core.model.SummonModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.model.sensemodels.TeleporterModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.HiddenState;
   import com.gfp.core.utils.SpriteType;
   import flash.geom.Point;
   
   public class RunMatchControl
   {
      
      private static var _targetPoint:Point;
      
      private static const START_POS:Point = new Point(1626,533);
      
      public static const PATH_DATA:Array = [7,58,18,15,27,32,33,34,41,54,57,60];
      
      private static const POS_DATA:Array = [[[505,508],[85,720],[418,647]],[[1026,470],[705,627],[385,495]],[[177,386],[600,838],[290,860]],[[1732,432],[1018,755],[560,670]],[[1072,253],[200,560],[770,760]],[[500,788],[1360,1144],[260,340]],[[513,386],[578,1200],[160,1170]],[[888,589],[884,1150],[1770,1441]],[[660,503],[670,788],[380,580]],[[1200,530],[410,590],[993,747]],[[],[],[]],[[],[],[]]];
      
      private static var _playerList:Array = [];
      
      private static var _playStartList:Array = [];
      
      private static var _mapPath:Array = [];
      
      private static var _clearBoxList:Array = [];
      
      private static var _openedBoxList:Array = [];
      
      private static var _onMatch:Boolean = false;
      
      private static const END_NPCID:uint = 10411;
      
      public function RunMatchControl()
      {
         super();
      }
      
      public static function startMatch() : void
      {
         MapManager.addEventListener(MapEvent.USER_ENTER_MAP,onUserEnterMap);
         MapManager.addEventListener(MapEvent.USER_LIST_COMPLETE,onUserListComplete);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onSwitchComplete);
         HiddenManager.addMoveEventForStandMap();
         HiddenManager.addEventListener(HiddenEvent.OPEN,onHidenOpen);
         setOperateDisable(true);
         creatRunBox(7);
         _mapPath = [7];
         MainManager.actorModel.pos = START_POS;
         MainManager.actorModel.execStandAction();
         _onMatch = true;
         hideOtherPlayers();
         initArrowUI();
         ModuleManager.destroy(ClientConfig.getAppModule("RunMatchReadyPanel"));
         ModuleManager.turnAppModule("RunMatchProcessPanel","正在加载...");
      }
      
      public static function endMatch() : void
      {
         MapManager.removeEventListener(MapEvent.USER_ENTER_MAP,onUserEnterMap);
         MapManager.removeEventListener(MapEvent.USER_LIST_COMPLETE,onUserListComplete);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,onSwitchComplete);
         HiddenManager.removeMoveEventForStandMap();
         HiddenManager.removeEventListener(HiddenEvent.OPEN,onHidenOpen);
         setOperateDisable(false);
         _onMatch = false;
         clearMatchPlayers();
         showOtherPlayers();
         RunDirectionArrow.destroy();
         ModuleManager.destroy(ClientConfig.getAppModule("RunMatchProcessPanel"));
      }
      
      public static function get onMatch() : Boolean
      {
         return _onMatch;
      }
      
      public static function chechRunOver() : Boolean
      {
         return _mapPath.length == PATH_DATA.length;
      }
      
      private static function onUserEnterMap(param1:MapEvent) : void
      {
         hideOtherPlayers();
      }
      
      private static function onUserListComplete(param1:MapEvent) : void
      {
         hideOtherPlayers();
      }
      
      private static function onSwitchComplete(param1:MapEvent) : void
      {
         var _loc2_:MapModel = param1.mapModel;
         var _loc3_:uint = uint(_loc2_.info.id);
         var _loc4_:int = PATH_DATA.indexOf(_loc3_);
         if(_loc4_ != -1)
         {
            HiddenManager.addMoveEventForStandMap();
            if(_mapPath.indexOf(_loc3_) == -1)
            {
               _mapPath.push(_loc3_);
            }
            creatRunBox(_loc3_);
            clearWaitRemoveRunBox();
            clearOpenedBoxByMapID(_loc3_);
         }
         initArrowUI();
         ModuleManager.turnAppModule("RunMatchProcessPanel","正在加载...");
      }
      
      private static function initArrowUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:TeleporterModel = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         if(MapManager.mapInfo.mapType != MapType.STAND)
         {
            RunDirectionArrow.instance.hide();
            MainManager.actorModel.removeEventListener(MoveEvent.MOVE,onMove);
         }
         else
         {
            if(MainManager.actorModel.hasEventListener(MoveEvent.MOVE))
            {
               MainManager.actorModel.removeEventListener(MoveEvent.MOVE,onMove);
            }
            MainManager.actorModel.addEventListener(MoveEvent.MOVE,onMove);
            _loc1_ = uint(MapManager.mapInfo.id);
            _loc2_ = PATH_DATA.indexOf(_loc1_);
            if(_loc2_ != -1)
            {
               if(_loc2_ != PATH_DATA.length - 1)
               {
                  _loc3_ = PATH_DATA[_loc2_ + 1];
                  _loc4_ = SightManager.getSightModelList();
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_.length)
                  {
                     if(_loc4_[_loc5_] is TeleporterModel)
                     {
                        _loc6_ = _loc4_[_loc5_] as TeleporterModel;
                        _loc7_ = _loc6_.mapTo;
                        _loc8_ = "";
                        if(_loc7_.indexOf(",") != -1)
                        {
                           _loc8_ = _loc7_.split(",")[0];
                        }
                        else
                        {
                           _loc8_ = _loc7_;
                        }
                        if(_loc8_ == _loc3_)
                        {
                           _targetPoint = _loc6_.pos;
                        }
                     }
                     _loc5_++;
                  }
               }
               else
               {
                  _targetPoint = NpcXMLInfo.getTtranPos(END_NPCID);
               }
               if(_targetPoint)
               {
                  RunDirectionArrow.instance.show();
                  onMove(null);
               }
            }
            else
            {
               _targetPoint = null;
               RunDirectionArrow.instance.hide();
            }
         }
      }
      
      private static function onMove(param1:MoveEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Point = null;
         var _loc5_:Number = NaN;
         var _loc2_:Point = MainManager.actorModel.pos;
         if(_targetPoint)
         {
            _loc3_ = Point.distance(_loc2_,_targetPoint);
            _loc4_ = _targetPoint.subtract(_loc2_);
            _loc5_ = Math.acos(_loc4_.x / _loc3_) * 180 / Math.PI;
            _loc5_ = _loc4_.y > 0 ? _loc5_ : -_loc5_;
            RunDirectionArrow.instance.turnRound(_loc5_);
         }
      }
      
      public static function addPlayerInfo(param1:RunMatchInfo) : void
      {
         _playerList.push(param1);
      }
      
      public static function getPlayersInfo() : Array
      {
         return _playerList;
      }
      
      public static function clearPlayersInfo() : void
      {
         _playerList = [];
      }
      
      public static function execEvent(param1:uint, param2:uint, param3:uint) : void
      {
         var _loc4_:UserModel = UserManager.getModel(param1);
         if(_loc4_ == null)
         {
            return;
         }
         var _loc5_:uint = 140;
         var _loc6_:Boolean = false;
         if(_loc4_.info.userID == MainManager.actorID)
         {
            _loc6_ = true;
         }
         switch(param2)
         {
            case 1:
               if(param3 == 0)
               {
                  _loc4_.speed = _loc5_;
                  removeAllBUff(_loc4_.info.userID);
                  break;
               }
               _loc4_.speed = _loc5_ - 50;
               addBuffIcon(11,_loc4_.info.userID);
               if(_loc6_)
               {
                  TextAlert.show("你获得了减速效果，你的移动速度降低了！");
                  break;
               }
               TextAlert.show("恭喜你，其他侠士获得了减速效果！");
               break;
            case 2:
               if(param3 == 0)
               {
                  _loc4_.speed = _loc5_;
                  removeAllBUff(_loc4_.info.userID);
                  break;
               }
               _loc4_.speed = _loc5_ + 100;
               addBuffIcon(10,_loc4_.info.userID);
               if(_loc6_)
               {
                  TextAlert.show("恭喜你，你获得了加速效果！");
               }
               break;
            case 3:
               if(param3 == 0)
               {
                  _loc4_.speed = _loc5_;
                  removeAllBUff(_loc4_.info.userID);
                  break;
               }
               _loc4_.speed = 0;
               addBuffIcon(34,_loc4_.info.userID);
               if(_loc6_)
               {
                  TextAlert.show("很不幸，你获得了冰冻效果！");
                  break;
               }
               TextAlert.show("恭喜你，其他侠士已经被冻住不能移动了！");
               break;
            case 4:
               if(_loc4_.info.userID == MainManager.actorID)
               {
                  PveEntry.instance.enterTollgate(744);
                  break;
               }
               TextAlert.show("恭喜你，其他侠士已经被拉入关卡战斗了！");
               break;
            default:
               return;
         }
      }
      
      private static function addBuffIcon(param1:uint, param2:uint) : void
      {
         var _loc3_:BuffConfigInfo = SkillXMLInfo.getBuffConfigInfo(param1);
         var _loc4_:BuffInfo = new BuffInfo();
         _loc4_.keyID = param1;
         _loc4_.view = _loc3_.buffViewID;
         _loc4_.layer = _loc3_.buffLayer;
         _loc4_.align = _loc3_.buffAlign;
         _loc4_.name = _loc3_.buffName;
         var _loc5_:IBuff = new IconBuff(_loc4_,false);
         UserManager.execBuff(param2,_loc5_,true);
      }
      
      private static function removebuffIcon(param1:uint, param2:uint) : void
      {
         UserManager.endBuff(param2,param1);
      }
      
      private static function removeAllBUff(param1:uint) : void
      {
         UserManager.endKeyBuff(param1,10);
         UserManager.endKeyBuff(param1,11);
         UserManager.endKeyBuff(param1,34);
      }
      
      public static function creatRunBox(param1:uint) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:UserInfo = null;
         var _loc5_:Array = null;
         var _loc6_:KeyboardModel = null;
         var _loc2_:int = PATH_DATA.indexOf(param1);
         if(_loc2_ != -1)
         {
            _loc3_ = 0;
            while(_loc3_ < 3)
            {
               _loc4_ = new UserInfo();
               _loc4_.roleType = 30025;
               _loc4_.userID = param1 * 100 + _loc3_;
               _loc5_ = POS_DATA[_loc2_];
               _loc4_.pos = new Point(_loc5_[_loc3_][0],_loc5_[_loc3_][1]);
               _loc4_.nick = "竞速比赛宝箱";
               _loc6_ = new KeyboardModel(_loc4_);
               UserManager.add(_loc4_.userID,_loc6_);
               HiddenManager.add(_loc4_.userID,_loc6_);
               MapManager.currentMap.contentLevel.addChild(_loc6_);
               _loc3_++;
            }
         }
      }
      
      public static function addClearBox(param1:uint) : void
      {
         _clearBoxList.push(param1);
      }
      
      public static function addOpenedBox(param1:uint) : void
      {
         _openedBoxList.push(param1);
      }
      
      private static function clearWaitRemoveRunBox() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:UserModel = null;
         var _loc1_:uint = 0;
         while(_loc1_ < _clearBoxList.length)
         {
            _loc2_ = uint(_clearBoxList[_loc1_]);
            _loc3_ = UserManager.getModel(_loc2_);
            if(_loc3_)
            {
               _clearBoxList.splice(_loc1_,1);
               _loc1_--;
               UserManager.remove(_loc3_.info.userID);
               HiddenManager.remove(_loc3_.info.userID);
               _loc3_.destroy();
               addOpenedBox(_loc2_);
            }
            _loc1_++;
         }
      }
      
      private static function clearOpenedBoxByMapID(param1:uint) : void
      {
         var _loc2_:Array = [param1 * 100,param1 * 100 + 1,param1 * 100 + 2];
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_openedBoxList.indexOf(_loc2_[_loc3_]) != -1)
            {
               clearOpenedBoxByID(_loc2_[_loc3_]);
            }
            _loc3_++;
         }
      }
      
      private static function clearOpenedBoxByID(param1:uint) : void
      {
         var _loc2_:UserModel = UserManager.getModel(param1);
         if(_loc2_)
         {
            UserManager.remove(param1);
            HiddenManager.remove(param1);
            _loc2_.destroy();
         }
      }
      
      private static function onHidenOpen(param1:HiddenEvent) : void
      {
         var _loc2_:uint = uint(param1.state);
         var _loc3_:UserModel = param1.model;
         if(RoleXMLInfo.isKeyboardType(_loc3_.info.roleType))
         {
            if(_loc2_ == HiddenState.STATE_OPEN)
            {
               SocketConnection.send(CommandID.RUNMATCH_BOX_EVENT,_loc3_.info.userID);
               UserManager.remove(_loc3_.info.userID);
               HiddenManager.remove(_loc3_.info.userID);
               _loc3_.destroy();
            }
         }
      }
      
      private static function setOperateDisable(param1:Boolean) : void
      {
         FunctionManager.disabledActivityPanel = param1;
         FunctionManager.disabledDemonreCorded = param1;
         FunctionManager.disabledFightTeam = param1;
         FunctionManager.disabledMap = param1;
         FunctionManager.disabledMiniHome = param1;
         FunctionManager.disabledMsg = param1;
         FunctionManager.disabledNewspaper = param1;
         FunctionManager.disabledPickItem = param1;
         FunctionManager.disabledTask = param1;
         FunctionManager.disabledTransfiguration = param1;
         FunctionManager.disabledStorehouse = param1;
         FunctionManager.disabledPvp = param1;
         FunctionManager.disabledTradeHouse = param1;
         FunctionManager.disabledPointTran = param1;
         FunctionManager.disabledChange = param1;
         FunctionManager.disabledMail = param1;
         FunctionManager.disabledGuaranteeTrade = param1;
      }
      
      public static function addStartPlayer(param1:uint) : void
      {
         _playStartList.push(param1);
      }
      
      public static function clearMatchPlayers() : void
      {
         _playStartList = [];
      }
      
      public static function hideOtherPlayers() : void
      {
         SummonManager.eachSummonModel(function(param1:SummonModel):void
         {
            if(_playStartList.indexOf(param1.info.masterID) == -1)
            {
               param1.visible = false;
            }
         });
         UserManager.eachModel(function(param1:UserModel):void
         {
            if(_playStartList.indexOf(param1.info.userID) == -1)
            {
               if(SpriteModel.getSpriteType(param1.info.roleType) == SpriteType.PEOPLE)
               {
                  param1.visible = false;
               }
            }
         });
      }
      
      private static function showOtherPlayers() : void
      {
         SummonManager.eachSummonModel(function(param1:SummonModel):void
         {
            param1.visible = true;
         });
         UserManager.eachModel(function(param1:UserModel):void
         {
            param1.visible = true;
         });
      }
   }
}

