package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1128701 extends BaseMapProcess
   {
      
      public function MapProcess_1128701()
      {
         super();
      }
      
      override protected function init() : void
      {
         AnimatPlay.startAnimat("tollgate_1287",-1,true,0,0,false,false,true,0);
      }
   }
}

