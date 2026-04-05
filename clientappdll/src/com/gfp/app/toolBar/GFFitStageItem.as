package com.gfp.app.toolBar
{
   import com.gfp.core.controller.StageResizeController;
   
   public class GFFitStageItem
   {
      
      public function GFFitStageItem()
      {
         super();
         StageResizeController.instance.register(this.layout);
      }
      
      protected function layout() : void
      {
      }
      
      public function destroy() : void
      {
         StageResizeController.instance.unregister(this.layout);
      }
      
      protected function needToReponseNew() : Boolean
      {
         return true;
      }
      
      public function show() : void
      {
      }
      
      public function hide() : void
      {
      }
   }
}

