package com.gfp.app.manager
{
   import com.gfp.app.feature.GhostAdventureFeather;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.utils.strength.SwfLoaderHelper;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class GhostAdventureManager
   {
      
      private static var _feather:GhostAdventureFeather;
      
      private static var _isChanged:Boolean;
      
      private static var _completeIds:Array;
      
      private static var _mov1:MovieClip;
      
      private static var _mov2:MovieClip;
      
      public static var isShowMov1:Boolean;
      
      public static var isShowMov2:Boolean;
      
      public static const TASK_SWAP_ID:int = 4484;
      
      public static var taskInfos:Array = [{
         "id":0,
         "des":"今天带我参加一场武林风云吧！",
         "tran":"NPC_10150",
         "show":false,
         "complete":false
      },{
         "id":1,
         "des":"今天带我完成一局押镖吧！",
         "tran":"NPC_10024",
         "show":false,
         "complete":false
      },{
         "id":2,
         "des":"今天带我见识一下史诗级的关卡吧！",
         "tran":"PANEL_BossRoadMapPanel",
         "show":false,
         "complete":false
      },{
         "id":3,
         "des":"今天带我通关一局伏魔塔吧！",
         "tran":"24,809,487",
         "show":false,
         "complete":false
      },{
         "id":4,
         "des":"今天带我见识一下仙兽风云际会吧！",
         "tran":"PANEL_XianShouFengYunJiHuiPanel",
         "show":false,
         "complete":false
      },{
         "id":5,
         "des":"今天带我辨别一下真假武圣吧！",
         "tran":"NPC_10001",
         "show":false,
         "complete":false
      },{
         "id":6,
         "des":"今天带我完成一局相约寻宝吧！",
         "tran":"NPC_10048",
         "show":false,
         "complete":false
      }];
      
      public function GhostAdventureManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         requestData();
         MapManager.addEventListener(MapEvent.MAP_DESTROY,onMapDestory);
         MapManager.addEventListener(MapEvent.USER_LIST_COMPLETE,onMapSwtichComplete);
      }
      
      public static function showGhost() : void
      {
         checkGhost();
      }
      
      public static function hideGhost() : void
      {
         clearGhost();
         MapManager.removeEventListener(MapEvent.MAP_DESTROY,onMapDestory);
         MapManager.removeEventListener(MapEvent.USER_LIST_COMPLETE,onMapSwtichComplete);
      }
      
      private static function onMapDestory(param1:Event) : void
      {
         clearGhost();
      }
      
      private static function onMapSwtichComplete(param1:MapEvent) : void
      {
         clearGhost();
         checkGhost();
      }
      
      private static function checkGhost() : void
      {
         if(Boolean(MapManager.currentMap) && MapManager.currentMap.info.mapType == MapType.STAND)
         {
            if(getShowCount() > 0 && ActivityExchangeTimesManager.getTimes(4659) == 0)
            {
               if(!_feather)
               {
                  _feather = new GhostAdventureFeather();
                  if(isShowMov1 || getCompleteCount() >= 3)
                  {
                     showMov(1);
                  }
                  else if(isShowMov2)
                  {
                     showMov(2);
                  }
               }
               return;
            }
         }
         if(_feather)
         {
            _feather.destory();
         }
      }
      
      private static function clearGhost() : void
      {
         if(_feather)
         {
            _feather.destory();
            _feather = null;
         }
      }
      
      public static function notifiComplete() : void
      {
         _isChanged = true;
         _completeIds = getCompleteIds();
         requestData();
      }
      
      private static function requestData() : void
      {
         ActivityExchangeTimesManager.addEventListener(GhostAdventureManager.TASK_SWAP_ID,onTaskInfoBack);
         ActivityExchangeTimesManager.getActiviteTimeInfo(GhostAdventureManager.TASK_SWAP_ID);
      }
      
      private static function showMov(param1:int) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:SwfLoaderHelper = null;
         if(param1 == 1)
         {
            _loc2_ = _mov1;
         }
         else
         {
            _loc2_ = _mov2;
         }
         if(_loc2_)
         {
            if(_feather)
            {
               _feather.showMov(_loc2_);
            }
         }
         else
         {
            _loc3_ = new SwfLoaderHelper();
            _loc3_.loadFile(ClientConfig.getCartoon("ghost_" + param1),movieCallBack);
         }
      }
      
      private static function movieCallBack(param1:Loader) : void
      {
         var _loc2_:MovieClip = param1.content["mc"];
         if(isShowMov1)
         {
            _mov1 = _loc2_;
         }
         else if(isShowMov2)
         {
            _mov2 = _loc2_;
         }
         if(_feather)
         {
            _loc2_.x = 20;
            _loc2_.y = -100;
            _feather.showMov(_loc2_);
         }
      }
      
      private static function onTaskInfoBack(param1:Event) : void
      {
         var _loc2_:Array = null;
         ActivityExchangeTimesManager.removeEventListener(GhostAdventureManager.TASK_SWAP_ID,onTaskInfoBack);
         checkCompleteStatus();
         if(_isChanged)
         {
            _isChanged = false;
            _loc2_ = getCompleteIds();
            if(_loc2_.length == 3)
            {
               isShowMov1 = true;
               showMov(1);
            }
            else if(_loc2_.length > _completeIds.length)
            {
               isShowMov2 = true;
               showMov(2);
            }
         }
      }
      
      public static function checkCompleteStatus() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:int = int(ActivityExchangeTimesManager.getTimes(GhostAdventureManager.TASK_SWAP_ID));
         var _loc2_:int = 0;
         while(_loc2_ < 7)
         {
            _loc3_ = 1 << _loc2_;
            _loc4_ = 1 << _loc2_ + 7;
            taskInfos[_loc2_].show = (_loc1_ & _loc3_) == _loc3_;
            taskInfos[_loc2_].complete = (_loc1_ & _loc4_) == _loc4_;
            _loc2_++;
         }
         checkGhost();
      }
      
      public static function getCompleteCount() : int
      {
         var _loc2_:Object = null;
         var _loc1_:int = 0;
         for each(_loc2_ in taskInfos)
         {
            if(_loc2_.complete)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      private static function getCompleteIds() : Array
      {
         var _loc2_:Object = null;
         var _loc1_:Array = [];
         for each(_loc2_ in taskInfos)
         {
            if(_loc2_.complete)
            {
               _loc1_.push(_loc2_.id);
            }
         }
         return _loc1_;
      }
      
      public static function getShowInfos() : Array
      {
         var _loc2_:Object = null;
         var _loc1_:Array = [];
         for each(_loc2_ in taskInfos)
         {
            if(_loc2_.show)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public static function getShowCount() : int
      {
         var _loc2_:Object = null;
         var _loc1_:int = 0;
         for each(_loc2_ in taskInfos)
         {
            if(_loc2_.show)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
   }
}

