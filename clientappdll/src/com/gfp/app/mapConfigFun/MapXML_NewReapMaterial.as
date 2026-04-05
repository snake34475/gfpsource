package com.gfp.app.mapConfigFun
{
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.info.ActivityExchangeAwardInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SOManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.WallowUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.net.SharedObject;
   import org.taomee.manager.DepthManager;
   
   public class MapXML_NewReapMaterial implements IMapConfigFun
   {
      
      private static var _openSm:SightModel;
      
      private static var _so:SharedObject;
      
      private static var _swapID:uint;
      
      private static var _maxReapTime:uint;
      
      private static var _taskID:uint;
      
      private static var _animation:MovieClip;
      
      public function MapXML_NewReapMaterial()
      {
         super();
      }
      
      private static function isActorInRect() : Boolean
      {
         var _loc1_:Rectangle = new Rectangle(_openSm.x - 200,_openSm.y - 200,400,400);
         var _loc2_:Number = Number(MainManager.actorModel.x);
         var _loc3_:Number = Number(MainManager.actorModel.y);
         return _loc1_.contains(_loc2_,_loc3_);
      }
      
      private static function reap() : void
      {
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,onExchangeComplete);
         ActivityExchangeCommander.exchange(_swapID);
      }
      
      private static function onExchangeComplete(param1:ExchangeEvent) : void
      {
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,onExchangeComplete);
         var _loc2_:ActivityExchangeAwardInfo = param1.info as ActivityExchangeAwardInfo;
         if(_loc2_.id == _swapID)
         {
            updateRecord();
         }
      }
      
      private static function updateRecord() : void
      {
         var _loc1_:Date = new Date();
         _loc1_.setTime(MainManager.loginTimeInSecond * 1000);
         var _loc2_:String = _loc1_.getFullYear() + "-" + (_loc1_.getMonth() + 1) + "-" + _loc1_.getDate();
         var _loc3_:String = MapManager.currentMap.info.id.toString() + "-" + _openSm.info.id.toString();
         var _loc4_:String = MainManager.actorInfo.createTime.toString();
         var _loc5_:String = _loc4_ + "#" + _loc2_ + "#" + _loc3_;
         var _loc6_:int = int(_so.data[_loc5_]);
         _so.data[_loc5_] = ++_loc6_;
         SOManager.flush(_so);
         if(_loc6_ == _maxReapTime)
         {
            _openSm.hide();
            DepthManager.swapDepthAll(MapManager.currentMap.contentLevel);
         }
      }
      
      private static function getSo() : SharedObject
      {
         return SOManager.getUserSO(SOManager.DAILY_REAP);
      }
      
      private static function onRemoveOpenSm(param1:Event) : void
      {
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,onExchangeComplete);
         _openSm.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveOpenSm);
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         _openSm = param1;
         _openSm.addEventListener(Event.ADDED_TO_STAGE,this.onAddTostage);
         var _loc4_:Array = param2.toString().split(",");
         _swapID = uint(_loc4_[0]);
         _maxReapTime = uint(_loc4_[1]);
         _taskID = uint(_loc4_[2]);
         if(!this.checkSighModelShow())
         {
            return;
         }
         if(FunctionManager.disabledPickItem)
         {
            FunctionManager.dispatchDisabledEvt();
            return;
         }
         if(isActorInRect())
         {
            if(WallowUtil.isWallow())
            {
               WallowUtil.showWallowMsg(AppLanguageDefine.WALLOW_MSG_ARR[1]);
               return;
            }
            _openSm.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveOpenSm);
            _openSm.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveOpenSm);
            _so = getSo();
            if(this.canPutFruit(_swapID))
            {
               reap();
            }
            else
            {
               AlertManager.showSimpleAlarm(AppLanguageDefine.ACQUISITION_CHARACTER_COLLECTION[0]);
            }
         }
         else
         {
            TextAlert.show(AppLanguageDefine.ACQUISITION_CHARACTER_COLLECTION[1]);
         }
      }
      
      private function onAddTostage(param1:Event) : void
      {
         _openSm.removeEventListener(Event.ADDED_TO_STAGE,this.onAddTostage);
         this.checkSighModelShow();
      }
      
      private function checkSighModelShow() : Boolean
      {
         if(_taskID != 0)
         {
            if(!TasksManager.isAccepted(_taskID) || Boolean(TasksManager.isCompleted(_taskID)))
            {
               _openSm.hide();
               return false;
            }
         }
         return true;
      }
      
      private function canPutFruit(param1:int) : Boolean
      {
         var _loc2_:Boolean = true;
         var _loc3_:int = int(ItemManager.getItemAvailableCapacity());
         if(_loc3_ <= 0)
         {
            _loc2_ = false;
         }
         return _loc2_;
      }
   }
}

