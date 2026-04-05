package com.gfp.app.manager
{
   import com.gfp.app.feature.WorldBossFeather;
   import com.gfp.app.feature.WorldBossStageFeather;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.utils.TimeUtil;
   
   public class WorldBossMananer
   {
      
      private static var _bossFeather:WorldBossFeather;
      
      private static var _bossStageFeather:WorldBossStageFeather;
      
      public static const SYS_TIME_LIMIT:int = 152;
      
      public static const DETECT_BOSS_MAP:Array = [1057];
      
      private static const DETECT_BOSS_STAGE_MAP:Array = [1058901,1059001];
      
      public function WorldBossMananer()
      {
         super();
      }
      
      public static function setup() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapSwtichComplete);
      }
      
      private static function clear() : void
      {
         if(_bossFeather)
         {
            _bossFeather.destory();
            _bossFeather == null;
         }
         if(_bossStageFeather)
         {
            _bossStageFeather.destory();
            _bossStageFeather == null;
         }
      }
      
      private static function onMapSwtichComplete(param1:MapEvent) : void
      {
         clear();
         if(DETECT_BOSS_MAP.indexOf(param1.mapModel.info.id) != -1)
         {
            _bossFeather = new WorldBossFeather();
         }
         if(DETECT_BOSS_STAGE_MAP.indexOf(param1.mapModel.info.id) != -1)
         {
            _bossStageFeather = new WorldBossStageFeather();
         }
      }
      
      public static function get isMorning() : Boolean
      {
         var _loc1_:Date = TimeUtil.getSeverDateObject();
         return _loc1_.hours <= 15;
      }
      
      public static function getAwardTimeSwap() : uint
      {
         if(isMorning)
         {
            return 3199;
         }
         return 3200;
      }
   }
}

