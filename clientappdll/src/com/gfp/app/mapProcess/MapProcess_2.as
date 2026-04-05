package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AdvanceAnimat;
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.manager.FashionClothMananger;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.app.task.tc.TaskXML_HeartFight;
   import com.gfp.app.toolBar.AmbassadorEntry;
   import com.gfp.app.toolBar.CityToolBar;
   import com.gfp.app.user.UserInfoController;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.ActionInfo;
   import com.gfp.core.action.BaseAction;
   import com.gfp.core.behavior.ChangeRideBehavior;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.AdvancedManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.DeffEquiptManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.RideManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.PeopleModel;
   import com.gfp.core.model.SightView;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.Direction;
   import com.gfp.core.utils.RoleEquipType;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_2 extends MapProcessAnimat
   {
      
      private var _badgeTimeCode:uint = 0;
      
      private var _restAnimation:MovieClip;
      
      private var _doubleIntro:MovieClip;
      
      private var _moonStoneIntroAnimation:MovieClip;
      
      private var _moonStoneGotAnimation:MovieClip;
      
      private var _moonStoneCombineAnimation:MovieClip;
      
      private var _friendAnimation:MovieClip;
      
      private var _joeAnimation0:MovieClip;
      
      private var _joeEndAnimation:MovieClip;
      
      private var _wuSheng0:UserModel;
      
      private var _attPlayer:PeopleModel;
      
      private var _npcTime:uint;
      
      private var _playerTime:uint;
      
      private var _bawangMc:MovieClip;
      
      private var _preHideSetting:Boolean;
      
      private var _bawangInfo:UserInfo;
      
      private var _bawangModel:PeopleModel;
      
      public function MapProcess_2()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.task29FirstStepFinish();
         this.addTaskManagerEventListener();
         this.initTask37();
         var _loc1_:SightModel = SightManager.getSightModel(10001);
         if(Boolean(TasksManager.isCompleted(2083)) || Boolean(TasksManager.isProcess(2083,3)))
         {
            if(_loc1_)
            {
               if(Boolean(TasksManager.isCompleted(2148)) || Boolean(TasksManager.isAccepted(2148)) && Boolean(TasksManager.isTaskProComplete(2148,1)))
               {
                  _loc1_.changeNpcView(10555);
               }
               else
               {
                  _loc1_.changeNpcView(10215);
               }
            }
         }
         if(!TasksManager.isCompleted(2) || MainManager.actorInfo.lv < 80 && TasksManager.isCompleted(519) == false)
         {
            if(!DeffEquiptManager.isHideAllPlayer)
            {
               this._preHideSetting = true;
               DeffEquiptManager.hideAllPlayer(true);
            }
         }
         if(MainManager.actorInfo.lv < 60)
         {
            UserManager.addEventListener(UserEvent.BORN,this.onUserBorn);
         }
      }
      
      private function onUserBorn(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_)
         {
            _loc2_.hide();
         }
      }
      
      private function initBaWangModal() : void
      {
         this._bawangMc.buttonMode = true;
         this._bawangMc.useHandCursor = true;
         this._bawangMc.addEventListener(MouseEvent.CLICK,this.onModalClick);
         (this._bawangMc["nameMc"] as MovieClip).gotoAndStop(MainManager.loginInfo.lineType);
         var _loc1_:Array = [220033970,225406678];
         var _loc2_:Array = [1299923000,1391000994];
         this._bawangInfo = new UserInfo();
         this._bawangInfo.userID = _loc1_[MainManager.loginInfo.lineType - 1];
         this._bawangInfo.createTime = _loc2_[MainManager.loginInfo.lineType - 1];
         UserInfoManager.upDateSimpleInfo(this._bawangInfo,this.updateCallBack);
      }
      
      private function onModalClick(param1:MouseEvent) : void
      {
         UserInfoController.showForID(this._bawangInfo.userID,true,this._bawangInfo.createTime,true);
      }
      
      private function updateCallBack(param1:UserInfo) : void
      {
         this._bawangModel = new PeopleModel(param1);
         this._bawangModel.hideNick();
         this._bawangModel.hideNick();
         this._bawangModel.hideRing();
         this._bawangModel.hideSmog();
         this._bawangModel.direction = Direction.LEFT;
         this._bawangModel.vipIconVisible = false;
         this._bawangMc.addChildAt(this._bawangModel,0);
         this._bawangModel.x = 0;
         this._bawangModel.y = 0;
      }
      
      private function addTaskManagerEventListener() : void
      {
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
      }
      
      private function removeTaskManagerEventListener() : void
      {
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         var _loc5_:AdvanceAnimat = null;
         var _loc2_:uint = uint(param1.taskID);
         if(_loc2_ == 1157)
         {
            this.activeAmbassadorTask();
         }
         else if(_loc2_ == 1719)
         {
            NpcDialogController.showForNpc(10001);
         }
         else if(_loc2_ == 1722)
         {
            NpcDialogController.showForNpc(10158);
         }
         else if(_loc2_ == 1729)
         {
            _loc5_ = new AdvanceAnimat();
            _loc5_.play();
         }
         else if(_loc2_ == 1333)
         {
            MainManager.actorInfo.changeClothID = 1;
            MainManager.actorInfo.isCanChangeCloth = true;
            FashionClothMananger.instance.resetActorModel();
            SocketConnection.send(CommandID.CHANGE_ROLE,RoleEquipType.SAIYA);
         }
         else if(_loc2_ == 1926)
         {
            AdvancedManager.instance.advanced3();
         }
         else if(_loc2_ == 2 || _loc2_ == 519)
         {
            if(this._preHideSetting)
            {
               DeffEquiptManager.hideAllPlayer(false);
            }
         }
         var _loc3_:SightModel = SightManager.getSightModel(10003);
         var _loc4_:SightModel = SightManager.getSightModel(10004);
         if(_loc2_ == 2083)
         {
            _loc3_.player.visible = false;
            _loc3_.addChild(_loc4_.player as SightView);
         }
      }
      
      private function activeAmbassadorTask() : void
      {
         SocketConnection.addCmdListener(CommandID.SET_ANBASSADOR_STATE,this.onSetAnbState);
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeByte(1);
         SocketConnection.send(CommandID.SET_ANBASSADOR_STATE,_loc1_);
      }
      
      public function onSetAnbState(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.SET_ANBASSADOR_STATE,this.onSetAnbState);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = _loc2_.readByte();
         MainManager.actorInfo.ambassadorTaskState = _loc3_;
         AmbassadorEntry.instance.show();
         AlertManager.showSimpleAlarm(AppLanguageDefine.NPC_DIALOG_MAP2[0]);
         ModuleManager.turnModule(ClientConfig.getAppModule("AmbassadorTask"),AppLanguageDefine.LOAD_MATTER_COLLECTION[6]);
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 1723)
         {
            NpcDialogController.showForNpc(10158);
         }
         if(param1.taskID == 1126)
         {
            AmbassadorEntry.instance.show();
         }
         else if(param1.taskID == 34)
         {
            NpcDialogController.showForNpc(10001);
         }
         else if(param1.taskID == 1270)
         {
            NpcDialogController.showForNpc(10003);
         }
         else if(param1.taskID == 1294 || param1.taskID == 1297)
         {
            NpcDialogController.showForNpc(10003);
         }
         if(param1.taskID == 1313)
         {
            NpcDialogController.showForNpc(10003);
         }
         if(param1.taskID == 1314)
         {
            NpcDialogController.showForNpc(10003);
         }
         if(param1.taskID == 1315)
         {
            ModuleManager.turnModule(ClientConfig.getAppModule("BrainsPanel"),AppLanguageDefine.NPC_DIALOG_MAP2[1]);
         }
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:SightModel = null;
         if(param1.taskID == 1722 && param1.proID == 0)
         {
            NpcDialogController.showForNpc(10158);
         }
         if(param1.taskID == 1723 && param1.proID == 1)
         {
            NpcDialogController.showForNpc(10158);
         }
         if(param1.taskID == 1313)
         {
            if(param1.proID == 0 || param1.proID == 4)
            {
               ModuleManager.turnModule(ClientConfig.getAppModule("BrainsPanel"),AppLanguageDefine.NPC_DIALOG_MAP2[1]);
            }
            if(param1.proID == 5)
            {
               NpcDialogController.showForNpc(10003);
            }
         }
         if(param1.taskID == 53)
         {
            if(param1.proID == 0)
            {
               CityMap.instance.changeMap(15,0,1,new Point(700,260));
            }
         }
         if(param1.taskID == 54)
         {
            if(param1.proID == 1)
            {
               CityMap.instance.changeMap(15,0,1,new Point(240,260));
            }
         }
         if(param1.taskID == 1925)
         {
            if(param1.proID == 0)
            {
               _loc2_ = TaskXML_HeartFight.getTollgateID();
               if(0 != _loc2_)
               {
                  PveEntry.enterTollgate(_loc2_);
               }
            }
         }
         if(param1.taskID == 3 && param1.proID == 0)
         {
            CityToolBar.instance.setSkillBtnFlash(false);
         }
         if(param1.taskID == 2148 && param1.proID == 1)
         {
            _loc3_ = SightManager.getSightModel(10001);
            if(_loc3_)
            {
               _loc3_.changeNpcView(10555);
            }
         }
      }
      
      private function playJoeEndAnimation() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_MAPCOLLECT,"joeEscape");
         this._joeEndAnimation = _mapModel.libManager.getMovieClip("JoeEndAnimation");
         this._joeEndAnimation.x = 200;
         this._joeEndAnimation.y = 107;
         this._joeEndAnimation.addEventListener(Event.ENTER_FRAME,this.onJoeEndAnimationPlay);
         _mapModel.contentLevel.addChild(this._joeEndAnimation);
         SightManager.getSightModel(10001).hide();
      }
      
      private function onJoeEndAnimationPlay(param1:Event) : void
      {
         _mapModel.contentLevel.addChild(this._joeEndAnimation);
         if(this._joeEndAnimation.currentFrame == this._joeEndAnimation.totalFrames)
         {
            this._joeEndAnimation.removeEventListener(Event.ENTER_FRAME,this.onJoeEndAnimationPlay);
            DisplayUtil.removeForParent(this._joeEndAnimation);
            MainManager.openOperate();
            this._joeEndAnimation = null;
            SightManager.getSightModel(10001).show();
         }
      }
      
      private function hideNpc() : void
      {
         var _loc1_:SightModel = SightManager.getSightModel(10003);
         var _loc2_:SightModel = SightManager.getSightModel(10004);
         _loc1_.hide();
         _loc2_.hide();
      }
      
      private function showNpc() : void
      {
         var _loc1_:SightModel = SightManager.getSightModel(10003);
         var _loc2_:SightModel = SightManager.getSightModel(10004);
         _loc1_.show();
         _loc2_.show();
      }
      
      private function onDegreeClick(param1:MouseEvent) : void
      {
         ModuleManager.turnModule(ClientConfig.getAppModule("PromotionNoticePanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[7]);
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_MAPCOLLECT,"degreeTip");
      }
      
      private function task29FirstStepFinish() : void
      {
         if(TasksManager.isTaskProComplete(29,0))
         {
            NpcDialogController.showForNpc(10004);
         }
      }
      
      private function initTask37() : void
      {
         if(Boolean(TasksManager.isAccepted(37)) && TasksManager.isTaskProComplete(37,1) == false)
         {
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         }
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         MainManager.closeOperate();
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         if(TasksManager.isTaskProComplete(37,0) == false)
         {
            this._joeAnimation0 = _mapModel.libManager.getMovieClip("JoeAnimation0");
            this._joeAnimation0["roleIndex"] = MainManager.actorInfo.roleType;
            this._joeAnimation0.x = 0;
            this._joeAnimation0.y = 143;
            this._joeAnimation0.addEventListener(Event.ENTER_FRAME,this.onJoeAnimationPlay);
            _mapModel.contentLevel.addChild(this._joeAnimation0);
            MainManager.actorModel.x = 720;
            MainManager.actorModel.y = 400;
         }
         else if(TasksManager.isTaskProComplete(37,0) == true)
         {
            this.playJoeEndAnimation();
         }
         _mapModel.camera.scroll(200,42);
      }
      
      private function onJoeAnimationPlay(param1:Event) : void
      {
         _mapModel.contentLevel.addChild(this._joeAnimation0);
         if(this._joeAnimation0.currentFrame == 145)
         {
            MainManager.actorModel.direction = Direction.LEFT;
         }
         if(this._joeAnimation0.currentFrame == this._joeAnimation0.totalFrames)
         {
            this._joeAnimation0.removeEventListener(Event.ENTER_FRAME,this.onJoeAnimationPlay);
            DisplayUtil.removeForParent(this._joeAnimation0);
            this._joeAnimation0 = null;
            ModuleManager.turnModule(ClientConfig.getGameModule("FightJoe"),AppLanguageDefine.LOAD_MATTER_COLLECTION[5]);
         }
      }
      
      private function onWushengExprience(param1:Event) : void
      {
         MapManager.removeEventListener("wusheng_experience",this.onWushengExprience);
         if(RideManager.isOnRide)
         {
            MainManager.actorModel.execBehavior(new ChangeRideBehavior(0));
         }
         this.hideSights();
         DeffEquiptManager.hideAllPlayer(true);
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.animateEndHandler);
         AnimatPlay.startAnimat("scenceAnimat_",207,false,0.1,0);
         if(SummonManager.getActorSummonInfo().currentSummonInfo)
         {
            SummonManager.setActorSummonVisible(false);
         }
      }
      
      private function hideSights() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 16)
         {
            SightManager.hide(_loc1_);
            _loc1_++;
         }
      }
      
      private function showSights() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 16)
         {
            SightManager.show(_loc1_);
            _loc1_++;
         }
      }
      
      private function animateEndHandler(param1:AnimatEvent) : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.animateEndHandler);
         var _loc2_:String = param1.data as String;
         if(_loc2_ == "scenceAnimat_207")
         {
            MainManager.closeOperate(true,true,false);
            MainManager.actorModel.changeRoleView(11474);
            this.addWuSheng();
            this.addPlyer();
            return;
         }
         this.removeWusheng();
         MainManager.openOperate();
         this.showSights();
         this.init();
      }
      
      private function addWuSheng() : void
      {
         var _loc1_:UserInfo = new UserInfo();
         _loc1_.pos = new Point(800,300);
         _loc1_.roleType = 11475;
         this._wuSheng0 = new UserModel(_loc1_);
         this._wuSheng0.hideNick();
         MapManager.currentMap.contentLevel.addChild(this._wuSheng0);
      }
      
      private function addPlyer() : void
      {
         var _loc4_:SingleEquipInfo = null;
         var _loc1_:UserInfo = new UserInfo();
         _loc1_.roleType = 1;
         _loc1_.direction = 1;
         _loc1_.lv = 65;
         var _loc2_:Vector.<SingleEquipInfo> = new Vector.<SingleEquipInfo>();
         var _loc3_:int = 0;
         while(_loc3_ < 7)
         {
            _loc4_ = new SingleEquipInfo();
            _loc4_.itemID = 190001 + _loc3_;
            _loc1_.clothes.push(_loc4_);
            _loc3_++;
         }
         this._attPlayer = new PeopleModel(_loc1_);
         this._attPlayer.pos = new Point(870,300);
         MapManager.currentMap.contentLevel.addChild(this._attPlayer);
         this._attPlayer.addEventListener(Event.ENTER_FRAME,this.onFrame);
         this._npcTime = setInterval(this.doNpcAction,3000);
      }
      
      private function doNpcAction() : void
      {
         var _loc1_:ActionInfo = ActionXMLInfo.getInfo(20001);
         this._wuSheng0.execAction(new BaseAction(_loc1_));
         _loc1_ = ActionXMLInfo.getInfo(50102);
         this._attPlayer.execAction(new BaseAction(_loc1_));
      }
      
      private function onFrame(param1:Event) : void
      {
         if(this._attPlayer.hitTestObject(MainManager.actorModel))
         {
            this._attPlayer.removeEventListener(Event.ENTER_FRAME,this.onFrame);
            MainManager.actorModel.execStandAction(false);
            AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.animateEndHandler);
            AnimatPlay.startAnimat("scenceAnimat_",208,true);
         }
      }
      
      private function removeWusheng() : void
      {
         clearInterval(this._npcTime);
         MapManager.removeEventListener("wusheng_experience",this.onWushengExprience);
         if(SummonManager.getActorSummonInfo().currentSummonInfo)
         {
            SummonManager.setActorSummonVisible(true);
         }
         if(this._wuSheng0)
         {
            this._wuSheng0.destroy();
            this._wuSheng0 = null;
         }
         if(this._attPlayer)
         {
            this._attPlayer.removeEventListener(Event.ENTER_FRAME,this.onFrame);
            DisplayUtil.removeForParent(this._attPlayer);
            this._attPlayer.destroy();
            this._attPlayer = null;
         }
         DeffEquiptManager.hideAllPlayer(false);
         MainManager.actorModel.resetRoleView();
      }
      
      override public function destroy() : void
      {
         if(this._badgeTimeCode != 0)
         {
            clearTimeout(this._badgeTimeCode);
            this._badgeTimeCode = 0;
         }
         this.removeTaskManagerEventListener();
         if(this._preHideSetting)
         {
            DeffEquiptManager.isHideAllPlayer = false;
         }
         super.destroy();
         if(this._bawangMc)
         {
            this._bawangMc.addEventListener(MouseEvent.CLICK,this.onModalClick);
         }
         if(this._bawangModel)
         {
            this._bawangModel.destroy();
         }
         UserManager.removeEventListener(UserEvent.BORN,this.onUserBorn);
      }
   }
}

