package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.action.mouse.MouseProcess;
   import com.gfp.core.behavior.ChangeRideBehavior;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.RideManager;
   import com.gfp.core.map.MapManager;
   import flash.geom.Point;
   
   public class StoryAnimationTask_1926_0 extends PureStoryAnimationTask
   {
      
      public function StoryAnimationTask_1926_0()
      {
         super();
         _defalutPos.push("advancedAnimation");
      }
      
      override protected function loadAnimation(param1:String) : void
      {
         super.loadAnimation(param1);
         MouseProcess.execRun(MainManager.actorModel,new Point(391,627));
         MainManager.actorModel.addEventListener(MoveEvent.MOVE_END,this.onMoveEnd);
      }
      
      override protected function addStoryMc() : void
      {
         if(_storyMc)
         {
            _storyMc.x = 391;
            _storyMc.y = 627;
            MapManager.currentMap.downLevel.addChild(_storyMc);
         }
      }
      
      private function onMoveEnd(param1:MoveEvent) : void
      {
         if(RideManager.isOnRide)
         {
            MainManager.actorModel.execBehavior(new ChangeRideBehavior(0,true));
         }
         if(MainManager.actorInfo.monsterID != 0)
         {
            MainManager.actorModel.changeRoleView(0);
         }
      }
      
      override protected function onComplete() : void
      {
         super.onComplete();
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE_END,this.onMoveEnd);
      }
   }
}

