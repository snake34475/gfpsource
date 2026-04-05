package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1001002 extends BaseMapProcess
   {
      
      public function MapProcess_1001002()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(Boolean(TasksManager.isAccepted(50)) && Boolean(TasksManager.isProcess(50,1)))
         {
            FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
         }
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_SIMPLEACTION,"Levels_Pass");
      }
   }
}

