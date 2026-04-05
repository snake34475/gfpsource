package com.gfp.app.toolBar
{
   import flash.display.Sprite;
   
   public class LvlUpAlertEntry
   {
      
      private static var _instance:LvlUpAlertEntry;
      
      private var _mainUI:Sprite;
      
      private var _isHide:Boolean;
      
      public function LvlUpAlertEntry()
      {
         super();
      }
      
      public static function get instance() : LvlUpAlertEntry
      {
         if(_instance == null)
         {
            _instance = new LvlUpAlertEntry();
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
      }
      
      public function show() : void
      {
      }
      
      public function hide() : void
      {
      }
      
      public function destroy() : void
      {
      }
   }
}

