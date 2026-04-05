package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import flash.display.MovieClip;
   
   public class PanelStoryAnimationTask extends BaseStoryAnimationTask
   {
      
      public function PanelStoryAnimationTask()
      {
         super();
      }
      
      override protected function handleLoadMc(param1:MovieClip) : void
      {
         super.handleLoadMc(param1);
         if(_storyMc)
         {
            this.setupUI();
         }
         else
         {
            onFinish();
         }
      }
      
      protected function setupUI() : void
      {
         throw new Error("this function must be inherit");
      }
      
      override protected function onComplete() : void
      {
         super.onComplete();
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
      }
   }
}

