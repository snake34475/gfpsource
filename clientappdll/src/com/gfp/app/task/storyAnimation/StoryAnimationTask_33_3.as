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
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.DisplayUtil;
   
   public class StoryAnimationTask_33_3 implements IStoryAnimation
   {
      
      private var _params:String;
      
      private var _mainMC:MovieClip;
      
      private var _flyOut:MovieClip;
      
      private var _flyIn:MovieClip;
      
      private var _loader:UILoader;
      
      private var _npc10063:SightModel;
      
      public function StoryAnimationTask_33_3()
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
         this._loader = new UILoader(ClientConfig.getCartoon("task33_3"),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         MainManager.closeOperate();
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._mainMC = param1.uiloader.loader.content as MovieClip;
         this._flyOut = this._mainMC["_flyOut"];
         this._flyIn = this._mainMC["_flyIn"];
         this._flyOut.gotoAndStop(1);
         this._flyIn.gotoAndStop(1);
         this.playFlyOut();
      }
      
      private function playFlyOut() : void
      {
         this._npc10063 = SightManager.getSightModel(10063);
         this._flyOut.x = this._npc10063.x - this._npc10063.width - 50;
         this._flyOut.y = this._npc10063.y - this._npc10063.height - 16;
         MapManager.currentMap.contentLevel.addChild(this._flyOut);
         this._npc10063.hide();
         this._flyOut.addEventListener(Event.ENTER_FRAME,this.onEnterFrame1);
         DepthManager.swapDepthAll(MapManager.currentMap.contentLevel);
         this._flyOut.play();
      }
      
      private function onEnterFrame1(param1:Event) : void
      {
         if(this._flyOut.currentFrame == this._flyOut.totalFrames)
         {
            this._npc10063.show();
            this._flyOut.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame1);
            DisplayUtil.removeForParent(this._flyOut);
            LayerManager.topLevel.addChild(this._flyIn);
            this._flyIn.addEventListener(Event.ENTER_FRAME,this.onEnterFrame2);
            this._flyIn.play();
         }
      }
      
      private function onEnterFrame2(param1:Event) : void
      {
         if(this._flyIn.currentFrame == this._flyIn.totalFrames)
         {
            if(this._flyIn)
            {
               this._flyIn.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame2);
               DisplayUtil.removeForParent(this._flyIn);
               this._npc10063 = null;
               this._flyOut = null;
               this._flyIn = null;
               this._mainMC = null;
            }
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
         NpcDialogController.showForNpc(10063);
         if(this._loader)
         {
            this._loader.destroy(true);
            this._loader = null;
         }
      }
   }
}

