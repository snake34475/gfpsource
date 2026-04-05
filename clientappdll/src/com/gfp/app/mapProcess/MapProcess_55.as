package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.control.DragonStepsControl;
   import com.gfp.app.info.dialog.DialogInfoSimple;
   import com.gfp.app.manager.EscortManager;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.WeatherManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.utils.ActivityTimeUtil;
   import com.gfp.core.utils.StringConstants;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.utils.Utils;
   
   public class MapProcess_55 extends MapProcessAnimat
   {
      
      private static const TASK_ID_HCNH:uint = 84;
      
      private static const COOK_NOODLE_TASK_ID:uint = 1755;
      
      private static const MILLE_TRACK_TASK_ID:uint = 85;
      
      private var kitchenMc:DisplayObject;
      
      private var _stoneMC:Sprite;
      
      private var isTakeoff1302000:Boolean = true;
      
      private var _npc10432:SightModel;
      
      private var snowMC:Sprite;
      
      private var crystalMc:MovieClip;
      
      private var _npc10536:SightModel;
      
      private var _npc10194:SightModel;
      
      public function MapProcess_55()
      {
         _mangoType = 1;
         super();
      }
      
      override protected function init() : void
      {
         _mangoType = 1;
         if(TasksManager.isAccepted(TASK_ID_HCNH))
         {
            if(TasksManager.getTaskProStatus(TASK_ID_HCNH,0) != 1)
            {
               MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.mapSwitchCompleteHandler);
            }
            TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.whenDialogOverHandler);
         }
         this.kitchenMc = _mapModel.contentLevel.getChildByName("kitchen_mc");
         MovieClip(this.kitchenMc).buttonMode = true;
         this.kitchenMc.visible = false;
         if(Boolean(TasksManager.isAccepted(COOK_NOODLE_TASK_ID)) && !TasksManager.isReady(COOK_NOODLE_TASK_ID))
         {
            this.kitchenMc.visible = true;
            this.kitchenMc.addEventListener(MouseEvent.CLICK,this.clickKitchenHandler);
            TasksManager.addActionListener(TaskActionEvent.TASK_COLLECT,"1500588",this.addItemHandler);
         }
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.whenDialogPerryHandler);
         TasksManager.addListener(TaskEvent.ACCEPT,this.acceptTaskHandler);
         if(this._stoneMC)
         {
            this._stoneMC.buttonMode = true;
            this._stoneMC.addEventListener(MouseEvent.CLICK,this.onStoneClick);
            AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
         }
         ActivityTimeUtil.check(91,function():void
         {
            WeatherManager.open("snow");
         },false);
         this.snowMC = _mapModel.contentLevel["snow"];
         if(TasksManager.isProcess(1905,5))
         {
            this.snowMC.buttonMode = true;
            this.snowMC.useHandCursor = true;
            this.snowMC.addEventListener(MouseEvent.CLICK,this.onSnowClick);
            AlertManager.showSimpleAlarm(AppLanguageDefine.NPC_DIALOG_MAP55[0]);
         }
         else
         {
            this.snowMC.buttonMode = false;
            this.snowMC.useHandCursor = false;
            this.snowMC.visible = false;
         }
         this._npc10194 = SightManager.getSightModel(10194);
         this._npc10536 = SightManager.getSightModel(10536);
         this.addCrystalMc();
         TasksManager.addListener(TaskEvent.COMPLETE,this.onComplegte);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onProComplete);
      }
      
      private function onComplegte(param1:TaskEvent) : void
      {
      }
      
      private function onProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 2088)
         {
            this.addCrystalMc();
         }
      }
      
      private function removeCrystalMc() : void
      {
         if(Boolean(this.crystalMc) && Boolean(this.crystalMc.parent))
         {
            this.crystalMc.parent.removeChild(this.crystalMc);
            this.crystalMc.bar.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.crystalMc.mc.removeEventListener(MouseEvent.CLICK,this.onCrystalMcClick);
            this.crystalMc = null;
         }
      }
      
      private function addCrystalMc() : void
      {
         var _loader:UILoader = null;
         var onLoadComplete:Function = null;
         if(Boolean(TasksManager.isCompleted(2084)) && !TasksManager.isCompleted(2090) && Boolean(TasksManager.isProcess(2088,1)))
         {
            onLoadComplete = function(param1:UILoadEvent):void
            {
               _loader.removeEventListener(UILoadEvent.COMPLETE,onLoadComplete);
               crystalMc = Utils.getMovieClipFromLoader("crystalMc",_loader.loader);
               _npc10536.parent.addChild(crystalMc);
               crystalMc.x = 922;
               crystalMc.y = 398;
               crystalMc.buttonMode = true;
               crystalMc.bar.visible = false;
               crystalMc.bar.gotoAndStop(1);
               crystalMc.mc.addEventListener(MouseEvent.CLICK,onCrystalMcClick);
            };
            if(this.crystalMc)
            {
               return;
            }
            _loader = new UILoader(ClientConfig.getCartoon("Crystal"));
            _loader.addEventListener(UILoadEvent.COMPLETE,onLoadComplete);
            _loader.load();
         }
      }
      
      private function onCrystalMcClick(param1:MouseEvent) : void
      {
         this.crystalMc.mc.removeEventListener(MouseEvent.CLICK,this.onCrystalMcClick);
         this.crystalMc.bar.visible = true;
         this.crystalMc.bar.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.crystalMc.bar.play();
         this.crystalMc.jiantou.visible = false;
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.currentFrameLabel == "bar")
         {
            if(ActivityExchangeTimesManager.getTimes(3580) == 0)
            {
               ActivityExchangeCommander.exchange(3580);
            }
         }
         if(_loc2_.currentFrame == _loc2_.totalFrames)
         {
            this.crystalMc.bar.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.crystalMc.bar.visible = false;
            this.crystalMc.bar.gotoAndStop(1);
            this.crystalMc.jiantou.visible = true;
            this.removeCrystalMc();
         }
      }
      
      private function onSnowClick(param1:MouseEvent) : void
      {
         this.snowMC.buttonMode = false;
         this.snowMC.useHandCursor = false;
         this.snowMC.removeEventListener(MouseEvent.CLICK,this.onSnowClick);
         this.snowMC.visible = false;
         AlertManager.showSimpleAlarm(AppLanguageDefine.NPC_DIALOG_MAP55[1],this.onDialogClosed);
      }
      
      private function onDialogClosed() : void
      {
         CityMap.instance.tranChangeMapByStr("55,732,828");
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_CUSTOM_FINISH,"1905_5");
      }
      
      private function onNpc10432Click(param1:Event) : void
      {
         if(EscortManager.instance.escortPathId != 0)
         {
            NpcDialogController.showForSimple(new DialogInfoSimple(["这真是雪中送碳啊，谢谢你，小侠士!"],"这是我应该做的"),10432,this.onConfirm,this.onConfirm);
         }
      }
      
      private function onConfirm() : void
      {
         EscortManager.instance.endEscort();
      }
      
      private function onEscortComplete(param1:DataEvent) : void
      {
         this._npc10432.removeEventListener(MouseEvent.CLICK,this.onNpc10432Click);
         var _loc2_:int = int(param1.data);
         switch(_loc2_)
         {
            case 22:
               ActivityExchangeTimesManager.updataTimesByOnce(2073);
               break;
            case 23:
               ActivityExchangeTimesManager.updataTimesByOnce(2074);
               break;
            case 24:
               ActivityExchangeTimesManager.updataTimesByOnce(2075);
               break;
            case 25:
               ActivityExchangeTimesManager.updataTimesByOnce(2076);
               break;
            case 26:
               ActivityExchangeTimesManager.updataTimesByOnce(2077);
               break;
            case 27:
               ActivityExchangeTimesManager.updataTimesByOnce(2078);
         }
         ModuleManager.turnAppModule("SaveVillagerPanel","拯救灾民...");
      }
      
      private function onStoneClick(param1:Event) : void
      {
         if(!DragonStepsControl.isAnimatPlayed())
         {
            AnimatPlay.startAnimat("task1785_",0,false,235,135,true);
         }
         else
         {
            ModuleManager.turnAppModule("DragonStepsEntryPanel","");
         }
      }
      
      private function onAnimatEnd(param1:AnimatEvent) : void
      {
         var _loc2_:String = param1.data as String;
         if(_loc2_ == "task1785_0")
         {
            DragonStepsControl.flushAnimatPlayed();
            AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
            ModuleManager.closeAllModule();
            ModuleManager.turnAppModule("DragonStepsEntryPanel","");
         }
      }
      
      private function whenDialogPerryHandler(param1:TaskEvent) : void
      {
         if(TasksManager.isTaskProComplete(MILLE_TRACK_TASK_ID,2))
         {
            TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.whenDialogPerryHandler);
            AnimatPlay.startAnimat("task85_",1,false);
         }
      }
      
      private function acceptTaskHandler(param1:TaskEvent) : void
      {
         if(param1.taskID == COOK_NOODLE_TASK_ID)
         {
            this.kitchenMc.visible = true;
            this.kitchenMc.addEventListener(MouseEvent.CLICK,this.clickKitchenHandler);
            TasksManager.addActionListener(TaskActionEvent.TASK_COLLECT,"1500588",this.addItemHandler);
         }
      }
      
      private function addItemHandler(param1:TaskActionEvent) : void
      {
         this.kitchenMc.visible = false;
      }
      
      private function clickKitchenHandler(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("CookNoodlesPanel","正在加载");
      }
      
      private function whenDialogOverHandler(param1:TaskEvent) : void
      {
         if(param1.taskID == TASK_ID_HCNH && param1.proID == 1)
         {
            TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.whenDialogOverHandler);
            AnimatPlay.startAnimat("task84_",1,false);
         }
      }
      
      private function mapSwitchCompleteHandler(param1:MapEvent) : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_CUSTOM_FINISH,TASK_ID_HCNH + StringConstants.SIGN + 0);
         AnimatPlay.startAnimat("task83_",1,false);
      }
      
      private function completeQsytHandler(param1:TaskEvent) : void
      {
         TasksManager.removeListener(TaskEvent.COMPLETE,this.completeQsytHandler);
         AnimatPlay.startAnimat("task83_",1,false);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.whenDialogOverHandler);
      }
      
      override public function destroy() : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.mapSwitchCompleteHandler);
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.whenDialogOverHandler);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.completeQsytHandler);
         TasksManager.removeListener(TaskEvent.ACCEPT,this.acceptTaskHandler);
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.whenDialogPerryHandler);
         this.kitchenMc.removeEventListener(MouseEvent.CLICK,this.clickKitchenHandler);
         if(this._stoneMC)
         {
            this._stoneMC.removeEventListener(MouseEvent.CLICK,this.onStoneClick);
         }
         if(this.snowMC)
         {
            this.snowMC.removeEventListener(MouseEvent.CLICK,this.onSnowClick);
         }
         super.destroy();
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onComplegte);
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onProComplete);
         this._npc10194 = null;
         this._npc10536 = null;
         this.removeCrystalMc();
         WeatherManager.hide("snow");
         WeatherManager.clearCurrentWeatherList();
      }
   }
}

