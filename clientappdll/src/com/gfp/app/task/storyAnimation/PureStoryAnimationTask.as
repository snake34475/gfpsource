package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class PureStoryAnimationTask extends BaseStoryAnimationTask
   {
      
      public function PureStoryAnimationTask()
      {
         super();
      }
      
      override protected function handleLoadMc(param1:MovieClip) : void
      {
         super.handleLoadMc(param1);
         if(_storyMc)
         {
            _storyMc.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         else
         {
            this.onComplete();
         }
      }
      
      override public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         super.onStart();
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
         if(_storyMc.currentFrame == _storyMc.totalFrames)
         {
            _storyMc.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.onComplete();
         }
      }
      
      override protected function onComplete() : void
      {
         super.onComplete();
         this.onFinish();
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_FINISH,"");
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
      }
   }
}

