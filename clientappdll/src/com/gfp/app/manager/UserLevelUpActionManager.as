package com.gfp.app.manager
{
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   
   public class UserLevelUpActionManager
   {
      
      private static var _instance:UserLevelUpActionManager;
      
      private var _lvAddInFight:int;
      
      public function UserLevelUpActionManager()
      {
         super();
      }
      
      public static function get instance() : UserLevelUpActionManager
      {
         if(_instance == null)
         {
            _instance = new UserLevelUpActionManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._lvAddInFight = 0;
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this._onMapSwitchConplete);
         UserInfoManager.ed.addEventListener(UserEvent.LVL_CHANGE,this._onLvChange);
      }
      
      private function _onMapSwitchConplete(param1:MapEvent) : void
      {
         if(Boolean(this._lvAddInFight) && !(MapManager.currentMap.info.mapType == MapType.PVE || MapManager.currentMap.info.mapType == MapType.PVP))
         {
            this._executeOutOfBattleField(this._lvAddInFight);
            this._lvAddInFight = 0;
         }
      }
      
      protected function _onLvChange(param1:UserEvent) : void
      {
         this._lvAddInFight = param1.data;
         this._execute(this._lvAddInFight);
         if(MapManager.currentMap == null || MapManager.currentMap.info == null || MapManager.currentMap.info.mapType == MapType.PVE || MapManager.currentMap.info.mapType == MapType.PVP)
         {
            return;
         }
         this._executeOutOfBattleField(this._lvAddInFight);
         this._lvAddInFight = 0;
      }
      
      private function _executeOutOfBattleField(param1:int) : void
      {
      }
      
      private function _execute(param1:int) : void
      {
      }
   }
}

