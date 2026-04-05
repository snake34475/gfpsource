package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeFeather;
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.dailyActivity.SwapTimesInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MagicChangeManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.ui.alert.TextAlert;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1108601 extends BaseMapProcess
   {
      
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
      
      private var _timeFeather:LeftTimeFeather;
      
      private var _expNumV:int = 200000;
      
      private var _growNumV:int = 15;
      
      public function MapProcess_1108601()
      {
         super();
      }
      
      override protected function init() : void
      {
         var updateTips:Sprite = null;
         super.init();
         if(ClientTempState.isHighFanTian)
         {
            this._expNumV *= 2;
            this._growNumV *= 2;
         }
         this.ui = _mapModel.libManager.getMovieClip("LittleSevenTrain");
         this._timeFeather = new LeftTimeFeather(60000);
         LayerManager.topLevel.addChildAt(this.ui,0);
         this.layoutUI();
         StageResizeController.instance.register(this.layoutUI);
         UserManager.addEventListener(UserEvent.DIE,this.onDie);
         UserManager.addEventListener(UserEvent.BORN,this.onUserBorn);
         this.calculateExpAndGrow();
         TasksManager.addActionListener(TaskActionEvent.TASK_TOLLGATE_PASSED,String(1086),this.onStartSwitch);
         MagicChangeManager.instance.installBlockFilter(this.magicFilter);
         updateTips = _mapModel.libManager.getMovieClip("UpdateTips");
         LayerManager.topLevel.addChild(updateTips);
         updateTips.x = LayerManager.stageWidth - updateTips.width >> 1;
         updateTips.y = 180;
         TweenLite.to(updateTips,1,{
            "delay":4,
            "y":0,
            "alpha":0,
            "onComplete":function():void
            {
               DisplayUtil.removeForParent(updateTips);
            }
         });
      }
      
      private function magicFilter() : Boolean
      {
         TextAlert.show("当前关卡不允许变身哦！",16711680);
         return true;
      }
      
      private function layoutUI() : void
      {
         this.ui.x = LayerManager.stageWidth - 400;
         this.ui.y = 100;
      }
      
      private function timerHandler(param1:TimerEvent) : void
      {
         this.calculateExpAndGrow();
      }
      
      private function onUserBorn(param1:UserEvent) : void
      {
         var _loc3_:UserInfo = null;
         var _loc2_:UserModel = param1.data as UserModel;
         if(Boolean(_loc2_) && Boolean(_loc2_.info))
         {
            _loc3_ = _loc2_.info;
            if(_loc2_.info.roleType == this._expcaoId || _loc2_.info.roleType == this._growcaoId)
            {
               this.calculateExpAndGrow();
            }
         }
      }
      
      private function onDie(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info == null || _loc2_.info.roleType == MainManager.actorInfo.roleType)
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
         this.ui["exp"].text = (this._killExpNum * this._expNumV).toString();
         this.ui["grow"].text = (this._killGrowNum * this._growNumV).toString();
      }
      
      private function onStartSwitch(param1:TaskActionEvent) : void
      {
         TasksManager.removeActionListener(TaskActionEvent.TASK_TOLLGATE_PASSED,String(1086),this.onStartSwitch);
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
         AlertManager.showSimpleAlarm("小侠士你这次获得了" + String(this._killExpNum * this._expNumV) + "仙兽经验," + this._killGrowNum * this._growNumV + "仙兽成长。");
      }
      
      private function onModelDied(param1:FightEvent) : void
      {
      }
      
      override public function destroy() : void
      {
         if(this.ui.parent)
         {
            DisplayUtil.removeForParent(this.ui);
         }
         TasksManager.removeActionListener(TaskActionEvent.TASK_TOLLGATE_PASSED,String(1086),this.onStartSwitch);
         StageResizeController.instance.unregister(this.layoutUI);
         UserManager.removeEventListener(UserEvent.DIE,this.onDie);
         UserManager.removeEventListener(UserEvent.BORN,this.onUserBorn);
         MagicChangeManager.instance.uninstallBlockFilter(this.magicFilter);
         this._timeFeather.destroy();
         super.destroy();
      }
   }
}

