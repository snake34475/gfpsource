package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.geom.Point;
   
   public class MapProcess_1068501 extends BaseMapProcess
   {
      
      public function MapProcess_1068501()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.checkTaskStatus();
      }
      
      private function checkTaskStatus() : void
      {
         if(Boolean(TasksManager.isAccepted(1880)) && !TasksManager.isTaskProComplete(1880,4))
         {
            FightManager.isAutoWinnerEnd = false;
            FightManager.isAutoReasonEnd = false;
            FightManager.outToMapID = 63;
            FightManager.outToMapPos = new Point(1318,650);
            this.addMapEvent();
         }
      }
      
      private function addMapEvent() : void
      {
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
         FightManager.instance.addEventListener(FightEvent.REASON,this.onReason);
      }
      
      private function removeMapEvent() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onReason);
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         PveEntry.onWinner();
         MainManager.actorModel.changeRoleView(0);
      }
      
      private function onReason(param1:FightEvent) : void
      {
         PveEntry.onReason();
      }
      
      override public function destroy() : void
      {
         this.removeMapEvent();
         super.destroy();
      }
   }
}

