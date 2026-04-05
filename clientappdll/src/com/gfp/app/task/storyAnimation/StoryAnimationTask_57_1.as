package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.TasksManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class StoryAnimationTask_57_1 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_57_1()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task57_1");
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         _mainMC.gotoAndStop(1);
         _mainMC.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
         _mainMC["dialog"].visible = false;
         _mainMC["dialog"].btn.addEventListener(MouseEvent.CLICK,this.onClick);
         _mainMC["mc1"].addEventListener(Event.ENTER_FRAME,this.onEnterFrame1);
         _mainMC["mc1"].gotoAndPlay(1);
      }
      
      override public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         super.onStart();
      }
      
      private function onEnterFrame1(param1:Event) : void
      {
         if(_mainMC["mc1"].currentFrame == _mainMC["mc1"].totalFrames)
         {
            _mainMC["mc1"].removeEventListener(Event.ENTER_FRAME,this.onEnterFrame1);
            _mainMC["dialog"].visible = true;
            _mainMC.gotoAndStop(2);
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(_mainMC["dialog"].currentFrame != 4)
         {
            _mainMC["dialog"].gotoAndStop(_mainMC["dialog"].currentFrame + 1);
         }
         else
         {
            _mainMC["dialog"].btn.removeEventListener(MouseEvent.CLICK,this.onClick);
            onFinish();
         }
      }
   }
}

