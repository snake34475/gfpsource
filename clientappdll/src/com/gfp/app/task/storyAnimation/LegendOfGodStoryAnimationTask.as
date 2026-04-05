package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class LegendOfGodStoryAnimationTask extends BaseStoryAnimation
   {
      
      private var _params:String;
      
      private var _currentPage:int;
      
      private var _bg:Sprite;
      
      public function LegendOfGodStoryAnimationTask()
      {
         super();
      }
      
      override public function setParams(param1:String) : void
      {
         super.setParams(param1);
         this._params = param1;
         this._bg = new Sprite();
         this._bg.graphics.beginFill(6710886,0.6);
         this._bg.graphics.drawRect(0,0,1200,660);
         this._bg.graphics.endFill();
      }
      
      override public function onStart() : void
      {
         loadAndPlayAnimat("LegendOfGods");
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         MainManager.closeOperate();
         _loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         _mainMC = param1.uiloader.loader.content as MovieClip;
         _mainMC.gotoAndStop(1);
         this.changePage(1);
         _mainMC.addEventListener(MouseEvent.CLICK,this.storyMcClickHandler);
         _mainMC.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         DisplayUtil.align(_mainMC,null,AlignType.MIDDLE_CENTER);
         _mainMC.y -= 60;
         LayerManager.topLevel.addChild(this._bg);
         LayerManager.topLevel.addChild(_mainMC);
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
      
      override protected function onEnterFrame(param1:Event) : void
      {
         if((_mainMC["wordMC"] as MovieClip).currentFrame == (_mainMC["wordMC"] as MovieClip).totalFrames)
         {
            (_mainMC["wordMC"] as MovieClip).stop();
         }
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         LayerManager.topLevel.removeChild(this._bg);
         ModuleManager.turnAppModule("LegendOfGodsPanel");
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

