package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.TollgateAnimationFeature;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1010301 extends BaseMapProcess
   {
      
      private var _feather:TollgateAnimationFeature;
      
      public function MapProcess_1010301()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._feather = new TollgateAnimationFeature();
         this._feather.setParams([11839,11840,11841,11842,11843],[2,3,4,5,8],103);
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

