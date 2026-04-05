package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.map.BaseMapProcess;
   import flash.events.Event;
   
   public class MapProcess_1011001 extends BaseMapProcess
   {
      
      public function MapProcess_1011001()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         FightManager.instance.addEventListener(FightEvent.OGRE_CLEAR,this.onOgreClear);
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimateEnd);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         FightManager.instance.removeEventListener(FightEvent.OGRE_CLEAR,this.onOgreClear);
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimateEnd);
      }
      
      private function onAnimateEnd(param1:Event) : void
      {
         this.playComplete();
      }
      
      private function onOgreClear(param1:FightEvent) : void
      {
         AnimatPlay.startAnimat("oldDragonAnimation",-1,false,0,0,false,false,true,2);
      }
      
      private function playComplete() : void
      {
         PveEntry.changeMap(1011002);
      }
   }
}

