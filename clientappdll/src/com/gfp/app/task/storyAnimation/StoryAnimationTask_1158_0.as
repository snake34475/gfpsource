package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.TasksManager;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class StoryAnimationTask_1158_0 extends BaseStoryAnimation
   {
      
      public static const FRAME_SPEED:int = 6000;
      
      private var _currentFrame:int;
      
      private var _interID:int;
      
      public function StoryAnimationTask_1158_0()
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
         loadAndPlayAnimat("task1158_0",null);
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         NpcDialogController.showForNpc(10006);
         clearInterval(this._interID);
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         _mainMC.stop();
         this._currentFrame = 0;
         this._interID = setInterval(this.playNext,FRAME_SPEED);
      }
      
      private function playNext() : void
      {
         this._currentFrame += 1;
         if(this._currentFrame > 3)
         {
            clearInterval(this._interID);
            this.onFinish();
         }
         else
         {
            _mainMC.gotoAndStop(this._currentFrame);
         }
      }
   }
}

