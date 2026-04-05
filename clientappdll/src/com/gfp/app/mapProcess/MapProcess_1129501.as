package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightGo;
   import com.gfp.app.fight.FightMonsterClear;
   import com.gfp.app.miniMap.MiniMap;
   import com.gfp.app.time.TimerComponents;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1129501 extends BaseMapProcess
   {
      
      public function MapProcess_1129501()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightGo.instance.enabledShow = false;
         FightMonsterClear.instance.enabledShow = false;
         MiniMap.instance.hide();
         TimerComponents.instance.hide();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         FightGo.instance.enabledShow = true;
         FightMonsterClear.instance.enabledShow = true;
      }
   }
}

