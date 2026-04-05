package com.gfp.app.manager
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.cache.CommonCache;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.fight.MapOgreListInfo;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.StageTeleportModel;
   import com.gfp.core.utils.FightMode;
   import flash.utils.Dictionary;
   
   public class PreviouslyLoaderManager
   {
      
      private static var _instance:PreviouslyLoaderManager;
      
      private var _loadedList:Array;
      
      private var _mapIds:Array;
      
      private var _clearedMapIds:Array;
      
      private var lastMapId:uint;
      
      public function PreviouslyLoaderManager()
      {
         super();
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.switchMapCompleteHandler);
      }
      
      public static function get instance() : PreviouslyLoaderManager
      {
         if(!_instance)
         {
            _instance = new PreviouslyLoaderManager();
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
      
      private function switchMapCompleteHandler(param1:MapEvent) : void
      {
         if(Boolean(MapManager.isFightMap) && FightManager.fightMode == FightMode.PVE)
         {
            this.calculatePreviousResoure(MapManager.currentMap.info.id);
            if(this.lastMapId != 0)
            {
               this.clearLastMapNpcCache();
            }
            this.lastMapId = MapManager.currentMap.info.id;
         }
      }
      
      public function calculatePreviousResoure(param1:uint, param2:Boolean = false) : void
      {
         var ogreList:Array = null;
         var mapId:uint = param1;
         var isFirst:Boolean = param2;
         ogreList = [];
         if(isFirst)
         {
            this._clearedMapIds = [];
            this._loadedList = [];
            this._mapIds = [];
            this.calculateMapOgreResource(mapId,ogreList);
         }
         else
         {
            SightManager.set.forEach(function(param1:Object):void
            {
               if(param1 is StageTeleportModel)
               {
                  calculateMapOgreResource(uint(StageTeleportModel(param1).stageTo),ogreList);
               }
            });
         }
         PveEntry.instance.resLoader.loaderOgreList(ogreList,isFirst);
      }
      
      private function calculateMapOgreResource(param1:uint, param2:Array) : void
      {
         var _loc3_:MapOgreListInfo = null;
         var _loc4_:UserInfo = null;
         if(!this.isExistMap(param1))
         {
            this._mapIds.push(param1);
            _loc3_ = PveEntry.instance.fightReadyInfo.getMapOgreList(param1);
            if(_loc3_)
            {
               for each(_loc4_ in _loc3_.ogreList)
               {
                  if(!this.isExist(_loc4_.roleType))
                  {
                     param2.push(_loc4_);
                     this._loadedList.push(_loc4_.roleType);
                  }
               }
            }
         }
      }
      
      private function isExist(param1:uint) : Boolean
      {
         var _loc2_:uint = 0;
         for each(_loc2_ in this._loadedList)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function isExistMap(param1:uint) : Boolean
      {
         var _loc2_:uint = 0;
         for each(_loc2_ in this._mapIds)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function clearLastMapNpcCache() : void
      {
         var _loc3_:MapOgreListInfo = null;
         var _loc4_:UserInfo = null;
         var _loc1_:MapOgreListInfo = PveEntry.instance.fightReadyInfo.getMapOgreList(this.lastMapId);
         if(_loc1_ == null || _loc1_.ogreList == null)
         {
            return;
         }
         var _loc2_:Dictionary = new Dictionary();
         var _loc5_:Array = new Array();
         this._clearedMapIds.push(this.lastMapId);
         for each(_loc3_ in PveEntry.instance.fightReadyInfo.mapOgreVec)
         {
            if(this._clearedMapIds.indexOf(_loc3_.mapId) == -1)
            {
               for each(_loc4_ in _loc3_.ogreList)
               {
                  _loc2_[_loc4_.roleType] = true;
               }
            }
         }
         for each(_loc4_ in _loc1_.ogreList)
         {
            if(!_loc2_[_loc4_.roleType])
            {
               _loc5_.push(_loc4_.roleType);
            }
         }
         CommonCache.clearNpcWithIds(_loc5_);
      }
      
      public function resetPreviousList() : void
      {
         this.lastMapId = 0;
         this._loadedList = [];
         this._clearedMapIds = [];
         this._mapIds = [];
      }
      
      public function destroy() : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.switchMapCompleteHandler);
         this._loadedList = null;
         this._mapIds = null;
         this._clearedMapIds = null;
      }
   }
}

