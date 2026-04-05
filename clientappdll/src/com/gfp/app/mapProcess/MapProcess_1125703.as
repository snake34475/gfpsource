package com.gfp.app.mapProcess
{
   import com.gfp.core.manager.LayerManager;
   import flash.display.Sprite;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1125703 extends MapProcess_1125701
   {
      
      private var _introduce:Sprite;
      
      public function MapProcess_1125703()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._introduce = _mapModel.libManager.getSprite("UI_Introduce");
         LayerManager.topLevel.addChild(this._introduce);
         this._introduce.y = 200;
      }
      
      override protected function initData() : void
      {
         _totalSeconds = 60;
         _successBuffID = 3077;
         _failtBuffID = 3076;
      }
      
      override public function destroy() : void
      {
         DisplayUtil.removeForParent(this._introduce);
         super.destroy();
      }
   }
}

