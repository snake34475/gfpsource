package com.gfp.app.mapProcess
{
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.dailyActivity.SwapTimesInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.PeopleModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.model.sensemodels.SightModel;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1105901 extends BaseMapProcess
   {
      
      private var guikeMC:MovieClip;
      
      private var monkeyHeadMC:MovieClip;
      
      private var stickMC1:MovieClip;
      
      private var stickMC2:MovieClip;
      
      private var _degreeSight:SightModel;
      
      private var _badgeBox1:SightModel;
      
      private var _badgeBox2:SightModel;
      
      private var _badgeBox3:SightModel;
      
      private var _badgeBox4:SightModel;
      
      private var _badgeTimeCode:uint = 0;
      
      private var _restAnimation:MovieClip;
      
      private var _doubleIntro:MovieClip;
      
      private var _moonStoneIntroAnimation:MovieClip;
      
      private var _moonStoneGotAnimation:MovieClip;
      
      private var _moonStoneCombineAnimation:MovieClip;
      
      private var _friendAnimation:MovieClip;
      
      private var _joeAnimation0:MovieClip;
      
      private var _joeEndAnimation:MovieClip;
      
      private var _wuSheng0:UserModel;
      
      private var _attPlayer:PeopleModel;
      
      private var _npcTime:uint;
      
      private var _playerTime:uint;
      
      private var _expSwapId:int = 5725;
      
      private var _growSwapId:int = 5726;
      
      private var _expV:Number;
      
      private var _growV:int;
      
      private var _expcao:TextField;
      
      private var _growcao:TextField;
      
      private var _exp:TextField;
      
      private var _grow:TextField;
      
      private var expmonster:int;
      
      private var growmonster:int;
      
      private var _expcaoId:int = 12137;
      
      private var _growcaoId:int = 12138;
      
      private var _killExpNum:int;
      
      private var _killGrowNum:int;
      
      protected var ui:MovieClip;
      
      private var delay:uint = 1000;
      
      private var repeat:uint = 10;
      
      public function MapProcess_1105901()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this.ui = _mapModel.libManager.getMovieClip("LittleSevenTrain");
         LayerManager.topLevel.addChildAt(this.ui,0);
         this.ui.x = LayerManager.stageWidth - 350 - 10;
         this.ui.y = 100;
         UserManager.addEventListener(UserEvent.DIE,this.onDie);
         UserManager.addEventListener(UserEvent.BORN,this.onUserBorn);
         this.calculateExpAndGrow();
         TasksManager.addActionListener(TaskActionEvent.TASK_TOLLGATE_PASSED,String(1059),this.onStartSwitch);
      }
      
      private function timerHandler(param1:TimerEvent) : void
      {
         this.calculateExpAndGrow();
      }
      
      private function onUserBorn(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         var _loc3_:UserInfo = _loc2_.info;
         if(_loc2_.info.roleType == this._expcaoId || _loc2_.info.roleType == this._growcaoId)
         {
            this.calculateExpAndGrow();
         }
      }
      
      private function onDie(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == MainManager.actorInfo.roleType)
         {
            return;
         }
         if(_loc2_.info.roleType == this._expcaoId || _loc2_.info.roleType == this._growcaoId)
         {
            this.calculateExpAndGrow();
         }
      }
      
      private function calculateExpAndGrow() : void
      {
         var _loc2_:UserModel = null;
         this._killExpNum = 0;
         this._killGrowNum = 0;
         var _loc1_:Array = UserManager.getModels();
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.info.roleType == this._expcaoId)
            {
               ++this._killExpNum;
            }
            else if(_loc2_.info.roleType == this._growcaoId)
            {
               ++this._killGrowNum;
            }
         }
         this.updateView();
      }
      
      private function updateView() : void
      {
         this.ui["expcao"].text = this._killExpNum.toString();
         this.ui["growcao"].text = this._killGrowNum.toString();
         this.ui["exp"].text = (this._killExpNum * 150000).toString();
         this.ui["grow"].text = (this._killGrowNum * 20).toString();
      }
      
      private function onStartSwitch(param1:TaskActionEvent) : void
      {
         TasksManager.removeActionListener(TaskActionEvent.TASK_TOLLGATE_PASSED,String(1059),this.onStartSwitch);
         this.getExpGrowV();
      }
      
      private function getExpGrowV() : void
      {
         ActivityExchangeTimesManager.addEventListener(this._expSwapId,this.getTimes);
         ActivityExchangeTimesManager.getActiviteTimeInfo(this._expSwapId);
         ActivityExchangeTimesManager.addEventListener(this._growSwapId,this.getTimes);
         ActivityExchangeTimesManager.getActiviteTimeInfo(this._growSwapId);
      }
      
      private function getTimes(param1:DataEvent) : void
      {
         ActivityExchangeTimesManager.removeEventListener(this._expSwapId,this.getTimes);
         ActivityExchangeTimesManager.removeEventListener(this._growSwapId,this.getTimes);
         var _loc2_:int = int((param1.data as SwapTimesInfo).dailyID);
         if(_loc2_ == this._expSwapId)
         {
            this._expV = (param1.data as SwapTimesInfo).times;
         }
         if(_loc2_ == this._growSwapId)
         {
            this._growV = (param1.data as SwapTimesInfo).times;
         }
         this.update();
      }
      
      private function update() : void
      {
         AlertManager.showSimpleAlarm("小侠士你这次获得了" + this._killExpNum * 150000 + "仙兽经验," + this._killGrowNum * 20 + "仙兽成长。");
      }
      
      override public function destroy() : void
      {
         if(this.ui.parent)
         {
            DisplayUtil.removeForParent(this.ui);
         }
         UserManager.removeEventListener(UserEvent.DIE,this.onDie);
         UserManager.removeEventListener(UserEvent.BORN,this.onUserBorn);
         super.destroy();
      }
   }
}

