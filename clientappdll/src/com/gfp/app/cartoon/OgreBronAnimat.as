package com.gfp.app.cartoon
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.LoadingType;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class OgreBronAnimat
   {
      
      private static var _instance:OgreBronAnimat;
      
      private var _x:int;
      
      private var _y:int;
      
      private var loader:UILoader;
      
      public var animat:MovieClip;
      
      public function OgreBronAnimat()
      {
         super();
      }
      
      public static function get instance() : OgreBronAnimat
      {
         if(_instance == null)
         {
            _instance = new OgreBronAnimat();
         }
         return _instance;
      }
      
      public function playBronAnimat(param1:int, param2:int = 0, param3:int = 0) : void
      {
         this.loadMC(param1);
         this._x = param2;
         this._y = param3;
      }
      
      private function loadMC(param1:int) : void
      {
         this.loader = new UILoader(ClientConfig.getCartoon("orgeBron_" + param1),LayerManager.stage,LoadingType.TITLE_AND_PERCENT,"正在技能动画");
         this.loader.closeEnabled = false;
         this.loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
         this.loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         this.animat = param1.uiloader.content as MovieClip;
         this.animat.x = this._x;
         this.animat.y = this._y;
         this.loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
         this.loader.close();
         this.loader = null;
         this.playAnimat();
      }
      
      private function playAnimat() : void
      {
         MainManager.closeOperate();
         this.animat.addEventListener(Event.ENTER_FRAME,this.animatEnterFrame);
         this.animat.gotoAndPlay(1);
         LayerManager.topLevel.addChild(this.animat);
      }
      
      private function animatEnterFrame(param1:Event) : void
      {
         if(this.animat == null)
         {
            return;
         }
         if(this.animat.currentFrame == this.animat.totalFrames)
         {
            this.animat.removeEventListener(Event.ENTER_FRAME,this.animatEnterFrame);
            MainManager.openOperate();
            this.animat.stop();
            DisplayUtil.removeForParent(this.animat);
         }
      }
      
      private function onIOErrorHandler(param1:IOErrorEvent) : void
      {
      }
      
      public function destory() : void
      {
         DisplayUtil.removeForParent(this.animat);
         this.animat = null;
      }
   }
}

