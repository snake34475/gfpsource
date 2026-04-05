package com.gfp.app.mapProcess
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1058 extends BaseMapProcess
   {
      
      public function MapProcess_1058()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         if(Boolean(TasksManager.isAccepted(300)) && Boolean(TasksManager.isTaskProComplete(300,0)))
         {
            NpcDialogController.showForNpc(10549);
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

