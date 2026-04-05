package com.gfp.app.cartoon
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.LoadingType;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class SceneOpenAnimat
   {
      
      private static var _instance:SceneOpenAnimat;
      
      private const checkLevelPoint:Array = [8,14,23,29,31,33,37,40,44,50,54];
      
      private var loader:UILoader;
      
      private var animat:MovieClip;
      
      public function SceneOpenAnimat()
      {
         super();
      }
      
      private static function get instance() : SceneOpenAnimat
      {
         if(_instance == null)
         {
            _instance = new SceneOpenAnimat();
         }
         return _instance;
      }
      
      public static function startAnimatByUserLv(param1:uint) : void
      {
         instance.startAnimatByUserLv(param1);
      }
      
      public function startAnimatByUserLv(param1:uint) : void
      {
         this.load(this.calculateAnimatID(param1));
      }
      
      private function calculateAnimatID(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         for each(_loc2_ in this.checkLevelPoint)
         {
            if(param1 + 3 == _loc2_)
            {
               return _loc2_;
            }
         }
         return 0;
      }
      
      private function load(param1:int) : void
      {
         if(param1 == 0)
         {
            return;
         }
         this.loader = new UILoader(ClientConfig.getCartoon(AnimatHeadString.SCENCE + param1),LayerManager.stage,LoadingType.TITLE_AND_PERCENT,"正在加载动画");
         this.loader.closeEnabled = false;
         this.loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
         this.loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         this.animat = param1.uiloader.content as MovieClip;
         this.loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
         this.loader.close();
         this.loader = null;
         this.playAnimat();
      }
      
      private function playAnimat() : void
      {
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

