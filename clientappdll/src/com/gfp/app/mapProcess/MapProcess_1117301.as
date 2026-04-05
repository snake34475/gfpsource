package com.gfp.app.mapProcess
{
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.ui.ExtenalUIPanel;
   
   public class MapProcess_1117301 extends BaseMapProcess
   {
      
      private var _ui:ExtenalUIPanel;
      
      public function MapProcess_1117301()
      {
         super();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._ui)
         {
            this._ui.destory();
         }
      }
      
      override protected function init() : void
      {
         super.init();
         this._ui = new ExtenalUIPanel("ice_zhu_que");
         this._ui.y = 0;
         this._ui.x = LayerManager.stageWidth;
         LayerManager.toolsLevel.addChildAt(this._ui,0);
      }
   }
}

