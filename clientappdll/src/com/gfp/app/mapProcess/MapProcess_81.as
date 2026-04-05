package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.CheckForOpenFeather;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_81 extends BaseMapProcess
   {
      
      private var _moduleOpen:CheckForOpenFeather;
      
      public function MapProcess_81()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._moduleOpen = new CheckForOpenFeather();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._moduleOpen)
         {
            this._moduleOpen.destory();
            this._moduleOpen = null;
         }
      }
   }
}

