package com.gfp.app.mapProcess
{
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1125001 extends BaseMapProcess
   {
      
      private var _txtWarnMc:MovieClip;
      
      public function MapProcess_1125001()
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
         TweenMax.to(this._txtWarnMc,3,{
            "x":LayerManager.stageWidth - this._txtWarnMc.width,
            "y":0,
            "delay":2,
            "onComplete":this.warnMcTweenOver
         });
         StageResizeController.instance.register(this.resizePos);
      }
      
      private function warnMcTweenOver() : void
      {
         TweenMax.killChildTweensOf(this._txtWarnMc);
      }
      
      private function resizePos() : void
      {
         this._txtWarnMc.y = LayerManager.stageHeight - this._txtWarnMc.height >> 1;
         this._txtWarnMc.x = LayerManager.stageWidth - this._txtWarnMc.width >> 1;
      }
      
      override public function destroy() : void
      {
         TweenMax.killChildTweensOf(this._txtWarnMc);
         DisplayUtil.removeForParent(this._txtWarnMc);
         super.destroy();
      }
   }
}

