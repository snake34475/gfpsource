package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import org.taomee.motion.easing.Quad;
   
   public class MapProcess_1091701 extends BaseMapProcess
   {
      
      private var _runAwayMC:MovieClip;
      
      public function MapProcess_1091701()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.checkTaskStatus();
      }
      
      private function checkTaskStatus() : void
      {
         if(Boolean(TasksManager.isAccepted(1309)) && Boolean(TasksManager.isProcess(1309,6)))
         {
            FightManager.isAutoWinnerEnd = false;
            FightManager.isAutoReasonEnd = false;
            FightManager.outToMapID = 14;
            this.addFightEventListener();
         }
      }
      
      private function addFightEventListener() : void
      {
         UserManager.addEventListener(UserEvent.DIE,this.onUserDied);
         FightManager.instance.addEventListener(FightEvent.REASON,this.onReason);
      }
      
      private function onUserDied(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data;
         if(_loc2_.info.roleType == 13053)
         {
            this.playRunaway(_loc2_.x,_loc2_.y);
         }
      }
      
      private function onWin(param1:FightEvent) : void
      {
      }
      
      private function playRunaway(param1:uint, param2:uint) : void
      {
         this._runAwayMC = _mapModel.libManager.getMovieClip("RunAway");
         this._runAwayMC.scaleX = -1;
         this._runAwayMC.x = param1;
         this._runAwayMC.y = param2;
         _mapModel.contentLevel.addChild(this._runAwayMC);
         TweenLite.to(this._runAwayMC,5,{
            "x":0,
            "y":param2,
            "ease":Quad.easeIn,
            "onComplete":this.onRunawayComplete
         });
      }
      
      private function onRunawayComplete() : void
      {
         FightManager.outToMapID = 14;
         MainManager.openOperate();
         MainManager.actorModel.execStandAction(false);
      }
      
      private function onReason(param1:FightEvent) : void
      {
         FightManager.outToMapID = 14;
         PveEntry.onReason();
      }
      
      private function removeFightEventListener() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWin);
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onReason);
         UserManager.removeEventListener(UserEvent.DIE,this.onUserDied);
      }
      
      override public function destroy() : void
      {
         this.removeFightEventListener();
      }
   }
}

