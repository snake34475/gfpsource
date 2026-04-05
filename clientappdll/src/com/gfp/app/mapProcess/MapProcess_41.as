package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.core.action.mouse.MouseProcess;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.info.ActivityExchangeAwardInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.model.sensemodels.SightModel;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_41 extends BaseMapProcess
   {
      
      public static const TASK_MIAOYUN:uint = 1812;
      
      private var _luzi:SimpleButton;
      
      private var _sandArea:MovieClip;
      
      private var _stoneArea:MovieClip;
      
      private var _stoneAnimatMC:MovieClip;
      
      private var _sandClickAble:Boolean = true;
      
      private var _frameOver:Boolean = false;
      
      private var _miaoYunNpcModel:SightModel;
      
      public function MapProcess_41()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._luzi = _mapModel.downLevel["task_1768_mc"];
         this._luzi.mouseEnabled = false;
         this._sandArea = _mapModel.downLevel["sandArea"];
         this._stoneArea = _mapModel.downLevel["stoneArea"];
         this._stoneAnimatMC = _mapModel.downLevel["stoneAnimatMC"];
         this.addTaskManagerEventListener();
         this.addMiaoYuntaskListener();
         this.clearUI();
      }
      
      private function initMapUI() : void
      {
         if(ActivityExchangeTimesManager.getTimes(1545) > 0)
         {
            this.clearUI();
            return;
         }
         if(TasksManager.isAccepted(1769))
         {
            this._sandArea.buttonMode = true;
            this._stoneArea.buttonMode = true;
            DisplayUtil.removeForParent(this._stoneArea);
            DisplayUtil.removeForParent(this._stoneAnimatMC);
            _mapModel.downLevel.addChild(this._sandArea);
            if(TasksManager.isTaskProComplete(1769,0))
            {
               this._sandArea.gotoAndStop(this._sandArea.totalFrames);
            }
            if(TasksManager.isTaskProComplete(1769,2))
            {
               DisplayUtil.removeForParent(this._sandArea);
               DisplayUtil.removeForParent(this._stoneAnimatMC);
               _mapModel.downLevel.addChild(this._stoneArea);
            }
         }
         else
         {
            this.clearUI();
         }
         if(TasksManager.isCompleted(1769))
         {
            DisplayUtil.removeForParent(this._sandArea);
            DisplayUtil.removeForParent(this._stoneAnimatMC);
            _mapModel.downLevel.addChild(this._stoneArea);
         }
      }
      
      private function clearUI() : void
      {
         DisplayUtil.removeForParent(this._sandArea);
         DisplayUtil.removeForParent(this._stoneArea);
         DisplayUtil.removeForParent(this._stoneAnimatMC);
      }
      
      private function addTaskManagerEventListener() : void
      {
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         if(this._luzi)
         {
            this._luzi.addEventListener(MouseEvent.CLICK,this.onLuziClick);
         }
         if(this._sandArea)
         {
            this._sandArea.addEventListener("frame_step_over",this.onFrameStepOver);
            this._sandArea.addEventListener("frame_step",this.onFrameStep);
            this._sandArea.addEventListener(MouseEvent.CLICK,this.onSandClick);
         }
         if(this._stoneArea)
         {
            this._stoneArea.addEventListener(MouseEvent.CLICK,this.onStoneClick);
         }
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplte);
      }
      
      private function removeTaskManagerEventListener() : void
      {
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         if(this._luzi)
         {
            this._luzi.removeEventListener(MouseEvent.CLICK,this.onLuziClick);
         }
         if(this._sandArea)
         {
            this._sandArea.removeEventListener("frame_step_over",this.onFrameStepOver);
            this._sandArea.removeEventListener("frame_step",this.onFrameStep);
            this._sandArea.removeEventListener(MouseEvent.CLICK,this.onSandClick);
         }
         if(this._stoneArea)
         {
            this._stoneArea.removeEventListener(MouseEvent.CLICK,this.onStoneClick);
         }
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplte);
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         var _loc2_:uint = uint(param1.taskID);
         if(_loc2_ == 1722)
         {
            NpcDialogController.showForNpc(10158);
         }
         if(param1.taskID == 80)
         {
            NpcDialogController.showForNpc(10158);
         }
         if(param1.taskID == 82)
         {
            AnimatPlay.startAnimat("task82_",3,false);
         }
         if(param1.taskID == 1769)
         {
            ActivityExchangeCommander.exchange(1553);
         }
         if(param1.taskID == 1802)
         {
            CityMap.instance.tranToNpc(10423);
         }
         if(param1.taskID == 1806)
         {
            CityMap.instance.tranToNpc(10427);
         }
         if(param1.taskID == 1807)
         {
            AnimatPlay.startAnimat("task1807_",2,true,0.1,0.1,false,true);
         }
         if(param1.taskID == TASK_MIAOYUN)
         {
            AnimatPlay.startAnimat("task1812_",4);
         }
         if(param1.taskID == 1816)
         {
            AnimatPlay.startAnimat("scenceAnimat_41_",1,false,0,0,false,true);
         }
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 1723)
         {
            NpcDialogController.showForNpc(10158);
         }
         if(param1.taskID == 81)
         {
            MouseProcess.execRun(MainManager.actorModel,new Point(2346,475));
         }
         if(param1.taskID == 82)
         {
            AnimatPlay.startAnimat("task82_",1,false);
         }
         if(param1.taskID == 1768)
         {
            MouseProcess.execRun(MainManager.actorModel,new Point(440,147));
         }
         if(param1.taskID == 1769)
         {
            this.initMapUI();
         }
         if(param1.taskID == 1794 && !ClientTempState.isNpcSleepAnimatPlayed)
         {
            AnimatPlay.startAnimat("scenceAnimat_62_",1,false,0,0,false,true);
            ClientTempState.isNpcSleepAnimatPlayed = true;
         }
         if(param1.taskID == 1806)
         {
            AnimatPlay.startAnimat("task1806_",1,false,0,0,false,true);
         }
         if(param1.taskID == 1807)
         {
            AnimatPlay.startAnimat("task1807_",1,true,0.1,0.1,false,true);
         }
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 1722 && param1.proID == 0)
         {
            NpcDialogController.showForNpc(10158);
         }
         if(param1.taskID == 1767 && param1.proID == 0)
         {
            CityMap.instance.changeMap(58,0,1,new Point(485,461));
         }
         if(param1.taskID == 1802 && param1.proID == 0)
         {
            AnimatPlay.startAnimat("task1802_",1,false,0,0,false,true);
         }
      }
      
      private function onExchangeComplte(param1:ExchangeEvent) : void
      {
         var _loc2_:ActivityExchangeAwardInfo = param1.info as ActivityExchangeAwardInfo;
         if(_loc2_.id == 1545)
         {
            this.clearUI();
         }
      }
      
      private function onLuziClick(param1:Event) : void
      {
      }
      
      private function onFrameStep(param1:Event) : void
      {
         this._sandClickAble = true;
      }
      
      private function onFrameStepOver(param1:Event) : void
      {
         this._frameOver = true;
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_CUSTOM_FINISH,"1769_0");
      }
      
      private function onSandClick(param1:Event) : void
      {
         if(this._sandClickAble && !this._frameOver)
         {
            this._sandArea.play();
            this._sandClickAble = false;
         }
         if(this._frameOver)
         {
            if(ItemManager.getItemCount(1500632) >= 5)
            {
               DisplayUtil.removeForParent(this._sandArea);
               _mapModel.downLevel.addChild(this._stoneAnimatMC);
               this._stoneAnimatMC.addEventListener(Event.ENTER_FRAME,this.onStoneAnimat);
               this._stoneAnimatMC.gotoAndPlay(1);
            }
            else
            {
               NpcDialogController.showForNpc(10159);
            }
         }
      }
      
      private function onStoneClick(param1:Event) : void
      {
         if(ActivityExchangeTimesManager.getTimes(1543) > 0)
         {
            ModuleManager.turnAppModule("ShenGuiHatchEndPanel","");
         }
         else
         {
            ModuleManager.turnAppModule("ShenGuiHatchStartPanel","");
         }
      }
      
      private function onStoneAnimat(param1:Event) : void
      {
         if(this._stoneAnimatMC.currentFrame == this._stoneAnimatMC.totalFrames)
         {
            this._stoneAnimatMC.removeEventListener(Event.ENTER_FRAME,this.onStoneAnimat);
            DisplayUtil.removeForParent(this._stoneAnimatMC);
            this._stoneAnimatMC = null;
            _mapModel.downLevel.addChild(this._stoneArea);
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_CUSTOM_FINISH,"1769_2");
         }
      }
      
      private function addMiaoYuntaskListener() : void
      {
         if(TasksManager.isAcceptable(TASK_MIAOYUN))
         {
            this._miaoYunNpcModel = SightManager.getSightModel(10427);
            this._miaoYunNpcModel.addEventListener(MouseEvent.CLICK,this.onClickMiaoYun);
         }
      }
      
      private function onClickMiaoYun(param1:MouseEvent) : void
      {
         this._miaoYunNpcModel.removeEventListener(MouseEvent.CLICK,this.onClickMiaoYun);
         if(TasksManager.isAcceptable(TASK_MIAOYUN))
         {
            NpcDialogController.hide();
            TasksManager.accept(TASK_MIAOYUN);
         }
      }
      
      override public function destroy() : void
      {
         this.removeTaskManagerEventListener();
         super.destroy();
      }
   }
}

