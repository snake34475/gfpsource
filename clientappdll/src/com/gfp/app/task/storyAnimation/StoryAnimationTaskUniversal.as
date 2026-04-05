package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.LoadingType;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class StoryAnimationTaskUniversal
   {
      
      private var _params:String;
      
      private var _mainMC:MovieClip;
      
      private var _loader:UILoader;
      
      private var swfUrl:String;
      
      private var isCompleteTask:Boolean;
      
      private var showForNpcID:uint;
      
      private var mapID:uint;
      
      public function StoryAnimationTaskUniversal()
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
         this._loader = new UILoader(ClientConfig.getCartoon("task2067_1"),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         MainManager.closeOperate();
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._mainMC = param1.uiloader.loader.content as MovieClip;
         this._mainMC.addEventListener(Event.ENTER_FRAME,this.onEnterFrame1);
         DisplayUtil.align(this._mainMC,null,AlignType.MIDDLE_CENTER);
         LayerManager.topLevel.addChild(this._mainMC);
         this._mainMC.mc.gotoAndPlay(1);
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
      
      public function onFinish() : void
      {
         DepthManager.swapDepthAll(MapManager.currentMap.contentLevel);
         MainManager.openOperate();
         NpcDialogController.showForNpc(10192);
         if(this._loader)
         {
            this._loader.destroy(true);
            this._loader = null;
         }
      }
   }
}

