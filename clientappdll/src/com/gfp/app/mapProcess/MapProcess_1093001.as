package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightGo;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.miniMap.MiniMap;
   import com.gfp.app.time.TimerComponents;
   import com.gfp.core.config.xml.TollgateXMLInfo;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.TollgateTimeEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1093001 extends BaseMapProcess
   {
      
      private var _scoreUI:Sprite;
      
      private var _timerComp:TimerComponents;
      
      private var _time:uint;
      
      private var _timeText:TextField;
      
      public function MapProcess_1093001()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightGo.instance.enabledShow = false;
         MiniMap.instance.hide();
         this._timerComp = TimerComponents.instance;
         this._timerComp.hide();
         this.initScoreUI();
         this.addMapListener();
      }
      
      private function initScoreUI() : void
      {
         this._scoreUI = UIManager.getSprite("ToolBar_TollgateTimeUI");
         this._timeText = this._scoreUI["time_txt"];
         LayerManager.topLevel.addChild(this._scoreUI);
         DisplayUtil.align(this._scoreUI,null,AlignType.TOP_CENTER,new Point(-140,0));
         this._time = TollgateXMLInfo.getTollgateInfoById(930).countDownTime;
         this.updateTime();
      }
      
      private function addMapListener() : void
      {
         UserManager.addEventListener(UserEvent.BORN,this.onBorn);
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWin);
         this._timerComp.addEventListener(TollgateTimeEvent.TIMER_FRAME,this.onTollgateTimer);
      }
      
      private function onBorn(param1:UserEvent) : void
      {
         var model:UserModel = null;
         var event:UserEvent = param1;
         model = event.data as UserModel;
         if(model.info.roleType != MainManager.actorInfo.roleType)
         {
            model.visible = false;
         }
         setTimeout(function():void
         {
            model.visible = true;
         },400);
      }
      
      private function onTollgateTimer(param1:TollgateTimeEvent) : void
      {
         this._timeText.text = param1.time.toString();
         if(param1.time == 120 || param1.time == 60 || param1.time == 10)
         {
            this.showTip(param1.time);
         }
      }
      
      private function onWin(param1:FightEvent) : void
      {
         this._timerComp.stop();
         this._timerComp.removeEventListener(TollgateTimeEvent.TIMER_FRAME,this.onTollgateTimer);
      }
      
      private function destroyScoreUI() : void
      {
         DisplayUtil.removeForParent(this._scoreUI);
         this._scoreUI = null;
      }
      
      private function showTip(param1:uint) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case 120:
               _loc2_ = "时间还剩下2分钟。";
               break;
            case 60:
               _loc2_ = "时间还剩下1分钟！";
               break;
            case 10:
               _loc2_ = "时间还剩下10秒钟，加油啊，小侠士！！！";
         }
         TextAlert.show(_loc2_);
      }
      
      private function updateTime() : void
      {
         this._timeText.text = this._time.toString();
      }
      
      private function removeMapListener() : void
      {
         UserManager.removeEventListener(UserEvent.BORN,this.onBorn);
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWin);
         this._timerComp.removeEventListener(TollgateTimeEvent.TIMER_FRAME,this.onTollgateTimer);
      }
      
      override public function destroy() : void
      {
         this.removeMapListener();
         this.destroyScoreUI();
         FightGo.instance.enabledShow = true;
      }
   }
}

