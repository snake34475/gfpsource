package com.gfp.app.mapProcess
{
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.Sprite;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1125901 extends BaseMapProcess
   {
      
      private var _tips:Sprite;
      
      public function MapProcess_1125901()
      {
         super();
         this._tips = _mapModel.libManager.getSprite("UI_Tips");
         LayerManager.topLevel.addChild(this._tips);
         StageResizeController.instance.register(this.layout);
         this.layout();
      }
      
      private function layout() : void
      {
         this._tips.x = LayerManager.stageWidth - 30;
         this._tips.y = 34;
      }
      
      override public function destroy() : void
      {
         DisplayUtil.removeForParent(this._tips);
         StageResizeController.instance.unregister(this.layout);
         super.destroy();
      }
   }
}

