package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.DestoryableCollisonFeather;
   import com.gfp.core.map.BaseMapProcess;
   import flash.geom.Rectangle;
   
   public class MapProcess_1011402 extends BaseMapProcess
   {
      
      private var _feather:DestoryableCollisonFeather;
      
      private var _rects:Array = [[11913,new Rectangle(45,20,15,26)],[11911,new Rectangle(135,31,15,25)],[11911,new Rectangle(135,31,15,25)]];
      
      public function MapProcess_1011402()
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

