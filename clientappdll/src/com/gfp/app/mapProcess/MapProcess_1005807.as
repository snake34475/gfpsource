package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.core.events.PickItemEvent;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1005807 extends BaseMapProcess
   {
      
      public function MapProcess_1005807()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(TasksManager.isProcess(96,0))
         {
            ItemManager.addListener(PickItemEvent.PICK_UP_ITEM,this.onPickUPItem);
         }
      }
      
      private function onPickUPItem(param1:PickItemEvent) : void
      {
         if(param1.itemID == 1410231 && ItemManager.getItemCount(1410231) <= 1)
         {
            AnimatPlay.startAnimat("task96_",1,false,0,0,false,true);
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         ItemManager.removeListener(PickItemEvent.PICK_UP_ITEM,this.onPickUPItem);
      }
   }
}

