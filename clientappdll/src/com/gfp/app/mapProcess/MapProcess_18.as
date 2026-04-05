package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.CheckForOpenFeather;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.LoadingType;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_18 extends MapProcessAnimat
   {
      
      private var _goToMap20:SightModel;
      
      private var _params:String;
      
      private var _mainMC:MovieClip;
      
      private var _loader:UILoader;
      
      private var _moduleOpen:CheckForOpenFeather;
      
      public function MapProcess_18()
      {
         _mangoType = 1;
         super();
      }
      
      override protected function init() : void
      {
         _mangoType = 1;
         TasksManager.addListener(TaskEvent.QUIT,this.onTaskQuit);
         this.isShowGoToMap20();
         TasksManager.addListener(TaskEvent.ACCEPT,this.onAcceptTask);
         if(TasksManager.isAccepted(2034))
         {
            NpcDialogController.showForNpc(10146);
         }
         if(!TasksManager.isCompleted(2063) && Boolean(TasksManager.isTaskProComplete(2063,0)))
         {
            TasksManager.taskComplete(2063);
         }
         TasksManager.addListener(TaskEvent.COMPLETE,this.onComplete);
         this._moduleOpen = new CheckForOpenFeather();
      }
      
      private function onComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 2063)
         {
            CityMap.instance.tranToNpc(10524);
         }
      }
      
      private function onAcceptTask(param1:TaskEvent) : void
      {
         if(param1.taskID == 2034)
         {
            NpcDialogController.showForNpc(10146);
         }
         if(param1.taskID == 2063)
         {
            TasksManager.taskComplete(2063);
         }
      }
      
      private function isShowGoToMap20() : void
      {
         if(TasksManager.isProcess(1719,1))
         {
            SightManager.getSightModel(1091101).visible = true;
         }
         else
         {
            SightManager.getSightModel(1091101).visible = false;
         }
         if(TasksManager.isProcess(1719,0))
         {
            SightManager.getSightModel(1091101).visible = true;
            this.loadAnimat();
         }
      }
      
      private function loadAnimat() : void
      {
         this._loader = new UILoader(ClientConfig.getCartoon("task1719_0"),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         MainManager.closeOperate();
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._mainMC = param1.uiloader.loader.content as MovieClip;
         this._mainMC.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         LayerManager.topLevel.addChild(this._mainMC);
         this._mainMC.gotoAndPlay(1);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this._mainMC.currentFrame == this._mainMC.totalFrames)
         {
            this._mainMC.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            DisplayUtil.removeForParent(this._mainMC);
            this.onFinish();
         }
      }
      
      public function onFinish() : void
      {
         this._mainMC = null;
         MainManager.openOperate();
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_MAPCOLLECT,"LetterReceive");
         PveEntry.enterTollgate(963);
      }
      
      private function onTaskQuit(param1:TaskEvent) : void
      {
         this.isShowGoToMap20();
      }
      
      override public function destroy() : void
      {
         TasksManager.removeListener(TaskEvent.QUIT,this.onTaskQuit);
         if(this._moduleOpen)
         {
            this._moduleOpen.destory();
            this._moduleOpen = null;
         }
         super.destroy();
      }
   }
}

