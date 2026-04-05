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
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class AnimationHelper
   {
      
      private var id:String;
      
      private var callBack:Function;
      
      private var mcName:String;
      
      private var _loader:UILoader;
      
      protected var _storyMc:MovieClip;
      
      private var _x:int = -1;
      
      private var _y:int = -1;
      
      public function AnimationHelper()
      {
         super();
      }
      
      public function play(param1:String, param2:Function = null, param3:String = "", param4:int = -1, param5:int = -1) : void
      {
         this.id = param1;
         this.callBack = param2;
         this.mcName = param3;
         this._x = param4;
         this._y = param5;
         this._loader = new UILoader(ClientConfig.getCartoon(param1),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         var _loc2_:MovieClip = param1.uiloader.loader.content as MovieClip;
         this.handleLoadMc(_loc2_);
         if(this._x != -1 && this._y != -1)
         {
            this._storyMc.x = this._x;
            this._storyMc.y = this._y;
         }
         else
         {
            DisplayUtil.align(this._storyMc,null,AlignType.MIDDLE_CENTER);
         }
         this._storyMc.gotoAndPlay(1);
      }
      
      protected function handleLoadMc(param1:MovieClip) : void
      {
         MainManager.closeOperate();
         if(this.mcName)
         {
            this._storyMc = param1[this.mcName];
         }
         else
         {
            this._storyMc = param1;
         }
         this.addStoryMc();
         this._storyMc.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      protected function addStoryMc() : void
      {
         if(this._storyMc)
         {
            LayerManager.topLevel.addChild(this._storyMc);
         }
         else
         {
            this.onFinish();
         }
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
         if(param1.currentTarget.currentFrame == param1.currentTarget.totalFrames)
         {
            param1.currentTarget.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.onFinish();
         }
      }
      
      public function onFinish() : void
      {
         if(this._storyMc)
         {
            this._storyMc.stop();
            DisplayUtil.removeForParent(this._storyMc);
            this._storyMc = null;
         }
         if(this._loader)
         {
            this._loader.destroy(true);
         }
         MainManager.openOperate();
         if(this.callBack != null)
         {
            this.callBack();
         }
      }
   }
}

