package com.gfp.app.cartoon
{
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.LoadingType;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class PlantAnimatPlay extends EventDispatcher
   {
      
      private static var instance:PlantAnimatPlay = new PlantAnimatPlay();
      
      private var loader:UILoader;
      
      private var animat:MovieClip;
      
      public var offsetX:Number;
      
      public var offsetY:Number;
      
      public var isRoot:Boolean;
      
      public var id:uint;
      
      public var parentObj:DisplayObjectContainer;
      
      public var resort:Boolean;
      
      public function PlantAnimatPlay()
      {
         super();
      }
      
      public static function startAnimat(param1:String, param2:uint, param3:Boolean = false, param4:Number = 0, param5:Number = 0, param6:DisplayObjectContainer = null, param7:Boolean = false) : void
      {
         instance.resort = param7;
         instance.isRoot = param3;
         instance.offsetX = param4;
         instance.offsetY = param5;
         instance.id = param2;
         instance.parentObj = param6;
         instance.load(param1);
      }
      
      public static function addAnimatListener(param1:String, param2:Function) : void
      {
         instance.addEventListener(param1,param2);
      }
      
      public static function removeAnimatListener(param1:String, param2:Function) : void
      {
         instance.removeEventListener(param1,param2);
      }
      
      private function load(param1:String) : void
      {
         this.loader = new UILoader(ClientConfig.getCartoon(param1),LayerManager.stage,LoadingType.TITLE_AND_PERCENT,"正在加载动画");
         this.loader.closeEnabled = false;
         this.loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
         this.loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         this.animat = this.isRoot ? param1.uiloader.content as MovieClip : (param1.uiloader.content as MovieClip)["animat"];
         this.loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
         this.loader.close();
         this.loader = null;
         this.playAnimat();
      }
      
      private function playAnimat() : void
      {
         MainManager.closeOperate();
         if(this.animat == null)
         {
            return;
         }
         this.animat.addEventListener(Event.ENTER_FRAME,this.animatEnterFrame);
         this.animat.gotoAndPlay(1);
         dispatchEvent(new AnimatEvent(AnimatEvent.ANIMAT_START));
         if(this.parentObj)
         {
            this.parentObj.addChild(this.animat);
            if(this.resort)
            {
               DepthManager.swapDepthAll(this.parentObj);
            }
         }
         else
         {
            LayerManager.topLevel.addChild(this.animat);
         }
         if(this.offsetX != 0 || this.offsetX != 0)
         {
            this.animat.x = this.offsetX;
            this.animat.y = this.offsetY;
         }
         else
         {
            DisplayUtil.align(this.animat,null,AlignType.MIDDLE_CENTER);
         }
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
            dispatchEvent(new AnimatEvent(AnimatEvent.ANIMAT_END,instance.id));
         }
      }
      
      private function onIOErrorHandler(param1:IOErrorEvent) : void
      {
      }
      
      public function destory() : void
      {
         DisplayUtil.removeForParent(this.animat);
         this.animat = null;
         this.parentObj = null;
      }
   }
}

