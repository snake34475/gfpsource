package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1057401 extends BaseMapProcess
   {
      
      public function MapProcess_1057401()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         TasksManager.addActionListener(TaskActionEvent.TASK_TOLLGATE_PASSED,"574",this.onTollgatePassed);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         TasksManager.removeActionListener(TaskActionEvent.TASK_TOLLGATE_PASSED,"574",this.onTollgatePassed);
      }
      
      private function onTollgatePassed(param1:TaskActionEvent) : void
      {
         AnimatPlay.startAnimat("light_dark_",3,false,0,0,false,true);
      }
   }
}

