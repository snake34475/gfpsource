package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.StageResizeController;
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
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.Tick;
   
   public class StoryAnimationTask_34_1 implements IStoryAnimation
   {
      
      private var _mainMC:Sprite;
      
      private var _loader:UILoader;
      
      private var _grandpa:MovieClip;
      
      private var _npc10001:SightModel;
      
      private var _totalFrame:int;
      
      private const CAMERA_TARGET_X:Number = 200;
      
      private var _cameraX:Number;
      
      private var _cameraY:Number;
      
      public function StoryAnimationTask_34_1()
      {
         super();
      }
      
      public function setParams(param1:String) : void
      {
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
         this._loader = new UILoader(ClientConfig.getCartoon("task34_1"),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         MainManager.closeOperate();
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._mainMC = param1.uiloader.loader.content as Sprite;
         this._grandpa = this._mainMC["_grandpa"];
         this._grandpa.gotoAndStop(1);
         this._totalFrame = this._grandpa.totalFrames;
         this._grandpa.addEventListener(Event.ENTER_FRAME,this.onEnterFrame1);
         this._npc10001 = SightManager.getSightModel(10001);
         this._grandpa.x = this._npc10001.x - this._npc10001.width - 2;
         this._grandpa.y = this._npc10001.y - this._npc10001.height + 5;
         this.scrollMap();
      }
      
      private function scrollMap() : void
      {
         this._cameraX = MapManager.currentMap.camera.viewArea.x;
         this._cameraY = MapManager.currentMap.camera.viewArea.y;
         Tick.instance.addCallback(this.onTick);
      }
      
      private function onTick(param1:int) : void
      {
         if(this.CAMERA_TARGET_X - this._cameraX > 2)
         {
            this._cameraX += (this.CAMERA_TARGET_X - this._cameraX) * 0.1;
            MapManager.currentMap.camera.scroll(this._cameraX,this._cameraY);
         }
         else
         {
            Tick.instance.removeCallback(this.onTick);
            MapManager.currentMap.contentLevel.addChild(this._grandpa);
            this._npc10001.hide();
            this._grandpa.play();
         }
      }
      
      private function onEnterFrame1(param1:Event) : void
      {
         if(this._grandpa.currentFrame == 360)
         {
            this._grandpa.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame1);
            this._npc10001.show();
            this._grandpa.gotoAndStop(361);
            DisplayUtil.removeForParent(this._grandpa);
            LayerManager.topLevel.addChild(this._grandpa);
            this._grandpa.addEventListener(Event.ENTER_FRAME,this.onEnterFrame2);
            this._grandpa.play();
            StageResizeController.instance.register(this.layout);
            this.layout();
         }
      }
      
      private function layout() : void
      {
         if(this._grandpa)
         {
            this._grandpa.x = (LayerManager.stageWidth - 960) * 0.5 + 847.6;
            this._grandpa.y = (LayerManager.stageHeight - 560) * 0.5 + 263.7;
         }
      }
      
      private function onEnterFrame2(param1:Event) : void
      {
         if(this._grandpa.currentFrame == this._totalFrame)
         {
            if(this._mainMC)
            {
               this._grandpa.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame2);
               DisplayUtil.removeForParent(this._grandpa);
               this._npc10001 = null;
               this._grandpa = null;
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
         NpcDialogController.showForNpc(10001);
         StageResizeController.instance.unregister(this.layout);
      }
   }
}

