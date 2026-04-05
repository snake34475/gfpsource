package com.gfp.app.mapProcess
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.SightModel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MapProcess_35 extends BaseMapProcess
   {
      
      private var _npc10147:SightModel;
      
      private var _mask:MovieClip;
      
      public function MapProcess_35()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.initForTask1316();
         this.addTaskListener();
      }
      
      private function addTaskListener() : void
      {
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
      }
      
      private function initForTask1316() : void
      {
         this._mask = MapManager.currentMap.contentLevel["maskMC"] as MovieClip;
         this._npc10147 = SightManager.getSightModel(10147);
         if(Boolean(TasksManager.isCompleted(1326)) || Boolean(TasksManager.isTaskProComplete(1326,2)))
         {
            this._npc10147.visible = true;
         }
         else
         {
            this._npc10147.visible = false;
         }
         if(TasksManager.isProcess(1326,2))
         {
            this._mask.addEventListener(MouseEvent.CLICK,this.onMaskClick);
            this._mask.buttonMode = true;
         }
      }
      
      private function onMaskClick(param1:MouseEvent) : void
      {
         this._mask.buttonMode = false;
         this._mask.removeEventListener(MouseEvent.CLICK,this.onMaskClick);
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_MAPCOLLECT,"findWangXiaoYou");
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 1326 && param1.proID == 2)
         {
            this.playMaskAnimat();
         }
      }
      
      private function playMaskAnimat() : void
      {
         MainManager.closeOperate();
         this._mask.addEventListener(Event.ENTER_FRAME,this.onMaskEnterFrame);
         this._mask.gotoAndPlay(2);
      }
      
      private function onMaskEnterFrame(param1:Event) : void
      {
         if(this._mask.currentFrame == this._mask.totalFrames)
         {
            this._mask.removeEventListener(Event.ENTER_FRAME,this.onMaskEnterFrame);
            MainManager.openOperate();
            this._npc10147.visible = true;
         }
      }
      
      override public function destroy() : void
      {
         this._npc10147 = null;
         this._mask.removeEventListener(MouseEvent.CLICK,this.onMaskClick);
         this._mask.removeEventListener(Event.ENTER_FRAME,this.onMaskEnterFrame);
         this._mask = null;
         this.removeTaskListener();
      }
      
      private function removeTaskListener() : void
      {
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
      }
   }
}

