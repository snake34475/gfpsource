package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.ui.UILoader;
   import flash.display.MovieClip;
   
   public class MapProcess_1005107 extends BaseMapProcess
   {
      
      private var _mainMC:MovieClip;
      
      private var _loader:UILoader;
      
      public function MapProcess_1005107()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(TasksManager.isProcess(78,2))
         {
            FightManager.isAutoWinnerEnd = false;
            FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
         }
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_MAPCOLLECT,"task_78_pro_2");
      }
      
      override public function destroy() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
      }
   }
}

