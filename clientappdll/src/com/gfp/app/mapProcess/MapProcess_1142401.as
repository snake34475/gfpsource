package com.gfp.app.mapProcess
{
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1142401 extends BaseMapProcess
   {
      
      private var _mc:MovieClip;
      
      public function MapProcess_1142401()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._mc = _mapModel.libManager.getMovieClip("tipsUI_1424");
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         LayerManager.topLevel.addChild(this._mc);
      }
      
      private function resizePos() : void
      {
         this._mc.x = LayerManager.stageWidth - this._mc.width;
         this._mc.y = LayerManager.stageHeight / 2;
      }
      
      override public function destroy() : void
      {
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this._mc);
      }
   }
}

