package com.gfp.app.systems
{
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.SampleDataEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.bean.BaseBean;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class SysActivate extends BaseBean
   {
      
      private var _ed:EventDispatcher;
      
      private var _mark:Sprite;
      
      private var _ui:MovieClip;
      
      private var _frameTotal:int = 5;
      
      private var _curFrame:int = 1;
      
      private var _flag:Boolean = true;
      
      private var _oldFrame:int = 1;
      
      private var _isActive:Boolean = true;
      
      private var _laterDestoryTimer:int;
      
      public var snd:Sound = new Sound();
      
      public var sndCh:SoundChannel;
      
      public function SysActivate()
      {
         super();
      }
      
      override public function start() : void
      {
         this._ed = new EventDispatcher();
         this._ed.addEventListener(Event.ACTIVATE,this.onActivate);
         this._ed.addEventListener(Event.DEACTIVATE,this.onDeactivate);
         StageResizeController.instance.register(this.layout);
         finish();
         this.snd.addEventListener(SampleDataEvent.SAMPLE_DATA,this.onSampleDataHandler,false,0,true);
         this.sndCh = this.snd.play();
      }
      
      public function onSampleDataHandler(param1:SampleDataEvent) : void
      {
         param1.data.position = param1.data.length = 4096 * 4;
      }
      
      private function onActivate(param1:Event) : void
      {
         this.startDestroy();
         this._isActive = true;
         SwfCache.cancel(ClientConfig.getSubUI("active"),this.onIconLoaded);
         DisplayUtil.removeForParent(this._mark,false);
      }
      
      private function startDestroy() : void
      {
         clearTimeout(this._laterDestoryTimer);
         this._laterDestoryTimer = setTimeout(function():void
         {
            clearTimeout(_laterDestoryTimer);
            _mark = null;
            DisplayUtil.removeForParent(_ui);
            _ui = null;
         },10 * 1000);
      }
      
      private function onDeactivate(param1:Event) : void
      {
         clearTimeout(this._laterDestoryTimer);
         this._isActive = false;
         if(this._mark == null)
         {
            this._mark = new Sprite();
            this._mark.graphics.beginFill(0,0.2);
            this._mark.graphics.drawRect(0,0,LayerManager.MAX_WIDTH,LayerManager.MAX_HEIGHT);
            this._mark.graphics.endFill();
            this._mark.cacheAsBitmap = true;
            this._mark.mouseChildren = false;
            this._mark.mouseEnabled = false;
         }
         LayerManager.stage.addChild(this._mark);
         if(this._ui == null)
         {
            SwfCache.getSwfInfo(ClientConfig.getSubUI("active"),this.onIconLoaded);
         }
         if(this._ui)
         {
            ++this._curFrame;
            if(this._curFrame > this._frameTotal)
            {
               this._curFrame = this._oldFrame;
            }
            this._ui.gotoAndStop(this._curFrame);
         }
      }
      
      private function onIconLoaded(param1:SwfInfo) : void
      {
         if(this._ui == null)
         {
            this._ui = param1.content as MovieClip;
            this._ui.stop();
            this._frameTotal = this._ui.totalFrames;
            this._mark.addChild(this._ui);
            DisplayUtil.align(this._ui,null,AlignType.MIDDLE_CENTER);
         }
      }
      
      private function layout() : void
      {
         if(this._ui)
         {
            DisplayUtil.align(this._ui,null,AlignType.MIDDLE_CENTER);
         }
      }
   }
}

