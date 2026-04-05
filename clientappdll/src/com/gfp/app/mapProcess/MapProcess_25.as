package com.gfp.app.mapProcess
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.LoadingType;
   import flash.display.MovieClip;
   
   public class MapProcess_25 extends MapProcessAnimat
   {
      
      private var _loader:UILoader;
      
      private var _animatMC:MovieClip;
      
      public function MapProcess_25()
      {
         super();
      }
      
      override protected function init() : void
      {
      }
      
      private function loadAnimat() : void
      {
         this._loader = new UILoader(ClientConfig.getCartoon("callDragon"),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
      }
   }
}

