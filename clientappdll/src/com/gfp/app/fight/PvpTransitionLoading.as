package com.gfp.app.fight
{
   import com.gfp.app.manager.FightGroupManager;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.info.GroupUserInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.ui.FightWaitUI;
   import com.gfp.core.ui.loading.PlayerLoadingPercent;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class PvpTransitionLoading extends EventDispatcher
   {
      
      protected var _mainUI:FightWaitUI;
      
      private var percentVec:Vector.<PlayerLoadingPercent>;
      
      private var _backFunc:Function;
      
      private var timerCount:uint = 2000;
      
      private var _timer:Timer;
      
      private var _timerInterval:uint = 100;
      
      private var curTimer:uint = 0;
      
      private var parent:DisplayObjectContainer;
      
      public function PvpTransitionLoading(param1:Array, param2:DisplayObjectContainer, param3:Function, param4:uint = 2000)
      {
         var _loc11_:UserInfo = null;
         var _loc12_:PlayerLoadingPercent = null;
         var _loc13_:GroupUserInfo = null;
         var _loc14_:MovieClip = null;
         super();
         this.parent = param2;
         this.timerCount = param4;
         this.percentVec = new Vector.<PlayerLoadingPercent>();
         this.setMainUI();
         var _loc5_:uint = param1.length;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = uint(UserInfo(param1[0]).troop);
         var _loc9_:Boolean = false;
         var _loc10_:int = 0;
         while(_loc10_ < _loc5_)
         {
            _loc9_ = false;
            _loc11_ = param1[_loc10_];
            if(_loc11_.userID == MainManager.actorID)
            {
               FightManager.pvpLeftSide = _loc11_.troop == _loc8_;
            }
            _loc12_ = new PlayerLoadingPercent("Fight_PlayerPercent",_loc11_,FightGroupManager.instance.groupBtlId == 0 && PvpEntry.pvpID == 72);
            this.percentVec.push(_loc12_);
            _loc12_.setPercent(0);
            this._mainUI.addChild(_loc12_);
            if(FightGroupManager.instance.groupBtlId != 0)
            {
               for each(_loc13_ in FightGroupManager.instance.groupUserList)
               {
                  if(_loc13_.userInfo.userID == _loc11_.userID)
                  {
                     _loc9_ = true;
                  }
               }
               if(_loc9_)
               {
                  _loc6_++;
                  _loc12_.x = 41.6;
                  _loc12_.y = 51.25 + _loc6_ * 50;
               }
               else
               {
                  _loc7_++;
                  _loc12_.x = 922 - _loc12_.width + LayerManager.stageWidth - 960;
                  _loc12_.y = 51.25 + _loc7_ * 50;
               }
            }
            else if(PvpEntry.pvpID == PvpTypeConstantUtil.PVP_THREE_FIGHT)
            {
               if(_loc11_.troop == _loc8_)
               {
                  _loc6_++;
               }
               else
               {
                  _loc7_++;
               }
               _loc12_.x = 360;
               _loc12_.y = 300 + (_loc7_ + _loc6_) * 50;
            }
            else if(PvpEntry.pvpID == PvpTypeConstantUtil.PVP_HERO_MIDAUTUMN || PvpEntry.pvpID == PvpTypeConstantUtil.PVP_SAN_GUO_CHI_BI)
            {
               _loc14_ = UIManager.getMovieClip("UI_CountryFlag");
               _loc14_.gotoAndStop(_loc11_.countryId + 1);
               _loc12_.addChild(_loc14_);
               _loc14_.x = -70;
               _loc14_.y = 4;
               _loc12_.x = 420;
               _loc12_.y = 300 + _loc10_ * 50;
            }
            else if(_loc11_.troop == _loc8_)
            {
               _loc6_++;
               _loc12_.x = 41.6;
               _loc12_.y = 51.25 + _loc6_ * 50;
            }
            else
            {
               _loc7_++;
               _loc12_.x = 922 - _loc12_.width + LayerManager.stageWidth - 960;
               _loc12_.y = 51.25 + _loc7_ * 50;
            }
            _loc10_++;
         }
         this._timer = new Timer(this._timerInterval,param4 / this._timerInterval);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.timerCompleteHandler);
         this._timer.start();
         this._backFunc = param3;
         param2.addChild(this._mainUI);
         this.layout();
         StageResizeController.instance.register(this.layout);
      }
      
      private function layout() : void
      {
      }
      
      private function setMainUI() : void
      {
         this._mainUI = new FightWaitUI(FightGroupManager.instance.pvpTypeIndex,1);
      }
      
      private function timerHandler(param1:TimerEvent) : void
      {
         var _loc2_:PlayerLoadingPercent = null;
         this.curTimer += this._timerInterval;
         for each(_loc2_ in this.percentVec)
         {
            _loc2_.setPercent(this.curTimer / this.timerCount * 100);
         }
      }
      
      private function timerCompleteHandler(param1:TimerEvent) : void
      {
         var _loc2_:PlayerLoadingPercent = null;
         for each(_loc2_ in this.percentVec)
         {
            _loc2_.setPercent(100);
         }
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.timerCompleteHandler);
            this._timer = null;
         }
         this._backFunc();
      }
      
      public function destory() : void
      {
         var _loc1_:PlayerLoadingPercent = null;
         StageResizeController.instance.unregister(this.layout);
         for each(_loc1_ in this.percentVec)
         {
            this._mainUI.removeChild(_loc1_);
         }
         this.parent.removeChild(this._mainUI);
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.timerCompleteHandler);
            this._timer = null;
         }
         this.parent = null;
         this._backFunc = null;
         this._mainUI = null;
      }
   }
}

