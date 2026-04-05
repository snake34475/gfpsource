package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.swap.SwapTool;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.fight.BruiseInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.utils.FilterUtil;
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1146601 extends BaseCountDownMapProcess
   {
      
      private var FREE_REBORN:int = 13133;
      
      private var COST_REBORN:int = 13134;
      
      private var _myScore:int;
      
      private var _otherScore:int;
      
      private var _myScorePanel:Sprite;
      
      private var _otherScorePanel:Sprite;
      
      private var _alertPanel:Sprite;
      
      private var _beginTip:Sprite;
      
      private var _fuZhouBorn:Sprite;
      
      private var _swapTool:SwapTool;
      
      private var _dieTime:int;
      
      private var _timer:int;
      
      public function MapProcess_1146601()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._swapTool = new SwapTool();
         UserManager.addEventListener(UserEvent.USER_DPS_HIT,this.bruiceHandle);
         UserManager.addEventListener(UserEvent.DIE,this.dieHandle);
         UserManager.addEventListener(UserEvent.BORN,this.onBossBorn);
         MainManager.actorModel.addEventListener(UserEvent.RE_BORN,this.userRebornHandle);
         this._myScorePanel = _mapModel.libManager.getSprite("UI_MyScore");
         this._otherScorePanel = _mapModel.libManager.getSprite("UI_OtherScore");
         LayerManager.topLevel.addChild(this._myScorePanel);
         LayerManager.topLevel.addChild(this._otherScorePanel);
         this._myScorePanel.y = 200;
         this._otherScorePanel.y = 200;
         this.layout();
         StageResizeController.instance.register(this.layout);
         this._myScorePanel["higherMC"].visible = false;
         this._otherScorePanel["higherMC"].visible = false;
         this._beginTip = _mapModel.libManager.getSprite("UI_Begin");
         LayerManager.topLevel.addChild(this._beginTip);
         this._beginTip.x = LayerManager.stageWidth - this._beginTip.width >> 1;
         this._beginTip.y = LayerManager.stageHeight - this._beginTip.height >> 1;
         TweenLite.to(this._beginTip,0.5,{
            "delay":3,
            "alpha":0
         });
      }
      
      private function onBossBorn(param1:UserEvent) : void
      {
         var e:UserEvent = param1;
         var model:UserModel = e.data as UserModel;
         if(Boolean(model) && Boolean(model.info) && model.info.roleType == 15365)
         {
            if(this._fuZhouBorn == null)
            {
               this._fuZhouBorn = _mapModel.libManager.getSprite("UI_FuZhouBorn");
               this._fuZhouBorn.mouseChildren = false;
               this._fuZhouBorn.mouseEnabled = false;
            }
            if(this._fuZhouBorn.stage == null)
            {
               LayerManager.topLevel.addChild(this._fuZhouBorn);
               this._fuZhouBorn.x = LayerManager.stageWidth - this._fuZhouBorn.width >> 1;
               this._fuZhouBorn.y = LayerManager.stageHeight - this._fuZhouBorn.height >> 1;
               this._fuZhouBorn.alpha = 1;
               TweenLite.to(this._fuZhouBorn,0.5,{
                  "delay":3,
                  "alpha":0,
                  "onComplete":function():void
                  {
                     DisplayUtil.removeForParent(_fuZhouBorn);
                  }
               });
            }
         }
      }
      
      private function bruiceHandle(param1:UserEvent) : void
      {
         var _loc2_:BruiseInfo = param1.data as BruiseInfo;
         if(_loc2_.roleID == 15364)
         {
            if(_loc2_.atkerID == MainManager.actorID)
            {
               this._myScore += _loc2_.decHP;
               this._myScorePanel["label"].text = this._myScore;
            }
            else
            {
               this._otherScore += _loc2_.decHP;
               this._otherScorePanel["label"].text = this._otherScore;
            }
            this._myScorePanel["higherMC"].visible = this._myScore > this._otherScore;
            this._otherScorePanel["higherMC"].visible = this._myScore < this._otherScore;
         }
      }
      
      private function dieHandle(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.userID == MainManager.actorID)
         {
            this._dieTime = getTimer();
            _mapModel.root.filters = FilterUtil.GRAY_FILTER;
            if(this._alertPanel == null)
            {
               this._alertPanel = _mapModel.libManager.getSprite("UI_Revivied");
               LayerManager.topLevel.addChild(this._alertPanel);
               this._alertPanel["costMC"].gotoAndStop(ActivityExchangeTimesManager.getTimes(this.FREE_REBORN) > 0 ? 1 : 2);
               this._alertPanel["goBtn"].addEventListener(MouseEvent.CLICK,this.rebornHandle);
               this._alertPanel["closeBtn"].addEventListener(MouseEvent.CLICK,this.closeAlertHandle);
               this.layout();
            }
            this._timer = setInterval(this.onTimer,1000);
            this.onTimer();
         }
      }
      
      private function onTimer() : void
      {
         var _loc1_:int = 0;
         if(this._alertPanel)
         {
            _loc1_ = (getTimer() - this._dieTime) * 0.001;
            this._alertPanel["timeMC"].gotoAndStop(_loc1_ + 1);
         }
      }
      
      private function closeAlertHandle(param1:MouseEvent = null) : void
      {
         clearInterval(this._timer);
         if(this._alertPanel)
         {
            this._swapTool.stop();
            this._alertPanel["closeBtn"].removeEventListener(MouseEvent.CLICK,this.closeAlertHandle);
            this._alertPanel["goBtn"].removeEventListener(MouseEvent.CLICK,this.rebornHandle);
            DisplayUtil.removeForParent(this._alertPanel);
            this._alertPanel = null;
         }
      }
      
      private function rebornHandle(param1:MouseEvent = null) : void
      {
         if(ActivityExchangeTimesManager.getTimes(this.FREE_REBORN) == 0)
         {
            this._swapTool.exchange(this.FREE_REBORN,false,"",this.exchangeCompleteHandle);
         }
         else
         {
            this._swapTool.exchange(this.COST_REBORN,false,"小侠士，是否花费{1}通宝立即复活？",this.exchangeCompleteHandle);
         }
      }
      
      private function exchangeCompleteHandle() : void
      {
         this.closeAlertHandle();
      }
      
      private function userRebornHandle(param1:UserEvent) : void
      {
         _mapModel.root.filters = [];
         this.closeAlertHandle();
      }
      
      private function layout() : void
      {
         if(FightManager.pvpLeftSide)
         {
            this._myScorePanel.x = 0;
            this._otherScorePanel.x = LayerManager.stageWidth - 151;
            this._otherScorePanel["higherMC"].x = -22.6;
         }
         else
         {
            this._otherScorePanel.x = 0;
            this._myScorePanel.x = LayerManager.stageWidth - 151;
            this._myScorePanel["higherMC"].x = -22.6;
         }
         if(this._alertPanel)
         {
            this._alertPanel.x = LayerManager.stageWidth - this._alertPanel.width >> 1;
            this._alertPanel.y = LayerManager.stageHeight - this._alertPanel.height >> 1;
         }
      }
      
      override public function destroy() : void
      {
         this.closeAlertHandle();
         DisplayUtil.removeForParent(this._myScorePanel);
         DisplayUtil.removeForParent(this._otherScorePanel);
         StageResizeController.instance.unregister(this.layout);
         UserManager.removeEventListener(UserEvent.USER_DPS_HIT,this.bruiceHandle);
         UserManager.removeEventListener(UserEvent.DIE,this.dieHandle);
         UserManager.removeEventListener(UserEvent.BORN,this.onBossBorn);
         MainManager.actorModel.removeEventListener(UserEvent.RE_BORN,this.userRebornHandle);
         this._swapTool.destroy();
         super.destroy();
      }
   }
}

