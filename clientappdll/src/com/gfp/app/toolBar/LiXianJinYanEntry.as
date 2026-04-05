package com.gfp.app.toolBar
{
   import com.gfp.app.manager.OfflineExpManager;
   import com.gfp.core.controller.StageResizeController;
   import flash.events.MouseEvent;
   
   public class LiXianJinYanEntry
   {
      
      private static var _instance:LiXianJinYanEntry;
      
      public function LiXianJinYanEntry()
      {
         super();
      }
      
      public static function get instance() : LiXianJinYanEntry
      {
         return _instance = _instance || new LiXianJinYanEntry();
      }
      
      public function destroy() : void
      {
         this.hide();
         StageResizeController.instance.unregister(this.layout);
      }
      
      private function initEvent() : void
      {
         StageResizeController.instance.register(this.layout);
      }
      
      public function show() : void
      {
         if(OfflineExpManager.getInstance().haveTime <= 0)
         {
            return;
         }
         this.layout();
         this.initEvent();
      }
      
      public function hide() : void
      {
      }
      
      private function layout() : void
      {
      }
      
      private function openPanel(param1:MouseEvent) : void
      {
      }
   }
}

