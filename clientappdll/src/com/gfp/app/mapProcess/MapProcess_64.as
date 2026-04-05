package com.gfp.app.mapProcess
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapProcess_64 extends BaseMapProcess
   {
      
      private var npc10531:SightModel;
      
      public function MapProcess_64()
      {
         super();
         this.npc10531 = SightManager.getSightModel(10531);
         this.npc10531.visible = Boolean(TasksManager.isProcess(2079,5)) || Boolean(TasksManager.isCompleted(2080));
      }
      
      override protected function init() : void
      {
         if(TasksManager.isProcess(2079,5))
         {
            NpcDialogController.showForNpc(10531);
         }
      }
      
      override public function destroy() : void
      {
      }
   }
}

