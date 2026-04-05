package com.gfp.app.cartoon
{
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.LoadingType;
   import flash.display.MovieClip;
   import flash.events.IOErrorEvent;
   import org.taomee.bean.BaseBean;
   
   public class AnimatBase extends BaseBean
   {
      
      private var loader:UILoader;
      
      protected var animatMC:MovieClip;
      
      public function AnimatBase()
      {
         super();
      }
      
      protected function loadMC(param1:String) : void
      {
         this.loader = new UILoader(param1,LayerManager.stage,LoadingType.TITLE_AND_PERCENT,"正在加载动画");
         this.loader.closeEnabled = false;
         this.loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
         this.loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         this.animatMC = param1.uiloader.content as MovieClip;
         this.loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
         this.playAnimat();
      }
      
      protected function playAnimat() : void
      {
      }
      
      private function onIOErrorHandler(param1:IOErrorEvent) : void
      {
      }
      
      public function destroy() : void
      {
         if(this.loader)
         {
            this.loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
            this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
            this.loader.destroy(true);
            this.loader = null;
         }
      }
   }
}

