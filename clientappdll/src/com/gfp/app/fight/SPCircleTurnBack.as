package com.gfp.app.fight
{
   import com.gfp.app.toolBar.FightToolBar;
   import com.gfp.core.info.ConvertMovieInfo;
   import com.gfp.core.manager.ConvertMovieClipManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.MapModel;
   import com.gfp.core.model.SpriteModel;
   import com.gfp.core.player.MovieFramePlayer;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.motion.TTween;
   import org.taomee.motion.TweenEvent;
   import org.taomee.motion.easing.Expo;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.Tick;
   
   public class SPCircleTurnBack
   {
      
      private static var endX:int = 845;
      
      private static var endY:int = 515;
      
      public var speed:int = 3;
      
      private var _mainUI:MovieFramePlayer;
      
      private var vx:Number = 0;
      
      private var vy:Number = 0;
      
      private var friction:Number = 0.6;
      
      private var angle:Number = Math.random() * (2 * Math.PI);
      
      private var dx:int = 2;
      
      private var dy:int = 1;
      
      private var maxX:int;
      
      private var maxY:int;
      
      private var minX:int;
      
      private var minY:int;
      
      private var _tween:TTween;
      
      private var _orderID:int;
      
      private var _target:SpriteModel;
      
      private var _endTimeOut:uint;
      
      public function SPCircleTurnBack(param1:int, param2:Point)
      {
         endY = LayerManager.stageHeight - 40;
         super();
         var _loc3_:ConvertMovieInfo = ConvertMovieClipManager.getInstance().getPlayerDataById("Add_SP_Turnback_animat");
         this._mainUI = new MovieFramePlayer(_loc3_);
         this._orderID = param1;
         this.maxX = LayerManager.stageWidth;
         this.minX = 0;
         this.maxY = LayerManager.stageHeight;
         this.minY = 0;
         var _loc4_:int = param2.x - 40 + 50 * Math.random();
         var _loc5_:int = param2.y - 100 + 100 * Math.random();
         this._mainUI.offsetX = _loc4_;
         this._mainUI.offsetY = _loc5_;
         LayerManager.topLevel.addChild(this._mainUI);
         this._mainUI.play();
         this.beginEffect();
      }
      
      public function beginEffect() : void
      {
         var _loc1_:uint = this._orderID * 300;
         _loc1_ = _loc1_ > 3000 ? 3000 : _loc1_;
         if(_loc1_ != 0)
         {
            Tick.instance.addCallback(this.onEnterFrame);
            this._endTimeOut = setTimeout(this.effectEnd,_loc1_);
         }
         else
         {
            this.effectEnd();
         }
      }
      
      private function effectEnd() : void
      {
         clearTimeout(this._endTimeOut);
         Tick.instance.removeCallback(this.onEnterFrame);
         this._tween = new TTween(this._mainUI);
         this._tween.addEventListener(TweenEvent.MOTION_FINISH,this.onTweenEnd);
         this._tween.init({
            "y":endY,
            "x":endX,
            "scaleX":1.5,
            "scaleY":1.5
         },{
            "y":Expo.easeIn,
            "x":Expo.easeIn,
            "scaleX":Expo.easeIn,
            "scaleY":Expo.easeIn
         },800);
         this._tween.start();
      }
      
      private function onTweenEnd(param1:TweenEvent) : void
      {
         this._tween.removeEventListener(TweenEvent.MOTION_FINISH,this.onTweenEnd);
         var _loc2_:MapModel = MapManager.currentMap;
         if(!_loc2_)
         {
         }
         this.destroy();
         FightToolBar.updateSkillPoint();
      }
      
      private function brownEffect() : void
      {
         this.vx += Math.random() * 10 - 5;
         this.vy += Math.random() * 10 - 5;
         this._mainUI.x += this.vx;
         this._mainUI.y += this.vy;
         this.vx *= this.friction;
         this.vy *= this.friction;
      }
      
      private function onEnterFrame(param1:Number) : void
      {
         this._mainUI.render();
         this.randomEffect();
      }
      
      private function randomEffect() : void
      {
         this._mainUI.x += Math.cos(this.angle) * this.dx;
         this._mainUI.y += Math.sin(this.angle) * this.dy;
         if(this._mainUI.x > this.maxX)
         {
            this.dx *= -1;
            this._mainUI.x -= this.speed;
            this.chageAngle();
         }
         if(this._mainUI.x < this.minX)
         {
            this.dx *= -1;
            this._mainUI.x += this.speed;
         }
         if(this._mainUI.y > this.maxY)
         {
            this.dy *= -1;
            this._mainUI.y -= this.speed;
            this.chageAngle();
         }
         if(this._mainUI.y < this.minY)
         {
            this.dy *= -1;
            this._mainUI.y += this.speed;
         }
      }
      
      private function chageAngle() : void
      {
         this.angle = Math.random() * (2 * Math.PI);
         this.angle = this.angle < 1 ? 1 : this.angle;
      }
      
      private function destroy() : void
      {
         DisplayUtil.removeForParent(this._mainUI);
         if(this._tween)
         {
            this._tween.destroy();
            this._tween = null;
         }
         if(this._mainUI)
         {
            this._mainUI.dispose();
         }
      }
   }
}

