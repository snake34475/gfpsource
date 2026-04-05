package com.gfp.app.mapConfigFun
{
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.ActivityExchangeXMLInfo;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.info.dailyActivity.RewardInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SOManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.UIManager;
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
   import org.taomee.ds.HashMap;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.DisplayUtil;
   
   public class MapXML_ReapMaterialOnlyLoading implements IMapConfigFun
   {
      
      private static var _openSm:SightModel;
      
      private static var _closeSm:SightModel;
      
      private static var _so:SharedObject;
      
      private static var _reapId:uint;
      
      private static var _maxReapTime:uint;
      
      private static var _animation:MovieClip;
      
      private static var _isPlayAnimation:Boolean = false;
      
      private static var crystalMap:HashMap = new HashMap();
      
      private static var crystalArr:Array = [2008,2064,2068,2015,2006,2013];
      
      crystalMap.add(1500224,[2008,1874]);
      crystalMap.add(1500225,[2064,1875]);
      crystalMap.add(1500234,[2068,1876]);
      crystalMap.add(1500229,[2015,1877]);
      crystalMap.add(1500223,[2006,1878]);
      crystalMap.add(1500228,[2013,1879]);
      
      public function MapXML_ReapMaterialOnlyLoading()
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
      
      private static function playReapAnimation() : void
      {
         if(_animation == null)
         {
            _animation = UIManager.getMovieClip("ReapAnimationOnlyLoading");
            _animation.addEventListener(Event.ENTER_FRAME,onAnimation);
            _animation.x = _openSm.x - 20;
            _animation.y = _openSm.y - _openSm.height - 20;
            _animation.gotoAndPlay(2);
            MapManager.currentMap.contentLevel.addChild(_animation);
            addActorMoveEventListener();
         }
      }
      
      private static function onAnimation(param1:Event) : void
      {
         if(_animation.currentFrame == _animation.totalFrames)
         {
            removeActorMoveEventListener();
            removeAnimation();
            reap();
         }
      }
      
      private static function abortAnimation() : void
      {
         if(_animation)
         {
            _animation.stop();
            removeActorMoveEventListener();
            removeAnimation();
         }
      }
      
      private static function removeAnimation() : void
      {
         _isPlayAnimation = false;
         _animation.removeEventListener(Event.ENTER_FRAME,onAnimation);
         DisplayUtil.removeForParent(_animation);
         _animation = null;
      }
      
      private static function addActorMoveEventListener() : void
      {
         if(!MainManager.actorModel.hasEventListener(Event.ENTER_FRAME))
         {
            MainManager.actorModel.addEventListener(Event.ENTER_FRAME,onActorMove);
         }
      }
      
      private static function removeActorMoveEventListener() : void
      {
         MainManager.actorModel.removeEventListener(Event.ENTER_FRAME,onActorMove);
      }
      
      private static function onActorMove(param1:Event) : void
      {
         if(!isActorInRect())
         {
            abortAnimation();
         }
      }
      
      private static function reap() : void
      {
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,onGetMaterial);
         ActivityExchangeCommander.exchange(_reapId);
      }
      
      private static function onGetMaterial(param1:ExchangeEvent) : void
      {
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,onGetMaterial);
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
         var _loc6_:int = int(ActivityExchangeTimesManager.getTimes(_reapId));
         _so.data[_loc5_] = _loc6_;
         SOManager.flush(_so);
         if(_loc6_ == _maxReapTime)
         {
            _closeSm.show();
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
         removeActorMoveEventListener();
         SocketConnection.removeCmdListener(CommandID.DAILY_ACTIVITY,onGetMaterial);
         if(_animation)
         {
            _animation.stop();
            removeAnimation();
         }
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         if(FunctionManager.disabledPickItem)
         {
            FunctionManager.dispatchDisabledEvt();
            return;
         }
         if(_isPlayAnimation)
         {
            return;
         }
         _openSm = param1;
         _closeSm = SightManager.getSightModel(_openSm.info.id - 1);
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
               playReapAnimation();
               _isPlayAnimation = true;
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
         var _loc3_:RewardInfo = ActivityExchangeXMLInfo.getActivityById(param1).rewardVect[0] as RewardInfo;
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

