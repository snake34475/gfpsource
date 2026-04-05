package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.DestoryableCollisonFeather;
   import com.gfp.core.map.BaseMapProcess;
   import flash.geom.Rectangle;
   
   public class MapProcess_1011404 extends BaseMapProcess
   {
      
      private var _feather:DestoryableCollisonFeather;
      
      private var _rects:Array = [[11913,new Rectangle(90,30,13,17)],[11911,new Rectangle(153,26,14,15)]];
      
      public function MapProcess_1011404()
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

