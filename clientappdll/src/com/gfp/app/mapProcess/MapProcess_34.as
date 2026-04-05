package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import org.taomee.algo.AStar;
   
   public class MapProcess_34 extends BaseMapProcess
   {
      
      private var _summonModelArr:Array;
      
      public function MapProcess_34()
      {
         super();
      }
      
      override protected function init() : void
      {
         AStar.instance.maxTry = 12000;
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 73)
         {
            NpcDialogController.showForNpc(10144);
         }
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 1779 && param1.proID == 0)
         {
            PveEntry.enterTollgate(741);
         }
      }
      
      override public function destroy() : void
      {
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
         AStar.instance.maxTry = 2000;
      }
   }
}

