package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightGo;
   import com.gfp.app.fight.FightMonsterClear;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1093301 extends BaseMapProcess
   {
      
      public function MapProcess_1093301()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightGo.instance.enabledShow = false;
         FightMonsterClear.instance.enabledShow = false;
      }
      
      override public function destroy() : void
      {
         FightGo.instance.enabledShow = true;
         FightMonsterClear.instance.enabledShow = true;
      }
   }
}

