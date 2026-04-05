package com.gfp.app.mapProcess
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.TextFormatUtil;
   
   public class MapProcess_1091402 extends BaseMapProcess
   {
      
      private const _monsterNotKill:uint = 11211;
      
      public function MapProcess_1091402()
      {
         super();
      }
      
      override protected function init() : void
      {
         TasksManager.addActionListener(TaskActionEvent.TASK_MONSTERWANTED,this._monsterNotKill.toString(),this.onInnocentKill);
      }
      
      private function onInnocentKill(param1:TaskActionEvent) : void
      {
         TextAlert.show(TextFormatUtil.getRedText("滥杀无辜的村民是不对的行为，请小侠士立刻停止！"));
      }
      
      override public function destroy() : void
      {
         TasksManager.removeActionListener(TaskActionEvent.TASK_MONSTERWANTED,this._monsterNotKill.toString(),this.onInnocentKill);
         super.destroy();
      }
   }
}

