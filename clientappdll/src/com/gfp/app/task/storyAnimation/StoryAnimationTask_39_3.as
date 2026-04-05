package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.toolBar.HeadSelfPanel;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.map.CityMap;
   
   public class StoryAnimationTask_39_3 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_39_3()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         var _loc1_:String = null;
         switch(MainManager.actorInfo.roleType)
         {
            case 7:
            case 4:
            case 5:
            case 6:
            case 1:
               _loc1_ = "task39_3_1";
               break;
            case 2:
               _loc1_ = "task39_3_2";
               break;
            case 3:
               _loc1_ = "task39_3_3";
         }
         loadAndPlayAnimat(_loc1_);
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         MainManager.actorModel.visible = true;
         HeadSelfPanel.instance.show();
         CityMap.instance.tranToNpc(10001);
         SightManager.showModelById(10001);
      }
   }
}

