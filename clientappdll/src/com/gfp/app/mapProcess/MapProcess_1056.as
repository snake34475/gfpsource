package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightAdded;
   import com.gfp.app.info.dialog.DialogInfoMultiple;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.app.toolBar.CityToolBar;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.app.toolBar.TootalExpBar;
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.FocusKeyController;
   import com.gfp.core.controller.KeyController;
   import com.gfp.core.controller.MouseController;
   import com.gfp.core.controller.ToolBarQuickKey;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MagicChangeManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TimeIntervalManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.Direction;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1056 extends BaseMapProcess
   {
      
      private var npc:SightModel;
      
      private var startMC:InteractiveObject;
      
      private var _stopByNPC:Boolean;
      
      private var _isZazen:Boolean;
      
      private var originalPosition:Point = new Point();
      
      private var _zazenLeftTime:int;
      
      private var timer:int;
      
      public function MapProcess_1056()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.startMC = _mapModel.downLevel["startMC"];
         this.npc = SightManager.getSightModel(10526);
         this.npc.addEventListener(MouseEvent.CLICK,this.onNpcClick);
         this.startMC.addEventListener(MouseEvent.CLICK,this.startZazen);
         _mapModel.groundLevel.addEventListener(MouseEvent.CLICK,this.onMapClick);
         SocketConnection.addCmdListener(CommandID.ZAZEN_START,this.onZazenStartHandle);
         SocketConnection.addCmdListener(CommandID.ZAZEN_STOP,this.onZazenStopHandle);
         ActivityExchangeTimesManager.addEventListener(3412,this.onTimeResult);
         ActivityExchangeTimesManager.getActiviteTimeInfo(3412);
         this._zazenLeftTime = 0;
         this.setCurrentTime();
         FightAdded.hideToolbar();
         CityToolBar.instance.hide();
         DynamicActivityEntry.instance.hide();
         TootalExpBar.show();
      }
      
      private function onTimeResult(param1:Event) : void
      {
         this._zazenLeftTime = 5 * 60 - ActivityExchangeTimesManager.getTimes(3412);
         if(this._zazenLeftTime < 0)
         {
            this._zazenLeftTime = 0;
         }
         this.setCurrentTime();
      }
      
      private function onTimer() : void
      {
         --this._zazenLeftTime;
         if(this._zazenLeftTime < 0)
         {
            this._zazenLeftTime = 0;
            clearInterval(this.timer);
         }
         this.setCurrentTime();
      }
      
      private function setCurrentTime() : void
      {
         var _loc1_:int = int(uint(this._zazenLeftTime / 60));
         var _loc2_:int = this._zazenLeftTime % 60;
         _mapModel.upLevel["timeMC0"].gotoAndStop(int(_loc1_ * 0.1) + 1);
         _mapModel.upLevel["timeMC1"].gotoAndStop(_loc1_ % 10 + 1);
         _mapModel.upLevel["timeMC2"].gotoAndStop(int(_loc2_ * 0.1) + 1);
         _mapModel.upLevel["timeMC3"].gotoAndStop(_loc2_ % 10 + 1);
      }
      
      private function onZazenStartHandle(param1:SocketEvent) : void
      {
         MouseController.instance.clear();
         KeyController.instance.clear();
         FocusKeyController.instance.clear();
         ToolBarQuickKey.unsetup();
         LayerManager.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandle);
         MainManager.addEventListener(Event.OPEN,this.onOpenOperateHandle);
         this._isZazen = true;
         this.originalPosition.x = MainManager.actorModel.x;
         this.originalPosition.y = MainManager.actorModel.y;
         var _loc2_:Point = this.getLegalPoint();
         MainManager.actorModel.x = _loc2_.x;
         MainManager.actorModel.y = _loc2_.y;
         this.synUserPosition(_loc2_);
         this.timer = setInterval(this.onTimer,1000);
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
         return new Point(this.startMC.x + Math.random() * this.startMC.width,this.startMC.y + Math.random() * this.startMC.height);
      }
      
      private function onZazenStopHandle(param1:SocketEvent) : void
      {
         MainManager.removeEventListener(Event.OPEN,this.onOpenOperateHandle);
         MainManager.openOperate();
         if(this._stopByNPC)
         {
            CityMap.instance.changeMap(2);
         }
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         this._zazenLeftTime = _loc2_.readUnsignedInt();
         if(this._zazenLeftTime < 0)
         {
            this._zazenLeftTime = 0;
         }
         this.setCurrentTime();
         AlertManager.showSimpleAlarm("本次获得经验" + _loc3_);
         if(this._isZazen)
         {
            MainManager.actorModel.x = this.originalPosition.x;
            MainManager.actorModel.y = this.originalPosition.y;
         }
         this._isZazen = false;
         clearInterval(this.timer);
      }
      
      private function onNpcClick(param1:Event) : void
      {
         var e:Event = param1;
         var dialogs:String = "内外兼修才能习得上乘武功，常来我这边打坐修炼有助于你自身的提高。";
         var select:String = "离开练功房";
         var simpleDialog:DialogInfoMultiple = new DialogInfoMultiple([dialogs],["开始打坐","离开练功房"]);
         this._stopByNPC = false;
         NpcDialogController.showForMultiple(simpleDialog,10526,this.startZazen,function():void
         {
            _stopByNPC = true;
            stopZazen();
         });
      }
      
      private function onMapClick(param1:MouseEvent) : void
      {
         if(param1.target != this.startMC)
         {
            if(this._isZazen)
            {
               this._stopByNPC = false;
               AlertManager.showSimpleAlert("是否离开打坐台？",this.stopZazen);
            }
         }
      }
      
      private function startZazen(param1:MouseEvent = null) : void
      {
         if(MagicChangeManager.instance.getCurrentInfo())
         {
            AlertManager.showSimpleAlarm("小侠士，变身状态不能打坐哦！");
            return;
         }
         if(!this._isZazen)
         {
            ModuleManager.turnAppModule("ZazenPanel");
         }
      }
      
      private function stopZazen() : void
      {
         if(this._isZazen)
         {
            SocketConnection.send(CommandID.ZAZEN_STOP);
         }
         else
         {
            CityMap.instance.changeMap(2);
         }
      }
      
      private function onOpenOperateHandle(param1:Event) : void
      {
         MouseController.instance.clear();
         KeyController.instance.clear();
         FocusKeyController.instance.clear();
         ToolBarQuickKey.unsetup();
      }
      
      private function onKeyUpHandle(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.SPACE && this._isZazen)
         {
            this._stopByNPC = false;
            AlertManager.showSimpleAlert("是否离开打坐台？",this.stopZazen);
         }
      }
      
      override public function destroy() : void
      {
         if(this._isZazen)
         {
            this.stopZazen();
            MainManager.actorModel.changeRoleView(0);
         }
         ActivityExchangeTimesManager.removeEventListener(3412,this.onTimeResult);
         LayerManager.stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandle);
         MainManager.removeEventListener(Event.OPEN,this.onOpenOperateHandle);
         this.npc.removeEventListener(MouseEvent.CLICK,this.onNpcClick);
         this.startMC.removeEventListener(MouseEvent.CLICK,this.startZazen);
         _mapModel.groundLevel.removeEventListener(MouseEvent.CLICK,this.onMapClick);
         SocketConnection.removeCmdListener(CommandID.ZAZEN_START,this.onZazenStartHandle);
         SocketConnection.removeCmdListener(CommandID.ZAZEN_STOP,this.onZazenStopHandle);
         this.npc = null;
         this.startMC = null;
         clearInterval(this.timer);
         FightAdded.showToolbar();
         CityToolBar.instance.show();
         DynamicActivityEntry.instance.show();
         TootalExpBar.hide();
         super.destroy();
      }
   }
}

