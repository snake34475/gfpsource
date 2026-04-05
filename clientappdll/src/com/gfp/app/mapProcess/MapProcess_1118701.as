package com.gfp.app.mapProcess
{
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1118701 extends BaseMapProcess
   {
      
      private var _txtInfoMc:MovieClip;
      
      public function MapProcess_1118701()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._txtInfoMc = _mapModel.libManager.getMovieClip("UI_TxtInfo");
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
      }
      
      private function resizePos() : void
      {
         this._txtInfoMc.x = LayerManager.stageWidth - this._txtInfoMc.width >> 1;
         this._txtInfoMc.y = 165;
         LayerManager.topLevel.addChild(this._txtInfoMc);
      }
      
      override public function destroy() : void
      {
         DisplayUtil.removeForParent(this._txtInfoMc);
         StageResizeController.instance.unregister(this.resizePos);
      }
   }
}

