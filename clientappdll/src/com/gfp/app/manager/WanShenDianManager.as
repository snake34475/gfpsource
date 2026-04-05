package com.gfp.app.manager
{
   import com.gfp.app.feature.WanShenDianFeather;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.time.SystimeEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.utils.StringConstants;
   import flash.geom.Point;
   
   public class WanShenDianManager
   {
      
      private static var _feather:WanShenDianFeather;
      
      private static var _livePoints:Array = [new Point(1372,387),new Point(2373,1056)];
      
      public static var effectMaps:Array = [1062];
      
      public function WanShenDianManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         addEvent();
      }
      
      private static function addEvent() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapSwtichComplete);
         MapManager.addEventListener(MapEvent.MAP_DESTROY,onMapDestory);
         TasksManager.addActionListener(TaskActionEvent.TASK_PVP_UNWIN,null,onPvpUnWin);
      }
      
      private static function onPvpUnWin(param1:TaskActionEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:String = param1.param.toString();
         var _loc3_:Array = _loc2_.split(StringConstants.SIGN);
         if(_loc3_.length == 2)
         {
            _loc4_ = parseInt(_loc3_[0]);
            _loc5_ = parseInt(_loc3_[1]);
            if(_loc5_ == 1047801)
            {
               FightManager.outToMapID = effectMaps[0];
               FightManager.outToMapPos = _livePoints[Math.floor(_livePoints.length * Math.random())];
            }
         }
      }
      
      private static function onTimeCome(param1:SystimeEvent) : void
      {
         if(_feather)
         {
            _feather.destroy();
            _feather = null;
         }
         if(param1.isStart && effectMaps.indexOf(MapManager.mapInfo.id) != -1)
         {
            _feather = new WanShenDianFeather();
         }
      }
      
      private static function onMapDestory(param1:MapEvent) : void
      {
         if(_feather)
         {
            _feather.destroy();
            _feather = null;
         }
      }
      
      private static function onMapSwtichComplete(param1:MapEvent) : void
      {
         if(effectMaps.indexOf(param1.mapModel.info.id) != -1)
         {
            _feather = new WanShenDianFeather();
         }
      }
   }
}

