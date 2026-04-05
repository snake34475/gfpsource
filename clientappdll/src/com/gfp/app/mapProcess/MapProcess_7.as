package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.info.dialog.DialogInfoMultiple;
   import com.gfp.app.info.dialog.DialogInfoSimple;
   import com.gfp.app.npcDialog.NPCDialogEvent;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.app.task.storyAnimation.StoryAnimationTask_10001_3;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SOManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.SharedObject;
   import flash.utils.setTimeout;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.MathUtil;
   
   public class MapProcess_7 extends MapProcessAnimat
   {
      
      private var _npc10083Animation:MovieClip;
      
      private const PHARM_ACTIVITY_MAX:int = 3;
      
      private var _currentNpcId:int;
      
      private var _dailyTaskSign:MovieClip;
      
      private var _wanVec:Array = [];
      
      private var _wanMC:MovieClip;
      
      private var _wanMC1:MovieClip;
      
      private var _timeID:uint;
      
      private var _npc10048:SightModel;
      
      private var _npc10580:SightModel;
      
      private var _npc10582:SightModel;
      
      private var left:int;
      
      public function MapProcess_7()
      {
         _mangoType = 1;
         super();
      }
      
      override protected function init() : void
      {
         var _loc1_:StoryAnimationTask_10001_3 = null;
         this.initNpc10083();
         this.initNpc10048();
         this.addTaskEventListener();
         this.addDialogEventListener();
         if(TasksManager.getTaskProStatus(10001,4) == 1 && TasksManager.getTaskStatus(10001) == 1 && ClientTempState.isPlayTASKAnimate == false)
         {
            ClientTempState.isPlayTASKAnimate = true;
            TasksManager.taskProComplete(10001,4);
            _loc1_ = new StoryAnimationTask_10001_3();
            _loc1_.start();
         }
         if(ClientTempState.isFight673Winner == true)
         {
            ClientTempState.isFight673Winner = false;
            ModuleManager.turnModule(ClientConfig.getAppModule("FlowerGame"),"开始小游戏...");
         }
         if(MainManager.preMapId == 1046101 || MainManager.preMapId == 1046001)
         {
            ModuleManager.turnAppModule("BattleJokingPanel");
         }
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
         this.initTask2175Npc();
         _mapModel.upLevel.addEventListener(MouseEvent.CLICK,this.openModuleHandle);
      }
      
      private function timerHandler() : void
      {
         var _loc3_:int = 0;
         var _loc1_:int = int(ActivityExchangeTimesManager.getTimes(12139));
         var _loc2_:int = 100 - _loc1_;
         if(_loc2_ >= 10)
         {
            this.left = 10;
         }
         else
         {
            this.left = _loc2_;
         }
         if(_loc1_ < 100)
         {
            _loc3_ = 0;
            while(_loc3_ < this.left)
            {
               if(this._wanVec[_loc3_] == null)
               {
                  this._wanVec[_loc3_] = _mapModel.libManager.getMovieClip("wan0");
                  this._wanVec[_loc3_].x = MathUtil.randomRegion(390,1906);
                  this._wanVec[_loc3_].y = MathUtil.randomRegion(390,1265);
                  this._wanVec[_loc3_].buttonMode = true;
                  _mapModel.contentLevel.addChild(this._wanVec[_loc3_]);
                  this._wanVec[_loc3_].gotoAndStop(1);
               }
               _loc3_++;
            }
            _loc3_ = this.left;
            while(_loc3_ < 10)
            {
               DisplayUtil.removeForParent(this._wanVec[_loc3_]);
               this._wanVec[_loc3_] = null;
               _loc3_++;
            }
            this.addEvent();
         }
      }
      
      private function lastGift() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < 10)
         {
            if(this._wanVec[_loc2_] != null)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function addEvent() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.left)
         {
            if(this._wanVec[_loc1_])
            {
               this._wanVec[_loc1_].addEventListener(MouseEvent.CLICK,this.clickHandler);
               this._wanVec[_loc1_].addEventListener(Event.ENTER_FRAME,this.onWan0EnterFrame);
            }
            _loc1_++;
         }
      }
      
      private function wanTest() : void
      {
         var _loc3_:int = 0;
         var _loc1_:int = int(ActivityExchangeTimesManager.getTimes(12139));
         var _loc2_:int = 100 - _loc1_;
         if(_loc2_ >= 10)
         {
            this.left = 10;
         }
         else
         {
            this.left = _loc2_;
         }
         if(_loc1_ < 100)
         {
            _loc3_ = 0;
            while(_loc3_ < this.left)
            {
               this._wanVec[_loc3_] = _mapModel.libManager.getMovieClip("wan0");
               this._wanVec[_loc3_].x = MathUtil.randomRegion(390,1906);
               this._wanVec[_loc3_].y = MathUtil.randomRegion(390,1265);
               this._wanVec[_loc3_].buttonMode = true;
               _mapModel.contentLevel.addChild(this._wanVec[_loc3_]);
               this._wanVec[_loc3_].gotoAndStop(1);
               _loc3_++;
            }
         }
      }
      
      protected function clickHandler(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         LayerManager.closeMouseEvent();
         this._timeID = setTimeout(function():void
         {
            ActivityExchangeCommander.exchange(12139);
            LayerManager.openMouseEvent();
         },2000);
         TextAlert.show("玩字令 X 1");
         event.currentTarget.gotoAndPlay(1);
      }
      
      protected function onWan0EnterFrame(param1:Event) : void
      {
         var _loc2_:int = this._wanVec.indexOf(param1.currentTarget);
         if(param1.currentTarget.currentFrame == param1.currentTarget.totalFrames)
         {
            param1.currentTarget.removeEventListener(Event.ENTER_FRAME,this.onWan0EnterFrame);
            param1.currentTarget.stop();
            DisplayUtil.removeForParent(this._wanVec[_loc2_]);
            this._wanVec[_loc2_] = null;
         }
      }
      
      private function adjustArray(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc5_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < 10)
         {
            _loc2_++;
            if(param1[_loc4_] != null)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  if(param1[_loc5_] == null)
                  {
                     return;
                  }
                  _loc5_++;
               }
               if(_loc4_ != _loc5_)
               {
                  _loc3_ = param1[_loc4_];
                  param1[_loc5_] = _loc3_;
                  _loc3_ = param1[_loc5_];
               }
            }
            _loc4_++;
         }
         if(_loc2_ < 10)
         {
            this.adjustArray(param1);
            return;
         }
      }
      
      private function openModuleHandle(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.target.name;
         if(_loc2_.indexOf("appModule_") != -1)
         {
            ModuleManager.turnAppModule(_loc2_.substr(10));
         }
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 2175)
         {
         }
         if(param1.taskID == 7004)
         {
            this._npc10580.visible = true;
         }
         if(param1.taskID == 7006)
         {
            this._npc10580.visible = false;
         }
         if(param1.taskID == 7009)
         {
         }
      }
      
      private function initTask2175Npc() : void
      {
         this._npc10580 = SightManager.getSightModel(10580);
         this._npc10580.visible = false;
         if(!TasksManager.isCompleted(2175))
         {
         }
         if(TasksManager.isCompleted(7004))
         {
            this._npc10580.visible = true;
         }
         if(TasksManager.isCompleted(7006))
         {
            this._npc10580.visible = false;
         }
         if(!TasksManager.isCompleted(7009))
         {
         }
      }
      
      private function initNpc10048() : void
      {
         this._npc10048 = SightManager.getSightModel(10048);
      }
      
      private function uninitNpc10048() : void
      {
         this._npc10048 = null;
      }
      
      private function initNpc10083() : void
      {
      }
      
      private function isPharmActivityAvailable() : Boolean
      {
         var _loc1_:SharedObject = SOManager.getUserSO("pharmDailyActivity");
         var _loc2_:Date = new Date();
         var _loc3_:String = _loc2_.getFullYear() + "-" + (_loc2_.getMonth() + 1) + "-" + _loc2_.getDate();
         var _loc4_:String = MainManager.actorInfo.createTime.toString();
         var _loc5_:String = _loc4_ + "#" + _loc3_ + "#";
         var _loc6_:int = int(_loc1_.data[_loc5_]);
         if(_loc6_ < this.PHARM_ACTIVITY_MAX)
         {
            return true;
         }
         return false;
      }
      
      private function updateLocalRecord() : void
      {
         var _loc1_:SharedObject = SOManager.getUserSO("pharmDailyActivity");
         var _loc2_:Date = new Date();
         _loc2_.setTime(MainManager.loginTimeInSecond * 1000);
         var _loc3_:String = _loc2_.getFullYear() + "-" + (_loc2_.getMonth() + 1) + "-" + _loc2_.getDate();
         var _loc4_:String = MainManager.actorInfo.createTime.toString();
         var _loc5_:String = _loc4_ + "#" + _loc3_ + "#";
         var _loc6_:* = int(_loc1_.data[_loc5_]);
         _loc6_ = _loc6_ + 1;
         _loc1_.data[_loc5_] = _loc6_;
         SOManager.flush(_loc1_);
      }
      
      private function gotoMap5Fun() : void
      {
         CityMap.instance.changeMap(5,0,1,new Point(508,388));
      }
      
      private function showItemNumFailedDialog() : void
      {
         var _loc1_:DialogInfoSimple = new DialogInfoSimple([AppLanguageDefine.NPC_DIALOG_MAP7[15]],AppLanguageDefine.NPC_DIALOG_MAP7[16]);
         NpcDialogController.showForSimple(_loc1_,10083);
      }
      
      private function showMedQAFailedDialog() : void
      {
         var _loc1_:DialogInfoSimple = new DialogInfoSimple([AppLanguageDefine.NPC_DIALOG_MAP7[17]],AppLanguageDefine.NPC_DIALOG_MAP7[16]);
         NpcDialogController.showForSimple(_loc1_,10083);
      }
      
      private function showMedMatchFailedDialog() : void
      {
         var _loc1_:DialogInfoSimple = new DialogInfoSimple([AppLanguageDefine.NPC_DIALOG_MAP7[18]],AppLanguageDefine.NPC_DIALOG_MAP7[16]);
         NpcDialogController.showForSimple(_loc1_,10083);
      }
      
      private function showTimeFaildDialog() : void
      {
         var _loc1_:DialogInfoSimple = new DialogInfoSimple([AppLanguageDefine.NPC_DIALOG_MAP7[19]],AppLanguageDefine.NPC_DIALOG_MAP7[16]);
         NpcDialogController.showForSimple(_loc1_,10083);
         MainManager.collectingMaterialID = -1;
      }
      
      private function addTaskEventListener() : void
      {
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onComplete);
      }
      
      private function addDialogEventListener() : void
      {
         if(TasksManager.isProcess(2006,4))
         {
            NpcDialogController.ed.addEventListener(NPCDialogEvent.INIT,this.onDialogInit);
         }
      }
      
      private function onDialogInit(param1:NPCDialogEvent) : void
      {
         var dialogs:String = null;
         var selects:Array = null;
         var multiDialog:DialogInfoMultiple = null;
         var event:NPCDialogEvent = param1;
         if(event.npcID == 10514)
         {
            NpcDialogController.hide();
            dialogs = "真的吗？太好了，我们快去鹊桥，他们应该还没走远。";
            selects = ["出发吧！"];
            multiDialog = new DialogInfoMultiple([dialogs],selects);
            NpcDialogController.showForMultiple(multiDialog,10514,function():void
            {
               PveEntry.enterTollgate(559);
            });
         }
      }
      
      private function onComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 1877)
         {
            CityMap.instance.tranToNpc(10428);
         }
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 48)
         {
            if(param1.proID == 0)
            {
               CityMap.instance.changeMap(14,0,1,new Point(2090,270));
            }
         }
         else if(param1.taskID == 50)
         {
            if(param1.proID == 0)
            {
               CityMap.instance.changeMap(18,0,1,new Point(1500,450));
            }
         }
         else if(param1.taskID == 51)
         {
            if(param1.proID == 0)
            {
               CityMap.instance.changeMap(18,0,1,new Point(441,532));
            }
         }
         else if(param1.taskID == 10001 && param1.proID == 0)
         {
            ModuleManager.turnModule(ClientConfig.getAppModule("snakeGame"),"开始给小蛇画脚...");
         }
         else if(param1.taskID == 1877 && param1.proID == 2)
         {
            NpcDialogController.showForNpc(10438);
         }
         else if(param1.taskID == 2006 && param1.proID == 3)
         {
            this.addDialogEventListener();
            PveEntry.enterTollgate(559);
         }
         else if(param1.taskID == 7006 && param1.proID == 2)
         {
            this._npc10580.visible = false;
         }
         else if(param1.taskID == 7009 && param1.proID == 1)
         {
         }
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 48)
         {
            NpcDialogController.showForNpc(10123);
         }
         if(param1.taskID == 50 || param1.taskID == 51)
         {
            NpcDialogController.showForNpc(10123);
         }
         if(param1.taskID == 52 || param1.taskID == 53)
         {
            CityMap.instance.changeMap(2,0,1,new Point(131,440));
         }
         if(param1.taskID == 65)
         {
            CityMap.instance.changeMap(2,0,1,new Point(131,440));
         }
         if(param1.taskID == 2029)
         {
            AnimatPlay.startAnimat("task2029_",0,false,0,0,false,true);
         }
      }
      
      private function removeTaskEventListener() : void
      {
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onComplete);
      }
      
      private function removeDialogEventListener() : void
      {
         NpcDialogController.ed.removeEventListener(NPCDialogEvent.INIT,this.onDialogInit);
      }
      
      override public function destroy() : void
      {
         _mapModel.upLevel.removeEventListener(MouseEvent.CLICK,this.openModuleHandle);
         this.uninitNpc10048();
         this.removeTaskEventListener();
         this.removeDialogEventListener();
         super.destroy();
      }
   }
}

