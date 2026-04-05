package com.gfp.app.control
{
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.MapModel;
   
   public class RedBlueMasterControl
   {
      
      private static var _instance:RedBlueMasterControl;
      
      public static const MAX_TIME:uint = 30;
      
      private var _isOnFlag:Boolean = false;
      
      private var _pvpLevel:uint;
      
      private var _currentTime:Number = 0;
      
      private var _leftFlag:uint;
      
      private var _outFightRoom:Boolean = false;
      
      private var _fightOver:Boolean = false;
      
      public function RedBlueMasterControl()
      {
         super();
      }
      
      public static function get instance() : RedBlueMasterControl
      {
         if(_instance == null)
         {
            _instance = new RedBlueMasterControl();
         }
         return _instance;
      }
      
      public function addMapSwitchEvent() : void
      {
         MapManager.addEventListener(MapEvent.MAP_DESTROY,this.onMapDestroy);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
      }
      
      public function removeMapSwitchEvent() : void
      {
         MapManager.removeEventListener(MapEvent.MAP_DESTROY,this.onMapDestroy);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
      }
      
      private function onMapDestroy(param1:MapEvent) : void
      {
         var _loc2_:MapModel = param1.mapModel;
         var _loc3_:uint = uint(_loc2_.info.id);
         if(_loc3_ == 1071101 || _loc3_ == 1071201 || _loc3_ == 1071301)
         {
            this._outFightRoom = true;
         }
         else
         {
            this._outFightRoom = false;
         }
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         if(this._isOnFlag && this._outFightRoom)
         {
            ModuleManager.turnAppModule("RedBlueProcessPanel","");
         }
      }
      
      public function get fightOver() : Boolean
      {
         return this._fightOver;
      }
      
      public function set fightOver(param1:Boolean) : void
      {
         this._fightOver = param1;
      }
      
      public function get leftFlag() : uint
      {
         return this._leftFlag;
      }
      
      public function set leftFlag(param1:uint) : void
      {
         this._leftFlag = param1;
      }
      
      public function get currentTime() : Number
      {
         return this._currentTime;
      }
      
      public function set currentTime(param1:Number) : void
      {
         this._currentTime = param1;
      }
      
      public function get pvpLevel() : uint
      {
         return this._pvpLevel;
      }
      
      public function set pvpLevel(param1:uint) : void
      {
         this._pvpLevel = param1;
      }
      
      public function get isOnFlag() : Boolean
      {
         return this._isOnFlag;
      }
      
      public function set isOnFlag(param1:Boolean) : void
      {
         this._isOnFlag = param1;
      }
   }
}

