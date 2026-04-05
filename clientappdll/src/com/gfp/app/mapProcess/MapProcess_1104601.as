package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.NanBuGongFangZhanFeather;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1104601 extends BaseMapProcess
   {
      
      private var _feather:NanBuGongFangZhanFeather;
      
      public function MapProcess_1104601()
      {
         super();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._feather)
         {
            this._feather.destroy();
            this._feather = null;
         }
      }
      
      override protected function init() : void
      {
         super.init();
         this._feather = new NanBuGongFangZhanFeather();
      }
   }
}

