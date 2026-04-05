package com.gfp.app.feature
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PvpEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.KeyController;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.CommEvent;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.CustomEventMananger;
   import com.gfp.core.manager.HiddenManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.HiddenModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.component.ProcessTimeBar;
   import com.gfp.core.utils.HiddenState;
   import com.gfp.core.utils.TimeUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class SanGuoChiBiFeather
   {
      
      private var _ui:Sprite;
      
      private var _infoMc:MovieClip;
      
      private var _arrowMc:MovieClip;
      
      private var _flag:MovieClip;
      
      private var _backMc:MovieClip;
      
      private var _keyMc:MovieClip;
      
      private var _flagMc:MovieClip;
      
      private var _backTxt:TextField;
      
      private var _nameTxt:TextField;
      
      private var _nameTxts:Vector.<TextField> = new Vector.<TextField>();
      
      private var _reBornLeftFeather:LeftTimeTxtFeater;
      
      private var _leftFeather:LeftTimeTxtFeater;
      
      private var _processBar:ProcessTimeBar;
      
      private var _processModel:HiddenModel;
      
      private var _processTimer:int;
      
      private var _leftTimeTxt:TextField;
      
      private var _currentFlagUserId:int = 0;
      
      private var _initTimer:Number;
      
      public function SanGuoChiBiFeather()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         this._initTimer = TimeUtil.getSeverDateObject().time;
         SwfCache.getSwfInfo(ClientConfig.getSubUI("chi_bi_battle"),this.onUILoaded);
      }
      
      private function addEvent() : void
      {
         StageResizeController.instance.register(this.layout);
         SocketConnection.addCmdListener(CommandID.FIGHT_ACTIVITY_EFFECT,this.activityEffect);
         CustomEventMananger.addEventLisnter(CustomEventMananger.SAN_GUO_CHI_BI_START_TAKE,this.onStartTake);
         SocketConnection.addCmdListener(CommandID.FIGHT_COMMON_NOTIFY,this.onInfo);
         FightManager.instance.addEventListener(FightEvent.OGRE_DIE,this.onOgreDie);
         MapManager.addEventListener(MapEvent.STAGE_USER_LISET_COMPLETE,this.onUserLoadComplete);
         MainManager.actorModel.addEventListener(UserEvent.RE_BORN,this.onUserReBorn);
      }
      
      private function removeEvent() : void
      {
         StageResizeController.instance.unregister(this.layout);
         SocketConnection.removeCmdListener(CommandID.FIGHT_ACTIVITY_EFFECT,this.activityEffect);
         CustomEventMananger.removeEventLisnter(CustomEventMananger.SAN_GUO_CHI_BI_START_TAKE,this.onStartTake);
         SocketConnection.removeCmdListener(CommandID.FIGHT_COMMON_NOTIFY,this.onInfo);
         FightManager.instance.removeEventListener(FightEvent.OGRE_DIE,this.onOgreDie);
         MapManager.removeEventListener(MapEvent.STAGE_USER_LISET_COMPLETE,this.onUserLoadComplete);
         MainManager.actorModel.removeEventListener(UserEvent.RE_BORN,this.onUserReBorn);
      }
      
      private function onUserReBorn(param1:UserEvent) : void
      {
         this.onLive();
      }
      
      private function onUserLoadComplete(param1:Event) : void
      {
         var _loc3_:UserInfo = null;
         var _loc4_:UserModel = null;
         var _loc2_:Array = PvpEntry.instance.fightReadyInfo.roles;
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = UserManager.getModel(_loc3_.userID);
            if(_loc4_)
            {
               _loc4_.info.countryId = _loc3_.countryId;
            }
         }
         this.updateNames();
      }
      
      private function updateNames() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this._nameTxts) && this._nameTxts.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < 3)
            {
               this._nameTxts[_loc1_].text = this.getUserNameByCountry(_loc1_);
               _loc1_++;
            }
         }
      }
      
      private function getUserNameByCountry(param1:int) : String
      {
         var _loc3_:UserInfo = null;
         var _loc2_:Array = PvpEntry.instance.fightReadyInfo.roles;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.countryId == param1)
            {
               return _loc3_.nick;
            }
         }
         return null;
      }
      
      private function onOgreDie(param1:FightEvent) : void
      {
         var _loc2_:UserInfo = param1.data as UserInfo;
         if(_loc2_.userID == MainManager.actorID && _loc2_.createTime == MainManager.actorInfo.createTime)
         {
            this.onDie();
         }
      }
      
      private function onInfo(param1:SocketEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:HiddenModel = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = _loc2_.readInt();
         if(_loc3_ == 1120)
         {
            _loc4_ = _loc2_.readInt();
            this.addFlag(_loc4_);
            if(_loc4_ == 0)
            {
               _loc5_ = UserManager.getModelByRoleType(30049) as HiddenModel;
               if(_loc5_)
               {
                  HiddenManager.executeStateChange(_loc5_.info.userID,HiddenState.STATE_HIDDEN);
               }
            }
         }
      }
      
      private function onStartTake(param1:CommEvent) : void
      {
         this.showProcess(param1.data.model,param1.data.duration,param1.data.timer);
      }
      
      public function showProcess(param1:HiddenModel, param2:int, param3:int) : void
      {
         this._processModel = param1;
         this._processTimer = param3;
         if(this._processBar)
         {
            this._processBar.reset(param2);
         }
         else
         {
            this._processBar = new ProcessTimeBar(param2,this.processComplete);
         }
         this._processBar.x = param1.x - 20;
         this._processBar.y = param1.y - param1.height - 20;
         MapManager.currentMap.upLevel.addChild(this._processBar);
      }
      
      private function stopProcess() : void
      {
         if(this._processBar)
         {
            this._processBar.stop();
         }
         clearTimeout(this._processTimer);
         this._processTimer = 0;
      }
      
      private function processComplete() : void
      {
      }
      
      private function activityEffect(param1:SocketEvent) : void
      {
         var _loc6_:HiddenModel = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:int = int(_loc2_.readUnsignedInt());
         if(_loc3_ == 1120)
         {
            if(_loc5_ == 1)
            {
               this.stopProcess();
               this.addFlag(_loc4_);
               _loc6_ = UserManager.getModelByRoleType(30049) as HiddenModel;
               if(_loc6_)
               {
                  HiddenManager.executeStateChange(_loc6_.info.userID,HiddenState.STATE_OPEN);
               }
            }
            else
            {
               this.stopProcess();
               _loc6_ = UserManager.getModelByRoleType(30049) as HiddenModel;
               if(_loc6_)
               {
                  HiddenManager.executeStateChange(_loc6_.info.userID,HiddenState.STATE_HIDDEN);
               }
            }
         }
      }
      
      private function addFlag(param1:int) : void
      {
         if(param1 == 0)
         {
            param1 = 30049;
         }
         var _loc2_:UserModel = UserManager.getModel(param1);
         if(_loc2_ == null)
         {
            _loc2_ = UserManager.getModelByRoleType(param1);
         }
         this._currentFlagUserId = param1;
         if(Boolean(_loc2_) && Boolean(_loc2_.info) && Boolean(this._flag))
         {
            this._flag.x = 0;
            this._flag.y = -_loc2_.height;
            _loc2_.addChild(this._flag);
            this._flagMc.gotoAndStop(_loc2_.info.countryId + 1);
            this._nameTxt.text = _loc2_.info.nick;
         }
         this.checkFlagTipInfo();
      }
      
      protected function layout() : void
      {
         if(this._ui)
         {
            this._ui.x = LayerManager.stageWidth - 644 >> 1;
            this._ui.y = 50;
            this._backMc.x = LayerManager.stageWidth - this._backMc.width - 20;
            this._backMc.y = 150;
         }
      }
      
      private function onDie() : void
      {
         if(this._reBornLeftFeather)
         {
            this._reBornLeftFeather.start();
         }
         if(this._backMc)
         {
            this._backMc.visible = true;
         }
      }
      
      private function onLive() : void
      {
         if(this._reBornLeftFeather)
         {
            this._reBornLeftFeather.clear();
         }
         if(this._backMc)
         {
            this._backMc.visible = false;
         }
      }
      
      private function onUILoaded(param1:SwfInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         if(this._ui == null)
         {
            this._ui = param1.content as MovieClip;
            this._infoMc = this._ui["infoMc"];
            this._backMc = this._ui["backMc"];
            this._backMc.visible = false;
            this._arrowMc = this._ui["arrowMc"];
            this._flag = this._ui["flag"];
            this._flag.mouseChildren = false;
            this._flag.mouseEnabled = false;
            this._flag.cacheAsBitmap = true;
            this._ui.removeChild(this._flag);
            _loc2_ = 0;
            while(_loc2_ < 3)
            {
               this._nameTxts.push(this._ui["nameTxt" + _loc2_]);
               _loc2_++;
            }
            this._leftTimeTxt = this._ui["leftTimeTxt"];
            _loc3_ = TimeUtil.getSeverDateObject().time - this._initTimer;
            this._leftFeather = new LeftTimeTxtFeater(2 * 60 * 1000 - _loc3_,this._leftTimeTxt,null);
            this._leftFeather.start();
            this._keyMc = this._arrowMc["keyMc"];
            this._flagMc = this._infoMc["flagMc"];
            this._flagMc.gotoAndStop(4);
            this._backTxt = this._backMc["backTxt"];
            this._nameTxt = this._infoMc["nameTxt"];
            LayerManager.uiLevel.addChild(this._ui);
            LayerManager.uiLevel.addChild(this._backMc);
            this._reBornLeftFeather = new LeftTimeTxtFeater(10 * 1000,this._backTxt,this.onLeftTimeCome);
            this.addFlag(this._currentFlagUserId);
            if(KeyController.currentControlType == 1)
            {
               this._keyMc.gotoAndStop(2);
            }
            else
            {
               this._keyMc.gotoAndStop(1);
            }
            this.layout();
            this.update();
         }
      }
      
      private function onLeftTimeCome() : void
      {
      }
      
      public function destory() : void
      {
         this.removeEvent();
         SwfCache.cancel(ClientConfig.getSubUI("san_guo_hit_info"),this.onUILoaded);
         if(this._ui)
         {
            DisplayUtil.removeForParent(this._ui);
         }
         if(this._reBornLeftFeather)
         {
            this._reBornLeftFeather.destroy();
         }
         if(this._leftFeather)
         {
            this._leftFeather.destroy();
         }
         DisplayUtil.removeForParent(this._flag);
      }
      
      public function update() : void
      {
         this.updateNames();
      }
      
      private function checkFlagTipInfo() : void
      {
         if(this._currentFlagUserId == 0 || this._currentFlagUserId == 30049)
         {
            this._infoMc.visible = false;
            this._arrowMc.visible = true;
         }
         else
         {
            this._infoMc.visible = true;
            this._arrowMc.visible = false;
         }
      }
   }
}

