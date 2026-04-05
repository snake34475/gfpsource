package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.fight.FightOperatePanel;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.Constant;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.TasksManager;
   import flash.utils.setTimeout;
   
   public class StoryAnimationTask_40_3 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_40_3()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         var _loc1_:String = null;
         if(MainManager.actorInfo.roleType >= Constant.ROLE_TYPE_DARGON)
         {
            _loc1_ = "task40_3_1";
         }
         else
         {
            _loc1_ = "task40_3_" + MainManager.actorInfo.roleType;
         }
         loadAndPlayAnimat(_loc1_,"mc");
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         _mainMC.gotoAndStop(1);
         _mainMC.visible = false;
         setTimeout(this.playAnimationDelay,2000);
         _background.visible = false;
      }
      
      override public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         super.onStart();
      }
      
      private function playAnimationDelay() : void
      {
         _background.visible = true;
         _mainMC.visible = true;
         _mainMC.gotoAndPlay(1);
         this.hideSighModel();
      }
      
      override public function onFinish() : void
      {
         var delay:Function;
         super.onFinish();
         this.showActor();
         delay = function():void
         {
            PveEntry.onWinner();
            FightOperatePanel.instance.onShow();
         };
         setTimeout(delay,3000);
      }
      
      private function hideSighModel() : void
      {
         SightManager.hideModelById(10133);
         SightManager.hideModelById(10134);
         SightManager.hideModelById(10135);
         MainManager.actorModel.visible = false;
         SummonManager.setActorSummonVisible(false);
      }
      
      private function showActor() : void
      {
         MainManager.actorModel.visible = true;
         SummonManager.setActorSummonVisible(true);
      }
   }
}

