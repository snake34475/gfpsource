package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.TasksManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class StoryAnimationTask_33_1 extends BaseStoryAnimation
   {
      
      private var _storyMC:MovieClip;
      
      private var _nextBtn:SimpleButton;
      
      private var _currPage:int;
      
      private const TOTALPAGE:int = 5;
      
      public function StoryAnimationTask_33_1()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task33_1");
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         this._storyMC = _mainMC["story_mc"];
         this._nextBtn = _mainMC["nextBtn"];
         this._currPage = 1;
         this._storyMC.gotoAndStop(this._currPage);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.onPlayNext);
      }
      
      override protected function onEnterFrame(param1:Event) : void
      {
      }
      
      override public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         super.onStart();
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         NpcDialogController.showForNpc(10063);
      }
      
      private function onPlayNext(param1:MouseEvent) : void
      {
         ++this._currPage;
         if(this._currPage == this.TOTALPAGE)
         {
            if(_mainMC)
            {
               this._nextBtn.removeEventListener(MouseEvent.CLICK,this.onPlayNext);
               DisplayUtil.removeForParent(_mainMC);
               this._storyMC = null;
               this._nextBtn = null;
            }
            this.onFinish();
         }
         else
         {
            this._storyMC.gotoAndStop(this._currPage);
         }
      }
   }
}

