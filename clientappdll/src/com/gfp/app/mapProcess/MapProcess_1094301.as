package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.task.storyAnimation.StoryAnimationTask_1330_0;
   import com.gfp.app.task.storyAnimation.StoryAnimationTask_1330_1;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.events.Event;
   
   public class MapProcess_1094301 extends BaseMapProcess
   {
      
      private var _endMovie:StoryAnimationTask_1330_1;
      
      public function MapProcess_1094301()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(TasksManager.isProcess(1330,0))
         {
            this.playStartMovie();
            this.initWinMovie();
         }
         else if(TasksManager.isProcess(1330,1))
         {
            this.initWinMovie();
         }
         this.disabledItemKey();
      }
      
      private function disabledItemKey() : void
      {
         var _loc3_:KeyInfo = null;
         var _loc1_:Vector.<KeyInfo> = new Vector.<KeyInfo>(5,true);
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            _loc3_ = new KeyInfo();
            _loc1_[_loc2_] = _loc3_;
            _loc2_++;
         }
         KeyManager.upDateItemQuickKeys(_loc1_);
         KeyManager.setItemQuickAutoAddable(false);
      }
      
      private function playStartMovie() : void
      {
         var _loc1_:StoryAnimationTask_1330_0 = new StoryAnimationTask_1330_0();
         _loc1_.start();
      }
      
      private function initWinMovie() : void
      {
         FightManager.isAutoWinnerEnd = false;
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         FightManager.outToMapID = 9;
         this._endMovie = new StoryAnimationTask_1330_1();
         this._endMovie.start();
         MainManager.actorModel.execStandAction();
      }
      
      private function onAnimatEnd(param1:Event) : void
      {
         PveEntry.onWinner();
      }
      
      override public function destroy() : void
      {
         if(this._endMovie)
         {
            this._endMovie = null;
         }
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         super.destroy();
         KeyManager.upDateItemQuickKeys(MainManager.actorInfo.items);
         KeyManager.setItemQuickAutoAddable(true);
      }
   }
}

