package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeFeather;
   import com.gfp.app.feature.NanManFeather;
   import com.gfp.app.feature.ShowCartoonFeather;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1112601 extends BaseMapProcess
   {
      
      private var _totalTime:int = 180000;
      
      private var _mapTimer:LeftTimeFeather;
      
      private var _feather:NanManFeather;
      
      private var _featherCartoon:ShowCartoonFeather;
      
      public function MapProcess_1112601()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._feather = new NanManFeather();
         this._featherCartoon = new ShowCartoonFeather("nan_man_tip");
         this._mapTimer = new LeftTimeFeather(this._totalTime);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._feather)
         {
            this._feather.destroy();
         }
         if(this._featherCartoon)
         {
            this._featherCartoon.destroy();
         }
         if(this._mapTimer)
         {
            this._mapTimer.destroy();
         }
      }
   }
}

