package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.info.MapInfo;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.ui.loading.LoadingType;
   
   public class StoryAnimationTask_39_2 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_39_2()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task39_2");
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         this.startGame();
         var _loc1_:StoryAnimationTask_39_3 = new StoryAnimationTask_39_3();
         _loc1_.start();
      }
      
      private function startGame() : void
      {
         KeyManager.reset();
         KeyManager.upDateSkillQuickKeys(MainManager.actorInfo.skills);
         KeyManager.upDateItemQuickKeys(MainManager.actorInfo.items);
         if(MapManager.mapInfo == null)
         {
            MapManager.mapInfo = new MapInfo();
         }
         MapManager.mapInfo.id = MainManager.actorInfo.mapID;
         MapManager.mapInfo.mapType = MainManager.actorInfo.mapType;
         CityMap.instance.changeMap(2,MainManager.actorInfo.mapType,LoadingType.TITLE_AND_PERCENT,MainManager.actorInfo.pos);
      }
   }
}

