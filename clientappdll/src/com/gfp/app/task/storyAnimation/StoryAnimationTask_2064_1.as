package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
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
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class StoryAnimationTask_2064_1 implements IStoryAnimation
   {
      
      private var _params:String;
      
      private var _mainMC:MovieClip;
      
      private var _loader:UILoader;
      
      public function StoryAnimationTask_2064_1()
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
      }
      
      public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         this.loadAnimat();
      }
      
      private function loadAnimat() : void
      {
         this._loader = new UILoader(ClientConfig.getCartoon("task2064_1"),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         var onComplete:Function = null;
         var ev:UILoadEvent = param1;
         onComplete = function():void
         {
            DisplayUtil.removeForParent(_mainMC);
            onFinish();
         };
         var npc:SightModel = SightManager.getSightModel(10524);
         npc.visible = false;
         MainManager.closeOperate();
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._mainMC = ev.uiloader.loader.content as MovieClip;
         DisplayUtil.align(this._mainMC,null,AlignType.MIDDLE_CENTER);
         LayerManager.topLevel.addChild(this._mainMC);
         this._mainMC.x = npc.x;
         this._mainMC.y = npc.y - 100;
         this._mainMC.gotoAndPlay(1);
         TweenLite.to(this._mainMC,2,{
            "x":-200,
            "y":200,
            "ease":Linear.easeNone,
            "onComplete":onComplete
         });
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
         NpcDialogController.showForNpc(10524);
         if(this._loader)
         {
            this._loader.destroy(true);
            this._loader = null;
         }
      }
   }
}

