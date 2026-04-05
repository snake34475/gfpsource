package com.gfp.app.toolBar
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.player.MovieClipPlayer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class EverydaySignEntry
   {
      
      private static var _instance:EverydaySignEntry;
      
      private static var _able:Boolean = false;
      
      private var _mainUI:MovieClip;
      
      private var mcEffect:MovieClipPlayer;
      
      public function EverydaySignEntry()
      {
         super();
      }
      
      public static function get instance() : EverydaySignEntry
      {
         return _instance = _instance || new EverydaySignEntry();
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      public function destroy() : void
      {
         this.hide();
         this._mainUI = null;
         StageResizeController.instance.unregister(this.layout);
      }
      
      private function initEvent() : void
      {
         this._mainUI.addEventListener(MouseEvent.CLICK,this.openPanel);
         StageResizeController.instance.register(this.layout);
      }
      
      public function show() : void
      {
      }
      
      public function hide() : void
      {
      }
      
      private function layout() : void
      {
         this._mainUI.x = LayerManager.stageWidth - 508;
         this._mainUI.y = LayerManager.stageHeight - 80;
      }
      
      public function hasAwardAlert() : void
      {
      }
      
      public function clearAwradAlert() : void
      {
         this.mcEffect.visible = false;
         this.mcEffect.stop();
      }
      
      private function openPanel(param1:MouseEvent) : void
      {
         if(MapManager.currentMap.info.mapType == MapType.TRADE)
         {
            AlertManager.showTradeMapUnavailableAlarm();
            return;
         }
         ModuleManager.turnModule(ClientConfig.getAppModule("CatchDragonPanel"),"正在加载...");
         this.clearAwradAlert();
      }
   }
}

