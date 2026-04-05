package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.LoadingType;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class StoryAnimationTask_2022_0 implements IStoryAnimation
   {
      
      private var _loader:UILoader;
      
      private var _mainMC:MovieClip;
      
      private var _jumpBtn:SimpleButton;
      
      private var mURL:Array;
      
      private var misPlay:Boolean;
      
      private var mMC:Array;
      
      protected var _background:Shape;
      
      protected var _offsetX:int;
      
      protected var _offsetY:int;
      
      public function StoryAnimationTask_2022_0()
      {
         super();
      }
      
      public function get isPlay() : Boolean
      {
         return this.misPlay;
      }
      
      public function set isPlay(param1:Boolean) : void
      {
         this.misPlay = param1;
      }
      
      private function loadAnimat() : void
      {
         var _loc1_:String = null;
         if(this.mURL.length != 0)
         {
            _loc1_ = this.mURL.shift();
            this._loader = new UILoader(ClientConfig.getCartoon(_loc1_),this.isPlay ? null : LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
            this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
            this._loader.load();
         }
         else
         {
            this.onFinish();
         }
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         var _loc2_:MovieClip = param1.uiloader.loader.content as MovieClip;
         if(_loc2_.totalFrames == 1)
         {
            _loc2_ = _loc2_.getChildAt(0) as MovieClip;
         }
         _loc2_.gotoAndStop(1);
         this.mMC.push(_loc2_);
         if(!this.isPlay)
         {
            this.startPlay();
         }
         if(this.mURL.length > 0)
         {
            this.loadAnimat();
         }
      }
      
      private function startPlay() : void
      {
         if(this.mMC.length == 0)
         {
            return;
         }
         DisplayUtil.removeForParent(this._mainMC);
         this._mainMC = this.mMC.shift();
         MainManager.closeOperate();
         this._offsetX = this._mainMC.x;
         this._offsetY = this._mainMC.y;
         if(this._background == null)
         {
            this._background = new Shape();
            this._background.graphics.beginFill(0);
            this._background.graphics.drawRect(0,0,LayerManager.MAX_WIDTH,LayerManager.MAX_HEIGHT);
            this._background.graphics.endFill();
         }
         LayerManager.topLevel.addChild(this._background);
         LayerManager.topLevel.addChild(this._mainMC);
         this._mainMC.gotoAndPlay(1);
         this._mainMC.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         if(this._jumpBtn == null)
         {
            this._jumpBtn = new ToolBar_JumpOverBtn();
            this._jumpBtn.addEventListener(MouseEvent.CLICK,this.onJumpOver);
            LayerManager.stage.addChild(this._jumpBtn);
            DisplayUtil.align(this._jumpBtn,null,AlignType.BOTTOM_RIGHT);
         }
         this.isPlay = true;
         StageResizeController.instance.register(this.layout);
         this.layout();
      }
      
      private function layout() : void
      {
         if(this._mainMC)
         {
            this._mainMC.x = (LayerManager.stageWidth - LayerManager.MIN_WIDTH) * 0.5 + this._offsetX;
            this._mainMC.y = (LayerManager.stageHeight - LayerManager.MIN_HEIGHT) * 0.5 + this._offsetY;
         }
         if(this._jumpBtn)
         {
            DisplayUtil.align(this._jumpBtn,null,AlignType.BOTTOM_RIGHT);
         }
      }
      
      private function onJumpOver(param1:MouseEvent) : void
      {
         this._mainMC.stop();
         this._mainMC.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.onFinish();
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this._mainMC.currentFrame == this._mainMC.totalFrames)
         {
            this._mainMC.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            if(this.mMC.length > 0)
            {
               this.startPlay();
            }
            else if(this.mURL.length == 0)
            {
               this.onFinish();
            }
            else
            {
               this.isPlay = false;
            }
         }
      }
      
      public function setParams(param1:String) : void
      {
         this.mURL = param1.split("|");
         this.mMC = [];
      }
      
      public function start() : void
      {
         this.onStart();
      }
      
      public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         this.loadAnimat();
      }
      
      public function onFinish() : void
      {
         DisplayUtil.removeForParent(this._jumpBtn);
         this._jumpBtn.removeEventListener(MouseEvent.CLICK,this.onJumpOver);
         DisplayUtil.removeForParent(this._mainMC);
         this.isPlay = false;
         this._jumpBtn = null;
         this._mainMC = null;
         MainManager.openOperate();
         StageResizeController.instance.unregister(this.layout);
         if(this._loader)
         {
            this._loader.destroy(true);
            this._loader = null;
         }
         if(this._background)
         {
            DisplayUtil.removeForParent(this._background);
            this._background = null;
         }
      }
   }
}

