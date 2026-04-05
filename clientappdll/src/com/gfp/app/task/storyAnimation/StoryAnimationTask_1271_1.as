package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class StoryAnimationTask_1271_1 extends BaseStoryAnimation
   {
      
      private var _npc10108:SightModel;
      
      public function StoryAnimationTask_1271_1()
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
         loadAndPlayAnimat("task1271_1","mc");
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         this._npc10108.show();
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         _offsetX = 1607;
         _offsetY = 217;
         layout();
         this._npc10108 = SightManager.getSightModel(10108);
         this._npc10108.hide();
      }
   }
}

