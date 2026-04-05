package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.ActorModel;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.LoadingType;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import org.taomee.utils.DisplayUtil;
   
   public class StoryAnimationTask_35_1 extends EventDispatcher implements IStoryAnimation
   {
      
      private var _mainMC:Sprite;
      
      private var _halo:MovieClip;
      
      private var _loader:UILoader;
      
      private var _stoneArray:Array;
      
      private var _sCount:int;
      
      private const targetX:int = 780;
      
      private const targetY:int = 472;
      
      private const playArray:Array = [50,60,70,80,90,100,110,120];
      
      private var _outStepX:Number;
      
      private var _outStepY:Number;
      
      public function StoryAnimationTask_35_1()
      {
         super();
      }
      
      public function setParams(param1:String) : void
      {
      }
      
      public function start() : void
      {
         this.onStart();
      }
      
      public function onStart() : void
      {
         MainManager.closeOperate();
         this._stoneArray = new Array();
         this._sCount = 0;
         this.loadAnimat();
      }
      
      private function loadAnimat() : void
      {
         this._loader = new UILoader(ClientConfig.getCartoon("task35_1"),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._mainMC = param1.uiloader.loader.content as Sprite;
         this.initStoneArray();
         this._halo = this._mainMC["_halo"];
         this._halo.gotoAndStop(1);
         this._halo.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._halo.x = 990;
         this._halo.y = 996;
         MapManager.currentMap.contentLevel.addChild(this._halo);
         this._halo.play();
      }
      
      private function initStoneArray() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = this._mainMC["s" + _loc1_];
            _loc2_.gotoAndStop(1);
            this._stoneArray.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(this.playArray.indexOf(this._halo.currentFrame) != -1)
         {
            _loc2_ = (this._halo.currentFrame - 50) / 10;
            this.addStone(_loc2_);
         }
         else if(this._halo.currentFrame == this._halo.totalFrames)
         {
            this._halo.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            DisplayUtil.removeForParent(this._halo);
            this._halo = null;
            this._mainMC = null;
            this._stoneArray = null;
            this.onFinish();
         }
      }
      
      private function addStone(param1:int) : void
      {
         var _loc2_:ActorModel = MainManager.actorModel;
         this._stoneArray[param1].x = _loc2_.x - 73;
         this._outStepX = (this._stoneArray[param1].x - this.targetX) / 14;
         this._stoneArray[param1].y = _loc2_.y - 150;
         this._outStepY = (this._stoneArray[param1].y - this.targetY) / 14;
         MapManager.currentMap.contentLevel.addChild(this._stoneArray[param1]);
         this._stoneArray[param1].addEventListener(Event.ENTER_FRAME,this.onPlayStone);
         this._stoneArray[param1].play();
      }
      
      private function onPlayStone(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.currentFrame < 16)
         {
            _loc2_.x -= this._outStepX;
            _loc2_.y -= this._outStepY;
         }
         else if(_loc2_.currentFrame == _loc2_.totalFrames)
         {
            _loc2_.removeEventListener(Event.ENTER_FRAME,this.onPlayStone);
            DisplayUtil.removeForParent(_loc2_);
            _loc2_ = null;
         }
      }
      
      public function onFinish() : void
      {
         this.dispatchEvent(new Event(Event.COMPLETE));
         if(this._loader)
         {
            this._loader.destroy(true);
            this._loader = null;
         }
      }
   }
}

