package com.gfp.app.fight
{
   import com.gfp.app.cartoon.ExtendBagItem;
   import com.gfp.core.CommandID;
   import com.gfp.core.info.RollItemInfo;
   import com.gfp.core.manager.FocusManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.ItemInfoTip;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.manager.DepthManager;
   import org.taomee.motion.easing.Quad;
   import org.taomee.utils.DisplayUtil;
   
   public class RollItem extends Sprite
   {
      
      public static const OVER_TIME:uint = 10;
      
      private var _mainUI:MovieClip;
      
      private var _itemIcon:Sprite;
      
      private var _itemNumTxt:TextField;
      
      private var _rollBtn:SimpleButton;
      
      private var _cancleBtn:SimpleButton;
      
      private var _rollAnimatMC:MovieClip;
      
      private var _numMC:MovieClip;
      
      private var _icom:ExtendBagItem;
      
      private var _timer:Timer;
      
      private var _numContainer:Sprite;
      
      private var _info:RollItemInfo;
      
      private var _timerOutID:uint;
      
      public function RollItem(param1:RollItemInfo)
      {
         super();
         this._mainUI = UIManager.getMovieClip("Fight_RollItem_panel");
         this._info = param1;
         this._itemIcon = this._mainUI["ItemIcon"];
         this._itemNumTxt = this._itemIcon["num_tf"];
         this._rollBtn = this._mainUI["rollBtn"];
         this._cancleBtn = this._mainUI["cancleBtn"];
         this._rollAnimatMC = this._mainUI["rollAnimatMC"];
         this._numMC = this._mainUI["numMC"];
         this._numContainer = this._mainUI["numBG"];
         this._icom = new ExtendBagItem(param1.rollItemID,false);
         this._icom.x = 25;
         this._icom.y = 25;
         this._itemIcon.addChild(this._icom);
         DepthManager.bringToTop(this._itemNumTxt);
         this._itemNumTxt.text = param1.rollCount + "";
         this._timer = new Timer(1000,OVER_TIME);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this._timer.start();
         addChild(this._mainUI);
         this.initEvent();
      }
      
      public function displayPoint(param1:int) : void
      {
         if(this._mainUI)
         {
            this._rollAnimatMC.stop();
            DisplayUtil.removeForParent(this._rollAnimatMC);
            this.displayNum(param1,this._numMC,12,15);
            this._timerOutID = setTimeout(this.playHide,1000);
            this._rollBtn.removeEventListener(MouseEvent.CLICK,this.onRollItemClick);
            DisplayUtil.removeForParent(this._rollBtn);
         }
      }
      
      public function playHide() : void
      {
         if(this._timerOutID)
         {
            clearTimeout(this._timerOutID);
         }
         if(this._mainUI)
         {
            TweenLite.to(this._mainUI,0.5,{
               "x":0,
               "y":-50,
               "alpha":0.5,
               "ease":Quad.easeIn,
               "onComplete":this.onPlayComplete
            });
         }
      }
      
      private function onTimerComplete(param1:TimerEvent) : void
      {
         this.calcle();
      }
      
      private function calcle() : void
      {
         this.playHide();
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         DisplayUtil.removeAllChild(this._numContainer);
         this.displayNum(OVER_TIME - this._timer.currentCount,this._numContainer,12,0);
      }
      
      private function displayNum(param1:int, param2:Sprite, param3:int = 0, param4:int = 0) : void
      {
         var _loc9_:Sprite = null;
         var _loc5_:Array = param1.toString().split("");
         var _loc6_:Number = 0;
         var _loc7_:int = int(_loc5_.length);
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc9_ = UIManager.getSprite("Number_Get_" + _loc5_[_loc8_]);
            if(_loc9_)
            {
               _loc9_.x = param3 + _loc6_;
               _loc6_ = _loc9_.width;
               _loc9_.y = param4;
               param2.addChild(_loc9_);
            }
            _loc8_++;
         }
      }
      
      private function initEvent() : void
      {
         this._rollBtn.addEventListener(MouseEvent.CLICK,this.onRollItemClick);
         this._cancleBtn.addEventListener(MouseEvent.CLICK,this.onCalcleClick);
      }
      
      private function onCalcleClick(param1:MouseEvent) : void
      {
         this._rollBtn.removeEventListener(MouseEvent.CLICK,this.onRollItemClick);
         this._cancleBtn.removeEventListener(MouseEvent.CLICK,this.onCalcleClick);
         this.calcle();
         this.sendRoll(true);
         FocusManager.setDefaultFocus();
      }
      
      private function onPlayComplete() : void
      {
         this.destroy();
      }
      
      private function onRollItemClick(param1:MouseEvent) : void
      {
         this._rollBtn.removeEventListener(MouseEvent.CLICK,this.onRollItemClick);
         this._cancleBtn.removeEventListener(MouseEvent.CLICK,this.onCalcleClick);
         DisplayUtil.removeForParent(this._rollBtn);
         this._rollAnimatMC.gotoAndPlay(1);
         FocusManager.setDefaultFocus();
         this.sendRoll(false);
      }
      
      private function sendRoll(param1:Boolean) : void
      {
         SocketConnection.send(CommandID.TEAM_ROLL_ITEM,this._info.roomId,this._info.rollID,param1 == true ? 1 : 0);
      }
      
      public function destroy() : void
      {
         ItemInfoTip.hide();
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
            this._timer = null;
         }
         if(this._mainUI)
         {
            this._rollBtn.removeEventListener(MouseEvent.CLICK,this.onRollItemClick);
            this._cancleBtn.removeEventListener(MouseEvent.CLICK,this.onCalcleClick);
            DisplayUtil.removeForParent(this._icom);
            this._icom.destroy();
            this._rollAnimatMC.stop();
            DisplayUtil.removeForParent(this._rollAnimatMC);
            this._rollAnimatMC = null;
            DisplayUtil.removeAllChild(this._mainUI);
            DisplayUtil.removeForParent(this._mainUI);
            this._mainUI = null;
         }
         FocusManager.setDefaultFocus();
      }
   }
}

