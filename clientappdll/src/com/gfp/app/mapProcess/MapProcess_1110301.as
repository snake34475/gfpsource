package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.HeroFightMidFeather;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1110301 extends BaseMapProcess
   {
      
      private var fight:HeroFightMidFeather;
      
      public function MapProcess_1110301()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this.fight = new HeroFightMidFeather();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.fight.destory();
         this.fight = null;
      }
   }
}

