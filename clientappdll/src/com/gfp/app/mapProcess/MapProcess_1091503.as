package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1091503 extends BaseMapProcess
   {
      
      private var _stageAnimatEnd:MovieClip;
      
      public function MapProcess_1091503()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc1_:uint = 0;
         FightManager.isAutoWinnerEnd = false;
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
         if(TasksManager.isProcess(1295,6))
         {
            this._stageAnimatEnd = _mapModel.libManager.getMovieClip("StageAnimat_End_" + 0);
         }
         else
         {
            _loc1_ = Math.random() * 4 + 1;
            this._stageAnimatEnd = _mapModel.libManager.getMovieClip("StageAnimat_End_" + _loc1_);
         }
      }
      
      override public function destroy() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         if(this._stageAnimatEnd)
         {
            DisplayUtil.removeForParent(this._stageAnimatEnd);
            this._stageAnimatEnd.removeEventListener(Event.ENTER_FRAME,this.onAnimatEnd);
            this._stageAnimatEnd = null;
            MainManager.openOperate();
         }
         super.destroy();
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         FightManager.outToMapID = 12;
         if(this._stageAnimatEnd)
         {
            this._stageAnimatEnd.x = 726;
            this._stageAnimatEnd.y = 343;
            LayerManager.topLevel.addChild(this._stageAnimatEnd);
            MainManager.closeOperate(true);
            MainManager.actorModel.execStandAction();
            this._stageAnimatEnd.addEventListener(Event.ENTER_FRAME,this.onAnimatEnd);
            this._stageAnimatEnd.gotoAndPlay(1);
         }
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
         }
      }
   }
}

