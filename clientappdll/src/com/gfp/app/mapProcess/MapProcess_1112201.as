package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeFeather;
   
   public class MapProcess_1112201 extends ShowDpsMapprocess
   {
      
      private var _totalTime:int = 180000;
      
      private var _mapTimer:LeftTimeFeather;
      
      public function MapProcess_1112201()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._mapTimer = new LeftTimeFeather(this._totalTime);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._mapTimer)
         {
            this._mapTimer.destroy();
         }
      }
   }
}

