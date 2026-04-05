package com.gfp.app.manager
{
   import com.gfp.app.arrowTip.EscortDirectionArrow;
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.control.OperateControl;
   import com.gfp.app.manager.mapEvents.CommMapEventIds;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.app.toolBar.MiniCityMap;
   import com.gfp.app.toolBar.TimeCountDown;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.EscortXMLInfo;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.config.xml.NpcXMLInfo;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.info.TransportPoint;
   import com.gfp.core.info.escort.EscortDialogInfo;
   import com.gfp.core.info.item.SingleItemInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MagicChangeManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.model.sensemodels.TeleporterModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.TextFormatUtil;
   import com.gfp.core.utils.WallowUtil;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.Delegate;
   
   public class EscortManager extends EventDispatcher
   {
      
      private static var _instance:EscortManager;
      
      public static const SELECT_ESCORT_TYPE:String = "select_escort_type";
      
      public static const ESCORT_START:String = "escort_start";
      
      public static const ESCORT_PROGRESS:String = "escort_progress";
      
      public static const ESCORT_COMPLETE:String = "escort_complete";
      
      public static const ESCORT_OVER:String = "escort_over";
      
      public static var FIXED_ROUTE_TYPE:uint = 2;
      
      public static var SAVE_VILLAGER:uint = 3;
      
      public static var ICE_TRANSPORT:int = 4;
      
      public static var UNSET_NPC_ROUTE:int = 5;
      
      public static var LOVE_TRANS_TYPE:int = 6;
      
      public static var PU_TIAN_TONG_QING:int = 7;
      
      public static var AI_XIN_KAO_YAN:int = 8;
      
      private static var CHOOSE_ROUTE_TYPE:uint = 1;
      
      private static var ESCORT_PATH_FIXED:int = 15;
      
      private static var SWAP_HELP_MIAOMIAO:int = 1874;
      
      private var curRouteType:int;
      
      public var isAttacked:Boolean = false;
      
      public var escortPathId:int = 0;
      
      public var escortItemId:int = 0;
      
      private var _pathID:uint;
      
      private var _startNPC:int;
      
      private var _endNPC:int;
      
      private var _endNPCModel:SightModel;
      
      private var _targetPoint:Point;
      
      private var _nextMapID:uint;
      
      private var _hasFighted:Boolean;
      
      private var _rewardList:Array;
      
      public function EscortManager()
      {
         super();
      }
      
      public static function get instance() : EscortManager
      {
         if(_instance == null)
         {
            _instance = new EscortManager();
         }
         return _instance;
      }
      
      public function selectEscortType(param1:int, param2:int, param3:int = 1) : void
      {
         if(MagicChangeManager.instance.getCurrentInfo())
         {
            TextAlert.show("正在变身中，不能进行该操作！",16711680);
            return;
         }
         if(MapManager.mapInfo.mapType == MapType.TRADE)
         {
            AlertManager.showSimpleAlarm("万博会中不能押镖！");
            return;
         }
         if(MapManager.mapInfo.mapType != MapType.STAND)
         {
            AlertManager.showSimpleAlarm("战斗中不能押镖！");
            return;
         }
         if(this.escortPathId != 0)
         {
            AlertManager.showSimpleAlarm("你已经在押镖中，不能双重押镖！");
            return;
         }
         this.curRouteType = param2;
         SocketConnection.addCmdListener(CommandID.ESCORT_SELECT_ESCORT_TYPE,this.onSelectEscortType);
         SocketConnection.send(CommandID.ESCORT_SELECT_ESCORT_TYPE,param2,param1,param3);
      }
      
      private function onSelectEscortType(param1:SocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc5_:Function = null;
         SocketConnection.removeCmdListener(CommandID.ESCORT_SELECT_ESCORT_TYPE,this.onSelectEscortType);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc3_ = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         switch(this.curRouteType)
         {
            case CHOOSE_ROUTE_TYPE:
               _loc5_ = Delegate.create(this.onAcceptEscort,_loc3_);
               if(_loc4_ > 0)
               {
                  AlertManager.showSimpleAlert("小侠士此次押镖需要押金" + _loc4_ + "功夫豆，确定接镖吗，取消将消耗一次今天的押镖总数",_loc5_,this.onCancle);
                  break;
               }
               _loc5_();
               break;
            case UNSET_NPC_ROUTE:
               this._pathID = _loc3_;
               this.tansToNpc();
               break;
            default:
               this.onAcceptEscort(_loc3_);
         }
      }
      
      private function onAcceptEscort(param1:int) : void
      {
         this.startEscort(param1);
      }
      
      private function onCancle() : void
      {
         this.cancleEscort();
      }
      
      private function tansToNpc() : void
      {
         var _loc1_:TransportPoint = null;
         this._startNPC = EscortXMLInfo.getStartNpcByID(this._pathID);
         if(this._startNPC != 0)
         {
            _loc1_ = new TransportPoint();
            _loc1_.mapId = NpcXMLInfo.getNpcMapId(this._startNPC);
            _loc1_.pos = NpcXMLInfo.getTtranPos(this._startNPC);
            CityMap.instance.tranChangeMap(_loc1_);
            if(Boolean(MapManager.currentMap) && MapManager.currentMap.info.id == _loc1_.mapId)
            {
               MainManager.closeOperate();
               MainManager.actorModel.addEventListener(MoveEvent.MOVE_END,this.onMoveEnd);
            }
            else
            {
               MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
            }
         }
      }
      
      private function onMoveEnd(param1:MoveEvent) : void
      {
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE_END,this.onMoveEnd);
         this.showNpcDialog();
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         this.showNpcDialog();
      }
      
      private function showNpcDialog() : void
      {
         var startDialogs:Array = EscortXMLInfo.getStartDialogs(this._pathID);
         this.escortDialogs(startDialogs,this._startNPC,function():void
         {
            startEscort(_pathID);
         },this.giveUpEscort);
      }
      
      private function escortDialogs(param1:Array, param2:uint, param3:Function, param4:Function = null) : void
      {
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:EscortDialogInfo = null;
         if(param1)
         {
            _loc5_ = new Array();
            _loc6_ = new Array();
            _loc7_ = param1.length;
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc9_ = param1[_loc8_] as EscortDialogInfo;
               _loc5_.push(_loc9_.npcDialogs);
               _loc6_.push(_loc9_.selectDesc);
               _loc8_++;
            }
            NpcDialogController.showForSingles(_loc5_,_loc6_,param2,param3,param4);
         }
      }
      
      public function startEscort(param1:int) : void
      {
         SocketConnection.addCmdListener(CommandID.ESCORT_START,this.onEscortStart);
         this.sendEscort(param1);
      }
      
      public function cancleEscort() : void
      {
         this.sendEscort(0);
      }
      
      private function sendEscort(param1:int) : void
      {
         SocketConnection.send(CommandID.ESCORT_START,param1);
      }
      
      private function onEscortStart(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.ESCORT_START,this.onEscortStart);
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:int = int(_loc2_.readUnsignedInt());
         if(this.curRouteType == CHOOSE_ROUTE_TYPE)
         {
            OperateControl.subCoin(_loc4_);
         }
         else if(this.curRouteType == PU_TIAN_TONG_QING)
         {
            OperateControl.subCoin(_loc4_);
         }
         if(_loc3_ > 0)
         {
            this.setStartEscort(_loc3_,_loc5_);
         }
      }
      
      public function setStartEscort(param1:int, param2:int) : void
      {
         var _loc8_:RegExp = null;
         this.escortPathId = param1;
         this.escortItemId = param2;
         ModuleManager.closeAllModule();
         ItemManager.addItem(this.escortItemId,1);
         var _loc3_:String = ItemXMLInfo.getName(this.escortItemId);
         var _loc4_:int = int(EscortXMLInfo.getEndNpcById(this.escortPathId));
         var _loc5_:String = RoleXMLInfo.getName(_loc4_);
         var _loc6_:String = NpcXMLInfo.getNpcMapNameByNpcId(_loc4_);
         var _loc7_:String = EscortXMLInfo.getStartAlert(this.escortPathId);
         if(_loc7_)
         {
            _loc8_ = /xxx|XXX/g;
            _loc7_ = _loc7_.replace(_loc8_,TextFormatUtil.getRedText(_loc6_ + "【" + _loc5_ + "】"));
         }
         else
         {
            _loc7_ = AppLanguageDefine.GET_AWARD + 1 + AppLanguageDefine.SPECIAL_CHARACTER_SPACE[0] + _loc3_ + ", 请速速运往" + TextFormatUtil.getRedText(_loc6_ + "【" + _loc5_ + "】") + "处";
         }
         AlertManager.showSimpleItemAlarm(_loc7_,ClientConfig.getItemIcon(this.escortItemId));
         CommMapEventManager.addTimerFightEvent();
         MainManager.setOperateDisable(true);
         if(param1 >= 53 || param1 < 64)
         {
            FunctionManager.disabledPvp = false;
         }
         if(this.curRouteType == CHOOSE_ROUTE_TYPE)
         {
            FunctionManager.allowTollgate = [735,736,737];
         }
         else
         {
            FunctionManager.allowTollgate = EscortXMLInfo.getEscortTollgate(param1);
         }
         FunctionManager.evtDispatch.addEventListener(FunctionManager.FUNCTION_DISABLED,this.functionDisabledHandler);
         SocketConnection.addCmdListener(CommandID.REC_FIGHT_EVENT_OVER,this.escortFightResult);
         MiniCityMap.instance.show();
         if(this.curRouteType == UNSET_NPC_ROUTE)
         {
            ActivityExchangeTimesManager.updataTimesByOnce(2621);
            ItemManager.removeItem(1581007,1);
            TimeCountDown.instance.start(600,-70,130);
            TimeCountDown.instance.addEventListener(TimeCountDown.COUNT_DOWN_OVER,this.onTimerComplete);
         }
         dispatchEvent(new DataEvent(ESCORT_START,param1));
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitch);
         this.onMapSwitch(null);
      }
      
      private function onTimerComplete(param1:Event) : void
      {
         TimeCountDown.instance.removeEventListener(TimeCountDown.COUNT_DOWN_OVER,this.onTimerComplete);
         TimeCountDown.destroy();
         AlertManager.showSimpleAlarm("时间已到，小侠士未能完成押镖，下次再接再厉！");
         this.giveUpEscort();
      }
      
      public function giveUpEscort() : void
      {
         SocketConnection.addCmdListener(CommandID.ESCORT_GIVE_UP,this.onEscortGiveUp);
         SocketConnection.send(CommandID.ESCORT_GIVE_UP,this._pathID);
      }
      
      private function onEscortGiveUp(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.ESCORT_GIVE_UP,this.onEscortGiveUp);
         this.overEscor();
      }
      
      private function onMapSwitch(param1:MapEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:TeleporterModel = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         if(MapManager.mapInfo.mapType != MapType.STAND)
         {
            EscortDirectionArrow.instance.hide();
            MainManager.actorModel.removeEventListener(MoveEvent.MOVE,this.onMove);
         }
         else
         {
            MainManager.actorModel.addEventListener(MoveEvent.MOVE,this.onMove);
            _loc2_ = EscortXMLInfo.getEscortPath(this.escortPathId);
            _loc3_ = uint(MapManager.mapInfo.id);
            _loc4_ = _loc2_.indexOf(_loc3_.toString());
            if(_loc4_ != -1)
            {
               if(_loc4_ != _loc2_.length - 1)
               {
                  _loc5_ = _loc2_[_loc4_ + 1];
                  _loc6_ = SightManager.getSightModelList();
                  _loc7_ = 0;
                  while(_loc7_ < _loc6_.length)
                  {
                     if(_loc6_[_loc7_] is TeleporterModel)
                     {
                        _loc8_ = _loc6_[_loc7_] as TeleporterModel;
                        _loc9_ = _loc8_.mapTo;
                        if(_loc9_.indexOf(",") != -1)
                        {
                           _loc10_ = _loc9_.split(",")[0];
                        }
                        else
                        {
                           _loc10_ = _loc9_;
                        }
                        if(_loc10_ == _loc5_)
                        {
                           this._targetPoint = _loc8_.pos;
                        }
                     }
                     _loc7_++;
                  }
                  this._nextMapID = uint(_loc5_);
               }
               else
               {
                  this._endNPC = EscortXMLInfo.getEndNpcById(this.escortPathId);
                  this._endNPCModel = SightManager.getSightModel(this._endNPC);
                  this._endNPCModel.addEventListener(MouseEvent.CLICK,this.onEndNpcClick);
                  this._targetPoint = NpcXMLInfo.getTtranPos(this._endNPC);
                  this._nextMapID = 0;
               }
               if(this._targetPoint)
               {
                  EscortDirectionArrow.instance.show();
                  this.onMove(null);
                  dispatchEvent(new DataEvent(ESCORT_PROGRESS,_loc4_));
               }
            }
            else
            {
               this._targetPoint = null;
               EscortDirectionArrow.instance.hide();
            }
         }
      }
      
      private function onEndNpcClick(param1:MouseEvent) : void
      {
         var _loc2_:Array = EscortXMLInfo.getEndDialogs(this.escortPathId);
         this.escortDialogs(_loc2_,this._endNPC,this.endEscort);
      }
      
      private function onMove(param1:MoveEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Point = null;
         var _loc5_:Number = NaN;
         var _loc2_:Point = MainManager.actorModel.pos;
         if(this._targetPoint)
         {
            _loc3_ = Point.distance(_loc2_,this._targetPoint);
            _loc4_ = this._targetPoint.subtract(_loc2_);
            _loc5_ = Math.acos(_loc4_.x / _loc3_) * 180 / Math.PI;
            _loc5_ = _loc4_.y > 0 ? _loc5_ : -_loc5_;
            EscortDirectionArrow.instance.turnRound(_loc5_);
         }
      }
      
      public function endEscort() : void
      {
         ClientTempState.pvpYaBiaoFirstSelect = 0;
         ClientTempState.pvpYaBiaoSecondSelect = 0;
         SocketConnection.addCmdListener(CommandID.ESCORT_END,this.onEscortEnd);
         if(this.curRouteType == UNSET_NPC_ROUTE)
         {
            SocketConnection.addCmdListener(CommandID.DELAY_ADD_ITEM,this.onAddReward);
         }
         SocketConnection.send(CommandID.ESCORT_END,this.escortPathId);
         if(ActivityExchangeTimesManager.getTimes(12541) == 0)
         {
            ActivityExchangeCommander.exchange(12541);
         }
      }
      
      private function onEscortEnd(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.ESCORT_END,this.onEscortEnd);
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         dispatchEvent(new DataEvent(ESCORT_COMPLETE,_loc3_));
         var _loc4_:uint = uint(EscortXMLInfo.getSwapID(_loc3_));
         if(_loc4_ != 0)
         {
            ActivityExchangeTimesManager.updataTimesByOnce(_loc4_);
         }
         this.overEscor();
      }
      
      private function onAddReward(param1:SocketEvent) : void
      {
         var _loc6_:SingleItemInfo = null;
         SocketConnection.removeCmdListener(CommandID.DELAY_ADD_ITEM,this.onAddReward);
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         this._rewardList = new Array();
         var _loc4_:int = -1;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = new SingleItemInfo(_loc2_);
            this._rewardList.push(_loc6_);
            switch(_loc6_.itemID)
            {
               case 1302001:
                  _loc4_ = 0;
                  break;
               case 1:
                  _loc4_ = 1;
                  break;
               case 1701001:
                  _loc4_ = 2;
                  break;
               case 1500413:
                  _loc4_ = 3;
            }
            _loc5_++;
         }
         _loc4_ = _loc4_ < 0 ? 0 : _loc4_;
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
         AnimatPlay.startAnimat("escortReward_",_loc4_,false,0,0,false,true);
      }
      
      private function onAnimatEnd(param1:AnimatEvent) : void
      {
         var _loc2_:SingleItemInfo = null;
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
         for each(_loc2_ in this._rewardList)
         {
            ItemManager.addItem(_loc2_.itemID,_loc2_.itemNum);
            AlertManager.showSimpleItemAlarmFly(ItemXMLInfo.getName(_loc2_.itemID),ClientConfig.getItemIcon(_loc2_.itemID),{"num":_loc2_.itemNum});
         }
      }
      
      private function functionDisabledHandler(param1:Event) : void
      {
         AlertManager.showSimpleAlarm("小侠士，你正在护送物资，不能进行该操作。");
      }
      
      public function escortFightResult(param1:SocketEvent) : void
      {
         var _loc6_:String = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            _loc6_ = EscortXMLInfo.getFailAlert(_loc4_);
            if(this.curRouteType == CHOOSE_ROUTE_TYPE)
            {
               AlertManager.showSimpleAlarm("小侠士，镖箱已被怪物夺走，下次要努力哦!");
            }
            else if(Boolean(_loc6_) && _loc6_ != "")
            {
               AlertManager.showSimpleAlarm(_loc6_);
            }
            else
            {
               AlertManager.showSimpleAlarm("小侠士，救援物资已经丢失，请重新押运吧！");
            }
            this.overEscor();
         }
      }
      
      private function overEscor() : void
      {
         if(ItemManager.getItemCount(this.escortItemId) > 0)
         {
            ItemManager.removeItem(this.escortItemId,1);
         }
         MainManager.setOperateDisable(false);
         FunctionManager.allowTollgate = [];
         FunctionManager.evtDispatch.removeEventListener(FunctionManager.FUNCTION_DISABLED,this.functionDisabledHandler);
         SocketConnection.removeCmdListener(CommandID.REC_FIGHT_EVENT_OVER,this.escortFightResult);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitch);
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE,this.onMove);
         if(this._endNPCModel)
         {
            this._endNPCModel.removeEventListener(MouseEvent.CLICK,this.onEndNpcClick);
         }
         this._endNPCModel = null;
         EscortDirectionArrow.destroy();
         TimeCountDown.destroy();
         CommMapEventManager.destroyEvtById(CommMapEventIds.TIME_FIGHT);
         this.escortItemId = 0;
         this.escortPathId = 0;
         this._pathID = 0;
         ClientTempState.pvpYaBiaoFirstSelect = 0;
         ClientTempState.pvpYaBiaoSecondSelect = 0;
         this.hasFighted = false;
         dispatchEvent(new Event(ESCORT_OVER));
      }
      
      public function checkLimit() : Boolean
      {
         if(WallowUtil.isWallow())
         {
            WallowUtil.showWallowMsg(AppLanguageDefine.WALLOW_MSG_ARR[18]);
            return true;
         }
         if(MainManager.actorInfo.lv < 35)
         {
            AlertManager.showSimpleAlarm("江湖危险，修炼到35级的侠士才能押镖");
            return true;
         }
         if(this.escortPathId > 0)
         {
            AlertManager.showSimpleAlarm("小侠士你当前正在押镖中");
            return true;
         }
         if(MainManager.actorInfo.changeClothID > 0)
         {
            AlertManager.showSimpleAlarm("小侠士你当前在变身状态下，不能押镖，请先取消变身状态");
            return true;
         }
         if(MainManager.actorInfo.wulinID > 0)
         {
            AlertManager.showSimpleAlarm("小侠士你当前已报名了武林盛典，无法押镖");
            return true;
         }
         if(MagicChangeManager.instance.getCurrentInfo())
         {
            TextAlert.show("正在变身中，不能进行该操作！",16711680);
            return true;
         }
         if(MapManager.mapInfo.mapType == MapType.TRADE)
         {
            AlertManager.showSimpleAlarm("万博会中不能押镖！");
            return true;
         }
         if(MapManager.mapInfo.mapType != MapType.STAND)
         {
            AlertManager.showSimpleAlarm("战斗中不能押镖！");
            return true;
         }
         return false;
      }
      
      public function get targetPoint() : Point
      {
         return this._targetPoint;
      }
      
      public function get endNpcModule() : SightModel
      {
         return this._endNPCModel;
      }
      
      public function get nextMapID() : uint
      {
         return this._nextMapID;
      }
      
      public function get hasFighted() : Boolean
      {
         return this._hasFighted;
      }
      
      public function set hasFighted(param1:Boolean) : void
      {
         var id:uint = 0;
         var value:Boolean = param1;
         if(value != this._hasFighted)
         {
            this._hasFighted = value;
            if(value)
            {
               id = setTimeout(function():void
               {
                  clearTimeout(id);
                  _hasFighted = false;
               },1000 * 60);
            }
         }
      }
   }
}

