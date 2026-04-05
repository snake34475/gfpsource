package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class StoryAnimationTask_1295_3 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_1295_3()
      {
         super();
      }
      
      override public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         super.onStart();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task1295_3","mainMC");
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         StageResizeController.instance.register(layout);
         MainManager.closeOperate();
         _loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         var _loc2_:MovieClip = param1.uiloader.loader.content as MovieClip;
         if(_animatName == null)
         {
            _mainMC = _loc2_;
         }
         else
         {
            _mainMC = _loc2_[_animatName];
         }
         _closeBtn = _mainMC["closeBtn"];
         if(_closeBtn)
         {
            _closeBtn.addEventListener(MouseEvent.CLICK,onClose);
         }
         _offsetX = _mainMC.x;
         _offsetY = _mainMC.y;
         LayerManager.topLevel.addChild(_mainMC);
         _mainMC.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         _mainMC.gotoAndPlay(1);
         _background = new Shape();
         LayerManager.topLevel.addChild(_background);
         addJumpBtn();
         playSound();
         layout();
      }
      
      override protected function onEnterFrame(param1:Event) : void
      {
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         NpcDialogController.showForNpc(10020);
      }
   }
}

