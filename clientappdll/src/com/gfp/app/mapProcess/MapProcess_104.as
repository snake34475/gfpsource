package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.CheckForOpenFeather;
   
   public class MapProcess_104 extends MapProcessAnimat
   {
      
      private var _moduleOpen:CheckForOpenFeather;
      
      public function MapProcess_104()
      {
         _mangoType = 1;
         super();
      }
      
      override protected function init() : void
      {
         _mangoType = 1;
         this._moduleOpen = new CheckForOpenFeather();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this._moduleOpen.destory();
         this._moduleOpen = null;
      }
   }
}

