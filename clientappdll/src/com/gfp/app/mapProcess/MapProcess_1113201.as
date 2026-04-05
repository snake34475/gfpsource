package com.gfp.app.mapProcess
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.utils.strength.SwfLoaderHelper;
   import flash.display.Loader;
   import flash.display.MovieClip;
   
   public class MapProcess_1113201 extends BaseMapProcess
   {
      
      private var mc:MovieClip;
      
      private var isDestoryed:Boolean = false;
      
      public function MapProcess_1113201()
      {
         super();
         var _loc1_:SwfLoaderHelper = new SwfLoaderHelper();
         _loc1_.loadFile(ClientConfig.getCartoon("dian_dao"),this.movieCallBack);
      }
      
      private function movieCallBack(param1:Loader) : void
      {
         if(!this.isDestoryed)
         {
            this.mc = param1.content["mc1"];
            this.mc.x = LayerManager.stageWidth - this.mc.width;
            this.mc.y = 0;
            LayerManager.topLevel.addChild(this.mc);
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.isDestoryed = true;
         if(this.mc)
         {
            LayerManager.topLevel.removeChild(this.mc);
            this.mc = null;
         }
      }
   }
}

