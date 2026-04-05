package com.gfp.app.fightpower
{
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserManager;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class FightPowerChangShow extends EventDispatcher
   {
      
      private static var _instance:FightPowerChangShow;
      
      private var _fightPowerCon:MovieClip;
      
      private var _fightNumList:Vector.<MovieClip>;
      
      private var _fightObj:Object;
      
      private var _timeId:int;
      
      private var _preFCon:Sprite;
      
      private var _curFCon:Sprite;
      
      private var _isRun:Boolean = false;
      
      private var _changStr:String;
      
      private var _changTime:Number = 0;
      
      private var _isNewEnter:Boolean = false;
      
      public function FightPowerChangShow(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function getInstance() : FightPowerChangShow
      {
         if(!_instance)
         {
            _instance = new FightPowerChangShow();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         UserManager.addEventListener(UserEvent.FIght_POWER_CHANGE,this.powerChangeHandler);
      }
      
      private function powerChangeHandler(param1:UserEvent) : void
      {
         var _loc2_:int = 0;
         if(this._isRun)
         {
            this._changTime = 0;
            clearInterval(this._timeId);
            TweenMax.killAll();
            this._isNewEnter = true;
         }
         this._isRun = true;
         this._fightObj = param1.data;
         if(!this._fightPowerCon)
         {
            this._fightPowerCon = UIManager.getMovieClip("UI_FightPowerCon");
            this._fightPowerCon.mouseChildren = this._fightPowerCon.mouseEnabled = false;
            this._fightNumList = new Vector.<MovieClip>();
            _loc2_ = 0;
            while(_loc2_ < 18)
            {
               this._fightNumList.push(UIManager.getMovieClip("UI_FightPowerNumer"));
               _loc2_++;
            }
            this._preFCon = new Sprite();
            this._curFCon = new Sprite();
         }
         this.fightNumOper();
         this.fightNumMove();
         this.fightNumChange();
      }
      
      private function fightNumMove() : void
      {
         this._fightPowerCon.alpha = 1;
         this._fightPowerCon.y = 0;
         LayerManager.topLevel.stage.addChild(this._fightPowerCon);
         DisplayUtil.align(this._fightPowerCon,null,AlignType.MIDDLE_CENTER);
         TweenMax.to(this._fightPowerCon,3,{
            "y":this._fightPowerCon.y - 50,
            "onComplete":this.moveOver
         });
      }
      
      private function moveOver() : void
      {
         TweenMax.to(this._fightPowerCon,1.5,{
            "delay":1,
            "y":this._fightPowerCon.y - 50,
            "alpha":0,
            "onComplete":this.hideFightNum
         });
      }
      
      private function hideFightNum() : void
      {
         if(Boolean(this._fightPowerCon) && Boolean(this._fightPowerCon.parent))
         {
            LayerManager.topLevel.stage.removeChild(this._fightPowerCon);
         }
         TweenMax.killChildTweensOf(this._fightPowerCon);
         this._isRun = false;
      }
      
      private function fightNumChange() : void
      {
         this._timeId = setInterval(this.changNum,50);
      }
      
      private function changNum() : void
      {
         var _loc1_:int = 0;
         if(this._changTime == 0)
         {
            this._changTime = getTimer();
         }
         if(getTimer() - this._changTime > 800)
         {
            this._changTime = 0;
            clearInterval(this._timeId);
            var _loc2_:int = 0;
            while(_loc2_ < this._changStr.length)
            {
               (this._curFCon.getChildAt(_loc2_) as MovieClip).gotoAndStop(int(this._changStr.substr(_loc2_,1)) + 1);
               _loc2_++;
            }
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < this._curFCon.numChildren)
         {
            _loc1_ = Math.ceil(Math.random() * 10);
            (this._curFCon.getChildAt(_loc2_) as MovieClip).gotoAndStop(_loc1_);
            _loc2_++;
         }
      }
      
      private function fightNumOper() : void
      {
         while(this._preFCon.numChildren)
         {
            this._preFCon.removeChildAt(0);
         }
         var _loc1_:String = this._fightObj.preF.toString();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            this._fightNumList[_loc2_].gotoAndStop(int(_loc1_.substr(_loc2_,1)) + 1);
            this._fightNumList[_loc2_].x = 31 * _loc2_ + 5;
            this._preFCon.addChild(this._fightNumList[_loc2_]);
            _loc2_++;
         }
         var _loc3_:int = _loc1_.length;
         while(this._curFCon.numChildren)
         {
            this._curFCon.removeChildAt(0);
         }
         _loc1_ = (this._fightObj.f - this._fightObj.preF).toString();
         this._changStr = _loc1_;
         if(_loc3_ + _loc1_.length > this._fightNumList.length)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            this._fightNumList[_loc3_ + _loc2_].gotoAndStop(int(_loc1_.substr(_loc2_,1)) + 1);
            this._fightNumList[_loc3_ + _loc2_].x = 31 * _loc2_ + 6;
            this._curFCon.addChild(this._fightNumList[_loc3_ + _loc2_]);
            _loc2_++;
         }
         this._preFCon.x = this._fightPowerCon["posMc"].x + this._fightPowerCon["posMc"].width + 10;
         this._fightPowerCon["addMark"].x = this._preFCon.x + this._preFCon.width + 15;
         this._curFCon.x = this._fightPowerCon["addMark"].x + this._fightPowerCon["addMark"].width + 3;
         this._fightPowerCon["upArrowMark"].x = this._curFCon.x + this._curFCon.width + 28;
         this._curFCon.y = this._preFCon.y = 33;
         this._fightPowerCon.addChild(this._preFCon);
         this._fightPowerCon.addChild(this._curFCon);
      }
      
      private function removeEvent() : void
      {
         UserManager.removeEventListener(UserEvent.FIght_POWER_CHANGE,this.powerChangeHandler);
      }
   }
}

