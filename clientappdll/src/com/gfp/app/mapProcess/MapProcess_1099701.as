package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.geom.Point;
   
   public class MapProcess_1099701 extends BaseMapProcess
   {
      
      public function MapProcess_1099701()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addMapEvent();
      }
      
      private function addMapEvent() : void
      {
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWin);
      }
      
      private function removeMapEvent() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWin);
      }
      
      private function onWin(param1:FightEvent) : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_CUSTOM_FINISH,"1923_1");
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_CUSTOM_FINISH,"2061_0");
         TextAlert.show("恭喜你小侠士，你已经打通九天连环阵！快去领取奖励吧。");
         FightManager.outToMapID = 53;
         FightManager.outToMapPos = new Point(1046,627);
      }
      
      override public function destroy() : void
      {
         this.removeMapEvent();
         super.destroy();
      }
   }
}

