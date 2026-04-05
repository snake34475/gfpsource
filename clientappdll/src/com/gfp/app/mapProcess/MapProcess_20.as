package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.SightModel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_20 extends BaseMapProcess
   {
      
      private var _npc10057:SightModel;
      
      private var _npc10525:SightModel;
      
      private var _npc10524:SightModel;
      
      private var _beautyToBeastMC:MovieClip;
      
      public function MapProcess_20()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._npc10057 = SightManager.getSightModel(10057);
         this._npc10057.visible = false;
         this._npc10525 = SightManager.getSightModel(10525);
         this._npc10524 = SightManager.getSightModel(10524);
         this._npc10525.visible = false;
         this._npc10524.visible = false;
         if(TasksManager.isProcess(27,0))
         {
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         }
         if(Boolean(TasksManager.isAcceptable(28)) || Boolean(TasksManager.isProcess(28,0)) || Boolean(TasksManager.isReady(27)))
         {
            this._npc10057.visible = true;
         }
         if(Boolean(TasksManager.isAcceptable(28)) || Boolean(TasksManager.isProcess(28,0)) || Boolean(TasksManager.isReady(27)))
         {
            this._npc10057.visible = true;
         }
         TasksManager.addCommonListener(TaskEvent.PRO_COMPLETE,this.onProComplete);
         if(Boolean(TasksManager.isProcess(2064,1)) || Boolean(TasksManager.isProcess(2064,2)))
         {
            MainManager.actorModel.changeRoleView(11177);
         }
         if(TasksManager.isTaskProComplete(2064,2))
         {
            this._npc10525.visible = true;
         }
         if(TasksManager.isProcess(2064,6))
         {
            TasksManager.taskProComplete(2064,6);
         }
         if(TasksManager.isCompleted(2063))
         {
            this._npc10524.visible = true;
         }
         if(TasksManager.isTaskProComplete(2064,1))
         {
            this._npc10524.visible = false;
         }
         if(TasksManager.isTaskProComplete(2064,1))
         {
            this._npc10524.visible = false;
         }
         if(TasksManager.isCompleted(2064))
         {
            this._npc10525.visible = false;
            this._npc10524.visible = false;
         }
         TasksManager.addCommonListener(TaskEvent.COMPLETE,this.onCompleteTask);
      }
      
      private function onCompleteTask(param1:TaskEvent) : void
      {
         if(param1.taskID == 2064)
         {
            this._npc10525.visible = false;
         }
      }
      
      private function onProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 2064 && param1.proID == 1)
         {
            MainManager.actorModel.changeRoleView(11177);
         }
         if(param1.taskID == 2064 && param1.proID == 3)
         {
            MainManager.actorModel.changeRoleView(0);
         }
         if(TasksManager.isTaskProComplete(2064,1))
         {
            this._npc10524.visible = false;
         }
         if(TasksManager.isTaskProComplete(2064,2))
         {
            this._npc10525.visible = true;
         }
         if(param1.taskID == 2064 && param1.proID == 5)
         {
            PveEntry.instance.enterTollgate(401);
         }
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         this.playBeautyToBeast();
      }
      
      private function playBeautyToBeast() : void
      {
         MainManager.closeOperate(true);
         this._beautyToBeastMC = _mapModel.libManager.getMovieClip("beautyToBeastMC");
         this._beautyToBeastMC.addEventListener(Event.ENTER_FRAME,this.onBeautyToBeast);
         this._beautyToBeastMC.x = 424;
         this._beautyToBeastMC.y = 251;
         _mapModel.contentLevel.addChild(this._beautyToBeastMC);
      }
      
      private function onBeautyToBeast(param1:Event) : void
      {
         if(this._beautyToBeastMC.currentFrame == this._beautyToBeastMC.totalFrames)
         {
            this._beautyToBeastMC.removeEventListener(Event.ENTER_FRAME,this.onBeautyToBeast);
            DisplayUtil.removeForParent(this._beautyToBeastMC);
            MainManager.openOperate();
            PveEntry.enterTollgate(903);
         }
      }
      
      override public function destroy() : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         if(this._beautyToBeastMC)
         {
            this._beautyToBeastMC.removeEventListener(Event.ENTER_FRAME,this.onBeautyToBeast);
            this._beautyToBeastMC = null;
         }
      }
   }
}

