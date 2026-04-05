package com.gfp.app.mapProcess
{
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1130301 extends BaseMapProcess
   {
      
      private var _cntMc:MovieClip;
      
      public function MapProcess_1130301()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._cntMc = _mapModel.libManager.getMovieClip("UI_TipMC");
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         LayerManager.topLevel.addChild(this._cntMc);
      }
      
      private function resizePos() : void
      {
         this._cntMc.x = 300;
         this._cntMc.y = 455;
      }
      
      override public function destroy() : void
      {
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this._cntMc);
      }
   }
}

