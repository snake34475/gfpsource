package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.action.mouse.MouseProcess;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.ui.UILoader;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.algo.AStar;
   
   public class MapProcess_27 extends BaseMapProcess
   {
      
      private var _npc10119:SightModel;
      
      private var _loader:UILoader;
      
      private var _mainMC:MovieClip;
      
      public function MapProcess_27()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addTaskEventListener();
         this.initNpc10119ForTask40();
      }
      
      private function initNpc10119ForTask40() : void
      {
         this._npc10119 = SightManager.getSightModel(10119);
         this._npc10119.addEventListener(MouseEvent.CLICK,this.onNpc10119Click);
      }
      
      private function detroyNpcInitNpc10119ForTask40() : void
      {
         this._npc10119.removeEventListener(MouseEvent.CLICK,this.onNpc10119Click);
         this._npc10119 = null;
      }
      
      private function onNpc10119Click(param1:MouseEvent) : void
      {
         if(!TasksManager.isProcess(40,2) && Boolean(TasksManager.isProcess(40,3)))
         {
            PveEntry.enterTollgate(922);
         }
      }
      
      private function onEnterTollgate() : void
      {
         PveEntry.enterTollgate(922);
      }
      
      private function addTaskEventListener() : void
      {
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function removeTaskManagerEventListener() : void
      {
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 63)
         {
            AStar.instance.maxTry = 9999;
            MouseProcess.execWalk(MainManager.actorModel,new Point(1074,920));
            AStar.instance.maxTry = 2000;
         }
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 61)
         {
            if(param1.proID == 3)
            {
               MouseProcess.execWalk(MainManager.actorModel,new Point(1672,929));
            }
         }
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 63)
         {
         }
         if(param1.taskID == 64)
         {
            CityMap.instance.changeMap(7,0,1,new Point(380,800));
         }
      }
      
      override public function destroy() : void
      {
         this.removeTaskManagerEventListener();
         this.detroyNpcInitNpc10119ForTask40();
         super.destroy();
      }
   }
}

