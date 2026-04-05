package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.SanGuoChiBiFeather;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1112001 extends BaseMapProcess
   {
      
      private var _feater:SanGuoChiBiFeather;
      
      public function MapProcess_1112001()
      {
         super();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._feater)
         {
            this._feater.destory();
         }
      }
      
      override protected function init() : void
      {
         super.init();
         this._feater = new SanGuoChiBiFeather();
      }
   }
}

