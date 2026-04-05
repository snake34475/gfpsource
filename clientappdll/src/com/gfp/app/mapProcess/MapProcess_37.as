package com.gfp.app.mapProcess
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class MapProcess_37 extends BaseMapProcess
   {
      
      private var _clickMC:MovieClip;
      
      public function MapProcess_37()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._clickMC = MapManager.currentMap.downLevel["clickMC"];
         this._clickMC.buttonMode = true;
         this._clickMC.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         ModuleManager.turnModule(ClientConfig.getAppModule("PveAlertPanel"),"正在加载...",934);
      }
      
      override public function destroy() : void
      {
         this._clickMC.removeEventListener(MouseEvent.CLICK,this.onClick);
      }
   }
}

