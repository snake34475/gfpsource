package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.CheckForOpenFeather;
   import com.gfp.app.feature.LeftTimeMovFeather;
   import com.gfp.app.fight.FightAdded;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.app.toolBar.CityToolBar;
   import com.gfp.app.toolBar.HeadOgrePanel;
   import com.gfp.app.toolBar.HeadSelfPanel;
   import com.gfp.app.toolBar.TootalExpBar;
   import com.gfp.core.behavior.ChangeRideBehavior;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.info.SummonInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.DeffEquiptManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.RideManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.player.MovieClipPlayerEx;
   import com.gfp.core.utils.FilterUtil;
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1065 extends BaseMapProcess
   {
      
      private var _moduleOpen:CheckForOpenFeather;
      
      private var _timer:Vector.<int> = new Vector.<int>();
      
      private var _items:Vector.<InteractiveObject>;
      
      private var _modulePlayers:Vector.<MovieClipPlayerEx> = new Vector.<MovieClipPlayerEx>();
      
      private var _repeatEx:MovieClipPlayerEx;
      
      private var _repeatBtn:MovieClipPlayerEx;
      
      private var _repeatWord:MovieClipPlayerEx;
      
      private var _countDown:MovieClip;
      
      private var _dengtMc:Vector.<MovieClipPlayerEx> = new Vector.<MovieClipPlayerEx>();
      
      private var _dengcMc:Vector.<MovieClipPlayerEx> = new Vector.<MovieClipPlayerEx>();
      
      private var _res:Vector.<int> = new Vector.<int>();
      
      private var _resClone:Vector.<int> = new Vector.<int>();
      
      private var _closeBtn:SimpleButton;
      
      private var _lun:int;
      
      private var _numMc:MovieClip;
      
      private var _txtTimeMc:MovieClip;
      
      private var _expArr:Array = [20,40,60,90,140,200];
      
      private var _bornArr:Array = [5,10,15,25,40,60];
      
      private var _nowIndex:int = 0;
      
      private var dengFlash:Array = new Array();
      
      private var _tipMc:MovieClip;
      
      private var _tipNum:int = 0;
      
      private var dianboMc:MovieClipPlayerEx;
      
      private var _conTiaoMc:MovieClip;
      
      private var _guanMc:MovieClip;
      
      private var SWAP_ID:Array = new Array();
      
      private var str:String;
      
      private var btnC:MovieClipPlayerEx;
      
      private var _mapTimer:LeftTimeMovFeather;
      
      private var _mouseTips:MovieClip;
      
      private var index:int;
      
      public function MapProcess_1065()
      {
         super();
      }
      
      private static function onSwitchComplete(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,onSwitchComplete);
         CityToolBar.instance.show();
         FightManager.destroy();
         DeffEquiptManager.hideAllPlayer(false);
      }
      
      override protected function init() : void
      {
         var _loc1_:UserModel = null;
         var _loc3_:int = 0;
         if(RideManager.isOnRide)
         {
            MainManager.actorModel.execBehavior(new ChangeRideBehavior(0));
         }
         for each(_loc1_ in UserManager.getModels())
         {
            if(_loc1_.info as SummonInfo == SummonManager.getActorSummonInfo().currentSummonInfo)
            {
               _loc1_.visible = false;
            }
         }
         super.init();
         CityToolBar.instance.hide();
         TootalExpBar.show();
         FightAdded.hideToolbar();
         HeadSelfPanel.instance.init(MainManager.actorModel);
         HeadSelfPanel.instance.show();
         HeadOgrePanel.instance.start();
         MainManager.actorModel.clickEnabled = false;
         MainManager.actorModel.disableUserClick = false;
         SightManager.clear();
         DeffEquiptManager.hideAllPlayer(true);
         if(SummonManager.getUserSummonModel(MainManager.actorID))
         {
            SummonManager.getUserSummonModel(MainManager.actorID).visible = false;
         }
         if(!ClientTempState.IsForbiddenShowHePlaying)
         {
            AlertManager.showSimpleAlarm("小侠士，这里是守鹤禁地，非法入侵者将在3秒后被驱逐出境。");
            _loc3_ = int(setTimeout(this.fuckOffMyMap,3000));
            this._timer.push(_loc3_);
            return;
         }
         this._countDown = ClientTempState.ForbiddenCountDownMc;
         this._countDown.gotoAndPlay(1);
         LayerManager.topLevel.addChild(this._countDown);
         this._countDown.x = LayerManager.stageWidth / 2;
         this._countDown.y = LayerManager.stageHeight / 2;
         _mapModel.downLevel.addEventListener(Event.ENTER_FRAME,this.onCountDown);
         this.initMyMap();
         var _loc2_:int = 0;
         while(_loc2_ < 6)
         {
            this.SWAP_ID[_loc2_] = 7829 + _loc2_;
            _loc2_++;
         }
      }
      
      private function initMyMap() : void
      {
         var _loc1_:MovieClipPlayerEx = null;
         var _loc2_:InteractiveObject = null;
         var _loc3_:MovieClipPlayerEx = null;
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeCompleteHandler);
         this._txtTimeMc = _mapModel.libManager.getMovieClip("UI_TimeMc");
         this._tipMc = _mapModel.libManager.getMovieClip("UI_TIPS");
         this._conTiaoMc = _mapModel.libManager.getMovieClip("comTiaoMc");
         this._numMc = _mapModel.libManager.getMovieClip("UI_TXT");
         this._closeBtn = _mapModel.libManager.getButton("UI_CLOSEBTN");
         this._mouseTips = _mapModel.libManager.getMovieClip("UI_MOUSETIP");
         this._guanMc = _mapModel.libManager.getMovieClip("UI_GUAN");
         this._mapTimer = new LeftTimeMovFeather(3 * 60 * 1000,this._txtTimeMc,this.timeOut,1,false);
         this._numMc["exp"].text = "0";
         this._numMc["born"].text = "0";
         if(ClientTempState.IsForbiddenShowHePlaying)
         {
            LayerManager.topLevel.addChild(this._conTiaoMc);
            LayerManager.topLevel.addChild(this._numMc);
            LayerManager.topLevel.addChild(this._closeBtn);
            LayerManager.topLevel.addChild(this._txtTimeMc);
         }
         this._closeBtn.x = LayerManager.stageWidth - 100;
         this._closeBtn.y = 50;
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         this._numMc.x = 20;
         this._numMc.y = 150;
         this._conTiaoMc.x = LayerManager.stageWidth - 370;
         this._conTiaoMc.y = 95;
         this._txtTimeMc.x = LayerManager.stageWidth - 200;
         this._txtTimeMc.y = LayerManager.stageHeight - 100;
         this.lun = 1;
         this._items = new Vector.<InteractiveObject>();
         this._modulePlayers = new Vector.<MovieClipPlayerEx>();
         this.checkContentOpenElement(_mapModel.downLevel);
         this.checkContentOpenElement(_mapModel.nearLevel);
         if(ClientTempState.IsForbiddenShowHePlaying)
         {
            for each(_loc2_ in this._items)
            {
               _loc3_ = new MovieClipPlayerEx(_loc2_ as MovieClip);
               _loc2_.parent.addChild(_loc3_);
               _loc3_.x = _loc2_.x;
               _loc3_.y = _loc2_.y;
               _loc3_.name = _loc2_.name;
               if(_loc3_.name.indexOf("openAppc") == 0)
               {
                  this._dengcMc.push(_loc3_);
                  _loc3_.play();
                  _loc3_.buttonMode = true;
               }
               if(_loc3_.name.indexOf("openAppt") == 0)
               {
                  this._dengtMc.push(_loc3_);
                  _loc3_.visible = false;
               }
               if(_loc3_.name.indexOf("openAppreeff") == 0)
               {
                  this._repeatEx = _loc3_;
                  this._repeatEx.stop();
                  this._repeatEx.visible = false;
               }
               if(_loc3_.name.indexOf("openAppreword") == 0)
               {
                  this._repeatWord = _loc3_;
                  _loc3_.play();
               }
               if(_loc3_.name.indexOf("openAppreBtn") == 0)
               {
                  this._repeatBtn = _loc3_;
                  _loc3_.buttonMode = true;
               }
               this._modulePlayers.push(_loc3_);
               DisplayUtil.removeForParent(_loc2_);
            }
         }
      }
      
      protected function exchangeCompleteHandler(param1:ExchangeEvent) : void
      {
         this.index = this.SWAP_ID.indexOf(param1.info.id);
         if(this.index == -1)
         {
            return;
         }
         (this._numMc["exp"] as TextField).text = this._expArr[this.index].toString() + "万";
         (this._numMc["born"] as TextField).text = this._bornArr[this.index].toString();
      }
      
      private function addBtnEvent() : void
      {
         var _loc1_:MovieClipPlayerEx = null;
         for each(_loc1_ in this._dengcMc)
         {
            _loc1_.visible = true;
            _loc1_.addEventListener(MouseEvent.ROLL_OVER,this.overHandle);
            _loc1_.addEventListener(MouseEvent.ROLL_OUT,this.outHandle);
            _loc1_.addEventListener(MouseEvent.CLICK,this.onDengClick);
         }
         this._repeatBtn.addEventListener(MouseEvent.CLICK,this.onRepeat);
      }
      
      private function removeBtnEvent() : void
      {
         var _loc1_:MovieClipPlayerEx = null;
         for each(_loc1_ in this._dengcMc)
         {
            _loc1_.removeEventListener(MouseEvent.ROLL_OVER,this.overHandle);
            _loc1_.removeEventListener(MouseEvent.ROLL_OUT,this.outHandle);
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onDengClick);
         }
         this._repeatBtn.removeEventListener(MouseEvent.CLICK,this.onRepeat);
      }
      
      protected function overHandle(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClipPlayerEx).filters = FilterUtil.MOUSE_OVER_FILTER;
         if((param1.currentTarget as MovieClipPlayerEx).name.indexOf("openAppc") == 0)
         {
            (param1.currentTarget as MovieClipPlayerEx).addChild(this._mouseTips);
            this._mouseTips.play();
         }
      }
      
      protected function outHandle(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClipPlayerEx).filters = null;
         if((param1.currentTarget as MovieClipPlayerEx).name.indexOf("openAppc") == 0)
         {
            DisplayUtil.removeForParent(this._mouseTips);
         }
      }
      
      private function onCountDown(param1:Event) : void
      {
         if(this._countDown.currentFrame == this._countDown.totalFrames)
         {
            this._countDown.visible = false;
            this._countDown.stop();
            this.ranRes(this._lun);
            _mapModel.downLevel.removeEventListener(Event.ENTER_FRAME,this.onCountDown);
            this._mapTimer.start();
         }
      }
      
      private function startFlash() : void
      {
         this.removeBtnEvent();
         if(this._res.length != 0)
         {
            _mapModel.downLevel.getChildByName("openAppc" + this._res[0]).visible = false;
            this._dengtMc[this._res[0]].visible = true;
            this._dengtMc[this._res[0]].currentFrame = 1;
            this._dengtMc[this._res[0]].play();
            DepthManager.bringToTop(this._dengtMc[this._res[0]]);
            LayerManager.stage.addEventListener(Event.ENTER_FRAME,this.onFlash);
         }
      }
      
      protected function onFlash(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this._res.length == 0)
         {
            LayerManager.stage.removeEventListener(Event.ENTER_FRAME,this.onFlash);
            this.addBtnEvent();
            this._tipMc.gotoAndStop(2);
            this._tipMc.x = LayerManager.stageWidth / 2;
            _loc2_ = 0;
            while(_loc2_ < 4)
            {
               this._dengtMc[_loc2_].currentFrame = 1;
               _loc2_++;
            }
            return;
         }
         if(this._dengtMc[this._res[0]].currentFrame == this._dengtMc[this._res[0]].totalFrames)
         {
            this._dengtMc[this._res[0]].stop();
            this._dengtMc[this._res[0]].visible = false;
            _mapModel.downLevel.getChildByName("openAppc" + this._res[0]).visible = true;
            this._res.shift();
            if(this._res.length != 0)
            {
               this._dengtMc[this._res[0]].currentFrame = 1;
            }
            _loc3_ = int(setTimeout(this.lianShan,1000));
            this._timer.push(_loc3_);
         }
      }
      
      private function lianShan() : void
      {
         if(this._res.length != 0)
         {
            if(_mapModel)
            {
               _mapModel.downLevel.getChildByName("openAppc" + this._res[0]).visible = false;
            }
            if(this._dengtMc[this._res[0]])
            {
               this._dengtMc[this._res[0]].visible = true;
               this._dengtMc[this._res[0]].play();
               DepthManager.bringToTop(this._dengtMc[this._res[0]]);
            }
         }
      }
      
      private function checkContentOpenElement(param1:DisplayObjectContainer) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc2_:int = param1.numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.getChildAt(_loc3_);
            if(_loc4_ is InteractiveObject && _loc4_.name.indexOf("openApp") == 0)
            {
               this._items.push(_loc4_ as InteractiveObject);
            }
            _loc3_++;
         }
      }
      
      private function fuckOffMyMap() : void
      {
         if(ClientTempState.IsForbiddenShowHePlaying)
         {
            MapManager.setMapEndAction("open:ForbiddenShowHePanel");
         }
         else
         {
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onSwitchComplete);
         }
         ClientTempState.IsForbiddenShowHePlaying = false;
         CityMap.instance.changeMap(1);
         this.destroy();
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         this.fuckOffMyMap();
      }
      
      private function onRepeat(param1:MouseEvent) : void
      {
         while(this._res.length != 0)
         {
            this._res.pop();
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._resClone.length)
         {
            this._res.push(this._resClone[_loc2_]);
            _loc2_++;
         }
         this.startFlash();
      }
      
      private function onDengClick(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         this.btnC = param1.currentTarget as MovieClipPlayerEx;
         param1.currentTarget.visible = false;
         this.removeBtnEvent();
         this.str = param1.currentTarget.name.charAt(8);
         var _loc2_:int = int(this.str) + 2;
         this.outHandle(param1);
         if(this.str != this._resClone[this._nowIndex].toString())
         {
            this._tipMc.x = LayerManager.stageWidth / 2;
            this._tipMc.gotoAndStop(3);
         }
         else
         {
            this._tipMc.gotoAndStop(2);
            this._conTiaoMc["deng" + this._nowIndex].gotoAndStop(_loc2_);
            ++this._nowIndex;
         }
         if(this._nowIndex == this._lun && this._lun <= 6)
         {
            ActivityExchangeCommander.exchange(this.SWAP_ID[this._lun - 1]);
            this._tipMc.x = LayerManager.stageWidth / 2;
            this._tipMc.gotoAndStop(4);
            this._nowIndex = 0;
            if(this._lun < 6)
            {
               _loc3_ = int(setTimeout(this.changeLun,3000));
               this._timer.push(_loc3_);
            }
            else
            {
               AlertManager.showSimpleAlarm("恭喜小侠士成功闯过守鹤禁地共获得200万仙兽经验和60仙兽成长，3秒钟后护送小侠士安全出境。");
               _loc3_ = int(setTimeout(this.fuckOffMyMap,3000));
               this._timer.push(_loc3_);
            }
         }
         this.dianboMc = _mapModel.downLevel.getChildByName("openAppt" + this.str) as MovieClipPlayerEx;
         this.dianboMc.currentFrame = 1;
         this.dianboMc.visible = true;
         this.dianboMc.play();
         DepthManager.bringToTop(this.dianboMc);
         LayerManager.stage.addEventListener(Event.ENTER_FRAME,this.dianBo);
      }
      
      private function timeOut() : void
      {
         AlertManager.showSimpleAlarm("很遗憾，小侠士没有能在规定时间内闯过守鹤禁地，共获得" + this._expArr[this.index] + "万仙兽经验和" + this._bornArr[this.index] + "仙兽成长,3秒钟后护送小侠士安全出境。");
         var _loc1_:int = int(setTimeout(this.fuckOffMyMap,3000));
         this._timer.push(_loc1_);
      }
      
      private function changeLun() : void
      {
         ++this.lun;
         this.ranRes(this.lun);
      }
      
      protected function dianBo(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(this.dianboMc.currentFrame == this.dianboMc.totalFrames)
         {
            LayerManager.stage.removeEventListener(Event.ENTER_FRAME,this.dianBo);
            this.dianboMc.visible = false;
            this.btnC.visible = true;
            _loc2_ = 0;
            while(_loc2_ < 4)
            {
               this._dengtMc[_loc2_].currentFrame = 1;
               _loc2_++;
            }
            this.addBtnEvent();
         }
      }
      
      private function ranRes(param1:int) : void
      {
         this.tipIn(1);
         while(this._res.length != 0)
         {
            this._res.pop();
         }
         while(this._resClone.length != 0)
         {
            this._resClone.pop();
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1)
         {
            this._res.push(int(Math.random() * 4));
            this._resClone.push(this._res[_loc2_]);
            _loc2_++;
         }
         DisplayUtil.removeForParent(this._mouseTips);
         this.startFlash();
      }
      
      override public function destroy() : void
      {
         var _loc1_:int = 0;
         MainManager.actorModel.clickEnabled = true;
         MainManager.actorModel.disableUserClick = true;
         for each(_loc1_ in this._timer)
         {
            clearTimeout(_loc1_);
         }
         if(this._mapTimer)
         {
            this._mapTimer.destroy();
         }
         if(this._countDown)
         {
            DisplayUtil.removeForParent(this._countDown);
         }
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,onSwitchComplete);
         LayerManager.stage.removeEventListener(Event.ENTER_FRAME,this.dianBo);
         LayerManager.stage.removeEventListener(Event.ENTER_FRAME,this.onFlash);
         if(this._tipMc)
         {
            DisplayUtil.removeForParent(this._tipMc);
         }
         if(this._conTiaoMc)
         {
            DisplayUtil.removeForParent(this._conTiaoMc);
         }
         if(this._closeBtn)
         {
            DisplayUtil.removeForParent(this._closeBtn);
         }
         if(this._numMc)
         {
            DisplayUtil.removeForParent(this._numMc);
         }
         if(this._txtTimeMc)
         {
            DisplayUtil.removeForParent(this._txtTimeMc);
         }
         super.destroy();
         if(this._moduleOpen)
         {
            this._moduleOpen.destory();
            this._moduleOpen = null;
         }
         FightAdded.showToolbar();
         CityToolBar.instance.show();
         FightManager.destroy();
         DeffEquiptManager.hideAllPlayer(true);
      }
      
      private function tipIn(param1:int) : void
      {
         LayerManager.topLevel.addChild(this._tipMc);
         this._tipMc.gotoAndStop(param1);
         this._tipMc.x = -1200;
         this._tipMc.y = 20 + this._tipNum * this._tipMc.height;
         TweenLite.to(this._tipMc,0.5,{
            "x":LayerManager.stageWidth / 2,
            "y":20 + this._tipNum * this._tipMc.height
         });
      }
      
      private function tipOut(param1:int) : void
      {
         this._tipMc.gotoAndStop(param1);
         TweenLite.to(this._tipMc,0.5,{
            "x":1200,
            "onComplete":this.tipMcGone
         });
      }
      
      private function tipMcGone() : void
      {
         DisplayUtil.removeForParent(this._tipMc);
      }
      
      private function guanIn(param1:int) : void
      {
         LayerManager.topLevel.addChild(this._guanMc);
         this._guanMc["mc"].gotoAndStop(param1);
         this._guanMc.x = -1200;
         this._guanMc.y = LayerManager.stageHeight / 2;
         TweenLite.to(this._guanMc,0.5,{
            "x":0,
            "onComplete":this.guanMcGone
         });
      }
      
      private function guanMcGone() : void
      {
         var _loc1_:int = int(setTimeout(this.guanMcDes,1000));
         this._timer.push(_loc1_);
      }
      
      private function guanMcDes() : void
      {
         TweenLite.to(this._guanMc,0.5,{
            "x":LayerManager.stageWidth,
            "onComplete":this.guanMcRem
         });
      }
      
      private function guanMcRem() : void
      {
         DisplayUtil.removeForParent(this._guanMc);
      }
      
      private function set lun(param1:int) : void
      {
         this._lun = param1;
         var _loc2_:int = 0;
         while(_loc2_ < param1)
         {
            this._conTiaoMc["deng" + _loc2_].visible = true;
            this._conTiaoMc["deng" + _loc2_].gotoAndStop(1);
            this.guanIn(this._lun);
            _loc2_++;
         }
         while(_loc2_ < 6)
         {
            this._conTiaoMc["deng" + _loc2_].visible = false;
            _loc2_++;
         }
      }
      
      private function get lun() : int
      {
         return this._lun;
      }
   }
}

