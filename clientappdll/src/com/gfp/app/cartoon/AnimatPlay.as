package com.gfp.app.cartoon
{
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ServerBuffManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.sound.SoundManager;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.LoadingType;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class AnimatPlay extends EventDispatcher
   {
      
      private static var _instance:AnimatPlay;
      
      private var loader:UILoader;
      
      private var animat:MovieClip;
      
      public var offsetX:Number;
      
      public var offsetY:Number;
      
      private var _headName:String;
      
      private var hasMusic:Boolean = false;
      
      private var musicFlag:Boolean = false;
      
      public var isRoot:Boolean;
      
      private var canJump:Boolean;
      
      private var _jumpBtn:SimpleButton;
      
      private var closeTop:Boolean = false;
      
      private var closeKey:Boolean = false;
      
      private var closeTool:Boolean = false;
      
      private var _isLoopBack:Boolean;
      
      private var bgNeeded:Boolean;
      
      private var background:Shape;
      
      private var backgroundType:int;
      
      public var isPlaying:Boolean;
      
      public var removeRoot:Boolean;
      
      public function AnimatPlay()
      {
         super();
      }
      
      public static function get instance() : AnimatPlay
      {
         if(_instance == null)
         {
            _instance = new AnimatPlay();
         }
         return _instance;
      }
      
      public static function startAnimat(param1:String, param2:int = -1, param3:Boolean = false, param4:Number = 0, param5:Number = 0, param6:Boolean = false, param7:Boolean = false, param8:Boolean = true, param9:int = 1, param10:Boolean = true, param11:Boolean = true, param12:Boolean = false) : void
      {
         instance.isRoot = param3;
         instance.offsetX = param4;
         instance.offsetY = param5;
         instance.hasMusic = param6;
         instance.canJump = param7;
         instance.closeTop = param8;
         instance.closeKey = param11;
         instance.closeTool = param10;
         instance.backgroundType = param9;
         instance.removeRoot = param12;
         instance.load(param1,param2);
      }
      
      private static function isBgNeeded(param1:String) : Boolean
      {
         return param1 != AnimatHeadString.STAGE && param1 != AnimatHeadString.STAGE_TURN && param1 != "forgeIron_";
      }
      
      public static function addAnimatListener(param1:String, param2:Function) : void
      {
         instance.addEventListener(param1,param2);
      }
      
      public static function removeAnimatListener(param1:String, param2:Function) : void
      {
         instance.removeEventListener(param1,param2);
      }
      
      public static function destory() : void
      {
         if(_instance)
         {
            _instance.destory();
         }
         _instance = null;
      }
      
      public static function getAnimat() : MovieClip
      {
         return instance.animat;
      }
      
      private function load(param1:String, param2:int) : void
      {
         if(param2 == -1)
         {
            this._headName = param1;
         }
         else
         {
            this._headName = param1 + param2;
         }
         this.loader = new UILoader(ClientConfig.getCartoon(this._headName),LayerManager.stage,LoadingType.TITLE_AND_PERCENT,"正在加载动画");
         this.loader.closeEnabled = false;
         this.loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
         this.loader.load();
         this.isPlaying = true;
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         this.animat = this.isRoot ? param1.uiloader.content as MovieClip : (param1.uiloader.content as MovieClip)["animat"];
         if(this.loader != null)
         {
            this.loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
            this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
         }
         this.playAnimat();
      }
      
      private function playAnimat() : void
      {
         if(this.animat == null)
         {
            return;
         }
         StageResizeController.instance.register(this.layout);
         MainManager.closeOperate(this.closeTop,this.closeTool,this.closeKey);
         this.animat.addEventListener(Event.ENTER_FRAME,this.animatEnterFrame);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwtichComplete);
         this.animat.gotoAndPlay(1);
         dispatchEvent(new AnimatEvent(AnimatEvent.ANIMAT_START,this._headName));
         LayerManager.stage.addChild(this.animat);
         if(this.removeRoot)
         {
            LayerManager.removeRoot();
         }
         if(this.background == null)
         {
            this.background = new Shape();
         }
         LayerManager.stage.addChild(this.background);
         if(this.backgroundType == 2)
         {
            LayerManager.stage.addChild(this.animat);
         }
         if(this.canJump)
         {
            this._jumpBtn = new ToolBar_JumpOverBtn();
            this._jumpBtn.addEventListener(MouseEvent.CLICK,this.onJumpOver);
            LayerManager.stage.addChild(this._jumpBtn);
         }
         this.layout();
         if(this.hasMusic)
         {
            if(SoundManager.isMusicEnable)
            {
               this.musicFlag = true;
               SoundManager.setMusicEnable(false);
               ServerBuffManager.instance.setMusicEnable(false);
            }
         }
      }
      
      private function layout() : void
      {
         if(this.offsetX == -2 && this.offsetY == -2)
         {
            this.drawBackgroud();
            return;
         }
         if(this._jumpBtn)
         {
            DisplayUtil.align(this._jumpBtn,null,AlignType.BOTTOM_RIGHT);
         }
         if(this.offsetX != 0 || this.offsetY != 0)
         {
            this.animat.x = this.offsetX + (LayerManager.stageWidth - 960) * 0.5;
            this.animat.y = this.offsetY + (LayerManager.stageHeight - 560) * 0.5;
         }
         else if(this.offsetX == -1 || this.offsetY == -1)
         {
            this.animat.x = this.animat.y = 0;
         }
         else
         {
            DisplayUtil.align(this.animat,null,AlignType.MIDDLE_CENTER);
         }
         this.drawBackgroud();
      }
      
      private function drawBackgroud() : void
      {
         var _loc1_:Graphics = this.background.graphics;
         _loc1_.clear();
         if(this.backgroundType == 1)
         {
            _loc1_.beginFill(0);
            _loc1_.drawRect(0,0,LayerManager.stageWidth,LayerManager.stageHeight - 560 >> 1);
            _loc1_.drawRect(0,560 + (LayerManager.stageHeight - 560 >> 1),LayerManager.stageWidth,LayerManager.stageHeight - 560 >> 1);
            _loc1_.drawRect(0,LayerManager.stageHeight - 560 >> 1,LayerManager.stageWidth - 960 >> 1,560);
            _loc1_.drawRect(960 + (LayerManager.stageWidth - 960 >> 1),LayerManager.stageHeight - 560 >> 1,LayerManager.stageWidth - 960 >> 1,560);
            _loc1_.endFill();
         }
         else if(this.backgroundType == 2)
         {
            _loc1_.beginFill(0);
            _loc1_.drawRect(0,0,LayerManager.stageWidth,LayerManager.stageHeight);
            _loc1_.endFill();
         }
      }
      
      private function animatEnterFrame(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_)
         {
            if(_loc2_.currentFrame == _loc2_.totalFrames)
            {
               if(_loc2_ == this.animat)
               {
                  this.stopAnimat();
               }
               else
               {
                  DisplayUtil.removeForParent(_loc2_);
               }
               this.isPlaying = false;
            }
         }
      }
      
      private function onMapSwtichComplete(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwtichComplete);
         this.stopAnimat();
      }
      
      private function onJumpOver(param1:MouseEvent) : void
      {
         this.stopAnimat();
      }
      
      public function stopAnimat() : void
      {
         this.isPlaying = false;
         StageResizeController.instance.unregister(this.layout);
         if(this.animat == null)
         {
            return;
         }
         if(this.background)
         {
            DisplayUtil.removeForParent(this.background);
         }
         this.animat.removeEventListener(Event.ENTER_FRAME,this.animatEnterFrame);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwtichComplete);
         MainManager.openOperate();
         this.animat.stop();
         this._isLoopBack = false;
         DisplayUtil.removeForParent(this.animat);
         dispatchEvent(new AnimatEvent(AnimatEvent.ANIMAT_END,this._headName));
         if(this.removeRoot)
         {
            LayerManager.addRoot();
         }
         if(this.musicFlag)
         {
            SoundManager.setMusicEnable(true);
            ServerBuffManager.instance.setMusicEnable(true);
         }
         if(this._jumpBtn)
         {
            this._jumpBtn.removeEventListener(MouseEvent.CLICK,this.onJumpOver);
            DisplayUtil.removeForParent(this._jumpBtn);
            this._jumpBtn = null;
         }
         this.animat = null;
         if(this.loader)
         {
            this.loader.destroy(true);
            this.loader = null;
         }
      }
      
      private function onIOErrorHandler(param1:IOErrorEvent) : void
      {
         this.isPlaying = false;
      }
      
      public function set isLoopBack(param1:Boolean) : void
      {
         this._isLoopBack = param1;
      }
      
      private function destory() : void
      {
         if(this.loader != null)
         {
            this.loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
            this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
            this.loader = null;
         }
         this.stopAnimat();
         this.animat = null;
      }
   }
}

