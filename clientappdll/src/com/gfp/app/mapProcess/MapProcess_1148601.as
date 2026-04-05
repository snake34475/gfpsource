package com.gfp.app.mapProcess
{
   import com.gfp.app.ui.compoment.McNumber;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1148601 extends BaseMapProcess
   {
      
      private var _cntMc:MovieClip;
      
      private var _numMC:MovieClip;
      
      private var _score:int = 0;
      
      private var numberMC:McNumber;
      
      public function MapProcess_1148601()
      {
         super();
      }
      
      override protected function init() : void
      {
      }
      
      private function resizePos() : void
      {
         this._cntMc.x = LayerManager.stageWidth - this._cntMc.width;
         this._cntMc.y = 0;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this._cntMc);
      }
   }
}

