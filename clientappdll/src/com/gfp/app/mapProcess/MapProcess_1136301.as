package com.gfp.app.mapProcess
{
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1136301 extends BaseMapProcess
   {
      
      private var _strategyPanel:MovieClip;
      
      public function MapProcess_1136301()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._strategyPanel = _mapModel.libManager.getMovieClip("StrategyUI");
         this._strategyPanel.mouseChildren = this._strategyPanel.mouseEnabled = false;
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         LayerManager.topLevel.addChild(this._strategyPanel);
      }
      
      private function resizePos() : void
      {
         this._strategyPanel.x = 7;
         this._strategyPanel.y = (LayerManager.stageHeight - this._strategyPanel.height) / 2;
      }
      
      override public function destroy() : void
      {
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this._strategyPanel);
      }
   }
}

