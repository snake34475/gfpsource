package com.gfp.app.mapProcess
{
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1117201 extends BaseMapProcess
   {
      
      private var _txtWarnMc:MovieClip;
      
      public function MapProcess_1117201()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._txtWarnMc = _mapModel.libManager.getMovieClip("UI_TxtWarn");
         DisplayUtil.align(this._txtWarnMc,null,AlignType.MIDDLE_CENTER);
         LayerManager.topLevel.addChild(this._txtWarnMc);
         this.resizePos();
         StageResizeController.instance.register(this.resizePos);
      }
      
      private function resizePos() : void
      {
         this._txtWarnMc.y = 0;
         this._txtWarnMc.x = LayerManager.stageWidth - this._txtWarnMc.width;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         DisplayUtil.removeForParent(this._txtWarnMc);
         StageResizeController.instance.unregister(this.resizePos);
      }
   }
}

