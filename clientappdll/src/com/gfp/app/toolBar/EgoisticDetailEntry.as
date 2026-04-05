package com.gfp.app.toolBar
{
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UIManager;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class EgoisticDetailEntry
   {
      
      private static var _instance:EgoisticDetailEntry;
      
      private var _entryBtn:SimpleButton;
      
      public function EgoisticDetailEntry()
      {
         super();
         this._entryBtn = UIManager.getButton("ToolBar_CityWarDataEntry");
         this._entryBtn.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public static function get instance() : EgoisticDetailEntry
      {
         if(_instance == null)
         {
            _instance = new EgoisticDetailEntry();
         }
         return _instance;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("EgoisticInfoPanel");
      }
      
      public function show() : void
      {
         LayerManager.toolsLevel.addChild(this._entryBtn);
         DisplayUtil.align(this._entryBtn,null,AlignType.MIDDLE_RIGHT);
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this._entryBtn);
      }
   }
}

