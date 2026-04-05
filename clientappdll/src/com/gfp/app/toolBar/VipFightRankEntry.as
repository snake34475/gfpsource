package com.gfp.app.toolBar
{
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UIManager;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class VipFightRankEntry extends Sprite
   {
      
      private static var _instance:VipFightRankEntry;
      
      private var _mainUI:InteractiveObject;
      
      public function VipFightRankEntry()
      {
         super();
         this._mainUI = UIManager.getSprite("ToolBar_CityWarDataEntry");
         addChild(this._mainUI);
         addEventListener(MouseEvent.CLICK,this.onRankPanel);
      }
      
      public static function get instance() : VipFightRankEntry
      {
         if(_instance == null)
         {
            _instance = new VipFightRankEntry();
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
      
      public function show() : void
      {
         LayerManager.toolsLevel.addChild(this);
         DisplayUtil.align(this,null,AlignType.MIDDLE_RIGHT);
      }
      
      private function onRankPanel(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("VipFightRankPanel");
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this);
         removeEventListener(MouseEvent.CLICK,this.onRankPanel);
         this._mainUI = null;
      }
   }
}

