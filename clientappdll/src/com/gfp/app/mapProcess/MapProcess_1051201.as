package com.gfp.app.mapProcess
{
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1051201 extends BaseMapProcess
   {
      
      private var temp:MapProcess_1051101;
      
      public function MapProcess_1051201()
      {
         super();
         this.temp = new MapProcess_1051101(90,512);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.temp.destroy();
         this.temp = null;
      }
   }
}

