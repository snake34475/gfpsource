package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.Constant;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   
   public class StoryAnimationTask_39_1 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_39_1()
      {
         super();
      }
      
      private function hidenNPC() : void
      {
         SightManager.hideModelById(10001);
         MainManager.actorModel.visible = false;
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         _background.visible = false;
      }
      
      override public function onStart() : void
      {
         var _loc1_:String = null;
         var _loc2_:uint = 0;
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         this.hidenNPC();
         if(MainManager.actorInfo.roleType >= Constant.ROLE_TYPE_DARGON)
         {
            _loc2_ = 1;
         }
         else
         {
            _loc2_ = uint(MainManager.actorInfo.roleType);
         }
         _loc1_ = "task39_1_" + _loc2_;
         loadAndPlayAnimat(_loc1_,"mc");
      }
      
      override public function onFinish() : void
      {
         var _loc1_:StoryAnimationTask_39_2 = new StoryAnimationTask_39_2();
         _loc1_.start();
      }
   }
}

