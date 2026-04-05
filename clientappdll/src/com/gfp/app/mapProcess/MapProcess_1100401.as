package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.ThreeHeroFightFeather;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1100401 extends BaseMapProcess
   {
      
      private var fight:ThreeHeroFightFeather;
      
      public function MapProcess_1100401()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this.fight = new ThreeHeroFightFeather(false);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.fight.destory();
         this.fight = null;
      }
   }
}

