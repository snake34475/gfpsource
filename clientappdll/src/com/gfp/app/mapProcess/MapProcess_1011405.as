package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.DestoryableCollisonFeather;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1011405 extends BaseMapProcess
   {
      
      private var _feather:DestoryableCollisonFeather;
      
      private var _rects:Array = [];
      
      public function MapProcess_1011405()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._feather = new DestoryableCollisonFeather();
         this._feather.initData(this._rects);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this._feather.destory();
      }
   }
}

