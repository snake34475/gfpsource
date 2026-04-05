package com.gfp.app.mapProcess
{
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1139601 extends BaseMapProcess
   {
      
      private var _showMC:MovieClip;
      
      public function MapProcess_1139601()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._showMC = _mapModel.libManager.getMovieClip("daoJu");
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         LayerManager.topLevel.addChild(this._showMC);
      }
      
      private function resizePos() : void
      {
         this._showMC.x = LayerManager.stageWidth - 310;
         this._showMC.y = 100;
      }
      
      override public function destroy() : void
      {
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this._showMC);
      }
   }
}

