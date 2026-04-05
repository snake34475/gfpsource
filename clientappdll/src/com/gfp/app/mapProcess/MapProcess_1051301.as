package com.gfp.app.mapProcess
{
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1051301 extends BaseMapProcess
   {
      
      private var temp:MapProcess_1051101;
      
      public function MapProcess_1051301()
      {
         super();
         this.temp = new MapProcess_1051101(120,513);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.temp.destroy();
         this.temp = null;
      }
   }
}

