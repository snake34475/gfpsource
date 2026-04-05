package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.behavior.ChangeRideBehavior;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.GfpEvent;
   import com.gfp.core.events.RideEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.info.MapInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.RideManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.AppModel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MapProcess_63 extends MapProcessAnimat
   {
      
      private var _pheonix:MovieClip;
      
      public function MapProcess_63()
      {
         _mangoType = 1;
         super();
      }
      
      override protected function init() : void
      {
         _mangoType = 1;
         this.initMapUI();
         this.addTaskListener();
         if(Boolean(TasksManager.isProcess(2077,1)) && !TasksManager.isTaskProComplete(2077,1))
         {
            TasksManager.taskProComplete(2077,1);
         }
         if(Boolean(TasksManager.isCompleted(2076)) && !TasksManager.isAccepted(2077))
         {
            TasksManager.accept(2077);
         }
      }
      
      private function initMapUI() : void
      {
         if(TasksManager.isAccepted(1880))
         {
            if(Boolean(TasksManager.isTaskProComplete(1880,4)) && !TasksManager.isTaskProComplete(1880,5))
            {
               NpcDialogController.showForNpc(10428);
            }
         }
         this.addMapEvent();
      }
      
      private function addMapEvent() : void
      {
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         ModuleManager.closeAllModule();
         ModuleManager.turnAppModule("PhoenixRegainPanel");
      }
      
      private function onShowMajorPanel(param1:Event) : void
      {
         ModuleManager.turnAppModule("PhenixCard");
      }
      
      private function addTaskListener() : void
      {
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
      }
      
      private function removeTaskListener() : void
      {
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 95)
         {
            if(RideManager.isOnRide)
            {
               RideManager.addEventListener(RideEvent.RIDE_OFF,this.onRoleChange);
               MainManager.actorModel.execBehavior(new ChangeRideBehavior(0,true));
            }
            else
            {
               this.onRoleChange(null);
            }
         }
         else if(param1.taskID == 1815)
         {
            AnimatPlay.startAnimat("task1815_",1,false,231,132,false,true);
         }
         else if(param1.taskID == 1878)
         {
            NpcDialogController.showForNpc(10428);
         }
         else if(param1.taskID == 1879)
         {
            PveEntry.instance.enterTollgate(683);
         }
      }
      
      private function onRoleChange(param1:RideEvent) : void
      {
         MainManager.actorModel.changeRoleView(10430);
         CityMap.instance.tranToNpc(10430);
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         var app:AppModel = null;
         var onNewBieTutorial:Function = null;
         var event:TaskEvent = param1;
         if(event.taskID == 97 && event.proID == 2)
         {
            AnimatPlay.startAnimat("task97_",2,false,0,0,false,true);
         }
         else if(event.taskID == 103 && event.proID == 0)
         {
            AnimatPlay.startAnimat("task103_",1,false,0,0,false,true);
         }
         else if(event.taskID == 1815 && event.proID == 0)
         {
            CityMap.instance.tranToTollgate(806);
         }
         else if(event.taskID == 1878 && event.proID == 0)
         {
            NpcDialogController.showForNpc(10428);
         }
         else if(event.taskID == 2072 && event.proID == 0)
         {
            onNewBieTutorial = function(param1:Event):void
            {
               param1.target.removeEventListener(GfpEvent.DESTROY,onNewBieTutorial);
               if(MapManager.mapInfo == null)
               {
                  MapManager.mapInfo = new MapInfo();
               }
               MapManager.mapInfo.mapType = MapType.STAND;
               CityMap.instance.tranToNpc(10429);
            };
            app = new AppModel(ClientConfig.getGameModule("MechaTutorial"),"");
            app.init({
               "userInfo":MainManager.actorInfo,
               "stageID":998
            });
            app.show();
            app.addEventListener(GfpEvent.DESTROY,onNewBieTutorial);
            TasksManager.taskComplete(2072);
         }
      }
      
      private function onAnimatEnd(param1:AnimatEvent) : void
      {
         if(param1.data == "task97_2")
         {
            NpcDialogController.showForNpc(10429);
         }
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 95)
         {
            MainManager.actorModel.resetRoleView();
         }
         else if(param1.taskID == 1878)
         {
            NpcDialogController.showForNpc(10428);
         }
         else if(param1.taskID == 1879)
         {
            NpcDialogController.showForNpc(10428);
         }
      }
      
      private function removePhoenix() : void
      {
         _mapModel.contentLevel.removeChild(this._pheonix);
         this._pheonix.removeEventListener(MouseEvent.CLICK,this.onClick);
         this._pheonix = null;
      }
      
      override public function destroy() : void
      {
         this.removeTaskListener();
         MainManager.actorModel.resetRoleView();
         super.destroy();
      }
   }
}

