package com.gfp.app.toolBar
{
   import com.gfp.core.controller.FocusKeyController;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.MapModel;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class CityWarDataEntry
   {
      
      private static var _instance:CityWarDataEntry;
      
      private var _mainUI:InteractiveObject;
      
      public function CityWarDataEntry()
      {
         super();
      }
      
      public static function get instance() : CityWarDataEntry
      {
         if(_instance == null)
         {
            _instance = new CityWarDataEntry();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
         }
         _instance = null;
      }
      
      public function setup() : void
      {
         this._mainUI = UIManager.getSprite("ToolBar_CityWarDataEntry");
         this._mainUI.addEventListener(MouseEvent.CLICK,this.onClickHandler);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         FocusKeyController.addKeyListener(78,this.onKeyListner);
         ToolTipManager.add(this._mainUI,"战况（N）");
      }
      
      private function onClickHandler(param1:MouseEvent = null) : void
      {
         ModuleManager.turnAppModule("CityWarDataPanel");
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         var _loc2_:MapModel = param1.mapModel;
         if(_loc2_.info.mapType == MapType.STAND)
         {
            this.show();
         }
         else
         {
            this.hide();
         }
      }
      
      private function onKeyListner(param1:Event) : void
      {
         this.onClickHandler();
      }
      
      public function show() : void
      {
         LayerManager.toolsLevel.addChild(this._mainUI);
         DisplayUtil.align(this._mainUI,null,AlignType.BOTTOM_CENTER,new Point(-25,-10));
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this._mainUI);
      }
      
      public function destroy() : void
      {
         this.hide();
         this._mainUI.removeEventListener(MouseEvent.CLICK,this.onClickHandler);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         FocusKeyController.removeKeyListener(78,this.onKeyListner);
         ToolTipManager.remove(this._mainUI);
         this._mainUI = null;
      }
   }
}

