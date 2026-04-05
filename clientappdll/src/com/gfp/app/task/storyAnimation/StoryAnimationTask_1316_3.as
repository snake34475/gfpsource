package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.LoadingType;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class StoryAnimationTask_1316_3 extends EventDispatcher
   {
      
      private var _loader:UILoader;
      
      private var _mainMC:MovieClip;
      
      private var _dailog:MovieClip;
      
      public function StoryAnimationTask_1316_3()
      {
         super();
      }
      
      private function loadAnimat() : void
      {
         this._loader = new UILoader(ClientConfig.getCartoon("task1316_3"),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         MainManager.closeOperate();
         var _loc2_:SightModel = SightManager.getSightModel(10124);
         _loc2_.hide();
         _loc2_ = SightManager.getSightModel(10132);
         _loc2_.hide();
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         var _loc3_:Sprite = param1.uiloader.loader.content as Sprite;
         this._mainMC = _loc3_["mc"];
         this._dailog = _loc3_["dialog"];
         this._mainMC.x = 40;
         this._mainMC.y = 60;
         MapManager.currentMap.contentLevel.addChild(this._mainMC);
         this._mainMC.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._mainMC.gotoAndPlay(1);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this._mainMC.currentFrame == this._mainMC.totalFrames)
         {
            if(this._mainMC)
            {
               this._mainMC.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
               this._mainMC.stop();
            }
            this.showDialog();
         }
      }
      
      private function showDialog() : void
      {
         this._dailog.x = 160;
         this._dailog.y = 370;
         LayerManager.topLevel.addChild(this._dailog);
         this._dailog.gotoAndStop(1);
         this._dailog.addEventListener(MouseEvent.CLICK,this.onNext);
      }
      
      private function onNext(param1:MouseEvent) : void
      {
         if(this._dailog.currentFrame != this._dailog.totalFrames)
         {
            this._dailog.gotoAndStop(this._dailog.currentFrame + 1);
         }
         else
         {
            this._dailog.removeEventListener(MouseEvent.CLICK,this.onNext);
            this.onFinish();
         }
      }
      
      public function start() : void
      {
         this.onStart();
      }
      
      public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_SIMPLEACTION,"TaskAnimationPlayed_1316_3");
         this.loadAnimat();
      }
      
      public function onFinish() : void
      {
         if(this._mainMC)
         {
            DisplayUtil.removeForParent(this._mainMC);
            this._mainMC = null;
         }
         if(this._dailog)
         {
            DisplayUtil.removeForParent(this._dailog);
            this._dailog = null;
         }
         if(this._loader)
         {
            this._loader.destroy(true);
            this._loader = null;
         }
         var _loc1_:SightModel = SightManager.getSightModel(10124);
         _loc1_.show();
         _loc1_ = SightManager.getSightModel(10132);
         _loc1_.show();
         MainManager.openOperate();
      }
   }
}

