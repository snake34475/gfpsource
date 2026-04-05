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
   import flash.events.Event;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.DisplayUtil;
   
   public class StoryAnimationTask_2086_1 implements IStoryAnimation
   {
      
      private var _params:String;
      
      private var _mainMC:MovieClip;
      
      private var _loader:UILoader;
      
      private var npc10002:SightModel;
      
      public function StoryAnimationTask_2086_1()
      {
         super();
      }
      
      public function setParams(param1:String) : void
      {
         this._params = param1;
      }
      
      public function start() : void
      {
         this.onStart();
         this.npc10002 = SightManager.getSightModel(10002);
      }
      
      public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         this.loadAnimat();
      }
      
      private function loadAnimat() : void
      {
         this._loader = new UILoader(ClientConfig.getCartoon("task2086_1"),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         MainManager.closeOperate();
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._mainMC = param1.uiloader.loader.content as MovieClip;
         this._mainMC.addEventListener(Event.ENTER_FRAME,this.onEnterFrame1);
         this.npc10002.parent.addChild(this._mainMC);
         this.npc10002.hide();
         this._mainMC.x = this.npc10002.x;
         this._mainMC.y = this.npc10002.y;
         this._mainMC.gotoAndPlay(1);
      }
      
      private function onEnterFrame1(param1:Event) : void
      {
         if(this._mainMC.mc.currentFrame == this._mainMC.mc.totalFrames)
         {
            this._mainMC.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame1);
            DisplayUtil.removeForParent(this._mainMC);
            this.onFinish();
         }
      }
      
      private function destroyLoader() : void
      {
         this._loader.destroy(true);
         this._loader = null;
      }
      
      public function onFinish() : void
      {
         DepthManager.swapDepthAll(MapManager.currentMap.contentLevel);
         MainManager.openOperate();
         this.npc10002.show();
         this.npc10002 = null;
         this.destroyLoader();
         TasksManager.taskComplete(2086);
      }
   }
}

