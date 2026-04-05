package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.TollgateAnimationFeature;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1101501 extends BaseMapProcess
   {
      
      private var _feather:TollgateAnimationFeature;
      
      public function MapProcess_1101501()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._feather = new TollgateAnimationFeature();
         this._feather.setup();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this._feather.destory();
         this._feather = null;
      }
   }
}

