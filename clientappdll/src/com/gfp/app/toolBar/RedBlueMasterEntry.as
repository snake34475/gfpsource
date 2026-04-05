package com.gfp.app.toolBar
{
   import com.gfp.core.controller.ToolBarQuickKey;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class RedBlueMasterEntry
   {
      
      private static var _instance:RedBlueMasterEntry;
      
      private var _mainUI:MovieClip;
      
      private var _up:MovieClip;
      
      private var _low:MovieClip;
      
      private var _unreadCount:int;
      
      public function RedBlueMasterEntry()
      {
         super();
      }
      
      public static function get instance() : RedBlueMasterEntry
      {
         if(_instance == null)
         {
            _instance = new RedBlueMasterEntry();
         }
         return _instance;
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
      }
      
      public function show() : void
      {
      }
      
      public function hide() : void
      {
         if(this._mainUI)
         {
            ToolBarQuickKey.removeTip(this._mainUI);
            DisplayUtil.removeForParent(this._mainUI,false);
         }
      }
      
      private function onShowFlag(param1:MouseEvent) : void
      {
      }
   }
}

