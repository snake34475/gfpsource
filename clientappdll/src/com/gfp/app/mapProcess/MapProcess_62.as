package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.CityMap;
   
   public class MapProcess_62 extends BaseMapProcess
   {
      
      public static const EXPEDITION_TASK:uint = 1805;
      
      public function MapProcess_62()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.initMapUI();
         this.addTaskListener();
      }
      
      private function initMapUI() : void
      {
      }
      
      private function addTaskListener() : void
      {
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
      }
      
      private function removeTaskListener() : void
      {
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 1803)
         {
            CityMap.instance.tranToTollgate(930);
         }
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == EXPEDITION_TASK && param1.proID == 0)
         {
            CityMap.instance.tranToNpc(10409);
         }
         if(param1.taskID == 97 && param1.proID == 0)
         {
            AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
            AnimatPlay.startAnimat("task97_",1,false,0,0,false,true);
         }
      }
      
      private function onAnimatEnd(param1:AnimatEvent) : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
         NpcDialogController.showForNpc(10419);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.removeTaskListener();
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
      }
   }
}

