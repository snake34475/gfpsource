package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.LoadingType;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.utils.DisplayUtil;
   
   public class StoryAnimationTask_1330_0
   {
      
      private var _mainMC:MovieClip;
      
      private var _loader:UILoader;
      
      public function StoryAnimationTask_1330_0()
      {
         super();
      }
      
      public function start() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_MAPCOLLECT,"PigTurnToMonster");
         this.loadAnimat();
      }
      
      private function loadAnimat() : void
      {
         this._loader = new UILoader(ClientConfig.getCartoon("task1330_0_" + MainManager.actorInfo.roleType),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         MainManager.closeOperate();
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._mainMC = param1.uiloader.loader.content as MovieClip;
         this._mainMC.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         LayerManager.topLevel.addChild(this._mainMC);
         this._mainMC.gotoAndPlay(1);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this._mainMC.currentFrame == this._mainMC.totalFrames)
         {
            this._mainMC.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            DisplayUtil.removeForParent(this._mainMC);
            this.onFinish();
         }
      }
      
      private function destroyLoader() : void
      {
         this._loader.destroy();
         this._loader = null;
      }
      
      private function onFinish() : void
      {
         this._mainMC = null;
         MainManager.openOperate();
      }
   }
}

