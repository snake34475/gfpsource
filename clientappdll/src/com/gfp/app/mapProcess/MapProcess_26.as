package com.gfp.app.mapProcess
{
   import com.gfp.core.action.mouse.MouseProcess;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.LoadingType;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.algo.AStar;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_26 extends BaseMapProcess
   {
      
      private var _joeAnimation:MovieClip;
      
      private var _loader:UILoader;
      
      private var _task1325MC:MovieClip;
      
      private var _npc10102:SightModel;
      
      private var _npc10109:SightModel;
      
      public function MapProcess_26()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.initNPC();
         this.addTaskEventListener();
      }
      
      private function initNPC() : void
      {
         this._npc10102 = SightManager.getSightModel(10102);
         this._npc10109 = SightManager.getSightModel(10109);
         this._npc10109.hide();
         if(TasksManager.isAccepted(36))
         {
            this._npc10102.hide();
            this._npc10109.show();
            this._npc10109.addEventListener(MouseEvent.CLICK,this.onNpc10109Click);
         }
      }
      
      private function addTaskEventListener() : void
      {
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 36)
         {
            this._npc10102.hide();
            this._npc10109.show();
            this._npc10109.addEventListener(MouseEvent.CLICK,this.onNpc10109Click);
         }
         if(param1.taskID == 60)
         {
            AStar.instance.maxTry = 9999;
            MouseProcess.execWalk(MainManager.actorModel,new Point(1044,1590));
            AStar.instance.maxTry = 2000;
         }
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 58)
         {
            if(param1.proID == 4)
            {
               MouseProcess.execWalk(MainManager.actorModel,new Point(174,869));
            }
         }
         if(param1.taskID == 61)
         {
            if(param1.proID == 2)
            {
               CityMap.instance.changeMap(27,0,1,new Point(1466,544));
            }
         }
      }
      
      private function onNpc10109Click(param1:MouseEvent) : void
      {
         if(TasksManager.isReady(36))
         {
            TasksManager.taskComplete(36);
         }
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 36)
         {
            if(this._joeAnimation != null)
            {
               return;
            }
            this._joeAnimation = _mapModel.libManager.getMovieClip("Joe") as MovieClip;
            this._joeAnimation["roleIndex"] = MainManager.actorInfo.roleType;
            this._joeAnimation.x = 503;
            this._joeAnimation.y = 1204;
            _mapModel.contentLevel.addChild(this._joeAnimation);
            this._joeAnimation.addEventListener(Event.ENTER_FRAME,this.onJoeAnimationPlay);
            this._npc10109.hide();
            MainManager.closeOperate();
            _mapModel.camera.scroll(100,970);
         }
         if(param1.taskID == 58)
         {
            TasksManager.accept(59);
         }
         if(param1.taskID == 60)
         {
            TasksManager.accept(61);
         }
         if(param1.taskID == 61)
         {
            TasksManager.accept(62);
         }
         if(param1.taskID == 1325)
         {
            this.playTaskAnimat1325();
         }
      }
      
      private function playTaskAnimat1325() : void
      {
         this._loader = new UILoader(ClientConfig.getCartoon("task1325"),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         MainManager.closeOperate();
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         var _loc2_:Sprite = param1.uiloader.loader.content as Sprite;
         this._task1325MC = _loc2_["mc"];
         this._task1325MC.y = -6;
         this._task1325MC.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         LayerManager.topLevel.addChild(this._task1325MC);
         this._task1325MC.gotoAndPlay(1);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this._task1325MC.currentFrame == this._task1325MC.totalFrames)
         {
            this._task1325MC.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            DisplayUtil.removeForParent(this._task1325MC);
            MainManager.openOperate();
         }
      }
      
      private function onJoeAnimationPlay(param1:Event) : void
      {
         _mapModel.contentLevel.addChild(this._joeAnimation);
         if(this._joeAnimation.currentFrame == this._joeAnimation.totalFrames)
         {
            this._joeAnimation.removeEventListener(Event.ENTER_FRAME,this.onJoeAnimationPlay);
            DisplayUtil.removeForParent(this._joeAnimation);
            this._joeAnimation = null;
            MainManager.openOperate();
         }
      }
      
      private function removeTaskEventListener() : void
      {
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      override public function destroy() : void
      {
         if(this._loader)
         {
            this._loader.destroy();
            this._loader = null;
         }
         if(this._task1325MC)
         {
            this._task1325MC.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this._task1325MC = null;
         }
         this.removeTaskEventListener();
      }
   }
}

