package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeUI;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1130901 extends BaseMapProcess
   {
      
      private var _leftTime:LeftTimeUI;
      
      protected var _countDownTime:int;
      
      public function MapProcess_1130901()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._countDownTime = 60;
         this.initLeftTimeUI();
      }
      
      protected function initLeftTimeUI() : void
      {
         this._leftTime = new LeftTimeUI(this._countDownTime * 1000);
         this.layout();
         StageResizeController.instance.register(this.layout);
         LayerManager.topLevel.addChild(this._leftTime);
      }
      
      private function layout() : void
      {
         this._leftTime.x = LayerManager.stageWidth / 2;
         this._leftTime.y = 150;
      }
      
      override public function destroy() : void
      {
         this._leftTime.destory();
         DisplayUtil.removeForParent(this._leftTime);
         StageResizeController.instance.unregister(this.layout);
         super.destroy();
      }
   }
}

