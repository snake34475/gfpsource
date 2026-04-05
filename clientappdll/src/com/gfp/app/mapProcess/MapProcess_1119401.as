package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeTxtFeater;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.manager.FightPluginManager;
   import com.gfp.app.manager.fightPlugin.AutoFightManager;
   import com.gfp.app.manager.fightPlugin.AutoRecoverManager;
   import com.gfp.app.manager.fightPlugin.AutoTollgateTransManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.Tick;
   
   public class MapProcess_1119401 extends BaseMapProcess
   {
      
      private var _killNum:int = 0;
      
      private var _txtInfoMc:MovieClip;
      
      private var _map:Dictionary;
      
      private var _feather:LeftTimeTxtFeater;
      
      public function MapProcess_1119401()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightPluginManager.instance.isPluginRunning = true;
         AutoFightManager.instance.setup();
         AutoTollgateTransManager.instance.setup(true);
         AutoRecoverManager.instance.setup();
         SocketConnection.addCmdListener(CommandID.FIGHT_END,this.onEnd);
         this._txtInfoMc = _mapModel.libManager.getMovieClip("UI_TxtInfo");
         this._feather = new LeftTimeTxtFeater(1 * 60 * 1000,this._txtInfoMc["timeTxt"] as TextField,null);
         this._feather.start();
         FightManager.instance.addEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         this._map = new Dictionary();
         Tick.instance.addCallback(this.onTick);
         UserManager.addEventListener(UserEvent.BORN,this.onBossBorn);
         UserManager.addEventListener(UserEvent.DIE,this.onOgreExploded);
         UserManager.addEventListener(UserEvent.EXPLODED,this.onOgreExploded);
      }
      
      private function onBossBorn(param1:UserEvent) : void
      {
         var _loc3_:CountDown = null;
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == 14560)
         {
            _loc3_ = new CountDown(_mapModel);
            _loc3_.start();
            _mapModel.upLevel.addChild(_loc3_);
            this._map[_loc2_.info.userID] = [_loc2_,_loc3_];
            this.updateCountDownPosition(_loc2_,_loc3_);
         }
      }
      
      private function onOgreExploded(param1:UserEvent) : void
      {
         var _loc3_:Array = null;
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == 14560)
         {
            _loc3_ = this._map[_loc2_.info.userID];
            if(_loc3_)
            {
               (_loc3_[1] as CountDown).destroy();
            }
            this._map[_loc2_.info.userID] = null;
            delete this._map[_loc2_.info.userID];
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
            param2.y = param1.y - param1.height;
         }
      }
      
      private function resizePos() : void
      {
         this._txtInfoMc.x = LayerManager.stageWidth - this._txtInfoMc.width >> 1;
         this._txtInfoMc.y = 165;
         LayerManager.topLevel.addChild(this._txtInfoMc);
      }
      
      private function onModelDied(param1:FightEvent) : void
      {
         if(param1.data.roleType == 14559)
         {
            this._killNum += 80000;
            this._txtInfoMc.expTxt.text = this._killNum.toString();
         }
      }
      
      protected function onEnd(param1:SocketEvent) : void
      {
         FightPluginManager.instance.isPluginRunning = false;
         FightPluginManager.instance.stop();
         AlertManager.showSimpleAlarm("本次获得了" + this._killNum.toString() + "点仙兽经验");
      }
      
      override public function destroy() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Array = null;
         if(this._feather)
         {
            this._feather.destroy();
            this._feather = null;
         }
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
         this._map = null;
         Tick.instance.removeCallback(this.onTick);
         FightPluginManager.instance.isPluginRunning = false;
         FightPluginManager.instance.stop();
         this._killNum = 0;
         DisplayUtil.removeForParent(this._txtInfoMc);
         this._txtInfoMc = null;
         FightManager.instance.removeEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         StageResizeController.instance.unregister(this.resizePos);
         SocketConnection.removeCmdListener(CommandID.FIGHT_END,this.onEnd);
         UserManager.removeEventListener(UserEvent.BORN,this.onBossBorn);
         UserManager.removeEventListener(UserEvent.DIE,this.onOgreExploded);
         UserManager.removeEventListener(UserEvent.EXPLODED,this.onOgreExploded);
         super.destroy();
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
      this._mainUI.gotoAndStop(_loc2_ + 1);
   }
   
   public function destroy() : void
   {
      Tick.instance.removeCallback(this.onTick);
      DisplayUtil.removeForParent(this);
   }
}
