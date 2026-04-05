package com.gfp.app.toolBar
{
   import com.gfp.core.controller.FocusKeyController;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class CityWarMiniMapEntry
   {
      
      private static var _instance:CityWarMiniMapEntry;
      
      private var _mainUI:InteractiveObject;
      
      public function CityWarMiniMapEntry()
      {
         super();
      }
      
      public static function get instance() : CityWarMiniMapEntry
      {
         if(_instance == null)
         {
            _instance = new CityWarMiniMapEntry();
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
         this._mainUI = UIManager.getSprite("ToolBar_CityMapEntry");
         this._mainUI.addEventListener(MouseEvent.CLICK,this.onClickHandler);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         FocusKeyController.addKeyListener(77,this.onKeyListner);
         ToolTipManager.add(this._mainUI,"小地图（M）");
      }
      
      private function onClickHandler(param1:MouseEvent = null) : void
      {
         ModuleManager.turnAppModule("CityWarMiniMap");
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         if(MapManager.mapInfo.mapType == MapType.STAND)
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
         if(this._mainUI.parent == null)
         {
            LayerManager.toolsLevel.addChild(this._mainUI);
            DisplayUtil.align(this._mainUI,null,AlignType.BOTTOM_CENTER,new Point(-95,-10));
         }
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
         FocusKeyController.removeKeyListener(77,this.onKeyListner);
         ToolTipManager.remove(this._mainUI);
         this._mainUI = null;
      }
   }
}

