package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1090201 extends BaseMapProcess
   {
      
      private var _stageAnimatStart:MovieClip;
      
      private var _stageAnimatEnd:MovieClip;
      
      protected var _background:Shape;
      
      public function MapProcess_1090201()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(Boolean(TasksManager.isProcess(15,0)) || Boolean(TasksManager.isProcess(523,0)))
         {
            this._stageAnimatStart = _mapModel.libManager.getMovieClip("StageAnimat_Start");
            LayerManager.topLevel.addChild(this._stageAnimatStart);
            MainManager.closeOperate(true);
            this._stageAnimatStart.addEventListener(Event.ENTER_FRAME,this.onAnimatStart);
            this._stageAnimatStart.gotoAndPlay(1);
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_SIMPLEACTION,"TaskAnimationPlayed_15_0");
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_SIMPLEACTION,"TaskAnimationPlayed_523_0");
            if(this._background == null)
            {
               this._background = new Shape();
            }
            LayerManager.topLevel.addChild(this._background);
            this.layout();
            StageResizeController.instance.register(this.layout);
         }
         if(Boolean(TasksManager.isProcess(15,1)) || Boolean(TasksManager.isProcess(15,523)))
         {
            FightManager.isAutoWinnerEnd = false;
            FightManager.isAutoReasonEnd = false;
            FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
            FightManager.instance.addEventListener(FightEvent.REASON,this.onReason);
         }
      }
      
      protected function layout() : void
      {
         if(this._stageAnimatStart)
         {
            this._stageAnimatStart.x = (LayerManager.stageWidth - LayerManager.MIN_WIDTH) * 0.5;
            this._stageAnimatStart.y = (LayerManager.stageHeight - LayerManager.MIN_HEIGHT) * 0.5;
         }
         if(this._stageAnimatEnd)
         {
            this._stageAnimatEnd.x = (LayerManager.stageWidth - LayerManager.MIN_WIDTH) * 0.5;
            this._stageAnimatEnd.y = (LayerManager.stageHeight - LayerManager.MIN_HEIGHT) * 0.5;
         }
         this.drawBackgroud();
      }
      
      private function drawBackgroud() : void
      {
         var _loc1_:Graphics = this._background.graphics;
         _loc1_.clear();
         _loc1_.beginFill(0);
         _loc1_.drawRect(0,0,LayerManager.stageWidth,LayerManager.stageHeight - 550 >> 1);
         _loc1_.drawRect(0,550 + (LayerManager.stageHeight - 550 >> 1),LayerManager.stageWidth,LayerManager.stageHeight - 550 >> 1);
         _loc1_.drawRect(0,LayerManager.stageHeight - 550 >> 1,LayerManager.stageWidth - 950 >> 1,550);
         _loc1_.drawRect(950 + (LayerManager.stageWidth - 950 >> 1),LayerManager.stageHeight - 550 >> 1,LayerManager.stageWidth - 950 >> 1,550);
         _loc1_.endFill();
      }
      
      override public function destroy() : void
      {
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onReason);
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         if(this._stageAnimatStart)
         {
            this._stageAnimatStart.removeEventListener(Event.ENTER_FRAME,this.onAnimatStart);
            this._stageAnimatStart = null;
         }
         if(this._stageAnimatEnd)
         {
            this._stageAnimatEnd.removeEventListener(Event.ENTER_FRAME,this.onAnimatEnd);
            this._stageAnimatEnd = null;
         }
         if(this._background)
         {
            DisplayUtil.removeForParent(this._background);
            this._background = null;
         }
         StageResizeController.instance.unregister(this.layout);
         super.destroy();
      }
      
      private function onAnimatStart(param1:Event) : void
      {
         if(this._stageAnimatStart.currentFrame == this._stageAnimatStart.totalFrames)
         {
            this._stageAnimatStart.removeEventListener(Event.ENTER_FRAME,this.onAnimatStart);
            DisplayUtil.removeForParent(this._stageAnimatStart);
            this._stageAnimatStart = null;
            MainManager.openOperate();
            if(this._background)
            {
               DisplayUtil.removeForParent(this._background);
               this._background = null;
            }
            StageResizeController.instance.unregister(this.layout);
         }
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         FightManager.outToMapID = 2;
         var _loc2_:int = int(MainManager.actorInfo.roleType);
         _loc2_ = _loc2_ > 3 ? 1 : _loc2_;
         this._stageAnimatEnd = _mapModel.libManager.getMovieClip("StageAnimat_End_" + _loc2_);
         if(this._stageAnimatEnd)
         {
            LayerManager.topLevel.addChild(this._stageAnimatEnd);
            MainManager.closeOperate(true);
            this._stageAnimatEnd.addEventListener(Event.ENTER_FRAME,this.onAnimatEnd);
            this._stageAnimatEnd.gotoAndPlay(1);
            if(this._background == null)
            {
               this._background = new Shape();
            }
            LayerManager.topLevel.addChild(this._background);
            this.layout();
            StageResizeController.instance.register(this.layout);
         }
      }
      
      private function onReason(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onReason);
         FightManager.outToMapID = 1;
         PveEntry.onReason();
      }
      
      private function onAnimatEnd(param1:Event) : void
      {
         if(this._stageAnimatEnd.currentFrame == this._stageAnimatEnd.totalFrames)
         {
            this._stageAnimatEnd.removeEventListener(Event.ENTER_FRAME,this.onAnimatEnd);
            DisplayUtil.removeForParent(this._stageAnimatEnd);
            this._stageAnimatEnd = null;
            MainManager.openOperate();
            PveEntry.onWinner();
            if(this._background)
            {
               DisplayUtil.removeForParent(this._background);
               this._background = null;
            }
            StageResizeController.instance.unregister(this.layout);
         }
      }
   }
}

