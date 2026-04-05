package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.Stage105Feather;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_10105Base extends BaseMapProcess
   {
      
      private var _feather:Stage105Feather;
      
      public function MapProcess_10105Base()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._feather = new Stage105Feather();
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

