package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.PlantAnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.control.SystemTimeController;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.app.toolBar.CityToolBar;
   import com.gfp.app.toolBar.EverydaySignEntry;
   import com.gfp.app.toolBar.MapInfoShow;
   import com.gfp.app.toolBar.RedBlueMasterEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.ActionInfo;
   import com.gfp.core.action.BaseAction;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.config.xml.PlantsXMLInfo;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.events.CommEvent;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.FieldEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.PlantsEvent;
   import com.gfp.core.events.SummonRoomLvlEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TimeEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.ActivityExchangeAwardInfo;
   import com.gfp.core.info.FieldInfo;
   import com.gfp.core.info.PlantsInfo;
   import com.gfp.core.info.SnowmanInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ClampSnowManager;
   import com.gfp.core.manager.HomeSummonManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MiniRoomManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.PlantsModel;
   import com.gfp.core.model.SolidModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.PlantsType;
   import com.gfp.core.utils.SummonRoomType;
   import com.gfp.core.utils.TextUtil;
   import com.gfp.core.utils.TimeUtil;
   import com.gfp.core.utils.TimerManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import org.taomee.ds.HashMap;
   import org.taomee.manager.DepthManager;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_40 extends BaseMapProcess
   {
      
      private static const SEARCH_JADE_TASK_ID:uint = 1756;
      
      private static const HOUR:uint = 3600;
      
      private static const HALF_HOUR:uint = 1800;
      
      private static const SWAP_JADE_ID:uint = 1376;
      
      private const FIELDS_MAX:uint = 8;
      
      private var _summonModelMap:HashMap;
      
      private var _summonList:Array;
      
      private var _enter953:MovieClip;
      
      private var _homeLvlPad:SimpleButton;
      
      private var _padBtn:SimpleButton;
      
      private var _secretTreeMC:MovieClip;
      
      private var _mainMC:MovieClip;
      
      private var _loader:UILoader;
      
      private var _reapAnimation:MovieClip;
      
      private var _currentReapModel:PlantsModel;
      
      private var npc10157:SightModel = SightManager.getSightModel(10157);
      
      private var _1420Count:uint;
      
      private var lastTime:uint;
      
      private var timeInterval:uint;
      
      private var haveJade:Boolean;
      
      private var loader:Loader;
      
      private var loaderInfo:LoaderInfo;
      
      private var exchangeNameList:Array = ["shuitong_mc","hua_mc","yugan_mc"];
      
      private var replaceMcList:Array;
      
      private var replacedMc:DisplayObject;
      
      private var replaceMc:MovieClip;
      
      private var _enterUniverseBtn:SimpleButton;
      
      private var _fruitOpenMC:MovieClip;
      
      private var _currentPos:Point;
      
      private var _fruitList:Array = [];
      
      private const FRUITS:Array = [10802,10803,10804,10805];
      
      private const FRUITS_POS:Array = [new Point(717,688),new Point(792,744),new Point(856,695),new Point(792,628)];
      
      public function MapProcess_40()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._homeLvlPad = _mapModel.contentLevel["homePadHolder"]["homeLvlPad"];
         this.initField();
         this.addCommandListener();
         this.requestCommand();
         this.initTask1724();
         this.initHouseView();
         this.initSearchJade();
      }
      
      private function initHouseView() : void
      {
         CityToolBar.instance.hide();
         EverydaySignEntry.instance.hide();
         RedBlueMasterEntry.instance.hide();
         MapInfoShow.instance.showInSummonRoom();
         this.npc10157 = SightManager.getSightModel(10157);
         if(MainManager.actorInfo.lv < 20)
         {
            this.npc10157.hide();
         }
         else if(TasksManager.isCompleted(1724))
         {
            this.npc10157.show();
         }
         else if(TasksManager.isProcess(1724,1))
         {
            this.npc10157.hide();
         }
      }
      
      private function initTask1724() : void
      {
         if(TasksManager.isAcceptable(1724))
         {
            this.npc10157.hide();
            TasksManager.accept(1724);
         }
         if(Boolean(TasksManager.isTaskProComplete(1724,1)) && !TasksManager.isCompleted(1724))
         {
            ModuleManager.turnModule(ClientConfig.getAppModule("HousekeeperBoard"),"正在加载....");
            TasksManager.taskComplete(1724,1);
            this.npc10157.show();
         }
      }
      
      private function initField() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this.FIELDS_MAX)
         {
            _loc2_ = _mapModel.downLevel["field_" + (_loc1_ + 1)];
            _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,this.onFieldClick);
            _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.onFieldOver);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.onFieldOut);
            MiniRoomManager.addField(_loc1_ + 1,_loc2_);
            _loc1_++;
         }
      }
      
      private function onFieldOver(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.currentTarget as DisplayObject;
         _loc2_.filters = [new GlowFilter(3407616,1,10,10)];
      }
      
      private function onFieldOut(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.currentTarget as DisplayObject;
         _loc2_.filters = null;
      }
      
      private function onFieldClick(param1:MouseEvent) : void
      {
         var _loc2_:uint = uint(String(param1.currentTarget.name).split("_")[1]);
         MiniRoomManager.dispatchEvent(new FieldEvent(FieldEvent.FIELD_CLICK,_loc2_));
         var _loc3_:PlantsModel = MiniRoomManager.getPlantByField(_loc2_);
         if(_loc3_ != null)
         {
            this.reap(_loc3_);
         }
      }
      
      private function disposeField() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.FIELDS_MAX)
         {
            MiniRoomManager.getField(_loc1_ + 1).removeEventListener(MouseEvent.CLICK,this.onFieldClick);
            _loc1_++;
         }
      }
      
      private function requestCommand() : void
      {
         SocketConnection.send(CommandID.MINIROOM_PLANTS_INIT);
      }
      
      private function addCommandListener() : void
      {
         SocketConnection.addCmdListener(CommandID.MINIROOM_PLANTS_INIT,this.onMiniRoomInit);
         SocketConnection.addCmdListener(CommandID.MINIROOM_PLANTS_SOW,this.onPlantSow);
         SocketConnection.addCmdListener(CommandID.MINIROOM_PLANTS_PRO_CHANGE,this.onPlantsProChange);
         SocketConnection.addCmdListener(CommandID.MINIROOM_PLANTS_STATUS_CHANGE,this.onPlantsStatusChange);
         SocketConnection.addCmdListener(CommandID.MINIROOM_PLANTS_REAP,this.onPlantsReap);
         SocketConnection.addCmdListener(CommandID.SUMMON_HOME_ATTR,this.onGetHomeAttr);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         MiniRoomManager.addEventListener(SummonRoomLvlEvent.LVL_UP,this.onLvlUp);
         UserManager.addEventListener(UserEvent.PLANT_CLICK,this.onPlantClick);
         ActivityExchangeCommander.instance.closeID(1061);
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchageComplete);
      }
      
      private function removeCommandListener() : void
      {
         SocketConnection.removeCmdListener(CommandID.MINIROOM_PLANTS_INIT,this.onMiniRoomInit);
         SocketConnection.removeCmdListener(CommandID.MINIROOM_PLANTS_SOW,this.onPlantSow);
         SocketConnection.removeCmdListener(CommandID.MINIROOM_PLANTS_PRO_CHANGE,this.onPlantsProChange);
         SocketConnection.removeCmdListener(CommandID.MINIROOM_PLANTS_STATUS_CHANGE,this.onPlantsStatusChange);
         SocketConnection.removeCmdListener(CommandID.MINIROOM_PLANTS_REAP,this.onPlantsReap);
         SocketConnection.removeCmdListener(CommandID.SUMMON_HOME_ATTR,this.onGetHomeAttr);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         MiniRoomManager.removeEventListener(SummonRoomLvlEvent.LVL_UP,this.onLvlUp);
         UserManager.removeEventListener(UserEvent.PLANT_CLICK,this.onPlantClick);
         ActivityExchangeCommander.instance.unCloseID(1061);
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchageComplete);
      }
      
      private function onPlantClick(param1:UserEvent) : void
      {
         var _loc2_:PlantsModel = param1.data;
         this.reap(_loc2_);
      }
      
      private function onLvlUp(param1:SummonRoomLvlEvent) : void
      {
         var _loc2_:uint = uint(param1.lvl);
         this.setHomeLv(_loc2_);
      }
      
      private function onGetHomeAttr(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         _loc2_.position = 0;
         if(_loc3_ == MainManager.actorInfo.userID && _loc4_ == MainManager.actorInfo.createTime)
         {
            this.setHomeLv(_loc5_);
         }
         else
         {
            HomeSummonManager.instance.addHomeLvl(_loc3_,_loc4_,_loc5_);
            this.setHomeLv(_loc5_);
         }
      }
      
      private function setHomeLv(param1:uint) : void
      {
         if(MiniRoomManager.ownerID == MainManager.actorInfo.userID)
         {
            this._homeLvlPad.addEventListener(MouseEvent.CLICK,this.onHomePad);
         }
         MapInfoShow.instance.setRoomText(MiniRoomManager.ownerNick + "的家园",param1);
         MiniRoomManager.roomLv = param1;
      }
      
      private function onHomePad(param1:MouseEvent) : void
      {
         ModuleManager.turnModule(ClientConfig.getAppModule("SummonRoomMemoPad"),"正在加载......");
      }
      
      private function onAnimateEnd(param1:AnimatEvent) : void
      {
         var _loc2_:uint = uint(param1.data);
         this._secretTreeMC.visible = true;
         PlantAnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimateEnd);
         DepthManager.swapDepthAll(MapManager.currentMap.contentLevel);
         if(ItemManager.getItemCount(1500383) > 1)
         {
            PveEntry.enterTollgate(952);
         }
         else
         {
            ActivityExchangeCommander.exchange(1061);
         }
      }
      
      private function onExchageComplete(param1:ExchangeEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc2_:ActivityExchangeAwardInfo = param1.info as ActivityExchangeAwardInfo;
         if(_loc2_.id == 1061)
         {
            PveEntry.enterTollgate(952);
         }
         if(_loc2_.id == 1420)
         {
            ++this._1420Count;
            _loc3_ = uint(ActivityExchangeTimesManager.getTimes(1420));
            _loc4_ = MainManager.actorInfo.lv * (4 + _loc3_) * 10;
            _loc4_ = _loc4_ < 1000 ? 1000 : _loc4_;
            _loc5_ = "";
            if(this._1420Count == 10)
            {
               _loc5_ = "隔天来摘除果实消耗功夫豆会降低";
               this._1420Count = 0;
            }
            TextAlert.show("小侠士，你消耗了" + _loc4_ + "功夫豆。" + _loc5_);
         }
         if(_loc2_.id == 1421)
         {
            this.clearAllFruit();
            this.initFruit();
            this._fruitOpenMC.mouseEnabled = true;
            this._fruitOpenMC.mouseChildren = true;
         }
      }
      
      private function onMiniRoomInit(param1:SocketEvent) : void
      {
         var _loc5_:PlantsInfo = null;
         var _loc6_:FieldInfo = null;
         var _loc7_:PlantsModel = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new PlantsInfo();
            PlantsInfo.setForPlantsInfo(_loc5_,_loc2_);
            _loc5_.serverID = MainManager.serverID;
            if(_loc5_.fieldID <= 8)
            {
               _loc6_ = new FieldInfo();
               PlantsInfo.setForFieldInfo(_loc6_,_loc5_);
               _loc7_ = new PlantsModel(_loc5_);
               MiniRoomManager.add(_loc5_.fieldID,_loc7_);
               MiniRoomManager.addFieldInfo(_loc6_.fieldID,_loc6_);
               MapManager.currentMap.addUser(_loc5_.fieldID,_loc7_);
            }
            _loc4_++;
         }
      }
      
      private function onPlantSow(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:FieldInfo = new FieldInfo(_loc2_);
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:PlantsInfo = new PlantsInfo();
         _loc5_.fieldID = _loc3_.fieldID;
         _loc5_.roleType = _loc3_.plantID;
         _loc5_.userID = _loc3_.uniqueID;
         _loc5_.plantsStatus = PlantsType.BEAN;
         var _loc6_:MovieClip = MiniRoomManager.getField(_loc3_.fieldID);
         _loc5_.pos = PlantsXMLInfo.getPos(_loc3_.fieldID);
         _loc5_.nick = PlantsXMLInfo.getName(_loc3_.plantID);
         var _loc7_:PlantsModel = new PlantsModel(_loc5_);
         MiniRoomManager.add(_loc5_.fieldID,_loc7_);
         MiniRoomManager.addFieldInfo(_loc3_.fieldID,_loc3_);
         MapManager.currentMap.addUser(_loc5_.fieldID,_loc7_);
         ItemManager.removeItem(_loc4_,1);
         MiniRoomManager.dispatchEvent(new PlantsEvent(PlantsEvent.SEED_COMPLETE,null));
      }
      
      private function onPlantsProChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         var _loc7_:uint = _loc2_.readUnsignedInt();
         ItemManager.removeItem(_loc7_,1);
         if(_loc6_ == 2)
         {
            MiniRoomManager.dispatchEvent(new PlantsEvent(PlantsEvent.MANURE_COMPLETE,null));
         }
         else
         {
            MiniRoomManager.dispatchEvent(new PlantsEvent(PlantsEvent.WATER_COMPLETE,null));
         }
      }
      
      private function onPlantsStatusChange(param1:SocketEvent) : void
      {
         var _loc8_:PlantsInfo = null;
         var _loc9_:MovieClip = null;
         var _loc10_:PlantsModel = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:FieldInfo = new FieldInfo(_loc2_);
         var _loc4_:PlantsModel = MiniRoomManager.getPlantByField(_loc3_.fieldID);
         if(_loc4_ == null)
         {
            _loc8_ = new PlantsInfo();
            _loc8_.fieldID = _loc3_.fieldID;
            _loc8_.roleType = _loc3_.plantID;
            _loc8_.userID = _loc3_.uniqueID;
            _loc8_.plantsStatus = PlantsType.BEAN;
            _loc9_ = MiniRoomManager.getField(_loc3_.fieldID);
            _loc8_.pos = PlantsXMLInfo.getPos(_loc3_.fieldID);
            _loc8_.nick = PlantsXMLInfo.getName(_loc3_.plantID);
            _loc10_ = new PlantsModel(_loc8_);
            MiniRoomManager.add(_loc8_.fieldID,_loc10_);
            MiniRoomManager.addFieldInfo(_loc3_.fieldID,_loc3_);
            MapManager.currentMap.addUser(_loc8_.fieldID,_loc10_);
         }
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         var _loc7_:uint = _loc2_.readUnsignedInt();
         MiniRoomManager.addFieldInfo(_loc3_.fieldID,_loc3_);
         MiniRoomManager.execStatusChange(_loc3_.fieldID,_loc5_,_loc6_,_loc7_);
      }
      
      private function onPlantsReap(param1:SocketEvent) : void
      {
         var _loc8_:String = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:String = ItemXMLInfo.getName(_loc4_);
         if(_loc4_ != 0 && _loc5_ != 0)
         {
            _loc8_ = AppLanguageDefine.GET_AWARD + _loc5_ + AppLanguageDefine.SPECIAL_CHARACTER_SPACE[0] + _loc6_;
            AlertManager.showSimpleItemAlarm(_loc8_,ClientConfig.getItemIcon(_loc4_),this.resetReap);
            ItemManager.addItem(_loc4_,_loc5_);
            MiniRoomManager.dispatchEvent(new PlantsEvent(PlantsEvent.REAP_COMPLETE,null));
         }
         var _loc7_:PlantsModel = MiniRoomManager.getModel(_loc3_);
         if((Boolean(_loc7_)) && Boolean(_loc7_.info.roleType == 90005) && MainManager.actorInfo.inSummonRoom == SummonRoomType.OTHER)
         {
            _loc7_.hide();
            PlantAnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimateEnd);
            PlantAnimatPlay.startAnimat("Plant_90005_3",_loc7_.info.userID,false,_loc7_.x,_loc7_.y - 20,MapManager.currentMap.contentLevel,true);
            return;
         }
         if(_loc4_ == 0 || _loc5_ == 0)
         {
            AlertManager.showSimpleAlarm("采集失败，请稍后采集");
            return;
         }
      }
      
      private function resetReap() : void
      {
         MiniRoomManager.dispatchEvent(new PlantsEvent(PlantsEvent.REAP_RESET,null));
      }
      
      override public function destroy() : void
      {
         this._homeLvlPad.removeEventListener(MouseEvent.CLICK,this.onHomePad);
         this._homeLvlPad = null;
         HomeSummonManager.instance.destorySummon();
         this.removeCommandListener();
         this.disposeField();
         MapInfoShow.instance.hideOutSummonRoom();
         this.destorySnowman();
         this._currentReapModel = null;
         this._reapAnimation = null;
         this.destroyJade();
         this.clearAllFruit();
         super.destroy();
      }
      
      private function onEnter953(param1:MouseEvent) : void
      {
         this._enter953.gotoAndPlay(181);
         this._enter953.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(param1.currentTarget == this._enter953)
         {
            if(this._enter953.currentFrame == this._enter953.totalFrames)
            {
               this._enter953.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
               PveEntry.enterTollgate(953);
            }
         }
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         HomeSummonManager.instance.requestHomeSummon();
         if(TasksManager.getTaskStatus(1724) == 0 && MainManager.actorInfo.lv >= 20)
         {
            return;
         }
         ModuleManager.turnModule(ClientConfig.getAppModule("SummonRoomBarPanel"),"正在加载....");
      }
      
      private function reap(param1:PlantsModel) : void
      {
         this._currentReapModel = param1;
         this.playReapAnimation();
      }
      
      public function playReapAnimation() : void
      {
         if(this._reapAnimation == null)
         {
            this._reapAnimation = UIManager.getMovieClip("ReapAnimation");
         }
         MainManager.closeOperate(true);
         this._reapAnimation.addEventListener(Event.ENTER_FRAME,this.onReapAnimation);
         this._reapAnimation.x = this._currentReapModel.x - 20;
         this._reapAnimation.y = this._currentReapModel.y - this._currentReapModel.height - 60;
         this._reapAnimation.gotoAndPlay(2);
         MapManager.currentMap.contentLevel.addChild(this._reapAnimation);
      }
      
      private function onReapAnimation(param1:Event) : void
      {
         var _loc2_:PlantsInfo = null;
         if(this._reapAnimation.currentFrame == this._reapAnimation.totalFrames)
         {
            MainManager.openOperate();
            this._reapAnimation.removeEventListener(Event.ENTER_FRAME,this.onReapAnimation);
            DisplayUtil.removeForParent(this._reapAnimation);
            _loc2_ = this._currentReapModel.plantsInfo;
            SocketConnection.send(CommandID.MINIROOM_PLANTS_REAP,_loc2_.fieldID,PlantsXMLInfo.getFruitID(_loc2_.roleType));
         }
      }
      
      private function initSnowMan() : void
      {
         ClampSnowManager.eventDispatch.addEventListener(ClampSnowManager.CLAMP_SNOWMAN_GET_INFO,this.whenGetSnowmanInfoHandler);
         ClampSnowManager.eventDispatch.addEventListener(ClampSnowManager.CLAMP_SNOWMAN_STATE_CHANGE,this.whenSnowStateChange);
         ClampSnowManager.getSnowmanInfo(MiniRoomManager.ownerID,MiniRoomManager.createTime);
      }
      
      private function destorySnowman() : void
      {
         ClampSnowManager.eventDispatch.removeEventListener(ClampSnowManager.CLAMP_SNOWMAN_GET_INFO,this.whenGetSnowmanInfoHandler);
         ClampSnowManager.eventDispatch.removeEventListener(ClampSnowManager.CLAMP_SNOWMAN_STATE_CHANGE,this.whenSnowStateChange);
      }
      
      private function whenGetSnowmanInfoHandler(param1:CommEvent) : void
      {
         var _loc3_:SnowmanInfo = null;
         var _loc4_:UserInfo = null;
         var _loc5_:SolidModel = null;
         var _loc6_:ActionInfo = null;
         ClampSnowManager.eventDispatch.removeEventListener(ClampSnowManager.CLAMP_SNOWMAN_GET_INFO,this.whenGetSnowmanInfoHandler);
         var _loc2_:int = 0;
         while(_loc2_ < ClampSnowManager.snowmanList.length)
         {
            _loc3_ = ClampSnowManager.snowmanList[_loc2_] as SnowmanInfo;
            _loc4_ = new UserInfo();
            _loc4_.roleType = 10163;
            _loc4_.pos = new Point(780,560);
            _loc4_.direction = 0;
            _loc4_.nick = "小雪人";
            _loc4_.actionID = _loc3_.snowmanTime;
            _loc5_ = new SolidModel(_loc4_);
            _loc5_.clickEnabled = false;
            _loc5_.mouseEnabled = true;
            _loc5_.buttonMode = true;
            MapManager.currentMap.addUser(_loc3_.snowmanTime,_loc5_);
            _loc6_ = ActionXMLInfo.getInfo(10001);
            _loc5_.execAction(new BaseAction(_loc6_));
            _loc5_.addEventListener(MouseEvent.CLICK,this.whenSnowManClickHandler);
            _loc2_++;
         }
         this.whenSnowStateChange();
      }
      
      private function whenSnowStateChange(param1:CommEvent = null) : void
      {
         var _loc3_:SnowmanInfo = null;
         var _loc4_:UserModel = null;
         var _loc5_:ActionInfo = null;
         var _loc2_:int = 0;
         while(_loc2_ < ClampSnowManager.snowmanList.length)
         {
            _loc3_ = ClampSnowManager.snowmanList[_loc2_] as SnowmanInfo;
            _loc4_ = UserManager.getModel(_loc3_.snowmanTime);
            if(_loc3_.snowmanSchedule < 50)
            {
               _loc5_ = ActionXMLInfo.getInfo(10001);
            }
            else
            {
               _loc5_ = ActionXMLInfo.getInfo(10021);
            }
            if(_loc3_.snowmanState >= 1)
            {
               _loc5_ = ActionXMLInfo.getInfo(10022);
            }
            _loc4_.execAction(new BaseAction(_loc5_));
            _loc2_++;
         }
      }
      
      private function whenSnowManClickHandler(param1:MouseEvent) : void
      {
         var _loc3_:SnowmanInfo = null;
         var _loc2_:UserModel = param1.currentTarget as UserModel;
         for each(_loc3_ in ClampSnowManager.snowmanList)
         {
            if(_loc3_.snowmanTime == _loc2_.info.actionID)
            {
               ModuleManager.turnModule(ClientConfig.getAppModule("ClampSnowman"),"...",_loc3_);
            }
         }
      }
      
      private function initSearchJade() : void
      {
         if(TasksManager.isAccepted(SEARCH_JADE_TASK_ID))
         {
            if(SystemTimeController.instance.checkSysTimeAchieve(12))
            {
               this.timeInterval = HALF_HOUR;
            }
            else
            {
               this.timeInterval = HOUR;
            }
            TimerManager.ed.addEventListener(TimeEvent.TIMER_EVERY_MINUTE,this.everyMinuteHandler);
            this.everyMinuteHandler();
         }
      }
      
      private function everyMinuteHandler(param1:TimeEvent = null) : void
      {
         var _loc2_:uint = 0;
         if(!this.haveJade)
         {
            this.lastTime = TasksManager.getTaskProBytes(SEARCH_JADE_TASK_ID,1).readUnsignedInt();
            _loc2_ = TimeUtil.getSeverDateObject().getTime() / 1000 - this.lastTime;
            if(_loc2_ >= this.timeInterval)
            {
               this.haveJade = true;
               this.roundJadePostion();
            }
         }
      }
      
      private function roundJadePostion() : void
      {
         var _loc1_:uint = 0;
         if(this.loaderInfo)
         {
            _loc1_ = Math.floor(Math.random() * 3);
            if(this.replaceMcList[_loc1_])
            {
               this.replaceMc = this.replaceMcList[_loc1_];
            }
            else
            {
               this.replaceMc = DisplayObjectContainer(this.loaderInfo.content).getChildByName(this.exchangeNameList[_loc1_]) as MovieClip;
               this.replaceMcList[_loc1_] = this.replaceMc;
            }
            this.replacedMc = _mapModel.contentLevel.getChildByName(this.exchangeNameList[_loc1_]);
            _mapModel.swapContentLayerChild(this.replacedMc,this.replaceMc);
            this.replaceMc.stop();
            this.replaceMc.buttonMode = true;
            this.replaceMc.addEventListener(MouseEvent.CLICK,this.getJadeHandler);
         }
         else
         {
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loaderCompleteHandler);
            this.loader.load(new URLRequest(ClientConfig.getCartoon("task" + SEARCH_JADE_TASK_ID + "_1")));
         }
      }
      
      private function getJadeHandler(param1:MouseEvent) : void
      {
         this.replaceMc.removeEventListener(MouseEvent.CLICK,this.getJadeHandler);
         this.replaceMc.play();
         this.replaceMc.addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
      }
      
      private function enterFrameHandler(param1:Event) : void
      {
         if(this.replaceMc.currentFrame == this.replaceMc.totalFrames)
         {
            this.replaceMc.stop();
            this.replaceMc.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
            ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.getJadeCompleteHandler);
            ActivityExchangeCommander.exchange(SWAP_JADE_ID);
         }
      }
      
      private function getJadeCompleteHandler(param1:ExchangeEvent) : void
      {
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.getJadeCompleteHandler);
         var _loc2_:uint = TimeUtil.getSeverDateObject().getTime() / 1000;
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeUnsignedInt(_loc2_);
         TasksManager.setTaskProBytes(SEARCH_JADE_TASK_ID,1,_loc3_);
         _mapModel.swapContentLayerChild(this.replaceMc,this.replacedMc);
         this.haveJade = false;
      }
      
      private function loaderCompleteHandler(param1:Event) : void
      {
         this.loaderInfo = param1.target as LoaderInfo;
         this.loaderInfo.removeEventListener(Event.COMPLETE,this.loaderCompleteHandler);
         this.replaceMcList = [];
         this.roundJadePostion();
      }
      
      private function destroyJade() : void
      {
         if(this.loader)
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.loaderCompleteHandler);
         }
         TimerManager.ed.removeEventListener(TimeEvent.TIMER_EVERY_MINUTE,this.everyMinuteHandler);
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.getJadeCompleteHandler);
         if(this.replaceMc)
         {
            this.replaceMc.removeEventListener(MouseEvent.CLICK,this.getJadeHandler);
            this.replaceMc.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
         }
         this.replaceMc = null;
      }
      
      private function initUniverse() : void
      {
         if(_mapModel)
         {
            this._enterUniverseBtn = _mapModel.contentLevel["enterUniverseBtn"];
            if(this._enterUniverseBtn)
            {
               this._enterUniverseBtn.addEventListener(MouseEvent.CLICK,this.onUniverseClick);
            }
         }
      }
      
      private function onUniverseClick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         if(!MiniRoomManager.isSelfMiniRoom())
         {
            AlertManager.showSimpleAlert("小侠士只有在自己的家园里才能开始阵法，是否现在回到自己的家园",this.onGoSelfMiniRoom);
            return;
         }
         if(SystemTimeController.instance.checkSysTimeAchieve(19))
         {
            if(UserManager.getCurMapPlayerNum() >= 2)
            {
               CityMap.instance.leaveMiniRoom(0,0,2,715,1);
            }
            else
            {
               _loc2_ = TextUtil.getAppModelHref(1,"CatchUniverseDesc","点我查看活动详情");
               AlertManager.showSimpleAlarm("阵法开启时需要家园中有2名侠士助阵，小侠士可邀请好友来助阵，" + _loc2_);
            }
         }
         else
         {
            SystemTimeController.instance.showOutTimeAlert(19);
         }
      }
      
      private function onGoSelfMiniRoom() : void
      {
         CityMap.instance.inOtherMiniRoomEnterSelfMiniRoom();
      }
      
      private function initFruit() : void
      {
         var _loc2_:UserInfo = null;
         var _loc3_:SolidModel = null;
         var _loc1_:uint = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = new UserInfo();
            _loc2_.roleType = this.FRUITS[_loc1_];
            _loc2_.pos = this.FRUITS_POS[_loc1_];
            _loc2_.nick = RoleXMLInfo.getName(_loc2_.roleType);
            _loc2_.createTime = Math.random() * 1000000;
            _loc3_ = new SolidModel(_loc2_);
            this._fruitList.push(_loc3_);
            _loc3_.clickEnabled = false;
            _loc3_.mouseEnabled = true;
            _loc3_.buttonMode = true;
            UserManager.add(_loc2_.createTime,_loc3_);
            MapManager.currentMap.upLevel.addChild(_loc3_);
            _loc3_.addEventListener(MouseEvent.CLICK,this.onClickFruit);
            _loc3_.addEventListener(MouseEvent.MOUSE_OVER,this.onOverFruit);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.onOutFruit);
            _loc1_++;
         }
         if(this.checkSameType())
         {
            this._fruitOpenMC.gotoAndStop(2);
         }
         else
         {
            this._fruitOpenMC.gotoAndStop(1);
         }
         this._fruitOpenMC.addEventListener(MouseEvent.CLICK,this.onFruitOpenClick);
      }
      
      private function onFruitOpenClick(param1:Event) : void
      {
         if(this._fruitOpenMC.currentFrame == 1)
         {
            ModuleManager.turnAppModule("DescPeachPanel","");
         }
         else if(this.checkSameType())
         {
            if(this._fruitList[0].info.roleType == 10802)
            {
               if(Boolean(TasksManager.isAccepted(1759)) && Boolean(TasksManager.isProcess(1759,0)))
               {
                  AnimatPlay.startAnimat("task1759_",0);
                  TasksManager.dispatchActionEvent(TaskActionEvent.TASK_CUSTOM_FINISH,"1759_0");
                  return;
               }
            }
            CityMap.instance.leaveMiniRoom(0,0,2,this.getEnterTollgateID(this._fruitList[0].info.roleType),1);
         }
      }
      
      private function onClickFruit(param1:Event) : void
      {
         var confirm:Function;
         var model:SolidModel = null;
         var e:Event = param1;
         model = e.currentTarget as SolidModel;
         var time:uint = ActivityExchangeTimesManager.getTimes(1420) + 1;
         var costCoins:uint = MainManager.actorInfo.lv * (4 + time) * 10;
         costCoins = costCoins < 1000 ? 1000 : costCoins;
         if(MainManager.actorInfo.coins < costCoins)
         {
            AlertManager.showSimpleAlarm("小侠士，你的功夫都不足，不能采取果实！");
            return;
         }
         confirm = function():void
         {
            ClientTempState.isReapFruitAlert = true;
            clearFruit(model);
            setTimeout(creatFruit,1000,model.info.pos);
            ActivityExchangeCommander.exchange(1420);
         };
         if(!ClientTempState.isReapFruitAlert)
         {
            AlertManager.showSimpleAlert("采摘果实有概率获得4种相同的水果，第一次摘除果实需要" + costCoins + "功夫豆，之后每次消耗的功夫豆将会递增，你确定要摘除么？",confirm);
            return;
         }
         this.clearFruit(model);
         setTimeout(this.creatFruit,1000,model.info.pos);
         ActivityExchangeCommander.exchange(1420);
      }
      
      private function clearFruit(param1:SolidModel) : void
      {
         param1.execAction(new BaseAction(ActionXMLInfo.getInfo(40004),false));
         this.removeFruitFromList(param1.info);
         UserManager.remove(param1.info.createTime);
         param1.removeEventListener(MouseEvent.CLICK,this.onClickFruit);
         param1.removeEventListener(MouseEvent.MOUSE_OVER,this.onOverFruit);
         param1.removeEventListener(MouseEvent.MOUSE_OUT,this.onOutFruit);
         param1.delayDestroy(1000);
      }
      
      private function clearAllFruit() : void
      {
         var _loc1_:SolidModel = null;
         for each(_loc1_ in this._fruitList)
         {
            UserManager.remove(_loc1_.info.createTime);
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onClickFruit);
            _loc1_.removeEventListener(MouseEvent.MOUSE_OVER,this.onOverFruit);
            _loc1_.removeEventListener(MouseEvent.MOUSE_OUT,this.onOutFruit);
            _loc1_.destroy();
         }
         this._fruitList.length = 0;
      }
      
      private function creatFruit(param1:Point) : void
      {
         var _loc2_:UserInfo = new UserInfo();
         _loc2_.roleType = this.FRUITS[int(Math.random() * this.FRUITS.length)];
         _loc2_.pos = param1;
         _loc2_.nick = RoleXMLInfo.getName(_loc2_.roleType);
         _loc2_.createTime = new Date().getTime();
         var _loc3_:SolidModel = new SolidModel(_loc2_);
         this.addFruitToList(_loc3_);
         _loc3_.clickEnabled = false;
         _loc3_.mouseEnabled = true;
         _loc3_.buttonMode = true;
         UserManager.add(_loc2_.createTime,_loc3_);
         MapManager.currentMap.upLevel.addChild(_loc3_);
         _loc3_.addEventListener(MouseEvent.CLICK,this.onClickFruit);
         _loc3_.addEventListener(MouseEvent.MOUSE_OVER,this.onOverFruit);
         _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.onOutFruit);
         if(this.checkSameType())
         {
            this._fruitOpenMC.gotoAndStop(2);
         }
         else
         {
            this._fruitOpenMC.gotoAndStop(1);
         }
      }
      
      private function removeFruitFromList(param1:UserInfo) : void
      {
         var _loc3_:UserInfo = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this._fruitList.length)
         {
            _loc3_ = (this._fruitList[_loc2_] as SolidModel).info;
            if(param1.roleType == _loc3_.roleType && param1.createTime == _loc3_.createTime)
            {
               this._fruitList.splice(_loc2_,1);
               return;
            }
            _loc2_++;
         }
      }
      
      private function addFruitToList(param1:SolidModel) : void
      {
         this._fruitList.push(param1);
      }
      
      private function checkSameType() : Boolean
      {
         if(this._fruitList.length != 4)
         {
            return false;
         }
         var _loc1_:uint = 1;
         while(_loc1_ < this._fruitList.length)
         {
            if(this._fruitList[_loc1_ - 1].info.roleType != this._fruitList[_loc1_].info.roleType)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      private function getEnterTollgateID(param1:uint) : uint
      {
         if(param1 == 10802)
         {
            return 716;
         }
         return 717;
      }
      
      private function onOverFruit(param1:Event) : void
      {
         var _loc2_:SolidModel = param1.currentTarget as SolidModel;
         _loc2_.execAction(new BaseAction(ActionXMLInfo.getInfo(10010),false));
      }
      
      private function onOutFruit(param1:Event) : void
      {
         var _loc2_:SolidModel = param1.currentTarget as SolidModel;
         _loc2_.execAction(new BaseAction(ActionXMLInfo.getInfo(10001),false));
      }
   }
}

