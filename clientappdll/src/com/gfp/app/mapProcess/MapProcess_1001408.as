package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.FightOgreManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.ActorModel;
   import com.gfp.core.utils.Direction;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1001408 extends BaseMapProcess
   {
      
      private var _animation1:MovieClip;
      
      private var _cartoon:MovieClip;
      
      private var _animation2:MovieClip;
      
      private var _animation3:MovieClip;
      
      private var _animation4:MovieClip;
      
      public function MapProcess_1001408()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.checkTaskStatus();
      }
      
      private function checkTaskStatus() : void
      {
         if(Boolean(TasksManager.isAccepted(31)) && !TasksManager.isTaskProComplete(31,0))
         {
            FightManager.isAutoWinnerEnd = false;
            FightManager.isAutoReasonEnd = false;
            FightManager.outToMapID = 1;
            this.addFightEventListener();
         }
      }
      
      private function addFightEventListener() : void
      {
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWin);
         FightManager.instance.addEventListener(FightEvent.REASON,this.onReason);
      }
      
      private function onWin(param1:FightEvent) : void
      {
         this.resetActorPosition();
         MainManager.actorModel.execStandAction(true);
         FightManager.outToMapID = 15;
         FightOgreManager.clearOgre();
         MainManager.closeOperate(true);
         MapManager.currentMap.camera.scroll(0,140);
         this.hideActor();
         this.initTask31Animation();
      }
      
      private function onReason(param1:FightEvent) : void
      {
         FightManager.outToMapID = 15;
         PveEntry.onReason();
      }
      
      private function removeFightEventListener() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWin);
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onReason);
      }
      
      private function hideActor() : void
      {
         var _loc1_:ActorModel = MainManager.actorModel;
         _loc1_.visible = false;
         SummonManager.setActorSummonVisible(false);
      }
      
      private function resetActorPosition() : void
      {
         var _loc1_:ActorModel = MainManager.actorModel;
         _loc1_.direction = Direction.RIGHT;
         _loc1_.x = 280;
         _loc1_.y = 500;
      }
      
      private function showActor() : void
      {
         MainManager.actorModel.visible = true;
         SummonManager.setActorSummonVisible(true);
      }
      
      private function initTask31Animation() : void
      {
         var _loc1_:int = int(MainManager.actorInfo.roleType);
         _loc1_ = _loc1_ > 4 ? 1 : _loc1_;
         this._animation1 = _mapModel.libManager.getMovieClip("animation1_" + _loc1_);
         this._animation1.addEventListener(Event.ENTER_FRAME,this.onAnimation1End);
         this._animation1.x = 460;
         this._animation1.y = 423;
         _mapModel.contentLevel.addChild(this._animation1);
      }
      
      private function onAnimation1End(param1:Event) : void
      {
         if(this._animation1.currentFrame == this._animation1.totalFrames)
         {
            DisplayUtil.removeForParent(this._animation1);
            this._animation1.removeEventListener(Event.ENTER_FRAME,this.onAnimation1End);
            this._animation1 = null;
            this._cartoon = _mapModel.libManager.getMovieClip("cartoon");
            this._cartoon.addEventListener(Event.ENTER_FRAME,this.onCartoonEnd);
            this._cartoon.x = 516;
            this._cartoon.y = 290;
            LayerManager.topLevel.addChild(this._cartoon);
         }
      }
      
      private function onCartoonEnd(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(this._cartoon.currentFrame == this._cartoon.totalFrames)
         {
            this._cartoon.removeEventListener(Event.ENTER_FRAME,this.onCartoonEnd);
            DisplayUtil.removeForParent(this._cartoon);
            this._cartoon = null;
            _loc2_ = int(MainManager.actorInfo.roleType);
            _loc2_ = _loc2_ > 4 ? 1 : _loc2_;
            this._animation2 = _mapModel.libManager.getMovieClip("animation2_" + _loc2_);
            this._animation2.addEventListener(Event.ENTER_FRAME,this.onAnimation2End);
            this._animation2.x = 460;
            this._animation2.y = 423;
            _mapModel.contentLevel.addChild(this._animation2);
         }
      }
      
      private function onAnimation2End(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(this._animation2.currentFrame == this._animation2.totalFrames)
         {
            DisplayUtil.removeForParent(this._animation2);
            this._animation2.removeEventListener(Event.ENTER_FRAME,this.onAnimation2End);
            this._animation2 = null;
            _loc2_ = int(MainManager.actorInfo.roleType);
            _loc2_ = _loc2_ > 4 ? 1 : _loc2_;
            this._animation3 = _mapModel.libManager.getMovieClip("animation3_" + _loc2_);
            this._animation3.addEventListener(Event.ENTER_FRAME,this.onAnimation3End);
            this._animation3.x = 460;
            this._animation3.y = 423;
            _mapModel.contentLevel.addChild(this._animation3);
         }
      }
      
      private function onAnimation3End(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(this._animation3.currentFrame == this._animation3.totalFrames)
         {
            DisplayUtil.removeForParent(this._animation3);
            this._animation3.removeEventListener(Event.ENTER_FRAME,this.onAnimation3End);
            this._animation3 = null;
            _loc2_ = int(MainManager.actorInfo.roleType);
            _loc2_ = _loc2_ > 4 ? 1 : _loc2_;
            this._animation4 = _mapModel.libManager.getMovieClip("animation4_" + _loc2_);
            this._animation4.addEventListener(Event.ENTER_FRAME,this.onAnimation4End);
            this._animation4.x = 460;
            this._animation4.y = 423;
            _mapModel.contentLevel.addChild(this._animation4);
         }
      }
      
      private function onAnimation4End(param1:Event) : void
      {
         if(this._animation4.currentFrame == this._animation4.totalFrames)
         {
            this._animation4.removeEventListener(Event.ENTER_FRAME,this.onAnimation4End);
            DisplayUtil.removeForParent(this._animation4);
            MainManager.openOperate();
            this.showActor();
         }
      }
      
      override public function destroy() : void
      {
         this.removeFightEventListener();
         MainManager.openOperate();
         this.showActor();
         super.destroy();
      }
   }
}

