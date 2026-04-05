package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeTxtFeater;
   import com.gfp.app.manager.FightPluginManager;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1119901 extends BaseMapProcess
   {
      
      private var _txtInfoMc:MovieClip;
      
      private var _feather:LeftTimeTxtFeater;
      
      public function MapProcess_1119901()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._txtInfoMc = _mapModel.libManager.getMovieClip("UI_TxtInfo");
         this._feather = new LeftTimeTxtFeater(1 * 60 * 1000,this._txtInfoMc["timeTxt"] as TextField,null);
         this._feather.start();
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
      }
      
      private function resizePos() : void
      {
         this._txtInfoMc.x = LayerManager.stageWidth - this._txtInfoMc.width >> 1;
         this._txtInfoMc.y = 165;
         LayerManager.topLevel.addChild(this._txtInfoMc);
      }
      
      override public function destroy() : void
      {
         if(this._feather)
         {
            this._feather.destroy();
            this._feather = null;
         }
         FightPluginManager.instance.isPluginRunning = false;
         FightPluginManager.instance.stop();
         DisplayUtil.removeForParent(this._txtInfoMc);
         this._txtInfoMc = null;
         StageResizeController.instance.unregister(this.resizePos);
         super.destroy();
      }
   }
}

