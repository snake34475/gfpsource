package com.gfp.app.mapProcess
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.action.mouse.MouseProcess;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.CityMap;
   import flash.geom.Point;
   import org.taomee.algo.AStar;
   
   public class MapProcess_32 extends BaseMapProcess
   {
      
      public function MapProcess_32()
      {
         super();
      }
      
      override protected function init() : void
      {
         AStar.instance.maxTry = 7000;
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function removeEvent() : void
      {
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 66)
         {
            MouseProcess.execWalk(MainManager.actorModel,new Point(1303,1079));
         }
         if(param1.taskID == 67)
         {
            NpcDialogController.showForNpc(10127);
         }
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 67)
         {
            if(param1.proID == 2)
            {
               MouseProcess.execWalk(MainManager.actorModel,new Point(1306,336));
            }
         }
         if(param1.taskID == 68)
         {
            if(param1.proID == 1)
            {
               CityMap.instance.changeMap(5,0,1,new Point(500,400));
            }
         }
         if(param1.taskID == 69)
         {
            if(param1.proID == 2)
            {
               MouseProcess.execWalk(MainManager.actorModel,new Point(491,342));
            }
         }
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 66)
         {
            if(TasksManager.isAccepted(67) == false)
            {
               TasksManager.accept(67);
            }
         }
         if(param1.taskID == 67)
         {
            if(TasksManager.isAccepted(68) == false)
            {
               TasksManager.accept(68);
            }
         }
      }
      
      override public function destroy() : void
      {
         AStar.instance.maxTry = 2000;
         this.removeEvent();
      }
   }
}

