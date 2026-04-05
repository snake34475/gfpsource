package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class MultiStoryAnimationTask extends BaseStoryAnimationTask
   {
      
      private var currentIndex:int = 0;
      
      private var totalCount:int;
      
      private var paramArray:Array;
      
      private var mcArray:Array;
      
      public function MultiStoryAnimationTask()
      {
         super();
      }
      
      override public function setParams(param1:String) : void
      {
         super.setParams(param1);
         this.paramArray = this.params.split(";");
         this.mcArray = this.mcSrc.split(";");
         this.totalCount = this.paramArray.length;
      }
      
      override public function start() : void
      {
         super.start();
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
      }
      
      override public function onStart() : void
      {
         loadAnimation(this.paramArray[this.currentIndex]);
      }
      
      override protected function get getMcStr() : String
      {
         var _loc1_:String = this.mcArray[this.currentIndex];
         if(_loc1_ == "-1")
         {
            return "";
         }
         return this.mcArray[this.currentIndex];
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
            this.checkStoryStop();
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(_storyMc.currentFrame == _storyMc.totalFrames)
         {
            _storyMc.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.checkStoryStop();
         }
      }
      
      private function checkStoryStop() : void
      {
         ++this.currentIndex;
         onFinish();
         if(this.currentIndex < this.totalCount)
         {
            this.onStart();
         }
         else
         {
            this.onComplete();
         }
      }
      
      override protected function onComplete() : void
      {
         super.onComplete();
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_FINISH,"");
      }
   }
}

