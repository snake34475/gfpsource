package com.gfp.app.plugins
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.FocusManager;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.CustomUserModel;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import org.taomee.utils.DisplayUtil;
   
   public class HidingCatchGhostPlugin extends BasePlugin
   {
      
      private var _maps:Array = [1,33,53,15,59,34,54];
      
      private var _positions:Array = [[[2664,778],[685,858],[1280,511]],[[378,1510],[1024,723],[473,415]],[[1470,742],[1440,339],[873,331]],[[364,557],[770,1366],[931,879]],[[1278,523],[461,719],[620,196]],[[1332,1072],[2237,1480],[929,1223]],[[1350,436],[1563,620],[407,656]]];
      
      private var _timer:int;
      
      private var _startTime:int;
      
      private var _currentMaps:Array;
      
      private var _ghost:CustomUserModel;
      
      private var _animation:MovieClip;
      
      private var _isPlayAnimation:Boolean;
      
      private var _uiLoader:Loader;
      
      private var _ui:Sprite;
      
      public function HidingCatchGhostPlugin()
      {
         super();
      }
      
      override public function install() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(isInstalled == false)
         {
            this._timer = setInterval(this.onTimer,1000);
            this._startTime = getTimer();
            this.onTimer();
            this._currentMaps = [];
            _loc1_ = int(ActivityExchangeTimesManager.getTimes(5221));
            _loc2_ = 0;
            _loc3_ = 0;
            while(_loc3_ < 7)
            {
               if((_loc1_ & 1 << _loc3_) == 0)
               {
                  this._currentMaps.push(this._maps[_loc3_]);
               }
               else
               {
                  _loc2_++;
               }
               _loc3_++;
            }
            while(this._currentMaps.length > 4 - _loc2_)
            {
               this._currentMaps.splice(int(Math.random() * this._currentMaps.length),1);
            }
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComlete);
            ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
            this.updateMap();
            MainManager.actorModel.alpha = 0.3;
            FunctionManager.disabledPvp = false;
            FunctionManager.disabledYiaBiao = false;
            FunctionManager.allowTollgate = [9999];
            FunctionManager.evtDispatch.addEventListener(FunctionManager.FUNCTION_DISABLED,this.disabledHandle);
            this._uiLoader = new Loader();
            this._uiLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onUIComplete);
            this._uiLoader.load(new URLRequest(ClientConfig.getSubUI("hiding_catch_ghost")));
         }
         super.install();
      }
      
      protected function onUIComplete(param1:Event) : void
      {
         this._ui = this._uiLoader.content["time"];
         this._ui.mouseChildren = false;
         this._ui.mouseEnabled = false;
         LayerManager.stage.addChild(this._ui);
         StageResizeController.instance.register(this.layout);
         this.layout();
         this._uiLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onUIComplete);
         this._uiLoader.unloadAndStop();
         this._uiLoader = null;
         this.onTimer();
      }
      
      private function layout() : void
      {
         this._ui.x = LayerManager.stageWidth >> 1;
         this._ui.y = 200;
      }
      
      protected function disabledHandle(param1:Event) : void
      {
         AlertManager.showSimpleAlarm("小侠士，你现在正在隐身中，不能进行该操作！");
      }
      
      private function onMapSwitchComlete(param1:Event) : void
      {
         this.updateMap();
      }
      
      private function updateMap() : void
      {
         var _loc3_:Array = null;
         this.destroyGhost();
         var _loc1_:uint = uint(MapManager.mapInfo.id);
         var _loc2_:int = this._currentMaps.indexOf(_loc1_);
         if(_loc2_ != -1)
         {
            this._ghost = new CustomUserModel(10222);
            _loc2_ = this._maps.indexOf(_loc1_);
            _loc3_ = this._positions[_loc2_][int(Math.random() * 3)];
            this._ghost.show(new Point(_loc3_[0],_loc3_[1]),MapManager.currentMap.contentLevel,true);
            this._ghost.getContent().addEventListener(MouseEvent.CLICK,this.onGhostClick);
            this._ghost.setTopNickName("可恶的幽灵");
         }
      }
      
      private function onGhostClick(param1:MouseEvent) : void
      {
         if(Point.distance(this._ghost.pos,MainManager.actorModel.pos) > 200)
         {
            AlertManager.showSimpleAlarm("只有靠近点才可将它驱除哦~ ");
         }
         else if(this._isPlayAnimation == false)
         {
            this.playReapAnimation();
         }
      }
      
      private function playReapAnimation() : void
      {
         if(this._animation == null)
         {
            this._isPlayAnimation = true;
            this._animation = UIManager.getMovieClip("ReapProcess");
            this._animation.addEventListener(Event.ENTER_FRAME,this.onAnimation);
            this._animation.x = this._ghost.pos.x - 20;
            this._animation.y = this._ghost.pos.y - this._ghost.height - 20;
            this._animation.gotoAndPlay(2);
            MapManager.currentMap.contentLevel.addChild(this._animation);
         }
      }
      
      private function onAnimation(param1:Event) : void
      {
         if(this._animation.currentFrame == this._animation.totalFrames)
         {
            this.removeAnimation();
            ActivityExchangeCommander.exchange(6883,this._maps.indexOf(MapManager.mapInfo.id) + 1);
         }
      }
      
      private function removeAnimation() : void
      {
         this._isPlayAnimation = false;
         this._animation.removeEventListener(Event.ENTER_FRAME,this.onAnimation);
         DisplayUtil.removeForParent(this._animation);
         this._animation = null;
      }
      
      private function onExchangeComplete(param1:ExchangeEvent) : void
      {
         if(param1.info.id == 6883)
         {
            if(this._ghost)
            {
               this._ghost.getContent().removeEventListener(MouseEvent.CLICK,this.onGhostClick);
               this._ghost.destroy();
               this._ghost = null;
            }
            this._currentMaps.splice(this._currentMaps.indexOf(MapManager.mapInfo.id),1);
            if(ActivityExchangeTimesManager.getTimes(6883) >= 4)
            {
               AlertManager.showSimpleAlarm("小侠士，恭喜你，驱除了全部邪恶的幽灵！");
               this.gameOver();
            }
            else
            {
               AlertManager.showSimpleAlarm("恭喜小侠士，你已经为功夫世界驱除了一只邪恶的幽灵！");
            }
            FocusManager.setFocus(MapManager.currentMap.contentLevel);
         }
      }
      
      private function gameOver() : void
      {
         PluginManager.instance.uninstallPlugin("HidingCatchGhostPlugin");
      }
      
      private function onTimer() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:int = (this._startTime + 180000 - getTimer()) * 0.001;
         if(_loc1_ < 0)
         {
            _loc1_ = 0;
            this.gameOver();
         }
         if(this._ui)
         {
            _loc2_ = int(uint(_loc1_ / 60));
            _loc3_ = _loc1_ % 60;
            this._ui["timeMC0"].gotoAndStop(int(_loc2_ * 0.1) + 1);
            this._ui["timeMC1"].gotoAndStop(_loc2_ % 10 + 1);
            this._ui["timeMC2"].gotoAndStop(int(_loc3_ * 0.1) + 1);
            this._ui["timeMC3"].gotoAndStop(_loc3_ % 10 + 1);
         }
      }
      
      private function destroyGhost() : void
      {
         if(this._ghost)
         {
            this._ghost.getContent().removeEventListener(MouseEvent.CLICK,this.onGhostClick);
            this._ghost.destroy();
            this._ghost = null;
         }
      }
      
      override public function uninstall() : void
      {
         super.uninstall();
         this.destroyGhost();
         clearInterval(this._timer);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComlete);
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
         MainManager.actorModel.alpha = 1;
         FunctionManager.disabledPvp = true;
         FunctionManager.disabledYiaBiao = true;
         FunctionManager.allowTollgate = [];
         FunctionManager.evtDispatch.removeEventListener(FunctionManager.FUNCTION_DISABLED,this.disabledHandle);
         if(this._ui)
         {
            DisplayUtil.removeForParent(this._ui);
            this._ui = null;
         }
         StageResizeController.instance.unregister(this.layout);
      }
   }
}

