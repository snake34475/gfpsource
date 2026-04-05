package com.gfp.app.toolBar
{
   import com.gfp.app.config.xml.TransfigurationXMLInfo;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.manager.EscortManager;
   import com.gfp.app.manager.FightGroupManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.ActionInfo;
   import com.gfp.core.action.normal.SkillAction;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.config.xml.SkillXMLInfo;
   import com.gfp.core.controller.FocusKeyController;
   import com.gfp.core.events.CDEvent;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.RideEvent;
   import com.gfp.core.events.SkillLearnEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.events.UserItemEvent;
   import com.gfp.core.info.RideInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.fight.SkillInfo;
   import com.gfp.core.info.fight.SkillLevelInfo;
   import com.gfp.core.language.ModuleLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.CDManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.RideManager;
   import com.gfp.core.manager.SkillManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.popup.ModalType;
   import com.gfp.core.utils.SkillType;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.motion.Tween;
   import org.taomee.motion.easing.Back;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class HeadSelfPanel
   {
      
      private static var _instance:HeadSelfPanel;
      
      public static const CLOSE_STATE:String = "close";
      
      public static const OPEN_STATE:String = "open";
      
      private var _tween:Tween;
      
      private var _currentState:String = "open";
      
      private var _mainUI:Sprite;
      
      private var _lvTxt:TextField;
      
      private var _activityTxt:TextField;
      
      private var _activityBar:MovieClip;
      
      private var _hpTxt:TextField;
      
      private var _mpTxt:TextField;
      
      private var _hpBar:Sprite;
      
      private var _mpBar:Sprite;
      
      private var _hpRect:Rectangle;
      
      private var _hpChangeRect:Rectangle;
      
      private var _mpRect:Rectangle;
      
      private var _hpWidth:Number;
      
      private var _mpWidth:Number;
      
      private var _expWidth:Number;
      
      private var _headIcon:Sprite;
      
      private var _model:UserModel;
      
      private var _addhpTimeID:uint;
      
      private var _addmpTimeID:uint;
      
      private var _mcDouble:Sprite;
      
      private var _updateDoubleTimer:Timer;
      
      private var _buffBar:BuffIconBar;
      
      private var _teamLeader:Sprite;
      
      private var _decHp:int = 0;
      
      private var _isInitHp:Boolean;
      
      private var _isSpecialMap:Boolean;
      
      private var _showBtn:SimpleButton;
      
      private var _leaveGroupBtn:SimpleButton;
      
      private var _fightGroupIco:MovieClip;
      
      private var _rideSkillUI:Sprite;
      
      private var _outTimeId:int = 0;
      
      private var _transfigurationSkill:Sprite;
      
      private var monsterSkillID:int;
      
      private var _powerTxt:MovieClip;
      
      private var _powerBtn:SimpleButton;
      
      private var _addBtn:SimpleButton;
      
      private var roleIconType:int;
      
      private var _powerTimer:int;
      
      private var _currentPower:int;
      
      private var _headIconEnabled:Boolean = true;
      
      public function HeadSelfPanel()
      {
         super();
         this._mainUI = new UI_SWF_Head_SelfInfoPanel();
         this._showBtn = new UI_SWF_Left_Right_btn();
         this._rideSkillUI = new UI_Ride_E_SKill();
         this._rideSkillUI.x = 445;
         this._rideSkillUI.y = 65;
         this._transfigurationSkill = new UI_Monster_R_SKill();
         this._transfigurationSkill.x = 445;
         this._transfigurationSkill.y = 95;
         this._lvTxt = this._mainUI["lvTxt"];
         this._activityTxt = this._mainUI["activityTxt"];
         this._activityBar = this._mainUI["activityBar"];
         this._hpTxt = this._mainUI["hpTxt"];
         this._mpTxt = this._mainUI["mpTxt"];
         this._hpBar = this._mainUI["hp_mc"];
         this._mpBar = this._mainUI["mp_mc"];
         this._mcDouble = this._mainUI["mcDouble"];
         this._leaveGroupBtn = this._mainUI["closeBtn"];
         this._fightGroupIco = this._mainUI["fightGroupIcoMc"];
         this._powerTxt = this._mainUI["powerTxt"];
         this._powerBtn = this._mainUI["powerBtn"];
         this._addBtn = this._mainUI["addBtn"];
         this._addBtn.visible = false;
         this._leaveGroupBtn.visible = false;
         this._fightGroupIco.visible = false;
         this._buffBar = new BuffIconBar();
         this._buffBar.y = 93;
         this._mainUI.addChild(this._buffBar);
         this._mainUI.addChild(HeadRideBar.instance);
         this._showBtn.y = 18;
         this._showBtn.x = 248;
         this._showBtn.scaleX = this._showBtn.scaleY = 0.75;
         this._showBtn.rotationY = 180;
         ToolTipManager.add(this._showBtn,"点击关闭快捷栏");
         this._mainUI.addChild(this._showBtn);
         this._hpWidth = this._hpBar.width;
         this._hpRect = new Rectangle(0,0,0,this._hpBar.height);
         this._hpBar.scrollRect = this._hpRect;
         this._hpChangeRect = new Rectangle(0,0,0,this._hpBar.height);
         this._mpWidth = this._mpBar.width;
         this._mpRect = new Rectangle(0,0,0,this._mpBar.height);
         this._mpBar.scrollRect = this._mpRect;
         this._isInitHp = true;
         this._showBtn.addEventListener(MouseEvent.CLICK,this.onShowBtnClick);
         this._mainUI.setChildIndex(this._powerTxt,this._mainUI.numChildren - 1);
         UserManager.addEventListener(UserEvent.TURN_BACK,this.onTurnBack);
         UserManager.addEventListener(UserEvent.SECOND_TURN_BACK,this.onTurnBack);
      }
      
      public static function get instance() : HeadSelfPanel
      {
         if(_instance == null)
         {
            _instance = new HeadSelfPanel();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      protected function onTurnBack(param1:Event) : void
      {
         SwfCache.cancel(ClientConfig.getRoleIcon(this._model.info.roleType),this.onLoad);
         this.roleIconType = this._model.info.roleType;
         if(MainManager.actorInfo.secondTurnBackType)
         {
            this.roleIconType += 10 * (MainManager.actorInfo.secondTurnBackType + 1);
         }
         else if(MainManager.actorInfo.isTurnBack)
         {
            this.roleIconType += 10;
         }
         SwfCache.getSwfInfo(ClientConfig.getRoleIcon(this.roleIconType),this.onLoad);
         this.refreshUserInfo();
      }
      
      protected function onFightQuit(param1:Event) : void
      {
         FocusKeyController.removeFocusKeyListener(Keyboard.R,this.useTransfigurationSkill);
         CDManager.skillCD.removeEventListener(CDEvent.CDED,this.onCDEND);
         MainManager.actorModel.removeEventListener(UserEvent.ROLE_VIEW_CHANGE_OVER,this.onFightQuit);
         this.hideMonsetSkill();
      }
      
      protected function onFightBegin(param1:Event) : void
      {
         if(MainManager.actorModel.roleChangeStatus == 1 && EscortManager.instance.escortPathId == 0)
         {
            MainManager.actorModel.addEventListener(UserEvent.ROLE_VIEW_CHANGE_OVER,this.onFightQuit);
            this.monsterSkillID = TransfigurationXMLInfo.getSkillID(MainManager.actorInfo.monsterID);
            if(this.monsterSkillID != 0 && !CDManager.skillCD.cdContains(this.monsterSkillID))
            {
               this.showMonsterSkill();
            }
         }
         MainManager.actorModel.updateSkillStateIcon();
         this._buffBar.updateSkillStateIcon();
      }
      
      private function showMonsterSkill() : void
      {
         FocusKeyController.addFocusKeyListener(Keyboard.F,this.useTransfigurationSkill);
         this._mainUI.addChild(this._transfigurationSkill);
      }
      
      private function hideMonsetSkill() : void
      {
         FocusKeyController.removeFocusKeyListener(Keyboard.R,this.useTransfigurationSkill);
         DisplayUtil.removeForParent(this._transfigurationSkill);
      }
      
      private function useTransfigurationSkill(param1:Event) : void
      {
         var _loc6_:ActionInfo = null;
         var _loc7_:uint = 0;
         var _loc2_:int = this.monsterSkillID;
         var _loc3_:int = 1;
         var _loc4_:SkillLevelInfo = SkillXMLInfo.getLevelInfo(_loc2_,_loc3_);
         var _loc5_:uint = uint(_loc4_.actionID);
         if(_loc5_)
         {
            _loc6_ = ActionXMLInfo.getInfo(_loc5_);
            if(_loc6_)
            {
               _loc6_.skillID = _loc2_;
               _loc6_.skillLv = _loc3_;
               _loc6_.publicCDTime = _loc4_.duration;
               _loc6_.cdTime = _loc4_.cd;
               _loc6_.depHP = _loc4_.hp;
               _loc7_ = uint(_loc4_.mp);
               _loc6_.depMP = _loc7_;
               MainManager.actorModel.execAction(new SkillAction(_loc6_,_loc4_,MainManager.actorModel.getTroop(),MainManager.roleType,true,true));
            }
         }
         CDManager.skillCD.addEventListener(CDEvent.CDED,this.onCDEND);
         this.hideMonsetSkill();
      }
      
      protected function onCDEND(param1:CDEvent) : void
      {
         if(param1.targetID == this.monsterSkillID)
         {
            CDManager.skillCD.removeEventListener(CDEvent.CDED,this.onCDEND);
            if(MainManager.actorModel.roleChangeStatus == 1 && EscortManager.instance.escortPathId == 0)
            {
               this.showMonsterSkill();
            }
         }
      }
      
      public function setup() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         var _loc2_:uint = uint(MapManager.currentMap.info.mapType);
         if(_loc2_ != MapType.PVE && _loc2_ != MapType.PVP)
         {
            this.setupBuff();
            this.showForCity();
         }
         else
         {
            this._buffBar.updateSkillStateIcon();
         }
      }
      
      private function setupBuff() : void
      {
         this.addBaseBuff(1,false);
         this.addBaseBuff(2,false);
         this.addBaseBuff(3,false);
         this.addBaseBuff(4,false);
         this.addBaseBuff(9,false);
         this.addBaseBuff(12,false);
         this.addBaseBuff(13,false);
         this._buffBar.updateView();
         this._buffBar.updateBuff();
      }
      
      private function onMainClick(param1:MouseEvent) : void
      {
         if(param1.target == this._showBtn || this._headIconEnabled == false)
         {
            return;
         }
         ModuleManager.turnAppModule("UserInfoPanel","正在加载...",{"info":MainManager.actorInfo});
      }
      
      private function onShowBtnClick(param1:MouseEvent) : void
      {
         if(this._currentState == CLOSE_STATE)
         {
            this.onShow();
         }
         else
         {
            this.onClose();
         }
      }
      
      public function onShow() : void
      {
         this._tween = new Tween(this._mainUI,"x",Back.easeOut,this._mainUI.x,0,600,true);
         this._tween.start();
         this._currentState = OPEN_STATE;
         this._showBtn.rotationY = 180;
         ToolTipManager.add(this._showBtn,"点击关闭快捷栏");
      }
      
      public function onClose() : void
      {
         this._tween = new Tween(this._mainUI,"x",Back.easeOut,this._mainUI.x,-219,600,true);
         this._tween.start();
         this._currentState = CLOSE_STATE;
         this._showBtn.rotationY = 360;
         ToolTipManager.add(this._showBtn,"点击打开快捷栏");
      }
      
      public function init(param1:UserModel) : void
      {
         this._model = param1;
         this._lvTxt.text = this._model.info.lv.toString();
         this.updatePower(this._model.info.fightPower);
         this.setExpBar(this._model.info);
         this.showDoubleExpTime();
      }
      
      private function changeToPower(param1:int) : void
      {
         if(param1 != this._currentPower)
         {
            MainManager.actorInfo.fightPower = param1;
            if(this._powerTimer == 0)
            {
               LayerManager.stage.addEventListener(Event.ENTER_FRAME,this.onPowerAnimate);
               this._powerTimer = 1;
            }
         }
      }
      
      private function onPowerAnimate(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(this._currentPower == MainManager.actorInfo.fightPower)
         {
            LayerManager.stage.removeEventListener(Event.ENTER_FRAME,this.onPowerAnimate);
            this.updatePower(this._currentPower);
            this._powerTimer = 0;
         }
         else
         {
            _loc2_ = Math.abs(MainManager.actorInfo.fightPower - this._currentPower);
            if(_loc2_ > 10000)
            {
               if(this._currentPower > MainManager.actorInfo.fightPower)
               {
                  this.updatePower(this._currentPower - 10000);
               }
               else
               {
                  this.updatePower(this._currentPower + 10000);
               }
               return;
            }
            if(_loc2_ > 1000)
            {
               if(this._currentPower > MainManager.actorInfo.fightPower)
               {
                  this.updatePower(this._currentPower - 1000);
               }
               else
               {
                  this.updatePower(this._currentPower + 1000);
               }
               return;
            }
            if(_loc2_ > 100)
            {
               if(this._currentPower > MainManager.actorInfo.fightPower)
               {
                  this.updatePower(this._currentPower - 100);
               }
               else
               {
                  this.updatePower(this._currentPower + 100);
               }
               return;
            }
            if(_loc2_ > 10)
            {
               if(this._currentPower > MainManager.actorInfo.fightPower)
               {
                  this.updatePower(this._currentPower - 10);
               }
               else
               {
                  this.updatePower(this._currentPower + 10);
               }
               return;
            }
            if(this._currentPower > MainManager.actorInfo.fightPower)
            {
               this.updatePower(this._currentPower - 1);
            }
            else
            {
               this.updatePower(this._currentPower + 1);
            }
         }
      }
      
      public function updatePower(param1:int) : void
      {
         var _loc5_:MovieClip = null;
         this._currentPower = param1;
         DisplayUtil.removeAllChild(this._powerTxt);
         var _loc2_:String = param1.toString();
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = new UI_Head_Fight_Num();
            _loc5_.gotoAndStop(int(_loc2_.charAt(_loc4_)) + 1);
            _loc5_.cacheAsBitmap = true;
            _loc5_.scaleX = _loc5_.scaleY = 0.9;
            _loc5_.x = _loc3_;
            _loc3_ += _loc5_.width + 3;
            this._powerTxt.addChild(_loc5_);
            _loc4_++;
         }
         this._powerTxt.x = 107 + (88 - this._powerTxt.width) * 0.5;
      }
      
      public function showForCity() : void
      {
         this.show();
         var _loc1_:UserInfo = MainManager.actorInfo;
         _loc1_.mp = _loc1_.maxMp = _loc1_.cityMaxMp;
         _loc1_.hp = _loc1_.maxHp = _loc1_.cityMaxHp;
         this.setExpBar(_loc1_);
         SkillManager.getData();
         this._buffBar.clearFightBuff();
         HeadRideBar.check();
         this.onHideRideSkillUI(null);
         this.onRideSkillUpdate();
      }
      
      public function updateBuff() : void
      {
         this._buffBar.clearFightBuff();
      }
      
      public function show() : void
      {
         if(this._model == null)
         {
            return;
         }
         this._mainUI.y = -2;
         LayerManager.toolsLevel.addChild(this._mainUI);
         setTimeout(function():void
         {
            if(Boolean(MapManager.mapInfo) && MapManager.mapInfo.id == 1093101)
            {
               _isSpecialMap = true;
            }
         },500);
         this.clearHeadIcon();
         this.roleIconType = this._model.info.roleType;
         if(MainManager.actorInfo.secondTurnBackType)
         {
            this.roleIconType += 10 * (MainManager.actorInfo.secondTurnBackType + 1);
         }
         else if(MainManager.actorInfo.isTurnBack)
         {
            this.roleIconType += 10;
         }
         SwfCache.getSwfInfo(ClientConfig.getRoleIcon(this.roleIconType),this.onLoad);
         ToolTipManager.add(this._powerBtn,"如何提升战斗力");
         ToolTipManager.add(this._powerTxt,"战斗力");
         if(MainManager.actorInfo.isTurnBack)
         {
            ToolTipManager.add(this._activityTxt,"活力值，每天24点回复满。");
         }
         else
         {
            ToolTipManager.add(this._activityTxt,"转生后才能开启活力值哦。");
         }
         this.addEvent();
         this.updateEnergyTxt();
         this._outTimeId = setTimeout(this.onRideSkillUpdate,3000);
      }
      
      private function addEvent() : void
      {
         this._model.addEventListener(UserEvent.HP_CHANGE,this.onActorHP);
         this._model.addEventListener(UserEvent.MP_CHANGE,this.onActorMP);
         this._model.addEventListener(UserEvent.GROW_CHANGE,this.onInfoChange);
         ItemManager.addListener(UserItemEvent.USE_MEDICINE,this.onUseMedicine);
         HeadRideBar.instance.addEventListener(Event.CHANGE,this.onBarUpdate);
         FightManager.instance.addEventListener(FightEvent.BEGIN,this.onFightBegin);
         FightManager.instance.addEventListener(FightEvent.QUITE,this.onFightQuit);
         UserInfoManager.ed.addEventListener(UserEvent.FIGHT_POWER_CHANGED,this.onFightPowerChanged);
         SocketConnection.addCmdListener(CommandID.EXTRA_CAREER_ENERGY,this.onCareerEnergyChange);
         this._powerBtn.addEventListener(MouseEvent.CLICK,this.onPowerBtnClick);
         this._powerTxt.addEventListener(MouseEvent.CLICK,this.onPowerBtnClick);
         this._addBtn.addEventListener(MouseEvent.CLICK,this.onAddBtnClick);
         SkillManager.addEventListener(SkillManager.SKILL_UPDATE,this.onSkillUpdate);
         SkillManager.addEventListener(SkillLearnEvent.LEARN_SKILL,this.onSkillUpdate);
         SkillManager.addEventListener(SkillLearnEvent.RIDE_BE_SKILL,this.onRideSkillUpdate);
         SkillManager.addEventListener(SkillLearnEvent.UN_RIDE_BE_SKILL,this.onRideSkillUpdate);
         RideManager.addEventListener(RideEvent.RIDE_SKILL_APPEARED,this.onShowRideSkillUI);
         RideManager.addEventListener(RideEvent.RIDE_SKILL_DISAPPEARED,this.onHideRideSkillUI);
      }
      
      private function removeEvent() : void
      {
         if(this._model)
         {
            this._model.removeEventListener(UserEvent.GROW_CHANGE,this.onInfoChange);
            this._model.removeEventListener(UserEvent.HP_CHANGE,this.onActorHP);
            this._model.removeEventListener(UserEvent.MP_CHANGE,this.onActorMP);
         }
         ItemManager.removeListener(UserItemEvent.USE_MEDICINE,this.onUseMedicine);
         UserInfoManager.ed.removeEventListener(UserEvent.FIGHT_POWER_CHANGED,this.onFightPowerChanged);
         SocketConnection.removeCmdListener(CommandID.EXTRA_CAREER_ENERGY,this.onCareerEnergyChange);
         HeadRideBar.instance.removeEventListener(Event.CHANGE,this.onBarUpdate);
         this._powerBtn.removeEventListener(MouseEvent.CLICK,this.onPowerBtnClick);
         this._powerTxt.removeEventListener(MouseEvent.CLICK,this.onPowerBtnClick);
         this._addBtn.removeEventListener(MouseEvent.CLICK,this.onAddBtnClick);
         SkillManager.removeEventListener(SkillManager.SKILL_UPDATE,this.onSkillUpdate);
         SkillManager.removeEventListener(SkillLearnEvent.LEARN_SKILL,this.onSkillUpdate);
         RideManager.removeEventListener(RideEvent.RIDE_SKILL_APPEARED,this.onShowRideSkillUI);
         RideManager.removeEventListener(RideEvent.RIDE_SKILL_DISAPPEARED,this.onHideRideSkillUI);
         SkillManager.removeEventListener(SkillLearnEvent.RIDE_BE_SKILL,this.onRideSkillUpdate);
         SkillManager.removeEventListener(SkillLearnEvent.UN_RIDE_BE_SKILL,this.onRideSkillUpdate);
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this._mainUI,false);
         ToolTipManager.remove(this._powerBtn);
         ToolTipManager.remove(this._powerTxt);
         ToolTipManager.remove(this._activityTxt);
         this.removeEvent();
      }
      
      private function onAddBtnClick(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("BuyActivityPointPanel");
      }
      
      private function onCareerEnergyChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         MainManager.actorInfo.energyPoint = _loc3_;
         this.updateEnergyTxt();
      }
      
      private function updateEnergyTxt() : void
      {
         var _loc1_:int = 0;
         if(MainManager.actorInfo.isTurnBack)
         {
            _loc1_ = int(MainManager.actorInfo.energyPoint);
         }
         var _loc2_:Number = Math.min(_loc1_ / 100,1);
         this._activityBar.scaleX = _loc2_;
         this._activityTxt.text = _loc1_ + "/100";
      }
      
      private function onFightPowerChanged(param1:Event) : void
      {
         this.changeToPower(MainManager.actorInfo.fightPower);
      }
      
      private function onPowerBtnClick(param1:MouseEvent) : void
      {
         if(!MapManager.isFightMap)
         {
            ModuleManager.closeAllModule();
            ModuleManager.turnAppModule("ImproveFightPanel","正在加载...",{"modalType":ModalType.DARK});
         }
      }
      
      public function destroy() : void
      {
         clearTimeout(this._outTimeId);
         UserManager.removeEventListener(UserEvent.TURN_BACK,this.onTurnBack);
         UserManager.removeEventListener(UserEvent.SECOND_TURN_BACK,this.onTurnBack);
         this.stopUpdateTimer();
         SwfCache.cancel(ClientConfig.getRoleIcon(this.roleIconType),this.onLoad);
         if(this._hpBar)
         {
            this._hpBar.removeEventListener(Event.ENTER_FRAME,this.hpEnterFrame);
         }
         this.hide();
         this.clearHeadIcon();
         this.clearAddIcon();
         if(this._teamLeader)
         {
            DisplayUtil.removeForParent(this._teamLeader);
            this._teamLeader = null;
         }
         this._hpRect = null;
         this._mpRect = null;
         this._lvTxt = null;
         this._hpTxt = null;
         this._mpTxt = null;
         this._hpBar = null;
         this._mcDouble = null;
         this._mpBar = null;
         this._mainUI = null;
         this._model = null;
      }
      
      private function clearHeadIcon() : void
      {
         if(this._headIcon)
         {
            this._headIcon.cacheAsBitmap = false;
            DisplayUtil.removeForParent(this._headIcon);
            this._headIcon = null;
         }
      }
      
      private function clearAddIcon() : void
      {
         clearTimeout(this._addhpTimeID);
         clearTimeout(this._addmpTimeID);
         this._buffBar.destroy();
      }
      
      public function addBaseBuff(param1:uint, param2:Boolean = true) : void
      {
         this._buffBar.addBaseBuff(param1,param2);
      }
      
      public function hasBaseBuff(param1:uint) : Boolean
      {
         return this._buffBar.hasBaseBuff(param1);
      }
      
      public function removeBaseBuff(param1:uint) : void
      {
         this._buffBar.removeBaseBuff(param1);
      }
      
      public function addBuffIcon(param1:uint, param2:uint) : void
      {
         this._buffBar.addKeyBuff(param1,param2);
      }
      
      public function removeBuffIcon(param1:uint) : void
      {
         this._buffBar.removeKeyBuff(param1);
      }
      
      private function onSkillUpdate(param1:Event = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc5_:SkillInfo = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:SkillLevelInfo = null;
         var _loc4_:Array = SkillManager.getSkillsByType(SkillType.SKILL_TYPE_BE);
         if(_loc4_ == null)
         {
            return;
         }
         for each(_loc5_ in _loc4_)
         {
            _loc8_ = SkillXMLInfo.getLevelInfo(_loc5_.id,_loc5_.lv);
            if(_loc8_)
            {
               _loc2_ += _loc8_.exHp;
               _loc3_ += _loc8_.exMp;
            }
         }
         _loc6_ = MainManager.actorInfo.hp + _loc2_;
         _loc7_ = MainManager.actorInfo.mp + _loc3_;
         this._hpTxt.text = _loc6_.toString() + "/" + _loc6_.toString();
         this._mpTxt.text = _loc7_.toString() + "/" + _loc7_.toString();
      }
      
      private function onRideSkillUpdate(param1:SkillLearnEvent = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:RideInfo = null;
         var _loc5_:SkillLevelInfo = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         if(!param1)
         {
            if(RideManager.callRideID != 0)
            {
               _loc4_ = RideManager.getRide(RideManager.callRideID);
               if(_loc4_.beSkillID == 0)
               {
                  return;
               }
               _loc5_ = SkillXMLInfo.getLevelInfo(_loc4_.beSkillID,1);
               _loc6_ = MainManager.actorInfo.hp + _loc5_.exHp;
               _loc7_ = MainManager.actorInfo.mp + _loc5_.exMp;
            }
            else
            {
               _loc6_ = uint(MainManager.actorInfo.hp);
               _loc7_ = uint(MainManager.actorInfo.mp);
            }
         }
         else
         {
            _loc5_ = SkillXMLInfo.getLevelInfo(param1.skillId,1);
            switch(param1.type)
            {
               case SkillLearnEvent.RIDE_BE_SKILL:
                  _loc6_ = MainManager.actorInfo.hp + _loc5_.exHp;
                  _loc7_ = MainManager.actorInfo.mp + _loc5_.exMp;
                  break;
               case SkillLearnEvent.UN_RIDE_BE_SKILL:
                  _loc6_ = uint(MainManager.actorInfo.hp);
                  _loc7_ = uint(MainManager.actorInfo.mp);
            }
         }
         this._hpTxt.text = _loc6_.toString() + "/" + _loc6_.toString();
         this._mpTxt.text = _loc7_.toString() + "/" + _loc7_.toString();
      }
      
      private function setExpBar(param1:UserInfo) : void
      {
         if(!this._lvTxt)
         {
            return;
         }
         this._lvTxt.text = param1.lv.toString();
         var _loc2_:int = int(param1.hp);
         var _loc3_:int = int(param1.mp);
         var _loc4_:int = int(param1.maxHp);
         _loc4_ = _loc4_ == 0 ? _loc2_ : _loc4_;
         var _loc5_:int = int(param1.maxMp);
         _loc5_ = _loc5_ == 0 ? _loc3_ : _loc5_;
         this._hpRect.width = _loc2_ / _loc4_ * this._hpWidth;
         this._hpBar.scrollRect = this._hpRect;
         this._hpTxt.text = _loc2_.toString() + "/" + _loc4_.toString();
         this._mpRect.width = _loc3_ / _loc5_ * this._mpWidth;
         this._mpBar.scrollRect = this._mpRect;
         this._mpTxt.text = _loc3_.toString() + "/" + _loc5_.toString();
         this._addBtn.visible = param1.isTurnBack;
      }
      
      private function onInfoChange(param1:UserEvent) : void
      {
         var _loc2_:UserInfo = param1.data;
         if(Boolean(_loc2_) && Boolean(_loc2_.equals(MainManager.actorInfo)))
         {
         }
      }
      
      private function onActorHP(param1:UserEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_)
         {
            _loc3_ = int(_loc2_.getDecHP());
            _loc4_ = int(_loc2_.getHP());
            _loc5_ = int(_loc2_.getTotalHP());
            if(_loc4_ > this._decHp && this._decHp != 0)
            {
               this._hpRect.width = _loc4_ / _loc5_ * this._hpWidth;
               this._hpBar.scrollRect = this._hpRect;
               this._hpBar.scrollRect = this._hpRect;
               this._hpTxt.text = _loc4_.toString() + "/" + _loc5_.toString();
               return;
            }
            if(_loc4_ > 0)
            {
               _loc3_ = int(_loc2_.getDecHP());
            }
            else
            {
               _loc3_ = this._decHp;
            }
            this._hpRect.width = _loc4_ / _loc5_ * this._hpWidth;
            this._hpChangeRect.width = (_loc4_ + _loc3_) / _loc5_ * this._hpWidth;
            if(this._isInitHp)
            {
               this._hpBar.scrollRect = this._hpRect;
               this._isInitHp = false;
            }
            if(this._isSpecialMap)
            {
               this._hpBar.scrollRect = this._hpRect;
            }
            this._hpTxt.text = _loc4_.toString() + "/" + _loc5_.toString();
            this._hpBar.addEventListener(Event.ENTER_FRAME,this.hpEnterFrame);
            this._decHp = _loc2_.getHP();
         }
      }
      
      private function hpEnterFrame(param1:Event) : void
      {
         if(this._hpChangeRect.width > this._hpRect.width)
         {
            this._hpChangeRect.width -= 2;
            this._hpBar.scrollRect = this._hpChangeRect;
         }
         else
         {
            this._hpBar.removeEventListener(Event.ENTER_FRAME,this.hpEnterFrame);
         }
      }
      
      private function onActorMP(param1:UserEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_)
         {
            _loc3_ = int(_loc2_.getMP());
            _loc4_ = int(_loc2_.getTotalMP());
            this._mpRect.width = _loc3_ / _loc4_ * this._mpWidth;
            this._mpBar.scrollRect = this._mpRect;
            this._mpTxt.text = _loc3_.toString() + "/" + _loc4_.toString();
         }
      }
      
      private function onLoad(param1:SwfInfo) : void
      {
         this._headIcon = param1.content as Sprite;
         this._headIcon.cacheAsBitmap = true;
         this._mainUI["headIcoMc"].addChild(this._headIcon);
         if(this._teamLeader)
         {
            DisplayUtil.removeForParent(this._teamLeader);
         }
         if(MainManager.isLeader)
         {
            if(this._teamLeader == null)
            {
               this._teamLeader = UIManager.getSprite("Fight_Team_Leader");
               this._teamLeader.scaleX = 0.8;
               this._teamLeader.scaleY = 0.8;
            }
            this._teamLeader.x = 8;
            this._teamLeader.y = 35;
            this._mainUI.addChild(this._teamLeader);
         }
         this._headIcon.addEventListener(MouseEvent.CLICK,this.onMainClick);
         this._headIcon.buttonMode = true;
      }
      
      private function onUseMedicine(param1:UserItemEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:uint = param1.param as uint;
         if(_loc2_)
         {
            if(int(ItemXMLInfo.getHPRecover(_loc2_)) > 0)
            {
               clearTimeout(this._addhpTimeID);
               _loc3_ = int(ItemXMLInfo.getDuration(_loc2_)) * 1000;
               if(_loc3_ <= 0)
               {
                  _loc3_ = 1000;
               }
               this._addhpTimeID = setTimeout(this.onHideAddHpIcon,_loc3_);
               this._buffBar.addKeyBuff(10001,1);
            }
            if(int(ItemXMLInfo.getMPRecover(_loc2_)) > 0)
            {
               clearTimeout(this._addmpTimeID);
               _loc3_ = int(ItemXMLInfo.getDuration(_loc2_)) * 1000;
               if(_loc3_ <= 0)
               {
                  _loc3_ = 1000;
               }
               this._addmpTimeID = setTimeout(this.onHideAddMpIcon,_loc3_);
               this._buffBar.addKeyBuff(10002,2);
            }
         }
      }
      
      private function onHideAddHpIcon() : void
      {
         this._buffBar.removeKeyBuff(10001);
      }
      
      private function onHideAddMpIcon() : void
      {
         this._buffBar.removeKeyBuff(10002);
      }
      
      private function showDoubleExpTime() : void
      {
         if(MainManager.doubleExpTimeLeft > 0)
         {
            this._mcDouble.visible = true;
            this.stopUpdateTimer();
            this.startUpdateTimer();
         }
         else
         {
            this._mcDouble.visible = false;
         }
         this.updateDoubleExpTime();
      }
      
      private function startUpdateTimer() : void
      {
         this._updateDoubleTimer = new Timer(10000);
         this._updateDoubleTimer.addEventListener(TimerEvent.TIMER,this.onUpdateDoubleTime);
         this._updateDoubleTimer.start();
      }
      
      private function stopUpdateTimer() : void
      {
         if(this._updateDoubleTimer)
         {
            this._updateDoubleTimer.removeEventListener(TimerEvent.TIMER,this.onUpdateDoubleTime);
            this._updateDoubleTimer.stop();
            this._updateDoubleTimer = null;
         }
      }
      
      private function onUpdateDoubleTime(param1:TimerEvent) : void
      {
         this.updateDoubleExpTime();
      }
      
      private function updateDoubleExpTime() : void
      {
         var _loc1_:int = int(MainManager.doubleExpTimeLeft);
         var _loc2_:int = Math.floor(_loc1_ / 3600);
         var _loc3_:String = _loc2_.toString();
         _loc3_ = _loc3_.length > 1 ? _loc3_ : "0" + _loc3_;
         _loc1_ -= 3600 * _loc2_;
         var _loc4_:String = Math.floor(_loc1_ / 60).toString();
         _loc4_ = _loc4_.length > 1 ? _loc4_ : "0" + _loc4_;
         var _loc5_:TextField = this._mcDouble["tfTime"];
         var _loc6_:uint = 16050637;
         if(MainManager.doubleExpTimeLeft == 0)
         {
            _loc6_ = 16711680;
         }
         _loc5_.htmlText = TextFormatUtil.getColorText(_loc3_ + ":" + _loc4_,_loc6_);
      }
      
      public function refreshUserInfo() : void
      {
         UserInfoManager.upDateMoreInfo(MainManager.actorInfo,this.setExpBar);
      }
      
      public function initFightGroup() : void
      {
         if(FightGroupManager.instance.groupId != 0)
         {
            this._leaveGroupBtn.visible = true;
            ToolTipManager.remove(this._leaveGroupBtn);
            ToolTipManager.remove(this._fightGroupIco);
            ToolTipManager.add(this._leaveGroupBtn,ModuleLanguageDefine.FIGHT_GROUP_MSG[6]);
            this._leaveGroupBtn.addEventListener(MouseEvent.CLICK,this.clickLeaveGroupHandler);
            if(FightGroupManager.instance.myIsTheLeader)
            {
               this._fightGroupIco.gotoAndStop(1);
               ToolTipManager.add(this._fightGroupIco,"队长");
               this._fightGroupIco.visible = true;
            }
            else
            {
               this._fightGroupIco.gotoAndStop(2);
               this._fightGroupIco.visible = false;
            }
         }
         else
         {
            this._leaveGroupBtn.visible = false;
            this._fightGroupIco.visible = false;
            this._leaveGroupBtn.removeEventListener(MouseEvent.CLICK,this.clickLeaveGroupHandler);
         }
      }
      
      private function clickLeaveGroupHandler(param1:MouseEvent) : void
      {
         AlertManager.showSimpleAnswer(ModuleLanguageDefine.FIGHT_GROUP_MSG[7],this.leaveGroup);
      }
      
      private function leaveGroup() : void
      {
         FightGroupManager.instance.leaveGroup(MainManager.actorID,MainManager.actorInfo.createTime);
      }
      
      private function onShowRideSkillUI(param1:RideEvent) : void
      {
         this._mainUI.addChild(this._rideSkillUI);
      }
      
      private function onHideRideSkillUI(param1:RideEvent) : void
      {
         DisplayUtil.removeForParent(this._rideSkillUI,false);
      }
      
      private function onBarUpdate(param1:Event) : void
      {
         this.updateBuffView();
      }
      
      public function updateBuffView() : void
      {
         this._buffBar.updateView();
      }
      
      public function updateSceneBuff() : void
      {
         this._buffBar.updateBuff();
      }
      
      public function set headIconEnabled(param1:Boolean) : void
      {
         this._headIconEnabled = param1;
      }
   }
}

