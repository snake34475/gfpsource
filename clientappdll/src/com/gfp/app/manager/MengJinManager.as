package com.gfp.app.manager
{
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.ShaoDangMananger;
   
   public class MengJinManager
   {
      
      private static var _instance:MengJinManager;
      
      public static const STAGE_ID:int = 1027;
      
      private const LAYER_EXE:int = 5145;
      
      private const MAX_ROOM_EXE:int = 5140;
      
      public var isSpeed:Boolean;
      
      public var currentFightLayer:int;
      
      public function MengJinManager()
      {
         super();
      }
      
      public static function get instance() : MengJinManager
      {
         return _instance || (_instance = new MengJinManager());
      }
      
      public function updateExE() : void
      {
         ActivityExchangeTimesManager.getActiviteTimeInfo(this.LAYER_EXE);
         ActivityExchangeTimesManager.getActiviteTimeInfo(this.MAX_ROOM_EXE);
      }
      
      public function getPrevLayer() : int
      {
         return ActivityExchangeTimesManager.getTimes(this.LAYER_EXE);
      }
      
      public function getCurrentLayer() : int
      {
         return ShaoDangMananger.isShaoDang ? int(ActivityExchangeTimesManager.getTimes(this.LAYER_EXE) + ShaoDangMananger.shaoDangCurrentTimes) : int(ActivityExchangeTimesManager.getTimes(this.LAYER_EXE));
      }
      
      public function getMaxLayer() : int
      {
         return ActivityExchangeTimesManager.getTimes(this.MAX_ROOM_EXE);
      }
   }
}

