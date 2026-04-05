package com.gfp.app.mapProcess
{
   import com.gfp.app.toolBar.CityToolBar;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.CityMap;
   
   public class MapProcess_65 extends BaseMapProcess
   {
      
      public function MapProcess_65()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(MainManager.isFirstLogin)
         {
            MainManager.isFirstLogin = false;
            CityMap.instance.tranToNpc(10500);
         }
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 202 && param1.proID == 2)
         {
            CityToolBar.instance.setSkillBtnFlash(false);
         }
         if(param1.taskID == 202 && param1.proID == 3)
         {
            CityToolBar.instance.setSkillBtnFlash(true);
         }
      }
   }
}

