package com.gfp.app.manager
{
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.dailyActivity.SwapTimesInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SOManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.utils.TimeUtil;
   import flash.net.SharedObject;
   
   public class TianJiangHaoLiManager
   {
      
      private static var _instance:TianJiangHaoLiManager;
      
      private var _objList:Vector.<Object>;
      
      private var _panelName:String = null;
      
      private var _isTurnApp:Boolean = true;
      
      private var _isLvUpInFight:Boolean = false;
      
      public function TianJiangHaoLiManager()
      {
         super();
      }
      
      public static function getInstance() : TianJiangHaoLiManager
      {
         if(!_instance)
         {
            _instance = new TianJiangHaoLiManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         if(!this._objList)
         {
            this._objList = new Vector.<Object>();
            this._objList.push({
               "timeid":6994,
               "cntid":6997,
               "awardidlist":[7000,7001,7002],
               "offtime":0,
               "state":false,
               "panelname":["TianJiangHaoLiEggPanel0","TianJiangHaoLiAwardPanel0"]
            },{
               "timeid":6995,
               "cntid":6998,
               "awardidlist":[7003,7004,7005],
               "offtime":0,
               "state":false,
               "panelname":["TianJiangHaoLiEggPanel1","TianJiangHaoLiAwardPanel1"]
            },{
               "timeid":6996,
               "cntid":6999,
               "awardidlist":[7006,7007,7008],
               "offtime":0,
               "state":false,
               "panelname":["TianJiangHaoLiEggPanel2","TianJiangHaoLiAwardPanel2"]
            });
         }
         this.refresh();
         UserManager.addEventListener(UserEvent.TURN_BACK,this.onTurnBackSuccess);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchConplete);
         UserInfoManager.ed.addEventListener(UserEvent.LVL_CHANGE,this.onLvChange);
      }
      
      private function onMapSwitchConplete(param1:MapEvent) : void
      {
         var _loc2_:UserEvent = null;
         if(this._isLvUpInFight && !(MapManager.currentMap.info.mapType == MapType.PVE || MapManager.currentMap.info.mapType == MapType.PVP))
         {
            this._isLvUpInFight = false;
            _loc2_ = new UserEvent(UserEvent.LVL_CHANGE,1);
            this.onLvChange(_loc2_);
         }
      }
      
      private function onTurnBackSuccess(param1:UserEvent) : void
      {
         var _loc2_:UserEvent = new UserEvent(UserEvent.LVL_CHANGE,1);
         this.onLvChange(_loc2_);
      }
      
      protected function onLvChange(param1:UserEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         if(MapManager.currentMap.info.mapType == MapType.PVE || MapManager.currentMap.info.mapType == MapType.PVP)
         {
            this._isLvUpInFight = true;
            return;
         }
         if(int(param1.data) > 0)
         {
            _loc2_ = this._objList[this._objList.length - 1];
            for each(_loc3_ in _loc2_.awardidlist)
            {
               if(ActivityExchangeTimesManager.getTimes(_loc3_) > 0)
               {
                  UserInfoManager.ed.removeEventListener(UserEvent.LVL_CHANGE,this.onLvChange);
                  return;
               }
            }
            this.refresh();
         }
      }
      
      public function refresh(param1:Boolean = true) : void
      {
         var _loc2_:Object = null;
         this._isTurnApp = param1;
         for each(_loc2_ in this._objList)
         {
            ActivityExchangeTimesManager.addEventListener(_loc2_.timeid,this.getTimes);
            ActivityExchangeTimesManager.getActiviteTimeInfo(_loc2_.timeid);
         }
      }
      
      private function getTimes(param1:DataEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc2_:SwapTimesInfo = param1.data as SwapTimesInfo;
         ActivityExchangeTimesManager.removeEventListener(_loc2_.dailyID,this.getTimes);
         if(_loc2_.times == 0)
         {
            return;
         }
         var _loc3_:Object = this.getObj(_loc2_.dailyID);
         _loc3_.offtime = 24 * 3600 - (TimeUtil.getSeverDateObject().getTime() / 1000 - _loc2_.times);
         this._panelName = null;
         _loc3_.state = false;
         if(_loc3_.offtime >= 0 && Math.ceil(_loc3_.offtime / 3600) <= 24)
         {
            this._panelName = _loc3_.panelname[0];
            _loc3_.state = true;
            if(ActivityExchangeTimesManager.getTimes(_loc3_.cntid) > 0)
            {
               for each(_loc5_ in _loc3_.awardidlist)
               {
                  if(ActivityExchangeTimesManager.getTimes(_loc5_) > 0)
                  {
                     _loc3_.state = false;
                     UserInfoManager.ed.dispatchEvent(new DataEvent(DataEvent.DATA_UPDATE,this._panelName));
                     return;
                  }
               }
               this._panelName = _loc3_.panelname[1];
            }
         }
         var _loc4_:SharedObject = SOManager.getActorSO(this._panelName + "ShowPanelAuto");
         if(_loc4_)
         {
            _loc6_ = Boolean(_loc4_.data["ShowPanelAuto"]);
         }
         if(Boolean(this._isTurnApp) && Boolean(this._panelName) && !_loc6_)
         {
            if(_loc4_)
            {
               _loc4_.data["ShowPanelAuto"] = true;
            }
            ModuleManager.turnAppModule(this._panelName);
         }
         UserInfoManager.ed.dispatchEvent(new DataEvent(DataEvent.DATA_UPDATE,this._panelName));
      }
      
      private function getObj(param1:int) : Object
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this._objList)
         {
            if(_loc2_.timeid == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getCurUsingObj() : Object
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this._objList)
         {
            if(_loc1_.state)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function get objList() : Vector.<Object>
      {
         return this._objList;
      }
      
      public function get panelName() : String
      {
         return this._panelName;
      }
   }
}

