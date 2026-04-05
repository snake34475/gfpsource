package com.gfp.app.mapProcess
{
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1122201 extends BaseMapProcess
   {
      
      private var _txtWarnMc:MovieClip;
      
      public function MapProcess_1122201()
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
         TweenLite.to(this._txtWarnMc,4,{
            "x":LayerManager.stageWidth - this._txtWarnMc.width,
            "y":0
         });
         StageResizeController.instance.register(this.resizePos);
      }
      
      private function resizePos() : void
      {
         this._txtWarnMc.y = (LayerManager.stageHeight - this._txtWarnMc.height) / 2;
         this._txtWarnMc.x = (LayerManager.stageWidth - this._txtWarnMc.width) / 2;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         TweenLite.killTweensOf(this._txtWarnMc);
         DisplayUtil.removeForParent(this._txtWarnMc);
         StageResizeController.instance.unregister(this.resizePos);
      }
   }
}

