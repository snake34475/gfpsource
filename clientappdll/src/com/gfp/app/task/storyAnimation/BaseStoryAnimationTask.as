package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.LoadingType;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class BaseStoryAnimationTask implements IStoryAnimation
   {
      
      protected var params:String;
      
      protected var tranParams:String;
      
      protected var mcSrc:String;
      
      protected var playFrame:int = 1;
      
      protected var autoCompleteTaskId:int;
      
      protected var isStop:Boolean = false;
      
      protected var needBack:Boolean = true;
      
      protected var customData:int = 0;
      
      private var _loader:UILoader;
      
      protected var _storyMc:MovieClip;
      
      protected var _background:Shape;
      
      protected var _offsetX:int;
      
      protected var _offsetY:int;
      
      protected var _mcWidth:int;
      
      protected var _mcHeight:int;
      
      protected var _defalutPos:Array = [];
      
      public function BaseStoryAnimationTask()
      {
         super();
      }
      
      public function setParams(param1:String) : void
      {
         var _loc4_:int = 0;
         if(!param1)
         {
            return;
         }
         var _loc2_:Array = param1.split("|");
         var _loc3_:int = int(_loc2_.length);
         if(_loc3_ > 1)
         {
            this.params = _loc2_[0];
            this.tranParams = _loc2_[1];
            if(this.tranParams)
            {
               this.tranParams = this.tranParams.replace(/;/g,",");
            }
            if(_loc3_ > 2)
            {
               this.mcSrc = _loc2_[2];
               if(this.mcSrc == "false")
               {
                  this.mcSrc = "";
               }
               if(_loc3_ > 3)
               {
                  this.playFrame = parseInt(_loc2_[3]);
               }
               if(_loc3_ > 4)
               {
                  _loc4_ = parseInt(_loc2_[4]);
                  if(_loc4_ != 0)
                  {
                     this.autoCompleteTaskId = _loc4_;
                  }
               }
               if(_loc3_ > 5)
               {
                  this.isStop = parseInt(_loc2_[5]) == 1;
               }
               if(_loc3_ > 6)
               {
                  this.needBack = _loc2_[6] == "";
               }
               if(_loc3_ > 7)
               {
                  if(_loc2_[7])
                  {
                     this.customData = parseInt(_loc2_[7]);
                  }
               }
               if(_loc3_ > 8)
               {
                  this._mcWidth = parseInt(_loc2_[8]);
                  this._mcHeight = parseInt(_loc2_[9]);
               }
            }
         }
         else
         {
            this.params = param1;
         }
      }
      
      public function start() : void
      {
         this.onStart();
      }
      
      public function onStart() : void
      {
         this.loadAnimation(this.params);
      }
      
      public function onFinish() : void
      {
         if(this._storyMc)
         {
            this._storyMc.stop();
            DisplayUtil.removeForParent(this._storyMc);
            this._storyMc = null;
         }
         MainManager.openOperate();
         StageResizeController.instance.unregister(this.layout);
         if(this._background)
         {
            DisplayUtil.removeForParent(this._background);
            this._background = null;
         }
         if(this._loader)
         {
            this._loader.destroy(true);
            this._loader = null;
         }
      }
      
      protected function onComplete() : void
      {
         if(this.isStop)
         {
            if(this._storyMc)
            {
               this._storyMc.removeEventListener(MouseEvent.CLICK,this.storyMcClickHandler);
            }
         }
         if(this.tranParams)
         {
            if(MainManager.actorModel)
            {
               CityMap.instance.tranChangeMapByStr(this.tranParams);
            }
         }
         if(this.autoCompleteTaskId > 0)
         {
            TasksManager.taskComplete(this.autoCompleteTaskId);
         }
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         var _loc2_:MovieClip = param1.uiloader.loader.content as MovieClip;
         this.handleLoadMc(_loc2_);
         this.updateStoryMc();
         if(this.isStop)
         {
            this._storyMc.addEventListener(MouseEvent.CLICK,this.storyMcClickHandler);
         }
      }
      
      private function storyMcClickHandler(param1:MouseEvent) : void
      {
         this._storyMc.play();
      }
      
      protected function get getMcStr() : String
      {
         return this.mcSrc;
      }
      
      protected function handleLoadMc(param1:MovieClip) : void
      {
         MainManager.closeOperate();
         if(this.getMcStr)
         {
            this._storyMc = param1[this.getMcStr];
         }
         else
         {
            this._storyMc = param1;
         }
         if(this._background == null && this.needBack)
         {
            this._background = new Shape();
         }
         if(this._background)
         {
            LayerManager.topLevel.addChild(this._background);
         }
         this.addStoryMc();
         if(this._storyMc)
         {
            this._offsetX = this._storyMc.x;
            this._offsetY = this._storyMc.y;
            StageResizeController.instance.register(this.layout);
            this.layout();
         }
      }
      
      protected function layout() : void
      {
         if(this._defalutPos.indexOf(this.params) == -1)
         {
            if(this._mcWidth != 0 && this._mcHeight != 0)
            {
               this._storyMc.x = (LayerManager.stageWidth - this._mcWidth) * 0.5 + this._offsetX;
               this._storyMc.y = (LayerManager.stageHeight - this._mcHeight) * 0.5 + this._offsetY;
            }
            else if(Boolean(this._storyMc) && (Boolean(this._storyMc.width < LayerManager.MAX_WIDTH || this._storyMc.height < LayerManager.MAX_HEIGHT) || Boolean(!this.isStop && this.getMcStr)))
            {
               this._storyMc.x = (LayerManager.stageWidth - LayerManager.MIN_WIDTH) * 0.5 + this._offsetX;
               this._storyMc.y = (LayerManager.stageHeight - LayerManager.MIN_HEIGHT) * 0.5 + this._offsetY;
            }
         }
         this.drawBackgroud();
      }
      
      protected function drawBackgroud() : void
      {
         var _loc1_:Graphics = null;
         if(this._background)
         {
            _loc1_ = this._background.graphics;
            _loc1_.clear();
            _loc1_.beginFill(0);
            _loc1_.drawRect(0,0,LayerManager.stageWidth,LayerManager.stageHeight - 550 >> 1);
            _loc1_.drawRect(0,550 + (LayerManager.stageHeight - 550 >> 1),LayerManager.stageWidth,LayerManager.stageHeight - 550 >> 1);
            _loc1_.drawRect(0,LayerManager.stageHeight - 550 >> 1,LayerManager.stageWidth - 950 >> 1,550);
            _loc1_.drawRect(950 + (LayerManager.stageWidth - 950 >> 1),LayerManager.stageHeight - 550 >> 1,LayerManager.stageWidth - 950 >> 1,550);
            _loc1_.endFill();
         }
      }
      
      protected function addStoryMc() : void
      {
         if(this._storyMc)
         {
            LayerManager.topLevel.addChild(this._storyMc);
         }
      }
      
      protected function updateStoryMc() : void
      {
         if(this._storyMc)
         {
            if(!this.isStop)
            {
               this._storyMc.gotoAndPlay(this.playFrame);
            }
            else
            {
               this._storyMc.gotoAndStop(this.playFrame);
            }
         }
      }
      
      protected function loadAnimation(param1:String) : void
      {
         if(param1)
         {
            this._loader = new UILoader(ClientConfig.getCartoon(param1),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
            this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
            this._loader.load();
         }
      }
   }
}

