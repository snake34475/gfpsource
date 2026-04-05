package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.TakeHeroFeature;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1010401 extends BaseMapProcess
   {
      
      private var _feather:TakeHeroFeature;
      
      public function MapProcess_1010401()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._feather = new TakeHeroFeature();
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

