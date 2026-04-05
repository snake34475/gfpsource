package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.FirstPlayerFeather;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1104501 extends BaseMapProcess
   {
      
      private var _feather:FirstPlayerFeather;
      
      public function MapProcess_1104501()
      {
         super();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._feather)
         {
            this._feather.destory();
            this._feather = null;
         }
         DynamicActivityEntry.instance.show();
      }
      
      override protected function init() : void
      {
         super.init();
         this._feather = new FirstPlayerFeather();
         this._feather.setup();
         DynamicActivityEntry.instance.hide();
      }
   }
}

