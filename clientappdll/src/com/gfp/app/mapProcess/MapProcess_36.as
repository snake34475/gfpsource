package com.gfp.app.mapProcess
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.SightModel;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import org.taomee.manager.ToolTipManager;
   
   public class MapProcess_36 extends BaseMapProcess
   {
      
      private var clickMC:MovieClip;
      
      private var teleport37:SightModel;
      
      public function MapProcess_36()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.teleport37 = SightManager.getSightModel(37);
         this.clickMC = MapManager.currentMap.contentLevel["clickMC"];
         this.clickMC.buttonMode = true;
         this.clickMC.addEventListener(MouseEvent.CLICK,this.onClick);
         ToolTipManager.add(this.clickMC,"点击进入水晶法阵");
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
         if(!TasksManager.isCompleted(1774))
         {
            this.teleport37.hide();
         }
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 1774)
         {
            this.teleport37.show();
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         ModuleManager.turnModule(ClientConfig.getAppModule("PveAlertPanel"),"正在加载...",933);
      }
      
      override public function destroy() : void
      {
         ToolTipManager.remove(this.clickMC);
         this.clickMC.removeEventListener(MouseEvent.CLICK,this.onClick);
         this.clickMC = null;
      }
   }
}

