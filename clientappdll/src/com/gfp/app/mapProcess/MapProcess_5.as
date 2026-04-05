package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.info.dialog.DialogInfoSimple;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.app.storyProcess.StoryProcess_1;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.info.ActivityExchangeAwardInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.model.sensemodels.SightModel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class MapProcess_5 extends MapProcessAnimat
   {
      
      private var teaMC:MovieClip;
      
      private var paiziMC1:MovieClip;
      
      private var paiziMC2:MovieClip;
      
      private var paiziMC3:MovieClip;
      
      private var paiziMC4:MovieClip;
      
      private var paiziMC5:MovieClip;
      
      private var jinqiMC:MovieClip;
      
      private var abacusMC:MovieClip;
      
      private var stoneMC:MovieClip;
      
      private var _invStone:uint;
      
      private var _npc10002:SightModel;
      
      private var _isRequstMedicine:Boolean = false;
      
      public function MapProcess_5()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._npc10002 = SightManager.getSightModel(10002);
         this.teaMC = _mapModel.upLevel["teaMC"];
         this.abacusMC = _mapModel.contentLevel["abacusMC"];
         this.paiziMC1 = _mapModel.contentLevel["paiziMC1"];
         this.paiziMC2 = _mapModel.contentLevel["paiziMC2"];
         this.paiziMC3 = _mapModel.contentLevel["paiziMC3"];
         this.paiziMC4 = _mapModel.contentLevel["paiziMC4"];
         this.paiziMC5 = _mapModel.contentLevel["paiziMC5"];
         this.jinqiMC = _mapModel.contentLevel["jinqiMC"];
         addSimpleClickAnimat(this.teaMC);
         addSimpleClickAnimat(this.abacusMC);
         addSimpleClickAnimat(this.paiziMC1);
         addSimpleClickAnimat(this.paiziMC2);
         addSimpleClickAnimat(this.paiziMC3);
         addSimpleClickAnimat(this.paiziMC4);
         addSimpleClickAnimat(this.paiziMC5);
         addSimpleClickAnimat(this.jinqiMC);
         this.stoneMC = _mapModel.contentLevel["stoneMC"];
         this.stoneMC.buttonMode = true;
         this.stoneMC.addEventListener(MouseEvent.CLICK,this.onStoneClick);
         if(TasksManager.isAcceptable(2))
         {
            NpcDialogController.showForNpc(10002);
         }
         this.addMapListener();
         this.initNpcDialogForTask36();
         if(StoryProcess_1.instance.validate && StoryProcess_1.instance.step == StoryProcess_1.CHECK_STEP_1)
         {
            this.initNpcDialogForStroy();
         }
         var _loc1_:SightModel = SightManager.getSightModel(10535);
         _loc1_.visible = TasksManager.isCompleted(2083);
         this.initDialogForTask1928();
         this.initTask1108();
         if(TasksManager.isProcess(2083,1))
         {
            TasksManager.taskProComplete(2083,1);
         }
         if(Boolean(TasksManager.isAcceptable(2084)) || Boolean(TasksManager.isAccepted(2084)) || Boolean(TasksManager.isCompleted(2084)))
         {
            _loc1_ = SightManager.getSightModel(10535);
            _loc1_.visible = false;
         }
         if(TasksManager.isAcceptable(519))
         {
            NpcDialogController.showForNpc(10002);
         }
      }
      
      private function initTask1108() : void
      {
         if(Boolean(TasksManager.isAccepted(1108)) && !TasksManager.isReady(1108))
         {
            TasksManager.taskComplete(1108);
         }
      }
      
      private function initNpcDialogForStroy() : void
      {
         this._npc10002 = SightManager.getSightModel(10002);
         this._npc10002.addEventListener(MouseEvent.CLICK,this.onNpc10002ClickForStory);
      }
      
      private function onNpc10002ClickForStory(param1:Event) : void
      {
         var _loc2_:String = AppLanguageDefine.NPC_DIALOG_MAP5[0];
         var _loc3_:String = AppLanguageDefine.NPC_DIALOG_MAP5[1];
         var _loc4_:DialogInfoSimple = new DialogInfoSimple([_loc2_,_loc3_],AppLanguageDefine.NPC_DIALOG_MAP5[2]);
         NpcDialogController.showForSimple(_loc4_,10002,this.storyStep1);
      }
      
      private function storyStep1() : void
      {
         var _loc1_:DialogInfoSimple = new DialogInfoSimple([AppLanguageDefine.NPC_DIALOG_MAP5[3]],AppLanguageDefine.NPC_DIALOG_MAP5[4]);
         NpcDialogController.showForSimple(_loc1_,10002);
         this._npc10002.removeEventListener(MouseEvent.CLICK,this.onNpc10002ClickForStory);
         StoryProcess_1.instance.step = StoryProcess_1.CHECK_STEP_2;
         StoryProcess_1.instance.flushSO({"step":StoryProcess_1.CHECK_STEP_2});
      }
      
      private function onStoneClick(param1:MouseEvent) : void
      {
         if(TasksManager.isProcess(14,1))
         {
            clearTimeout(this._invStone);
            this._invStone = setTimeout(this.onStone,1000);
         }
      }
      
      private function onStone() : void
      {
         ActivityExchangeCommander.exchange(2096);
      }
      
      private function addMapListener() : void
      {
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchanged);
      }
      
      private function removeMapListener() : void
      {
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
         this._npc10002.removeEventListener(MouseEvent.CLICK,this.onNpcClickFor1928);
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchanged);
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 1242)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.NPC_DIALOG_MAP5[5]);
         }
         if(param1.taskID == 49)
         {
            CityMap.instance.changeMap(14,0,1,new Point(1630,228));
         }
         if(param1.taskID == 59)
         {
            NpcDialogController.showForNpc(10002);
         }
         if(param1.taskID == 1318)
         {
            NpcDialogController.showForNpc(10002);
         }
         if(param1.taskID == 1108)
         {
            this.initTask1108();
         }
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 58)
         {
            if(param1.proID == 3)
            {
               CityMap.instance.changeMap(26,0,1,new Point(526,206));
            }
         }
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 68)
         {
            if(TasksManager.isAccepted(69) == false)
            {
               TasksManager.accept(69);
               CityMap.instance.changeMap(32,0,1,new Point(1303,1079));
            }
         }
         if(param1.taskID == 79)
         {
            NpcDialogController.showForNpc(10002);
         }
         if(param1.taskID == 1928)
         {
            CityMap.instance.changeMap(61);
         }
      }
      
      private function initNpcDialogForTask36() : void
      {
         if(Boolean(TasksManager.isAccepted(36)) && Boolean(TasksManager.isTaskProComplete(36,0)))
         {
            this._npc10002 = SightManager.getSightModel(10002);
            this._npc10002.addEventListener(MouseEvent.CLICK,this.onNpc10002Click);
         }
      }
      
      private function onNpc10002Click(param1:MouseEvent) : void
      {
         var _loc2_:DialogInfoSimple = null;
         if(Boolean(TasksManager.isTaskProComplete(36,1)) && Boolean(TasksManager.isTaskProComplete(36,2)) && Boolean(TasksManager.isTaskProComplete(36,3)) && Boolean(TasksManager.isTaskProComplete(36,4)))
         {
            _loc2_ = new DialogInfoSimple([AppLanguageDefine.NPC_DIALOG_MAP5[6]],AppLanguageDefine.NPC_DIALOG_MAP5[7]);
            NpcDialogController.showForSimple(_loc2_,10002,this.getMedicine);
         }
         else
         {
            _loc2_ = new DialogInfoSimple([AppLanguageDefine.NPC_DIALOG_MAP5[8]],AppLanguageDefine.NPC_DIALOG_MAP5[9]);
            NpcDialogController.showForSimple(_loc2_,10002);
         }
      }
      
      private function getMedicine() : void
      {
         if(this._isRequstMedicine == false)
         {
            this._isRequstMedicine = true;
            ActivityExchangeCommander.exchange(2097);
         }
      }
      
      private function onExchanged(param1:ExchangeEvent) : void
      {
         var _loc2_:ActivityExchangeAwardInfo = param1.info;
         if(_loc2_.id == 2097)
         {
            CityMap.instance.tranToNpc(10109);
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.removeMapListener();
         removeSimpleClickAnimat(this.teaMC);
         removeSimpleClickAnimat(this.abacusMC);
         removeSimpleClickAnimat(this.paiziMC1);
         removeSimpleClickAnimat(this.paiziMC2);
         removeSimpleClickAnimat(this.paiziMC3);
         removeSimpleClickAnimat(this.paiziMC4);
         removeSimpleClickAnimat(this.paiziMC5);
         removeSimpleClickAnimat(this.jinqiMC);
         this.stoneMC.removeEventListener(MouseEvent.CLICK,this.onStoneClick);
         clearTimeout(this._invStone);
         this.teaMC = null;
         this.abacusMC = null;
         this.paiziMC1 = null;
         this.paiziMC2 = null;
         this.paiziMC3 = null;
         this.paiziMC4 = null;
         this.paiziMC5 = null;
         this.jinqiMC = null;
         this.stoneMC = null;
      }
      
      private function initDialogForTask1928() : void
      {
         if(Boolean(TasksManager.isAccepted(1928)) && Boolean(TasksManager.isProcess(1928,0)))
         {
            this._npc10002.addEventListener(MouseEvent.CLICK,this.onNpcClickFor1928);
         }
      }
      
      private function onNpcClickFor1928(param1:MouseEvent) : void
      {
         if(Boolean(TasksManager.isAccepted(1928)) && Boolean(TasksManager.isProcess(1928,0)))
         {
            this.dialogStep1928_1();
         }
      }
      
      private function dialogStep1928_1() : void
      {
         var _loc1_:String = "急急忙忙的，找我什么事情？";
         var _loc2_:DialogInfoSimple = new DialogInfoSimple([_loc1_],"桃花仙子和小桃长得有七分相似，是巧合吗？");
         NpcDialogController.showForSimple(_loc2_,10002,this.dialogStep1928_2);
      }
      
      private function dialogStep1928_2() : void
      {
         var _loc1_:String = "这并不是巧合，据我所知，桃花仙子应该是丫鬟小桃的前世。";
         var _loc2_:DialogInfoSimple = new DialogInfoSimple([_loc1_],"前世？");
         NpcDialogController.showForSimple(_loc2_,10002,this.dialogAnimat1928_1);
      }
      
      private function dialogStep1928_3() : void
      {
         var _loc1_:String = "不过桃花仙子却并非真正消失，只是幻化成了桃花瓣，如果有足够的桃花瓣，想必她就能重回人间。";
         var _loc2_:DialogInfoSimple = new DialogInfoSimple([_loc1_],"我明白了");
         NpcDialogController.showForSimple(_loc2_,10002,this.dialogAnimat1928_2);
      }
      
      private function dialogStep1928_4() : void
      {
         var _loc1_:String = "现在你可以前往<font color=\'#ff0000\'>家园中的怪树</font>，桃花仙子的本体就在其中。";
         var _loc2_:DialogInfoSimple = new DialogInfoSimple([_loc1_],"谢谢药师爷爷指点");
         NpcDialogController.showForSimple(_loc2_,10002,this.taskEnd1928);
      }
      
      private function taskEnd1928() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_CUSTOM_FINISH,"1928_0");
         this._npc10002.removeEventListener(MouseEvent.CLICK,this.onNpcClickFor1928);
      }
      
      private function dialogAnimat1928_1() : void
      {
         AnimatPlay.startAnimat("task1760_",1);
      }
      
      private function dialogAnimat1928_2() : void
      {
         AnimatPlay.startAnimat("task1760_",2);
      }
      
      private function onAnimatEnd(param1:AnimatEvent) : void
      {
         var _loc2_:String = param1.data as String;
         switch(_loc2_)
         {
            case "task1760_1":
               this.dialogStep1928_3();
               break;
            case "task1760_2":
               this.dialogStep1928_4();
         }
      }
   }
}

