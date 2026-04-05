package com.gfp.app.mapConfigFun
{
   import com.gfp.app.cartoon.DailyActivityAward;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.DailyActivityXMLInfo;
   import com.gfp.core.info.DailyActiveAwardInfo;
   import com.gfp.core.info.dailyActivity.RewardInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SOManager;
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.WallowUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.net.SharedObject;
   import org.taomee.manager.DepthManager;
   import org.taomee.net.SocketEvent;
   
   public class MapXML_ReapMaterialNoAnimation implements IMapConfigFun
   {
      
      private static var _openSm:SightModel;
      
      private static var _so:SharedObject;
      
      private static var _reapId:uint;
      
      private static var _maxReapTime:uint;
      
      private static var _animation:MovieClip;
      
      public function MapXML_ReapMaterialNoAnimation()
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
         SocketConnection.addCmdListener(CommandID.DAILY_ACTIVITY,onGetMaterial);
         SocketConnection.send(CommandID.DAILY_ACTIVITY,_reapId);
      }
      
      private static function onGetMaterial(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.DAILY_ACTIVITY,onGetMaterial);
         var _loc2_:DailyActiveAwardInfo = param1.data as DailyActiveAwardInfo;
         var _loc3_:uint = uint(_loc2_.type);
         if(_loc3_ != DailyActivityXMLInfo.TYPE_REAP_MATERIAL)
         {
            return;
         }
         DailyActivityAward.addAward(_loc2_);
         updateRecord();
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
         _openSm.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveOpenSm);
         SocketConnection.removeCmdListener(CommandID.DAILY_ACTIVITY,onGetMaterial);
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         if(FunctionManager.disabledPickItem)
         {
            FunctionManager.dispatchDisabledEvt();
            return;
         }
         _openSm = param1;
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
            _reapId = uint(param2.toString().split(",")[0]);
            _maxReapTime = uint(param2.toString().split(",")[1]);
            if(this.canPutFruit(_reapId))
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
      
      private function canPutFruit(param1:int) : Boolean
      {
         var _loc2_:Boolean = true;
         var _loc3_:RewardInfo = DailyActivityXMLInfo.getActivityById(param1).rewardVect[0] as RewardInfo;
         var _loc4_:int = int(_loc3_.id);
         var _loc5_:int = int(ItemManager.getItemAvailableCapacity());
         if(_loc5_ <= 0)
         {
            _loc2_ = false;
         }
         return _loc2_;
      }
   }
}

