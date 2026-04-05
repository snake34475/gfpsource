package com.gfp.app.fight
{
   import com.gfp.core.cache.SoundCache;
   import com.gfp.core.cache.SoundInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.SpriteModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.sound.SoundManager;
   import com.gfp.core.utils.Direction;
   import com.gfp.core.utils.SpriteType;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.Tick;
   
   public class FightEndEffect
   {
      
      private static var colorTransform:ColorTransform;
      
      protected var _background:Shape;
      
      protected var _images:Vector.<Bitmap>;
      
      protected var _movie:MovieClip;
      
      protected var _koSoundInfo:SoundInfo;
      
      private var _timer:int;
      
      private var _runnedTime:int;
      
      private var _soundPlayed:Boolean;
      
      public function FightEndEffect()
      {
         super();
      }
      
      public function init(param1:Boolean) : void
      {
         clearTimeout(this._timer);
         this._timer = setTimeout(this.start,2000,param1);
      }
      
      protected function start(param1:Boolean) : void
      {
         this._images = new Vector.<Bitmap>();
         this._background = new Shape();
         this._background.graphics.beginFill(0);
         this._background.graphics.drawRect(0,0,5000,5000);
         this._background.graphics.endFill();
         LayerManager.topLevel.addChild(this._background);
         this._soundPlayed = false;
         this._runnedTime = 0;
         if(param1)
         {
            this._movie = new UI_Fight_KO();
            this._movie.x = LayerManager.stageWidth >> 1;
            this._movie.y = LayerManager.stageHeight >> 1;
            SoundCache.load(ClientConfig.getSoundOther("fight_ko.mp3"),this.onSoundComplete,null);
         }
         Tick.instance.addCallback(this.onTick);
         this.onTick(0);
      }
      
      private function onSoundComplete(param1:SoundInfo) : void
      {
         this._koSoundInfo = param1;
         if(Boolean(this._movie) && this._movie.currentFrame > 55)
         {
            SoundManager.playSound(param1.url,0,false,0.6);
         }
      }
      
      protected function clearImages() : void
      {
         var _loc1_:Bitmap = null;
         while(Boolean(this._images) && Boolean(this._images.length))
         {
            _loc1_ = this._images.pop();
            DisplayUtil.removeForParent(_loc1_);
            _loc1_.bitmapData.dispose();
         }
      }
      
      protected function onTick(param1:int) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:uint = 0;
         this.clearImages();
         var _loc2_:DisplayObjectContainer = MapManager.currentMap.contentLevel;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.numChildren)
         {
            _loc4_ = _loc2_.getChildAt(_loc3_);
            if(_loc4_ is UserModel && Boolean(_loc4_.info))
            {
               _loc5_ = uint(SpriteModel.getSpriteType(_loc4_.info.roleType));
               if(_loc5_ == SpriteType.OGRE || _loc5_ == SpriteType.SUMMON || _loc5_ == SpriteType.PEOPLE)
               {
                  this.processUserModel(_loc4_);
               }
            }
            _loc3_++;
         }
         if(this._movie)
         {
            LayerManager.topLevel.addChild(this._movie);
         }
         this._runnedTime += param1;
         if(this._movie)
         {
            this._movie.gotoAndStop(int(this._movie.totalFrames * this._runnedTime / 600) + 1);
            if(this._movie.currentFrame >= 55 && this._soundPlayed == false)
            {
               if(this._koSoundInfo)
               {
                  this._soundPlayed = true;
                  SoundManager.playSound(this._koSoundInfo.url,0,false,0.6);
               }
            }
         }
      }
      
      private function processUserModel(param1:UserModel) : void
      {
         var _loc2_:DisplayObject = param1.player as DisplayObject;
         if(param1.visible == false || _loc2_.visible == false || _loc2_.width == 0 || _loc2_.height == 0)
         {
            return;
         }
         var _loc3_:BitmapData = new BitmapData(_loc2_.width,_loc2_.height,true,0);
         var _loc4_:Rectangle = _loc2_.getBounds(_loc2_);
         if(colorTransform == null)
         {
            colorTransform = new ColorTransform(0,0,0,1,255,255,255,0);
         }
         _loc3_.draw(_loc2_,new Matrix(1,0,0,1,-_loc4_.x,-_loc4_.y),colorTransform);
         var _loc5_:Bitmap = new Bitmap(_loc3_);
         _loc5_.x = param1.x + _loc4_.x + MapManager.currentMap.root.x;
         _loc5_.y = param1.y + _loc4_.y + MapManager.currentMap.root.y;
         if(param1.direction == Direction.LEFT)
         {
            _loc5_.scaleX = -1;
            _loc5_.x += _loc5_.width;
         }
         this._images.push(_loc5_);
         LayerManager.topLevel.addChild(_loc5_);
      }
      
      private function trunWhite(param1:BitmapData) : void
      {
         var _loc2_:Rectangle = new Rectangle(0,0,param1.width,param1.height);
         var _loc3_:Vector.<uint> = param1.getVector(_loc2_);
         _loc3_.forEach(this.processPixel);
         param1.setVector(_loc2_,_loc3_);
      }
      
      private function processPixel(param1:int, param2:int, param3:Vector.<uint>) : void
      {
         param3[param2] = (param1 & 0xFF000000) + 16777215;
      }
      
      public function destroy() : void
      {
         clearTimeout(this._timer);
         this.clearImages();
         Tick.instance.removeCallback(this.onTick);
         DisplayUtil.removeForParent(this._background);
         if(this._movie)
         {
            DisplayUtil.removeForParent(this._movie);
         }
         this._koSoundInfo = null;
         this._images = null;
      }
   }
}

