package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.control.SystemTimeController;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.action.BaseAction;
   import com.gfp.core.action.mouse.MouseProcess;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.events.TimeEvent;
   import com.gfp.core.info.ActivityExchangeAwardInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.SolidModel;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.TimeUtil;
   import com.gfp.core.utils.TimerManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   
   public class MapProcess_61 extends BaseMapProcess
   {
      
      private static const SEARCH_JADE_TASK_ID:uint = 1756;
      
      private static const HOUR:uint = 3600;
      
      private static const HALF_HOUR:uint = 1800;
      
      private static const SWAP_JADE_ID:uint = 1376;
      
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
      
      private var _fruitOpenMC:MovieClip;
      
      private var _fruitList:Array = [];
      
      private const FRUITS:Array = [10802,10803,10804,10805];
      
      private const FRUITS_POS:Array = [new Point(717,688),new Point(792,744),new Point(856,695),new Point(792,628)];
      
      public function MapProcess_61()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addCommandListener();
         this.initTask1724();
         this.initHouseView();
         this.initSearchJade();
         this._fruitOpenMC = _mapModel.contentLevel["fruitOpenMC"];
         this._fruitOpenMC.visible = false;
         this._fruitOpenMC.gotoAndStop(1);
         if(TasksManager.isReady(2031))
         {
            AnimatPlay.startAnimat("task2031_",0);
            TasksManager.taskComplete(2031);
         }
      }
      
      private function initHouseView() : void
      {
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
            TasksManager.taskComplete(1724,1);
            this.npc10157.show();
         }
      }
      
      private function addCommandListener() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         ActivityExchangeCommander.instance.closeID(1061);
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchageComplete);
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
      }
      
      private function removeCommandListener() : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         ActivityExchangeCommander.instance.unCloseID(1061);
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchageComplete);
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
      }
      
      private function onExchageComplete(param1:ExchangeEvent) : void
      {
         var _loc2_:ActivityExchangeAwardInfo = param1.info as ActivityExchangeAwardInfo;
         if(_loc2_.id == 1061)
         {
            PveEntry.enterTollgate(952);
         }
         if(_loc2_.id == 1420)
         {
            TextAlert.show("小侠士，你消耗了10000功夫豆。");
         }
         if(_loc2_.id == 1421)
         {
            this.clearAllFruit();
            this.initFruit();
         }
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 1927)
         {
            MouseProcess.execRun(MainManager.actorModel,new Point(650,920));
         }
         if(param1.taskID == 1928)
         {
            CityMap.instance.tranChangeMapByStr("5,521,388");
         }
      }
      
      override public function destroy() : void
      {
         this.removeCommandListener();
         this.destroyJade();
         super.destroy();
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         if(TasksManager.getTaskStatus(1724) == 0 && MainManager.actorInfo.lv >= 20)
         {
            return;
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
               if(Boolean(TasksManager.isAccepted(1927)) && Boolean(TasksManager.isProcess(1927,0)))
               {
                  AnimatPlay.startAnimat("task1759_",0);
                  TasksManager.dispatchActionEvent(TaskActionEvent.TASK_CUSTOM_FINISH,"1927_0");
                  return;
               }
            }
            PveEntry.enterTollgate(this.getEnterTollgateID(this._fruitList[0].info.roleType),1,2);
         }
      }
      
      private function onClickFruit(param1:Event) : void
      {
         var _loc2_:SolidModel = param1.currentTarget as SolidModel;
         var _loc3_:uint = 10000;
         if(MainManager.actorInfo.coins < _loc3_)
         {
            AlertManager.showSimpleAlarm("小侠士，你的功夫豆不足，不能采取果实！");
            return;
         }
         this.clearFruit(_loc2_);
         setTimeout(this.creatFruit,1000,_loc2_.info.pos);
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

