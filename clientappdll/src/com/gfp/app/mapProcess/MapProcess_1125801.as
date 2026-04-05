package com.gfp.app.mapProcess
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   
   public class MapProcess_1125801 extends BaseMapProcess
   {
      
      public function MapProcess_1125801()
      {
         super();
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onCom);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onCom);
      }
      
      private function onCom(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onCom);
         NpcDialogController.goToNpc(58,10608,350,481);
      }
   }
}

