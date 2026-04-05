package com.gfp.app.mapProcess
{
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.model.sensemodels.TeleporterModel;
   
   public class MapProcess_1063 extends BaseMapProcess
   {
      
      private var _tranModelTo7:SightModel;
      
      private var _sightModel10573:SightModel;
      
      private var _sightModel10574:SightModel;
      
      private var _sightModel10575:SightModel;
      
      private var _sightModel10576:SightModel;
      
      private var _sightModel10577:SightModel;
      
      private var _sightModel10578:SightModel;
      
      private var _sightModel10579:SightModel;
      
      public function MapProcess_1063()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._sightModel10573 = SightManager.getSightModel(10573);
         this._sightModel10574 = SightManager.getSightModel(10574);
         this._sightModel10575 = SightManager.getSightModel(10575);
         this._sightModel10576 = SightManager.getSightModel(10576);
         this._sightModel10577 = SightManager.getSightModel(10577);
         this._sightModel10578 = SightManager.getSightModel(10578);
         this._sightModel10579 = SightManager.getSightModel(10579);
         SightManager.getSightModelList().forEach(function(param1:SightModel, param2:int, param3:Array):void
         {
            if(param1 is TeleporterModel && (param1 as TeleporterModel).toMapId == 7)
            {
               _tranModelTo7 = param1;
            }
         });
         this._sightModel10573.visible = true;
         this._sightModel10574.visible = true;
         this._sightModel10575.visible = true;
         this._sightModel10576.visible = false;
         this._sightModel10577.visible = false;
         this._sightModel10578.visible = false;
         this._sightModel10579.visible = false;
         if(TasksManager.isCompleted(7004))
         {
            this._tranModelTo7.visible = true;
            this._sightModel10573.visible = false;
            this._sightModel10574.visible = false;
            this._sightModel10575.visible = false;
            this._sightModel10576.visible = true;
            this._sightModel10577.visible = true;
            this._sightModel10578.visible = true;
            this._sightModel10579.visible = true;
         }
         else
         {
            this._tranModelTo7.visible = false;
         }
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
      }
      
      private function removeEvent() : void
      {
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 7004)
         {
            this._tranModelTo7.visible = true;
            this._sightModel10573.visible = false;
            this._sightModel10574.visible = false;
            this._sightModel10575.visible = false;
            this._sightModel10576.visible = true;
            this._sightModel10577.visible = true;
            this._sightModel10578.visible = true;
            this._sightModel10579.visible = true;
         }
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 7004)
         {
            if(Boolean(TasksManager.isTaskProComplete(7004,1)) && !TasksManager.isTaskProComplete(7004,2))
            {
               this._tranModelTo7.visible = true;
               this._sightModel10573.visible = false;
               this._sightModel10574.visible = false;
               this._sightModel10575.visible = false;
               this._sightModel10576.visible = true;
               this._sightModel10577.visible = true;
               this._sightModel10578.visible = true;
               this._sightModel10579.visible = true;
            }
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.removeEvent();
      }
   }
}

