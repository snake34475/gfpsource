package com.gfp.app.toolBar
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class TurnBackTaskIco
   {
      
      private static var _instance:TurnBackTaskIco;
      
      private static var _able:Boolean = false;
      
      private var _mainUI:MovieClip;
      
      public function TurnBackTaskIco()
      {
         super();
         this._mainUI = new UI_turnBackTaskIco();
         this.stopAim();
         TasksManager.addListener(TaskEvent.COMPLETE,this.onComplete);
      }
      
      public static function get instance() : TurnBackTaskIco
      {
         return _instance = _instance || new TurnBackTaskIco();
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      public function playAim() : void
      {
         var mc:MovieClip = null;
         var onEnteFrame:Function = null;
         onEnteFrame = function(param1:Event):void
         {
            if(mc.mc.currentFrame == mc.mc.totalFrames)
            {
               mc.removeEventListener(Event.ENTER_FRAME,onEnteFrame);
               mc.parent.removeChild(mc);
               mc = null;
               show();
            }
         };
         mc = new TurnBackTaskIcoAim();
         mc.addEventListener(Event.ENTER_FRAME,onEnteFrame);
         mc.x = 405;
         mc.y = 134.55;
         mc.mc.play();
         LayerManager.topLevel.addChild(mc);
      }
      
      public function stopAim() : void
      {
         if(!this._mainUI)
         {
            return;
         }
         this._mainUI.fire.visible = false;
         this._mainUI.ico.stop();
         this._mainUI.buttonMode = true;
      }
      
      private function onComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 2085 || param1.taskID == 2086 || param1.taskID == 2087 || param1.taskID == 2088 || param1.taskID == 2089)
         {
            this._mainUI.fire.visible = true;
            this._mainUI.ico.play();
         }
         if(param1.taskID == 2090)
         {
            this.destroy();
         }
      }
      
      public function setup(param1:TaskEvent = null) : void
      {
         if(TasksManager.isTaskProComplete(2090,0))
         {
            this.show();
         }
         else
         {
            this.hide();
         }
      }
      
      public function destroy() : void
      {
         this.hide();
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onComplete);
         this._mainUI = null;
         StageResizeController.instance.unregister(this.layout);
      }
      
      private function initEvent() : void
      {
         this._mainUI.addEventListener(MouseEvent.CLICK,this.openPanel);
         StageResizeController.instance.register(this.layout);
      }
      
      public function show() : void
      {
         if(this._mainUI)
         {
            LayerManager.toolUiLevel.addChild(this._mainUI);
            this.layout();
            this._mainUI.filters = [];
            this.initEvent();
         }
      }
      
      private function layout() : void
      {
         this._mainUI.x = LayerManager.stageWidth - 140;
         this._mainUI.y = LayerManager.stageHeight - 275;
      }
      
      public function hide() : void
      {
         if(this._mainUI)
         {
            this._mainUI.removeEventListener(MouseEvent.CLICK,this.openPanel);
            DisplayUtil.removeForParent(this._mainUI,false);
         }
      }
      
      private function onQuickKey() : void
      {
         this.openPanel(null);
      }
      
      private function openPanel(param1:MouseEvent) : void
      {
         if(MapManager.currentMap.info.mapType == MapType.TRADE)
         {
            AlertManager.showTradeMapUnavailableAlarm();
            return;
         }
         ModuleManager.turnModule(ClientConfig.getAppModule("TurnBackTaskPanel"),"正在加载...");
      }
   }
}

