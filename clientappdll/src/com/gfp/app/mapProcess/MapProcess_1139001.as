package com.gfp.app.mapProcess
{
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1139001 extends BaseMapProcess
   {
      
      private var _showTips:MovieClip;
      
      public function MapProcess_1139001()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._showTips = _mapModel.libManager.getMovieClip("UI_leji");
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         LayerManager.topLevel.addChild(this._showTips);
      }
      
      private function resizePos() : void
      {
         this._showTips.x = 100 + 500 + 300;
         this._showTips.y = 150 + 10;
      }
      
      override public function destroy() : void
      {
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this._showTips);
      }
   }
}

