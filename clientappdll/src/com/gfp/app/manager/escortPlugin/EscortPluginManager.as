package com.gfp.app.manager.escortPlugin
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.manager.EscortManager;
   import com.gfp.app.manager.fightPlugin.AutoFightManager;
   import com.gfp.app.manager.fightPlugin.AutoRecoverManager;
   import com.gfp.app.manager.fightPlugin.AutoTollgateTransManager;
   import com.gfp.core.action.mouse.MouseProcess;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.CityMap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class EscortPluginManager
   {
      
      private static var _instance:EscortPluginManager;
      
      private var _escortID:uint;
      
      public function EscortPluginManager()
      {
         super();
      }
      
      public static function get instance() : EscortPluginManager
      {
         if(_instance == null)
         {
            _instance = new EscortPluginManager();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
         }
         _instance = null;
      }
      
      public function setup() : void
      {
         this.addEvent();
         AutoFightManager.instance.setup();
         AutoTollgateTransManager.instance.setup();
         AutoRecoverManager.instance.setup();
         this.onEscortProgress();
      }
      
      private function addEvent() : void
      {
         EscortManager.instance.addEventListener(EscortManager.ESCORT_PROGRESS,this.onEscortProgress);
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
         EscortManager.instance.addEventListener(EscortManager.ESCORT_OVER,this.onEscortOver);
      }
      
      private function removeEvent() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         EscortManager.instance.removeEventListener(EscortManager.ESCORT_PROGRESS,this.onEscortProgress);
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         EscortManager.instance.removeEventListener(EscortManager.ESCORT_OVER,this.onEscortOver);
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE_END,this.onMoveEnd);
      }
      
      private function onEscortProgress(param1:DataEvent = null) : void
      {
         var _loc2_:Point = EscortManager.instance.targetPoint;
         if(_loc2_)
         {
            if(Point.distance(_loc2_,MainManager.actorModel.pos) < 30)
            {
               if(EscortManager.instance.nextMapID != 0)
               {
                  CityMap.instance.changeMap(EscortManager.instance.nextMapID,0);
               }
               else
               {
                  this.onMoveEnd();
               }
            }
            else
            {
               MouseProcess.execRun(MainManager.actorModel,EscortManager.instance.targetPoint);
            }
         }
         if(EscortManager.instance.endNpcModule)
         {
            MainManager.actorModel.addEventListener(MoveEvent.MOVE_END,this.onMoveEnd);
         }
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         FightManager.quit();
      }
      
      private function onEscortOver(param1:Event) : void
      {
         this.destroy();
      }
      
      private function onMoveEnd(param1:MoveEvent = null) : void
      {
         EscortManager.instance.endNpcModule.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      public function destroy() : void
      {
         this.removeEvent();
         AutoFightManager.destroy();
         AutoTollgateTransManager.destroy();
         AutoRecoverManager.destroy();
      }
   }
}

