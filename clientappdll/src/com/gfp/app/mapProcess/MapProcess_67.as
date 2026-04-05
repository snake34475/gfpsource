package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.ui.UILoader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import org.taomee.utils.Utils;
   
   public class MapProcess_67 extends MapProcessAnimat
   {
      
      private var npc10534:SightModel;
      
      private var turnBackTaskCircle:MovieClip;
      
      private var stoveMc:SimpleButton;
      
      public function MapProcess_67()
      {
         _mangoType = 1;
         super();
      }
      
      override protected function init() : void
      {
         _mangoType = 1;
         if(TasksManager.isProcess(2080,1))
         {
            NpcDialogController.showForNpc(10527);
         }
         this.npc10534 = SightManager.getSightModel(10534);
         if(TasksManager.isCompleted(2081))
         {
            this.npc10534.visible = false;
         }
         TasksManager.addListener(TaskEvent.COMPLETE,this.onComplegte);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onProComplegte);
         TasksManager.addListener(TaskEvent.ACCEPT,this.onAccept);
         if(TasksManager.isAcceptable(2079))
         {
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         }
         if(TasksManager.isAcceptable(2080))
         {
            TasksManager.accept(2080);
         }
         this.addTurnBackTaskCircle();
         this.addStove();
      }
      
      private function addStove() : void
      {
         var onLoadComplete:Function = null;
         var _loader:UILoader = null;
         onLoadComplete = function(param1:UILoadEvent):void
         {
            _loader.removeEventListener(UILoadEvent.COMPLETE,onLoadComplete);
            stoveMc = Utils.getSimpleButtonFromLoader("Stove",_loader.loader);
            npc10534.parent.addChild(stoveMc);
            stoveMc.x = 860;
            stoveMc.y = 368;
            stoveMc.addEventListener(MouseEvent.CLICK,onStoveMcClick);
         };
         if(TasksManager.isAccepted(2089))
         {
            if(this.stoveMc)
            {
               return;
            }
            _loader = new UILoader(ClientConfig.getCartoon("Stove"));
            _loader.addEventListener(UILoadEvent.COMPLETE,onLoadComplete);
            _loader.load();
         }
      }
      
      private function onStoveMcClick(param1:MouseEvent) : void
      {
         if(ActivityExchangeTimesManager.getTimes(3578) > 0)
         {
            ActivityExchangeCommander.exchange(3579);
         }
         else
         {
            ActivityExchangeCommander.exchange(3578);
            PveEntry.instance.enterTollgate(415);
         }
      }
      
      private function removeStove() : void
      {
         if(this.stoveMc)
         {
            this.stoveMc.parent.removeChild(this.stoveMc);
            this.stoveMc.removeEventListener(MouseEvent.CLICK,this.onStoveMcClick);
            this.stoveMc = null;
         }
      }
      
      private function removeTurnBackTaskCircle() : void
      {
         if(this.turnBackTaskCircle)
         {
            this.turnBackTaskCircle.parent.removeChild(this.turnBackTaskCircle);
            this.turnBackTaskCircle.removeEventListener(MouseEvent.CLICK,this.onTurnBackTaskCircleClick);
            this.turnBackTaskCircle = null;
         }
      }
      
      private function addTurnBackTaskCircle() : void
      {
         var onLoadComplete:Function = null;
         var _loader:UILoader = null;
         onLoadComplete = function(param1:UILoadEvent):void
         {
            _loader.removeEventListener(UILoadEvent.COMPLETE,onLoadComplete);
            turnBackTaskCircle = Utils.getMovieClipFromLoader("TurnBackTaskCircleMc",_loader.loader);
            npc10534.parent.addChild(turnBackTaskCircle);
            turnBackTaskCircle.x = 380;
            turnBackTaskCircle.y = 987;
            turnBackTaskCircle.buttonMode = true;
            if(TasksManager.isTaskProComplete(2090,0))
            {
               turnBackTaskCircle.jiantou.visible = false;
            }
            turnBackTaskCircle.addEventListener(MouseEvent.CLICK,onTurnBackTaskCircleClick);
         };
         if(TasksManager.isCompleted(2090))
         {
            return;
         }
         if(Boolean(TasksManager.isCompleted(2084)) || Boolean(TasksManager.isAccepted(2084)))
         {
            if(this.turnBackTaskCircle)
            {
               return;
            }
            _loader = new UILoader(ClientConfig.getCartoon("TurnBackTaskCircle"));
            _loader.addEventListener(UILoadEvent.COMPLETE,onLoadComplete);
            _loader.load();
         }
      }
      
      private function onTurnBackTaskCircleClick(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("TurnBackTaskPanel");
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         CityMap.instance.tranToNpc(10527);
      }
      
      private function onAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 2089)
         {
            this.addStove();
         }
      }
      
      private function onComplegte(param1:TaskEvent) : void
      {
         if(param1.taskID == 2090)
         {
            this.removeTurnBackTaskCircle();
         }
         if(param1.taskID == 2089)
         {
            this.removeStove();
         }
         if(param1.taskID == 2084)
         {
            this.addTurnBackTaskCircle();
         }
         if(param1.taskID == 2078)
         {
            CityMap.instance.tranToNpc(10527);
         }
         if(param1.taskID == 2079)
         {
            TasksManager.accept(2080);
         }
         if(param1.taskID == 2065)
         {
            TasksManager.accept(2066);
            NpcDialogController.showForNpc(10527);
         }
         if(param1.taskID == 2076)
         {
            CityMap.instance.changeMap(63);
         }
         if(param1.taskID == 2080)
         {
         }
      }
      
      private function onProComplegte(param1:TaskEvent) : void
      {
         if(param1.target == 2090 && param1.proID == 0)
         {
            if(this.turnBackTaskCircle)
            {
               this.turnBackTaskCircle.jiantou.visible = false;
            }
         }
      }
      
      override public function destroy() : void
      {
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onProComplegte);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onComplegte);
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onAccept);
         this.npc10534 = null;
         this.removeTurnBackTaskCircle();
         this.removeStove();
         super.destroy();
      }
   }
}

