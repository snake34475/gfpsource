package com.gfp.app.mapProcess
{
   import com.gfp.app.info.dialog.DialogInfoSimple;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.FocusManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.model.sensemodels.SightModel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class MapProcess_3 extends MapProcessAnimat
   {
      
      private var _mcFindStudent:MovieClip;
      
      private var _sightHide:SightModel;
      
      private var _sightStudent:SightModel;
      
      private var _spiderNetMC:MovieClip;
      
      private var _spiderNetMC1:MovieClip;
      
      private var _spiderNetMC2:MovieClip;
      
      private var _buMC:MovieClip;
      
      private var _shujuanMC:MovieClip;
      
      private var _wallTigerMC:MovieClip;
      
      private var _shoseMC:MovieClip;
      
      private var _overrideFlagMC:MovieClip;
      
      public function MapProcess_3()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._mcFindStudent = _mapModel.contentLevel["mc_findstudent"];
         this._mcFindStudent.gotoAndStop(1);
         this._mcFindStudent.visible = false;
         this._sightHide = SightManager.getSightModel(110001);
         this._sightHide.addEventListener(MouseEvent.CLICK,this.onHideStudentClick);
         this._sightStudent = SightManager.getSightModel(10035);
         this._sightStudent.hide();
         this._spiderNetMC = _mapModel.downLevel["spiderNetMC"];
         this._buMC = _mapModel.downLevel["buMC"];
         this._shujuanMC = _mapModel.downLevel["shujuanMC"];
         this._wallTigerMC = _mapModel.downLevel["wallTigerMC"];
         this._shoseMC = _mapModel.downLevel["shoseMC"];
         this._spiderNetMC1 = _mapModel.downLevel["_spiderNetMC1"];
         this._spiderNetMC2 = _mapModel.downLevel["_spiderNetMC2"];
         this._overrideFlagMC = _mapModel.downLevel["overrideFlagMC"];
         addSimpleClickAnimat(this._spiderNetMC);
         addSimpleClickAnimat(this._spiderNetMC1);
         addSimpleClickAnimat(this._spiderNetMC2);
         addSimpleClickAnimat(this._buMC);
         addSimpleClickAnimat(this._shujuanMC);
         addSimpleClickAnimat(this._wallTigerMC);
         addSimpleClickAnimat(this._shoseMC);
         addFlagClickAnimat(this._overrideFlagMC);
         this.setCalabashAnimat();
         this.setSpiderAnimat();
         this.addTaskEventListener();
      }
      
      private function setCalabashAnimat(param1:Boolean = false) : void
      {
         var _loc3_:MovieClip = null;
         var _loc2_:int = 1;
         while(_loc2_ <= 3)
         {
            _loc3_ = _mapModel.downLevel["calabashMC" + _loc2_];
            if(param1)
            {
               removeSimpleClickAnimat(_loc3_);
            }
            else
            {
               addSimpleClickAnimat(_loc3_);
            }
            _loc2_++;
         }
      }
      
      private function setSpiderAnimat(param1:Boolean = false) : void
      {
         var _loc3_:MovieClip = null;
         var _loc2_:int = 1;
         while(_loc2_ <= 5)
         {
            _loc3_ = _mapModel.downLevel["spiderMC" + _loc2_];
            if(param1)
            {
               removeSimpleClickAnimat(_loc3_);
            }
            else
            {
               if(TasksManager.isAccepted(1099))
               {
                  if(TasksManager.isTaskProComplete(1099,_loc2_ - 1))
                  {
                     _loc3_.visible = false;
                  }
               }
               _loc3_.buttonMode = true;
               this.addSpiderAnimat(_loc3_);
            }
            _loc2_++;
         }
      }
      
      private function addSpiderAnimat(param1:MovieClip) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.onPiderClick);
      }
      
      private function onPiderClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(TasksManager.isAccepted(1099))
         {
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_MAPCOLLECT,_loc2_.name);
            _loc2_.addEventListener(Event.ENTER_FRAME,this.onSpiderEnter);
         }
         _loc2_.gotoAndPlay(2);
      }
      
      private function onSpiderEnter(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_.currentFrame == _loc2_.totalFrames)
         {
            _loc2_.removeEventListener(Event.ENTER_FRAME,this.onSpiderEnter);
            _loc2_.visible = false;
         }
      }
      
      private function onHideStudentClick(param1:MouseEvent) : void
      {
         this._sightHide.hide();
         FocusManager.setDefaultFocus();
         this._mcFindStudent.addEventListener(Event.ENTER_FRAME,this.onFindMcEnterFrame);
         this._mcFindStudent.visible = true;
         this._mcFindStudent.gotoAndPlay(1);
      }
      
      private function onFindMcEnterFrame(param1:Event) : void
      {
         if(this._mcFindStudent.currentFrame == this._mcFindStudent.totalFrames)
         {
            this._mcFindStudent.removeEventListener(Event.ENTER_FRAME,this.onFindMcEnterFrame);
            this._mcFindStudent.stop();
            this._mcFindStudent.visible = false;
            this._sightStudent.show();
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_MAPCOLLECT,"findLazyStudent");
            NpcDialogController.showForNpc(10035);
         }
      }
      
      private function addTaskEventListener() : void
      {
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function removeTaskEventListener() : void
      {
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         var _loc2_:DialogInfoSimple = null;
         if(param1.taskID == 1103)
         {
            if(ItemManager.getItemAvailableCapacity() < 1)
            {
               _loc2_ = new DialogInfoSimple([AppLanguageDefine.NPC_DIALOG_MAP14[0]],AppLanguageDefine.NPC_DIALOG_MAP14[1]);
               NpcDialogController.showForSimple(_loc2_,10009);
               TasksManager.quit(1103);
            }
            else
            {
               ModuleManager.turnModule(ClientConfig.getAppModule("WeaponIntroduceBook"),AppLanguageDefine.LOAD_MATTER_COLLECTION[8]);
            }
         }
         if(param1.taskID == 1269)
         {
            NpcDialogController.showForNpc(10034);
         }
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 1269)
         {
            CityMap.instance.changeMap(1,0,1,new Point(2477,759));
         }
      }
      
      override public function destroy() : void
      {
         this.setCalabashAnimat(true);
         super.destroy();
         removeSimpleClickAnimat(this._spiderNetMC);
         removeSimpleClickAnimat(this._buMC);
         removeSimpleClickAnimat(this._shujuanMC);
         removeSimpleClickAnimat(this._wallTigerMC);
         removeSimpleClickAnimat(this._shoseMC);
         removeSimpleClickAnimat(this._spiderNetMC1);
         removeSimpleClickAnimat(this._spiderNetMC2);
         this.removeTaskEventListener();
         this._spiderNetMC1 = null;
         this._spiderNetMC = null;
         this._buMC = null;
         this._shujuanMC = null;
         this._wallTigerMC = null;
         this._shoseMC = null;
      }
   }
}

