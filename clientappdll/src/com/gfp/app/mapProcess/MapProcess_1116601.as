package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeMovFeather;
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1116601 extends BaseMapProcess
   {
      
      private var _expTimer:uint;
      
      private var _txtWarnMc:MovieClip;
      
      private var _txtExpMc:MovieClip;
      
      private var _txtTimeMc:MovieClip;
      
      private var _mapTimer:LeftTimeMovFeather;
      
      private var _expPerSecond:int = 3;
      
      private var _num:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private var _changeToFrame:Array = [1,1,1,1,1,1,1];
      
      private var _currentNum:int;
      
      private var _startTime:int;
      
      public function MapProcess_1116601()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._txtWarnMc = _mapModel.libManager.getMovieClip("UI_TxtWarn");
         this._txtExpMc = _mapModel.libManager.getMovieClip("UI_ExpMc");
         this._txtTimeMc = _mapModel.libManager.getMovieClip("UI_TimeMc");
         DisplayUtil.align(this._txtWarnMc,null,AlignType.MIDDLE_CENTER);
         LayerManager.topLevel.addChild(this._txtWarnMc);
         LayerManager.topLevel.addChild(this._txtExpMc);
         LayerManager.topLevel.addChild(this._txtTimeMc);
         this.resizePos();
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            this._num.push(this._txtExpMc["num" + _loc1_]);
            this._num[_loc1_].gotoAndStop(1);
            _loc1_++;
         }
         TweenMax.to(this._txtWarnMc,3,{
            "alpha":0,
            "delay":2,
            "onComplete":this.warnMcTweenOver
         });
         StageResizeController.instance.register(this.resizePos);
         this.addEventListener();
         this._mapTimer = new LeftTimeMovFeather(3 * 60 * 1000,this._txtTimeMc,null,1,false);
         this._mapTimer.start();
         this._startTime = getTimer();
         this._expTimer = setInterval(this.expAdd,1000);
      }
      
      private function resizePos() : void
      {
         this._txtExpMc.y = 100;
         this._txtExpMc.x = LayerManager.stageWidth - this._txtExpMc.width - 200;
         this._txtTimeMc.y = 100;
         this._txtTimeMc.x = LayerManager.stageWidth - this._txtTimeMc.width - 700;
      }
      
      private function addEventListener() : void
      {
         this._txtExpMc.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onEnd);
         FightManager.instance.addEventListener(FightEvent.REASON,this.onEnd);
      }
      
      private function removeEventListener() : void
      {
         this._txtExpMc.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onEnd);
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onEnd);
      }
      
      private function onEnd(param1:FightEvent) : void
      {
         this._mapTimer.clear();
      }
      
      private function warnMcTweenOver() : void
      {
         TweenMax.killChildTweensOf(this._txtWarnMc);
         LayerManager.topLevel.removeChild(this._txtWarnMc);
      }
      
      private function expAdd() : void
      {
         var _loc1_:int = getTimer() - this._startTime;
         var _loc2_:int = this._currentNum;
         var _loc3_:int = this._currentNum + this._expPerSecond;
         var _loc4_:int = 0;
         while(_loc3_ >= 1)
         {
            this._changeToFrame[_loc4_] = _loc3_ % 10 * 5 + 1;
            _loc2_ = int(_loc2_ / 10);
            _loc3_ = int(_loc3_ / 10);
            _loc4_++;
         }
         this._currentNum = this._expPerSecond * (_loc1_ * 0.001);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            if(this._num[_loc2_].currentFrame != this._changeToFrame[_loc2_])
            {
               if(Boolean(this._num[_loc2_].playing) == false)
               {
                  this._num[_loc2_].play();
                  this._num[_loc2_].playing = true;
               }
            }
            else if(Boolean(this._num[_loc2_].playing) == true)
            {
               this._num[_loc2_].stop();
               this._num[_loc2_].playing = false;
            }
            _loc2_++;
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.removeEventListener();
         TweenMax.killChildTweensOf(this._txtWarnMc);
         DisplayUtil.removeForParent(this._txtWarnMc);
         DisplayUtil.removeForParent(this._txtExpMc);
         DisplayUtil.removeForParent(this._txtTimeMc);
         StageResizeController.instance.unregister(this.resizePos);
         if(this._mapTimer)
         {
            this._mapTimer.destroy();
         }
         if(this._expTimer)
         {
            clearInterval(this._expTimer);
         }
      }
   }
}

