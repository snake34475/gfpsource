package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class StoryAnimationTask_7077_1 extends BaseStoryAnimation
   {
      
      private var _params:String;
      
      private var _currentPage:int;
      
      public function StoryAnimationTask_7077_1()
      {
         super();
      }
      
      override public function setParams(param1:String) : void
      {
         super.setParams(param1);
         this._params = param1;
      }
      
      override public function start() : void
      {
         super.start();
         this.onStart();
      }
      
      override public function onStart() : void
      {
         super.onStart();
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         this.loadAnimate();
      }
      
      protected function loadAnimate() : void
      {
         super.loadAnimat();
         loadAndPlayAnimat("task7077_1");
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         MainManager.closeOperate();
         _loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         _mainMC = param1.uiloader.loader.content as MovieClip;
         _mainMC.gotoAndStop(1);
         this.changePage(1);
         _mainMC.addEventListener(MouseEvent.CLICK,this.storyMcClickHandler);
         _mainMC.addEventListener(Event.ENTER_FRAME,this.onEnterFrame1);
         DisplayUtil.align(_mainMC,null,AlignType.MIDDLE_CENTER);
         _mainMC.y -= 60;
         LayerManager.topLevel.addChild(_mainMC);
      }
      
      protected function onEnterFrame1(param1:Event) : void
      {
      }
      
      private function storyMcClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:SimpleButton = param1.target as SimpleButton;
         if(_loc2_ == null)
         {
            return;
         }
         switch(_loc2_.name)
         {
            case "preBtn":
               this.changePage(this._currentPage - 1);
               break;
            case "nextBtn":
               this.changePage(this._currentPage + 1);
               break;
            case "closeBtn":
               this.onFinish();
         }
      }
      
      override public function onFinish() : void
      {
         DepthManager.swapDepthAll(MapManager.currentMap.contentLevel);
         MainManager.openOperate();
         if(_closeBtn)
         {
            _closeBtn.removeEventListener(MouseEvent.CLICK,onClose);
            _closeBtn = null;
         }
         DisplayUtil.removeForParent(_background);
         _background = null;
         if(_loader)
         {
            _loader.destroy(true);
            _loader = null;
         }
         _mainMC.stop();
         _mainMC.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame1);
         LayerManager.topLevel.removeChild(_mainMC);
         _mainMC = null;
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onFinishHandler);
         AnimatPlay.startAnimat("task7077_2");
      }
      
      public function onFinishHandler(param1:AnimatEvent) : void
      {
         this.Finish();
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onFinishHandler);
      }
      
      public function Finish() : void
      {
         TasksManager.taskComplete(7077);
      }
      
      private function changePage(param1:int) : void
      {
         if(param1 <= 0 || param1 > 4)
         {
            return;
         }
         if(this._currentPage != param1)
         {
            this._currentPage = param1;
            _mainMC.gotoAndStop(param1);
            if(param1 == 4)
            {
               _mainMC["closeBtn"].visible = true;
               _mainMC["preBtn"].visible = true;
               _mainMC["nextBtn"].visible = false;
            }
            else if(param1 == 1)
            {
               _mainMC["closeBtn"].visible = true;
               _mainMC["preBtn"].visible = false;
               _mainMC["nextBtn"].visible = true;
            }
            else
            {
               _mainMC["closeBtn"].visible = true;
               _mainMC["preBtn"].visible = true;
               _mainMC["nextBtn"].visible = true;
            }
         }
      }
   }
}

