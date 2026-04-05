package com.gfp.app.mapProcess
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapProcess_66 extends BaseMapProcess
   {
      
      private var npc10532:SightModel;
      
      public function MapProcess_66()
      {
         super();
         this.npc10532 = SightManager.getSightModel(10532);
         this.npc10532.visible = TasksManager.isProcess(2079,3);
      }
      
      override protected function init() : void
      {
         if(TasksManager.isProcess(2079,3))
         {
            NpcDialogController.showForNpc(10532);
         }
      }
      
      override public function destroy() : void
      {
      }
   }
}

