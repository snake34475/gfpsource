package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.SanGuoHitInfoFeather;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1111401 extends BaseMapProcess
   {
      
      private var _feather:SanGuoHitInfoFeather;
      
      public function MapProcess_1111401()
      {
         super();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._feather)
         {
            this._feather.destory();
         }
      }
      
      override protected function init() : void
      {
         super.init();
         this._feather = new SanGuoHitInfoFeather(0);
      }
   }
}

