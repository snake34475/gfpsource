package com.gfp.app.mapProcess
{
   public class MapProcess_1104901 extends MapProcess_1104801
   {
      
      public function MapProcess_1104901()
      {
         super();
      }
      
      override protected function updateView() : void
      {
         ui["gfTxt"].text = currentNum * 12000;
         ui["expTxt"].text = currentNum * 5000;
      }
   }
}

