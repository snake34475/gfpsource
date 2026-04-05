package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   
   public class StoryAnimationTask_1269_3 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_1269_3()
      {
         super();
      }
      
      override public function onStart() : void
      {
         super.onStart();
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task1269_3",null);
      }
      
      override protected function playEnd() : void
      {
         ModuleManager.turnModule(ClientConfig.getAppModule("TokenPanel"),"加载令牌",{
            "isForTask":1,
            "isMini":0
         });
         super.playEnd();
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         SightManager.getSightModel(10034).visible = true;
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         SightManager.getSightModel(10034).visible = false;
         _offsetY = 10;
         _offsetX = 0;
         layout();
      }
   }
}

