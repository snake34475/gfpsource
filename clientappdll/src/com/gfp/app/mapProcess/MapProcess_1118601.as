package com.gfp.app.mapProcess
{
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1118601 extends BaseMapProcess
   {
      
      private var _warnMc:MovieClip;
      
      public function MapProcess_1118601()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._warnMc = _mapModel.libManager.getMovieClip("UI_Warn");
         LayerManager.topLevel.addChild(this._warnMc);
         this.resizePos();
         StageResizeController.instance.register(this.resizePos);
      }
      
      private function resizePos() : void
      {
         this._warnMc.y = 0;
         this._warnMc.x = LayerManager.stageWidth - this._warnMc.width;
      }
      
      override public function destroy() : void
      {
         DisplayUtil.removeForParent(this._warnMc);
         StageResizeController.instance.unregister(this.resizePos);
      }
   }
}

