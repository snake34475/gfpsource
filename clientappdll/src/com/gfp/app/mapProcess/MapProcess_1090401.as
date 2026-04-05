package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1090401 extends BaseMapProcess
   {
      
      private var _runToGfCityMC:MovieClip;
      
      private var _runToCrossMC:MovieClip;
      
      protected var _background:Shape;
      
      public function MapProcess_1090401()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightManager.isAutoWinnerEnd = false;
         FightManager.isAutoReasonEnd = false;
         FightManager.outToMapID = 18;
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
         FightManager.instance.addEventListener(FightEvent.REASON,this.onReason);
      }
      
      private function playRunToCity() : void
      {
         this._runToGfCityMC = _mapModel.libManager.getMovieClip("runToGFCityMC");
         this.initRunToMC(this._runToGfCityMC);
         this._runToGfCityMC.addEventListener(Event.ENTER_FRAME,this.onToCityEnterFrame);
         if(this._background == null)
         {
            this._background = new Shape();
         }
         LayerManager.topLevel.addChild(this._background);
         LayerManager.topLevel.addChild(this._runToGfCityMC);
         this.layout();
         StageResizeController.instance.register(this.layout);
      }
      
      private function onToCityEnterFrame(param1:Event) : void
      {
         if(this._runToGfCityMC.currentFrame == this._runToGfCityMC.totalFrames)
         {
            this._runToGfCityMC.removeEventListener(Event.ENTER_FRAME,this.onToCityEnterFrame);
            DisplayUtil.removeForParent(this._runToGfCityMC);
            if(this._background)
            {
               DisplayUtil.removeForParent(this._background);
               this._background = null;
            }
            StageResizeController.instance.unregister(this.layout);
            this.playRunToCross();
         }
      }
      
      private function playRunToCross() : void
      {
         this._runToCrossMC = _mapModel.libManager.getMovieClip("runToCrossMC");
         this.initRunToMC(this._runToCrossMC);
         this._runToCrossMC.addEventListener(Event.ENTER_FRAME,this.onToCrossEnterFrame);
         this._runToCrossMC.gotoAndPlay(1);
         if(this._background == null)
         {
            this._background = new Shape();
         }
         LayerManager.topLevel.addChild(this._background);
         LayerManager.topLevel.addChild(this._runToCrossMC);
         this.layout();
         StageResizeController.instance.register(this.layout);
      }
      
      private function onToCrossEnterFrame(param1:Event) : void
      {
         if(this._runToCrossMC.currentFrame == this._runToCrossMC.totalFrames)
         {
            this._runToCrossMC.removeEventListener(Event.ENTER_FRAME,this.onToCrossEnterFrame);
            DisplayUtil.removeForParent(this._runToCrossMC);
            FightManager.quit();
            if(this._background)
            {
               DisplayUtil.removeForParent(this._background);
               this._background = null;
            }
            StageResizeController.instance.unregister(this.layout);
         }
      }
      
      protected function layout() : void
      {
         if(this._runToGfCityMC)
         {
            this._runToGfCityMC.x = (LayerManager.stageWidth - LayerManager.MIN_WIDTH) * 0.5;
            this._runToGfCityMC.y = (LayerManager.stageHeight - LayerManager.MIN_HEIGHT) * 0.5;
         }
         if(this._runToCrossMC)
         {
            this._runToCrossMC.x = (LayerManager.stageWidth - LayerManager.MIN_WIDTH) * 0.5;
            this._runToCrossMC.y = (LayerManager.stageHeight - LayerManager.MIN_HEIGHT) * 0.5;
         }
         this.drawBackgroud();
      }
      
      private function drawBackgroud() : void
      {
         var _loc1_:Graphics = this._background.graphics;
         _loc1_.clear();
         _loc1_.beginFill(0);
         _loc1_.drawRect(0,0,LayerManager.stageWidth,LayerManager.stageHeight);
         _loc1_.endFill();
      }
      
      private function initRunToMC(param1:MovieClip) : void
      {
         var _loc2_:int = MainManager.roleType > 3 ? 1 : int(MainManager.roleType);
         param1["roleMC1"].visible = false;
         param1["roleMC2"].visible = false;
         param1["roleMC3"].visible = false;
         param1["roleMC" + _loc2_].visible = true;
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         FightManager.outToMapID = 14;
         this.playRunToCity();
      }
      
      private function onReason(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onReason);
         FightManager.outToMapID = 20;
         PveEntry.onReason();
      }
      
      override public function destroy() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onReason);
         if(this._runToGfCityMC)
         {
            this._runToGfCityMC.removeEventListener(Event.ENTER_FRAME,this.onToCityEnterFrame);
            this._runToGfCityMC = null;
         }
         if(this._runToCrossMC)
         {
            this._runToCrossMC.removeEventListener(Event.ENTER_FRAME,this.onToCrossEnterFrame);
            this._runToCrossMC = null;
         }
         if(this._background)
         {
            DisplayUtil.removeForParent(this._background);
            this._background = null;
         }
         StageResizeController.instance.unregister(this.layout);
         super.destroy();
      }
   }
}

