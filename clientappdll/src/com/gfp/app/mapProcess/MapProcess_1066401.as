package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.model.UserModel;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   
   public class MapProcess_1066401 extends BaseMapProcess
   {
      
      public function MapProcess_1066401()
      {
         super();
         FightManager.instance.addEventListener(FightEvent.REASON,this.onReason);
         MainManager.actorModel.addEventListener(UserEvent.DIE,this.onActorDie);
      }
      
      private function checkTaskStatus() : void
      {
         FightManager.isAutoWinnerEnd = false;
         FightManager.isAutoReasonEnd = false;
         FightManager.outToMapID = 7;
      }
      
      override protected function init() : void
      {
         this.checkTaskStatus();
      }
      
      private function onActorDie(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.userID == MainManager.actorID)
         {
            setTimeout(this.quit,2000);
         }
      }
      
      private function quit() : void
      {
         FightManager.quit();
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_TOLLGATE_PASSED,String(664));
         CityMap.instance.changeMap(7,0,1,new Point(708,400));
      }
      
      private function onReason(param1:FightEvent) : void
      {
      }
      
      override public function destroy() : void
      {
         MainManager.actorModel.removeEventListener(UserEvent.DIE,this.onActorDie);
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onReason);
      }
   }
}

