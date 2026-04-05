package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.DailyActivityAward;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.info.dialog.DialogInfoSimple;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.app.toolBar.TaskTrackPanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.DailyActivityXMLInfo;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.info.DailyActiveAwardInfo;
   import com.gfp.core.info.RectInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.controller.GuideAdapter;
   import com.gfp.core.utils.WallowUtil;
   import com.gfp.core.xmlconfig.GuideXmlInfo;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import org.taomee.motion.easing.Quad;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1 extends MapProcessAnimat
   {
      
      private var tongMC:MovieClip;
      
      private var noticeMC:MovieClip;
      
      private var _taskSign:MovieClip;
      
      private var _goToMap906:SightModel;
      
      private var _getExtendBagMC:MovieClip;
      
      private var _sightModel10005:SightModel;
      
      private var _sightModel10191:SightModel;
      
      private var _guide:GuideAdapter;
      
      public function MapProcess_1()
      {
         _mangoType = 1;
         super();
      }
      
      override protected function init() : void
      {
         this.tongMC = _mapModel.upLevel["tong"];
         this._sightModel10005 = SightManager.getSightModel(10005);
         this.tongMC.gotoAndStop(this.tongMC.totalFrames);
         this.initTongMC();
         TasksManager.addListener(TaskEvent.ACCEPT,this.onDailySignUpdate);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onDailySignUpdate);
         TasksManager.addListener(TaskEvent.QUIT,this.onDailySignUpdate);
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         this.isShow906();
         this.initTask6();
      }
      
      private function initTask6() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:RectInfo = null;
         if(Boolean(TasksManager.isReady(6)) || Boolean(TasksManager.isReady(522)))
         {
            _loc1_ = TaskTrackPanel.instance.getTaskArea(6) || TaskTrackPanel.instance.getTaskArea(522);
            if(_loc1_)
            {
               _loc2_ = new RectInfo();
               _loc2_.left = _loc1_.x;
               _loc2_.top = _loc1_.y;
               _loc2_.width = _loc1_.width;
               _loc2_.height = _loc1_.height;
               GuideXmlInfo.setInfoRect(8,1,_loc2_);
               this._guide = new GuideAdapter(8);
               this._guide.show();
            }
         }
      }
      
      private function onApply() : void
      {
         ModuleManager.turnAppModule("ChristmasTailPanel","");
      }
      
      private function isShow906() : void
      {
         this._goToMap906 = SightManager.getSightModel(1090601);
         this._goToMap906.show();
      }
      
      private function onDailySignUpdate(param1:TaskEvent) : void
      {
         if(TasksManager.isDailyTask(param1.taskID))
         {
            this.updateDailySign();
         }
         if(param1.taskID == 1158)
         {
            this._goToMap906.show();
         }
         if(param1.taskID == 1231 && param1.type == TaskEvent.COMPLETE)
         {
            this.playGetExtendsBag();
         }
         if(param1.taskID == 1255 && param1.type == TaskEvent.ACCEPT)
         {
            NpcDialogController.showForNpc(10006);
         }
      }
      
      private function updateDailySign() : void
      {
         if(this._taskSign)
         {
            DisplayUtil.removeForParent(this._taskSign);
            this._taskSign = null;
         }
         var _loc1_:uint = uint(TasksManager.isDailyProcess());
         if(_loc1_ != 0)
         {
            if(TasksManager.isReady(_loc1_))
            {
               this._taskSign = UIManager.getMovieClip("TaskSign_Ready");
            }
            else
            {
               this._taskSign = UIManager.getMovieClip("TaskSign_Unready");
            }
         }
         else if(TasksManager.isDailyAcceptabel())
         {
            this._taskSign = UIManager.getMovieClip("TaskSign_CanReceive");
         }
         if(this._taskSign)
         {
            this._taskSign.x = (this.noticeMC.width - this._taskSign.width) / 2;
            this._taskSign.y = -30;
            this.noticeMC.addChild(this._taskSign);
         }
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 1293)
         {
            NpcDialogController.showForNpc(10005);
         }
         if(param1.taskID == 2062)
         {
            AnimatPlay.startAnimat("task2062_",0,true);
         }
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 1874)
         {
            PveEntry.instance.enterTollgate(623);
         }
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
      }
      
      private function onNoticeClick(param1:MouseEvent) : void
      {
         var taskID:uint = 0;
         var dialogInfo:DialogInfoSimple = null;
         var funcOver:Function = null;
         var funcAccept:Function = null;
         var ev:MouseEvent = param1;
         if(Boolean(TasksManager.isAccepted(1109)) || Boolean(TasksManager.isCompleted(1109)))
         {
            if(TasksManager.isAccepted(1109))
            {
               TasksManager.dispatchActionEvent(TaskActionEvent.TASK_SIMPLEACTION,"DailyNotice");
            }
            taskID = uint(TasksManager.isDailyProcess());
            if(taskID != 0)
            {
               if(TasksManager.isReady(taskID))
               {
                  funcOver = function():void
                  {
                     ModuleManager.turnModule(ClientConfig.getAppModule("TaskPanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[4],taskID);
                  };
                  dialogInfo = new DialogInfoSimple([AppLanguageDefine.NPC_DIALOG_MAP1[0]],TasksXMLInfo.getName(taskID) + AppLanguageDefine.COMPLETE);
                  NpcDialogController.showForSimple(dialogInfo,10059,funcOver);
               }
               else
               {
                  dialogInfo = new DialogInfoSimple([AppLanguageDefine.NPC_DIALOG_MAP1[1]],TasksXMLInfo.getName(taskID) + AppLanguageDefine.NOTCOMPLETE);
                  NpcDialogController.showForSimple(dialogInfo,10059);
               }
            }
            else if(!TasksManager.isDailyAcceptabel())
            {
               dialogInfo = new DialogInfoSimple([AppLanguageDefine.NPC_DIALOG_MAP1[2] + TasksManager.DAILY_LEVEL_MAX.toString() + AppLanguageDefine.NPC_DIALOG_MAP1[3]],AppLanguageDefine.NPC_DIALOG_MAP1[4]);
               NpcDialogController.showForSimple(dialogInfo,10059);
            }
            else
            {
               funcAccept = function():void
               {
                  TasksManager.acceptDaily();
               };
               dialogInfo = new DialogInfoSimple([AppLanguageDefine.NPC_DIALOG_MAP1[5] + TasksManager.DAILY_LEVEL_MAX.toString() + AppLanguageDefine.NPC_DIALOG_MAP1[6]],AppLanguageDefine.NPC_DIALOG_MAP1[7]);
               NpcDialogController.showForSimple(dialogInfo,10059,funcAccept);
            }
         }
      }
      
      private function initTongMC() : void
      {
         this.tongMC.buttonMode = true;
         this.tongMC.addEventListener(MouseEvent.CLICK,this.onTongClick);
      }
      
      private function onTongClick(param1:MouseEvent) : void
      {
         if(WallowUtil.isWallow())
         {
            WallowUtil.showWallowMsg(AppLanguageDefine.WALLOW_MSG_ARR[13]);
         }
         else
         {
            this.tongMC.addEventListener(Event.ENTER_FRAME,this.onTongPlay);
            this.tongMC.gotoAndPlay(2);
         }
      }
      
      private function onTongPlay(param1:Event) : void
      {
         if(this.tongMC.currentFrame == this.tongMC.totalFrames - 1)
         {
            this.tongMC.removeEventListener(Event.ENTER_FRAME,this.onTongPlay);
            SocketConnection.addCmdListener(CommandID.DAILY_ACTIVITY,this.onGetMaterial);
            SocketConnection.send(CommandID.DAILY_ACTIVITY,2001);
         }
      }
      
      private function onGetMaterial(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.DAILY_ACTIVITY,this.onGetMaterial);
         var _loc2_:DailyActiveAwardInfo = param1.data as DailyActiveAwardInfo;
         var _loc3_:uint = uint(_loc2_.type);
         if(_loc3_ != DailyActivityXMLInfo.TYPE_REAP_MATERIAL)
         {
            return;
         }
         DailyActivityAward.addAward(_loc2_);
      }
      
      private function get getExtendBagMC() : MovieClip
      {
         if(this._getExtendBagMC == null)
         {
            this._getExtendBagMC = MapManager.currentMap.libManager.getMovieClip("getExtendsBag");
         }
         return this._getExtendBagMC;
      }
      
      private function playGetExtendsBag() : void
      {
         MainManager.closeOperate();
         this._sightModel10005.visible = false;
         this.getExtendBagMC.addEventListener(Event.ENTER_FRAME,this.onGetExtendBagEnter);
         this.getExtendBagMC.x = 1585;
         this.getExtendBagMC.y = 550;
         _mapModel.contentLevel.addChild(this.getExtendBagMC);
      }
      
      private function onGetExtendBagEnter(param1:Event) : void
      {
         if(this.getExtendBagMC.currentFrame == this.getExtendBagMC.totalFrames)
         {
            this.getExtendBagMC.stop();
            this.getExtendBagMC.removeEventListener(Event.ENTER_FRAME,this.onGetExtendBagEnter);
            this.flyToBag();
            this._sightModel10005.visible = true;
         }
      }
      
      private function flyToBag() : void
      {
         DisplayUtil.removeForParent(this.getExtendBagMC);
         LayerManager.topLevel.addChild(this.getExtendBagMC);
         DisplayUtil.align(this.getExtendBagMC,null,AlignType.MIDDLE_CENTER);
         TweenLite.to(this.getExtendBagMC,1,{
            "x":570,
            "y":500,
            "ease":Quad.easeIn,
            "onComplete":this.onFinishToBag
         });
      }
      
      private function onFinishToBag() : void
      {
         MainManager.openOperate();
         DisplayUtil.removeForParent(this.getExtendBagMC);
         this._getExtendBagMC = null;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         removeSimpleClickAnimat(this.tongMC);
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onDailySignUpdate);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onDailySignUpdate);
         TasksManager.removeListener(TaskEvent.QUIT,this.onDailySignUpdate);
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
         SocketConnection.removeCmdListener(CommandID.DAILY_ACTIVITY,this.onGetMaterial);
         if(this._guide)
         {
            this._guide.destory();
         }
         if(this._taskSign)
         {
            DisplayUtil.removeForParent(this._taskSign);
            this._taskSign = null;
         }
         this.tongMC = null;
         this.noticeMC = null;
         this._sightModel10191 = null;
      }
   }
}

