package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.SkillEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1124301 extends BaseMapProcess
   {
      
      private var _txtWarnMc:MovieClip;
      
      private var _txtBornMc:MovieClip;
      
      private var _hasShowed:Boolean;
      
      private var _map:Dictionary = new Dictionary();
      
      public function MapProcess_1124301()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this.initEventListener();
         this._txtWarnMc = _mapModel.libManager.getMovieClip("UI_TxtWarn");
         this._txtBornMc = _mapModel.libManager.getMovieClip("UI_TxtBorn");
         DisplayUtil.align(this._txtWarnMc,null,AlignType.MIDDLE_CENTER);
         DisplayUtil.align(this._txtBornMc,null,AlignType.MIDDLE_CENTER);
         LayerManager.topLevel.addChild(this._txtWarnMc);
         this.resizePos();
         TweenMax.to(this._txtWarnMc,3,{
            "x":LayerManager.stageWidth - this._txtWarnMc.width,
            "y":0,
            "delay":2,
            "onComplete":this.warnMcTweenOver
         });
         StageResizeController.instance.register(this.resizePos);
      }
      
      private function warnMcTweenOver() : void
      {
         TweenMax.killChildTweensOf(this._txtWarnMc);
      }
      
      private function resizePos() : void
      {
         this._txtWarnMc.y = LayerManager.stageHeight - this._txtWarnMc.height >> 1;
         this._txtWarnMc.x = LayerManager.stageWidth - this._txtWarnMc.width >> 1;
         this._txtBornMc.y = LayerManager.stageHeight >> 1;
         this._txtBornMc.x = LayerManager.stageWidth >> 1;
      }
      
      private function initEventListener() : void
      {
         UserManager.addEventListener(UserEvent.BORN,this.onMonsterBorn);
         UserManager.addEventListener(UserEvent.DIE,this.onOgreExploded);
         UserManager.addEventListener(UserEvent.EXPLODED,this.onOgreExploded);
         UserManager.addEventListener(SkillEvent.SKILL_ACTION,this.onSkill);
      }
      
      private function removeEventListener() : void
      {
         UserManager.removeEventListener(UserEvent.BORN,this.onMonsterBorn);
         UserManager.removeEventListener(UserEvent.DIE,this.onOgreExploded);
         UserManager.removeEventListener(UserEvent.EXPLODED,this.onOgreExploded);
         UserManager.removeEventListener(SkillEvent.SKILL_ACTION,this.onSkill);
      }
      
      private function onMonsterBorn(param1:UserEvent) : void
      {
         var _loc3_:CountDown = null;
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == 12426 && this._hasShowed == false)
         {
            this._hasShowed = true;
            LayerManager.topLevel.addChild(this._txtBornMc);
            TweenMax.to(this._txtBornMc,5,{
               "alpha":0,
               "delay":2,
               "onComplete":this.bornMcTweenOver
            });
         }
         if(_loc2_.info.roleType == 12423)
         {
            _loc3_ = new CountDown(_mapModel);
            _loc3_.start();
            _loc3_.y -= 150;
            _loc2_.addChild(_loc3_);
            this._map[_loc2_.info.userID] = [_loc2_,_loc3_];
         }
      }
      
      private function onOgreExploded(param1:UserEvent) : void
      {
         var _loc3_:Array = null;
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == 12423)
         {
            _loc3_ = this._map[_loc2_.info.userID];
            if(_loc3_)
            {
               (_loc3_[1] as CountDown).destroy();
            }
            this._map[_loc2_.info.userID] = null;
            delete this._map[_loc2_.info.userID];
         }
      }
      
      private function bornMcTweenOver() : void
      {
         TweenMax.killChildTweensOf(this._txtBornMc);
         LayerManager.topLevel.removeChild(this._txtBornMc);
      }
      
      private function onSkill(param1:SkillEvent) : void
      {
         if(param1.skillID == 4120884)
         {
            AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEndHandle);
            AnimatPlay.startAnimat("blood_explode",-1,true,0,0,false,false,true,0);
         }
      }
      
      private function onAnimatEndHandle(param1:AnimatEvent) : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEndHandle);
      }
      
      override public function destroy() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Array = null;
         this.removeEventListener();
         TweenMax.killChildTweensOf(this._txtBornMc);
         TweenMax.killChildTweensOf(this._txtWarnMc);
         for(_loc1_ in this._map)
         {
            _loc2_ = this._map[_loc1_];
            if(_loc2_)
            {
               (_loc2_[1] as CountDown).destroy();
            }
            this._map[_loc1_] = null;
            delete this._map[_loc1_];
         }
         this._map = null;
         DisplayUtil.removeForParent(this._txtWarnMc);
         DisplayUtil.removeForParent(this._txtBornMc);
         super.destroy();
      }
   }
}

import com.gfp.core.model.MapModel;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.utils.getTimer;
import org.taomee.utils.DisplayUtil;
import org.taomee.utils.Tick;

class CountDown extends Sprite
{
   
   private var _mainUI:MovieClip;
   
   private var _startTime:int;
   
   public function CountDown(param1:MapModel)
   {
      super();
      this._mainUI = param1.libManager.getMovieClip("CountDownUI");
      addChild(this._mainUI);
      this._mainUI.stop();
   }
   
   public function start() : void
   {
      Tick.instance.addCallback(this.onTick);
      this._startTime = getTimer();
      this.onTick(0);
   }
   
   private function onTick(param1:int) : void
   {
      var _loc2_:int = (getTimer() - this._startTime) * 0.001;
      this._mainUI.gotoAndStop(_loc2_ + 1);
   }
   
   public function destroy() : void
   {
      Tick.instance.removeCallback(this.onTick);
      DisplayUtil.removeForParent(this);
   }
}
