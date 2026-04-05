package com.gfp.app.manager
{
   import com.gfp.app.turnbackguide.TurnBackGuideEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.manager.UserManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class TurnBackGuideManager
   {
      
      private static var _instance:TurnBackGuideManager;
      
      private var _lastRepObj:Object;
      
      private var _objFunsList:Vector.<Object> = new Vector.<Object>();
      
      public var ed:EventDispatcher;
      
      public function TurnBackGuideManager()
      {
         super();
         this._objFunsList.push({
            "lv":15,
            "rep":4502
         },{
            "lv":20,
            "rep":4503
         },{
            "lv":30,
            "rep":4504
         },{
            "lv":45,
            "rep":4505
         },{
            "lv":80,
            "rep":4506,
            "turnlimit":true
         });
         UserManager.addEventListener(UserEvent.TURN_BACK,this.onUserTurnBack);
         UserInfoManager.ed.addEventListener(UserEvent.LVL_CHANGE,this.onLevelChange);
         this.ed = new EventDispatcher();
      }
      
      public static function get instance() : TurnBackGuideManager
      {
         if(_instance == null)
         {
            _instance = new TurnBackGuideManager();
         }
         return _instance;
      }
      
      public function getLastRepObj() : Object
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         this._lastRepObj = null;
         var _loc3_:int = 0;
         while(_loc3_ < this._objFunsList.length)
         {
            _loc1_ = this._objFunsList[_loc3_];
            _loc2_ = int(ActivityExchangeTimesManager.getTimes(_loc1_.rep));
            if(_loc2_ <= 0)
            {
               this._lastRepObj = _loc1_;
               this._lastRepObj.index = _loc3_;
               break;
            }
            _loc3_++;
         }
         return this._lastRepObj;
      }
      
      private function onUserTurnBack(param1:Event) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this._objFunsList)
         {
            if(ActivityExchangeTimesManager.getTimes(_loc2_.rep) == 0)
            {
               this.ed.dispatchEvent(new TurnBackGuideEvent(TurnBackGuideEvent.SHOW_LIGHT_EFFECT));
               break;
            }
         }
      }
      
      private function onLevelChange(param1:Event) : void
      {
         var _loc2_:Object = null;
         if(!MainManager.actorInfo.isTurnBack)
         {
            for each(_loc2_ in this._objFunsList)
            {
               if(MainManager.actorInfo.lv >= _loc2_.lv && ActivityExchangeTimesManager.getTimes(_loc2_.rep) == 0 && !_loc2_.turnlimit)
               {
                  this.ed.dispatchEvent(new TurnBackGuideEvent(TurnBackGuideEvent.SHOW_LIGHT_EFFECT));
                  break;
               }
            }
         }
         if(MainManager.actorInfo.isTurnBack)
         {
            for each(_loc2_ in this._objFunsList)
            {
               if(ActivityExchangeTimesManager.getTimes(_loc2_.rep) == 0)
               {
                  this.ed.dispatchEvent(new TurnBackGuideEvent(TurnBackGuideEvent.SHOW_LIGHT_EFFECT));
                  break;
               }
            }
         }
      }
      
      public function isHide() : Boolean
      {
         return !this.getLastRepObj();
      }
      
      public function getAwardLevel() : int
      {
         var _loc1_:Object = this.getLastRepObj();
         if(!_loc1_)
         {
            return 0;
         }
         return _loc1_.lv;
      }
      
      public function hasAward() : Boolean
      {
         var _loc1_:Object = this.getLastRepObj();
         if(!_loc1_)
         {
            return false;
         }
         if(MainManager.actorInfo.isTurnBack)
         {
            return true;
         }
         if(_loc1_.turnlimit)
         {
            if(!MainManager.actorInfo.isTurnBack)
            {
               return false;
            }
         }
         else if(_loc1_.lv > MainManager.actorInfo.lv)
         {
            return false;
         }
         return true;
      }
   }
}

