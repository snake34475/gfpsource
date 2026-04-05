package com.gfp.app.mapProcess
{
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.Tick;
   
   public class MapProcess_1122501 extends BaseMapProcess
   {
      
      private var _map:Dictionary;
      
      private var _monsterIdList:Array = [0,1,2,3,4,5,6,7,8];
      
      private var _txtInfoMc:MovieClip;
      
      public function MapProcess_1122501()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._map = new Dictionary();
         Tick.instance.addCallback(this.onTick);
         this._txtInfoMc = _mapModel.libManager.getMovieClip("UI_TxtInfo");
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         UserManager.addEventListener(UserEvent.BORN,this.onBossBorn);
         UserManager.addEventListener(UserEvent.LEAVE,this.onOgreExploded);
      }
      
      private function resizePos() : void
      {
         this._txtInfoMc.x = LayerManager.stageWidth - this._txtInfoMc.width - 10;
         this._txtInfoMc.y = 0;
         LayerManager.topLevel.addChild(this._txtInfoMc);
      }
      
      private function onOgreExploded(param1:UserEvent) : void
      {
         var _loc4_:Array = null;
         var _loc2_:UserModel = param1.data as UserModel;
         var _loc3_:int = int(this._monsterIdList[MainManager.actorInfo.roleType]);
         if(Boolean(_loc2_) && Boolean(_loc2_.info) && _loc2_.info.roleType == _loc3_)
         {
            _loc4_ = this._map[_loc2_.info.userID];
            if(_loc4_)
            {
               (_loc4_[1] as CountDown).destroy();
            }
            this._map[_loc2_.info.userID] = null;
            delete this._map[_loc2_.info.userID];
         }
      }
      
      private function onBossBorn(param1:UserEvent) : void
      {
         var _loc4_:CountDown = null;
         var _loc2_:UserModel = param1.data as UserModel;
         var _loc3_:int = int(this._monsterIdList[MainManager.actorInfo.roleType]);
         if(_loc2_.info.roleType == _loc3_)
         {
            _loc4_ = new CountDown(_mapModel);
            _loc4_.start();
            _mapModel.upLevel.addChild(_loc4_);
            this._map[_loc2_.info.userID] = [_loc2_,_loc4_];
            this.updateCountDownPosition(_loc2_,_loc4_);
         }
      }
      
      private function onTick(param1:int) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Array = null;
         for(_loc2_ in this._map)
         {
            _loc3_ = this._map[_loc2_];
            this.updateCountDownPosition(_loc3_[0] as UserModel,_loc3_[1] as Sprite);
         }
      }
      
      private function updateCountDownPosition(param1:UserModel, param2:Sprite) : void
      {
         if(param1.pos)
         {
            param2.x = param1.x;
            param2.y = param1.y - param1.height - 55;
         }
      }
      
      override public function destroy() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Array = null;
         for(_loc1_ in this._map)
         {
            _loc2_ = this._map[_loc1_];
            if(_loc2_)
            {
               (_loc2_[1] as CountDown).destroy();
            }
            this._map[_loc1_] = null;
            delete this._map[_loc1_];
         }
         DisplayUtil.removeForParent(this._txtInfoMc);
         this._txtInfoMc = null;
         this._map = null;
         Tick.instance.removeCallback(this.onTick);
         StageResizeController.instance.unregister(this.resizePos);
         UserManager.removeEventListener(UserEvent.BORN,this.onBossBorn);
         UserManager.removeEventListener(UserEvent.LEAVE,this.onOgreExploded);
      }
   }
}

import com.gfp.core.model.MapModel;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.utils.getTimer;
import org.taomee.utils.DisplayUtil;
import org.taomee.utils.Tick;

class CountDown extends Sprite
{
   
   private var _mainUI:MovieClip;
   
   private var _startTime:int;
   
   private var _total:int = 30;
   
   public function CountDown(param1:MapModel)
   {
      super();
      this._mainUI = param1.libManager.getMovieClip("CountDownUI");
      addChild(this._mainUI);
      this._mainUI.stop();
   }
   
   public function start() : void
   {
      Tick.instance.addCallback(this.onTick);
      this._startTime = getTimer();
      this.onTick(0);
   }
   
   private function onTick(param1:int) : void
   {
      var _loc2_:int = (getTimer() - this._startTime) * 0.001;
      _loc2_ %= this._total;
      var _loc3_:int = this._total - Math.floor(_loc2_);
      this._mainUI["timeTxt"].text = _loc3_.toString() + "秒";
   }
   
   public function restart() : void
   {
      this._startTime = getTimer();
   }
   
   public function destroy() : void
   {
      Tick.instance.removeCallback(this.onTick);
      DisplayUtil.removeForParent(this);
   }
}
