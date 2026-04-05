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
   import flash.events.Event;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class StoryAnimationTask_2080_2 implements IStoryAnimation
   {
      
      private var _params:String;
      
      private var _mainMC:MovieClip;
      
      private var _loader:UILoader;
      
      private var npc10527:SightModel;
      
      public function StoryAnimationTask_2080_2()
      {
         super();
      }
      
      public function setParams(param1:String) : void
      {
         this._params = param1;
      }
      
      public function start() : void
      {
         this.npc10527 = SightManager.getSightModel(10527);
         this.onStart();
      }
      
      public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         this.loadAnimat();
      }
      
      private function loadAnimat() : void
      {
         this._loader = new UILoader(ClientConfig.getCartoon("task2080_2"),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         var complete:Function = null;
         var ev:UILoadEvent = param1;
         complete = function():void
         {
            onFinish();
            DisplayUtil.removeForParent(_mainMC);
            TweenLite.killTweensOf(_mainMC);
         };
         MainManager.closeOperate();
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._mainMC = ev.uiloader.loader.content as MovieClip;
         DisplayUtil.align(this._mainMC,null,AlignType.MIDDLE_CENTER);
         this._mainMC.y -= 60;
         this.npc10527.parent.addChild(this._mainMC);
         this._mainMC.x = this.npc10527.x;
         this._mainMC.y = this.npc10527.y;
         this._mainMC.mc.gotoAndPlay(1);
         this.npc10527.hide();
         TweenLite.to(this._mainMC,1,{
            "x":this._mainMC.x + 600,
            "ease":Linear.easeNone,
            "onComplete":complete
         });
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
         this._loader.destroy();
         this._loader = null;
      }
      
      public function onFinish() : void
      {
         DepthManager.swapDepthAll(MapManager.currentMap.contentLevel);
         MainManager.openOperate();
         NpcDialogController.showForNpc(10533);
         if(this._loader)
         {
            this._loader.destroy(true);
            this._loader = null;
         }
      }
   }
}

