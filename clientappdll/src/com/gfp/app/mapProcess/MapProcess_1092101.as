package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightGo;
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1092101 extends BaseMapProcess
   {
      
      private var _runAwayMC:MovieClip;
      
      private var _13070UserModel:UserModel;
      
      private var time:Timer = new Timer(1000);
      
      private var _tips:Sprite;
      
      public function MapProcess_1092101()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightGo.instance.enabledShow = false;
         FightManager.isAutoReasonEnd = false;
         UserManager.addEventListener(UserEvent.BORN,this.onUserBorn);
         this.time.addEventListener(TimerEvent.TIMER,this.onUserMove);
         this.time.start();
         this._tips = _mapModel.libManager.getSprite("UI_StartTips");
         LayerManager.topLevel.addChild(this._tips);
         this.layout();
         StageResizeController.instance.register(this.layout);
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onFightWinner);
      }
      
      private function layout() : void
      {
         this._tips.x = LayerManager.stageWidth - this._tips.width >> 1;
         this._tips.y = 150;
      }
      
      private function onUserBorn(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         var _loc3_:uint = 13070;
         TasksManager.addActionListener(TaskActionEvent.TASK_MONSTERWANTED,_loc3_.toString(),this.onMonsterUpdate);
         if(_loc2_)
         {
            if(_loc2_.info.roleType == 13070)
            {
               this._13070UserModel = _loc2_;
            }
         }
      }
      
      private function onMonsterUpdate(param1:TaskActionEvent) : void
      {
         var _loc2_:uint = 13070;
         TasksManager.removeActionListener(TaskActionEvent.TASK_MONSTERWANTED,_loc2_.toString(),this.onMonsterUpdate);
         if(this.time)
         {
            this.time.stop();
            this.time.removeEventListener(TimerEvent.TIMER,this.onUserMove);
         }
      }
      
      private function onUserMove(param1:TimerEvent) : void
      {
         if(Boolean(this._13070UserModel) && Boolean(this._13070UserModel.pos))
         {
            if(Point.distance(this._13070UserModel.pos,MainManager.actorModel.pos) < 150)
            {
               TextAlert.show("全面戒备，谁都别想夺走封印内的密令！");
            }
         }
      }
      
      private function onFightWinner(param1:FightEvent) : void
      {
         DisplayUtil.removeForParent(this._tips);
         this.layout();
      }
      
      override public function destroy() : void
      {
         FightGo.instance.enabledShow = true;
         if(this._tips)
         {
            DisplayUtil.removeForParent(this._tips);
         }
         StageResizeController.instance.unregister(this.layout);
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onFightWinner);
         UserManager.removeEventListener(UserEvent.BORN,this.onUserBorn);
         if(this.time)
         {
            this.time.stop();
            this.time.removeEventListener(TimerEvent.TIMER,this.onUserMove);
         }
      }
   }
}

