package com.gfp.app.toolBar
{
   import com.gfp.app.im.IMController;
   import com.gfp.app.im.talk.TalkManager;
   import com.gfp.app.manager.AccountSafeManager;
   import com.gfp.app.manager.SumGuidTaskManager;
   import com.gfp.app.manager.escortPlugin.EscortPluginManager;
   import com.gfp.app.toolBar.chat.MultiChatPanel;
   import com.gfp.app.user.MoreUserInfoController;
   import com.gfp.core.CommandID;
   import com.gfp.core.Constant;
   import com.gfp.core.config.AttributeConfig;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.config.xml.SummonXMLInfo;
   import com.gfp.core.events.ChatEvent;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.HeroSoulEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.PickItemEvent;
   import com.gfp.core.events.SummonEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.events.UserItemEvent;
   import com.gfp.core.info.AlignInfo;
   import com.gfp.core.info.GodInstanceInfo;
   import com.gfp.core.info.SummonConfigInfo;
   import com.gfp.core.info.SummonInfo;
   import com.gfp.core.info.UserHeroSoulInfos;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.UserSummonInfos;
   import com.gfp.core.info.item.SingleItemInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.CardManager;
   import com.gfp.core.manager.DeffEquiptManager;
   import com.gfp.core.manager.GodManager;
   import com.gfp.core.manager.HeroSoulManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MagicChangeManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MasterManager;
   import com.gfp.core.manager.MessageManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SOManager;
   import com.gfp.core.manager.SearchGodManager;
   import com.gfp.core.manager.ServerBuffManager;
   import com.gfp.core.manager.SkillManager;
   import com.gfp.core.manager.SummonEvolveManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.manager.alert.AlertInfo;
   import com.gfp.core.manager.alert.AlertType;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.popup.ModalType;
   import com.gfp.core.sound.SoundManager;
   import com.gfp.core.ui.events.UIEvent;
   import com.gfp.core.utils.DisplayObjectFlashUtil;
   import com.gfp.core.utils.FilterUtil;
   import com.gfp.core.utils.RoleDisplayUtil;
   import com.gfp.core.utils.SummonStateType;
   import com.gfp.core.utils.TextUtil;
   import com.gfp.core.utils.TimeUtil;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.net.SharedObject;
   import flash.text.TextField;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.filter.ColorFilter;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class CityToolBar extends GFFitStageItem
   {
      
      private static var _instance:CityToolBar;
      
      public static var isBatteryUse:Boolean;
      
      public static const TOP_BAR_RELAYOUT:String = "top_bar_relayout";
      
      public static const CD_CELL_1:int = 11077;
      
      public static const CD_CELL_2:int = 11081;
      
      public static const CLAIM_TIME_1:int = 11078;
      
      public static const CLAIM_TIME_2:int = 11082;
      
      public static const SHEN_SHOU_GE_DATA_LIST:Array = [CD_CELL_1,CD_CELL_2,CLAIM_TIME_1,CLAIM_TIME_2];
      
      private var _bottomBar:MovieClip;
      
      private var _cityMapBtn:SimpleButton;
      
      private var _coinBtn:SimpleButton;
      
      private var _silverCoinBtn:SimpleButton;
      
      private var _bagBtn:SimpleButton;
      
      private var _bagChildButton:ChildButton;
      
      private var _bagBtnTip:MovieClip;
      
      private var _strengthBtn:SimpleButton;
      
      private var _goldCardBtn:SimpleButton;
      
      private var _strengthChildBtn:ChildButton;
      
      private var _strengthCon:Sprite;
      
      private var _hufaBtn:InteractiveObject;
      
      private var _summonBtn:SimpleButton;
      
      private var _summonChildBtn:ChildButton;
      
      private var _heroSoulBtn:InteractiveObject;
      
      private var _strongestSoulBtn:InteractiveObject;
      
      private var _heroSoulChildButton:ChildButton;
      
      private var _godBtn:InteractiveObject;
      
      private var _nbGodBtn:InteractiveObject;
      
      private var _godInOneBtn:InteractiveObject;
      
      private var _godChildButton:ChildButton;
      
      private var _unlock90:MovieClip;
      
      private var _unlock100:MovieClip;
      
      private var _goodSummonMC:MovieClip;
      
      private var newSearchGodEffect:MovieClip;
      
      private var _collectBtn:SimpleButton;
      
      private var _teamBtn:SimpleButton;
      
      private var _imInfoNum:Sprite;
      
      private var _imBtn:SimpleButton;
      
      private var _friendsMC:MovieClip;
      
      private var _changeMc:MovieClip;
      
      private var _changeChildButton:ChildButton;
      
      private var _friendsContainer:MovieClip;
      
      private var _teacherBtn:SimpleButton;
      
      private var _systemBtn:SimpleButton;
      
      private var _skillBtn:SimpleButton;
      
      private var _skillMc:MovieClip;
      
      private var _magicBtn:InteractiveObject;
      
      private var _juBtn:InteractiveObject;
      
      private var _miniCityMapBtn:SimpleButton;
      
      private var _autoYaBiao:SimpleButton;
      
      private var _strengthBtnTip:MovieClip;
      
      private var _gloryInfo:Sprite;
      
      private var _mohunInfoTip:Sprite;
      
      public const SWAP_ID:int = 2209;
      
      private var careerMaterialID:int;
      
      private var mTimer:Timer;
      
      private var _checkMohunTimer:uint;
      
      private var _summonParams:String;
      
      private var _hideBtn:MovieClip;
      
      private var _soundBtn:MovieClip;
      
      private var _expTxt:TextField;
      
      private var _expBar:MovieClip;
      
      private var _levelTxt:TextField;
      
      private var _dispatcher:EventDispatcher;
      
      private var _youngBookBtnEff:MovieClip;
      
      private var _effUserLv:int;
      
      private var _showYoungBookSwapIdList:Array = [6190,5053,10474,3630,5049,5050,5457,5046,10008];
      
      private var _openPotSwapIdList:Array = [8306,8307,8308,8309,8310,8311,8312];
      
      private var _shenshougeTip:MovieClip;
      
      public function CityToolBar()
      {
         super();
         this._bottomBar = UIManager.getGlobalUi("UI_SWF_BottomBar");
         this._levelTxt = this._bottomBar["levelTxt"];
         this.newSearchGodEffect = this._bottomBar["newSearchGodEffect"];
         this.newSearchGodEffect.stop();
         this.newSearchGodEffect.mouseEnabled = false;
         this.newSearchGodEffect.mouseChildren = false;
         this._youngBookBtnEff = this._bottomBar["youngBookBtnEff"];
         DisplayUtil.removeForParent(this._youngBookBtnEff);
         this._effUserLv = MainManager.actorInfo.lv;
         UIManager.setButtonAsBitmap(this._bottomBar);
         this._changeMc = this._bottomBar["changeMc"];
         this._magicBtn = this._changeMc["bainBtn"];
         this._juBtn = this._changeMc["juBtn"];
         this._goodSummonMC = this._bottomBar["goodSummonMC"];
         this.unvisible();
         this.initView();
         this.updateView();
         this.showSkillPointNum();
         this._dispatcher = new EventDispatcher();
         this._showYoungBookSwapIdList.push(this._openPotSwapIdList[MainManager.actorInfo.roleType - 1]);
         this._autoYaBiao = this._bottomBar["autoYaBiao"];
         this._autoYaBiao.visible = false;
      }
      
      public static function get instance() : CityToolBar
      {
         if(_instance == null)
         {
            _instance = new CityToolBar();
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
      
      public static function show() : void
      {
         instance.show();
      }
      
      private function unvisible() : void
      {
         this._goodSummonMC.visible = false;
      }
      
      private function updateTrans() : void
      {
      }
      
      public function get dispatcher() : IEventDispatcher
      {
         return this._dispatcher;
      }
      
      override protected function layout() : void
      {
         this._bottomBar.x = LayerManager.stageWidth - 1005 >> 1;
         this._bottomBar.y = LayerManager.stageHeight - 130.75;
         MultiChatPanel.instance.view.x = 0 - this._bottomBar.x - 97;
      }
      
      override public function show() : void
      {
         super.show();
         this.initEvent();
         this.layout();
         this.updateView();
         this.refreshExpBarLock();
         this.refreshExpBar();
         LayerManager.toolsLevel.addChildAt(this._bottomBar,0);
         MultiChatPanel.instance.view.y = -25;
         DisplayUtil.removeAllChild(this._bottomBar["chatMc"]);
         this._bottomBar["chatMc"].addChild(MultiChatPanel.instance.view);
         MultiChatPanel.instance.view.x = 0 - this._bottomBar.x - 97;
         MultiChatPanel.instance.noLayout = true;
         MultiChatPanel.instance.addEventListener(Event.CHANGE,this.onChange);
         this.onChange(null);
         this.onLevelChange(null);
         this.updateYoungBookBtnShow();
         this.updateIconState();
         this.updateShenShouGeTips();
      }
      
      public function updateShenShouGeTips() : void
      {
         ActivityExchangeTimesManager.addEventListeners(SHEN_SHOU_GE_DATA_LIST,this.resSummonRequestBack);
         ActivityExchangeTimesManager.getActivitesTimeInfo(SHEN_SHOU_GE_DATA_LIST);
      }
      
      private function resSummonRequestBack(param1:DataEvent) : void
      {
         var _loc10_:SummonInfo = null;
         var _loc11_:SummonInfo = null;
         var _loc12_:SummonConfigInfo = null;
         ActivityExchangeTimesManager.removeEventListeners(SHEN_SHOU_GE_DATA_LIST,this.resSummonRequestBack);
         var _loc2_:int = int(SummonManager.getSummonListByFuncType(4).length);
         if(_loc2_ == 0)
         {
            this._shenshougeTip.visible = false;
            this._shenshougeTip.stop();
            return;
         }
         var _loc3_:int = int(ActivityExchangeTimesManager.getTimes(CD_CELL_1));
         var _loc4_:int = int(ActivityExchangeTimesManager.getTimes(CD_CELL_2));
         var _loc5_:int = int(ActivityExchangeTimesManager.getTimes(CLAIM_TIME_1));
         var _loc6_:int = int(ActivityExchangeTimesManager.getTimes(CLAIM_TIME_2));
         var _loc7_:Number = Number(TimeUtil.getServerSecond());
         var _loc8_:Number = _loc7_ - _loc5_;
         var _loc9_:Number = _loc7_ - _loc6_;
         if(_loc3_)
         {
            _loc10_ = SummonManager.getActorSummonInfo().getSummonInfoByUniqId(_loc3_);
         }
         if(_loc4_)
         {
            _loc11_ = SummonManager.getActorSummonInfo().getSummonInfoByUniqId(_loc4_);
         }
         var _loc13_:int = 0;
         if(_loc10_)
         {
            _loc12_ = SummonXMLInfo.getSummonConfigInfoBySummonType(_loc10_.roleID);
            if(_loc8_ < _loc12_.outItemsCd * 60)
            {
               _loc13_++;
            }
         }
         if(_loc11_)
         {
            _loc12_ = SummonXMLInfo.getSummonConfigInfoBySummonType(_loc11_.roleID);
            if(_loc9_ < _loc12_.outItemsCd * 60)
            {
               _loc13_++;
            }
         }
         if(_loc13_ < 2 && _loc2_ > _loc13_)
         {
            this._shenshougeTip.visible = true;
            this._shenshougeTip.gotoAndPlay(1);
         }
         else
         {
            this._shenshougeTip.visible = false;
            this._shenshougeTip.stop();
         }
      }
      
      public function hideShenShouGeTip() : void
      {
         this._shenshougeTip.visible = false;
         this._shenshougeTip.stop();
      }
      
      protected function onChange(param1:Event) : void
      {
         if(MultiChatPanel.instance.isChatShow)
         {
         }
      }
      
      private function updateView(... rest) : void
      {
         if(SearchGodManager.instance.needMaoPao())
         {
            this.newSearchGodEffect.visible = true;
            this.newSearchGodEffect.play();
         }
         else
         {
            this.newSearchGodEffect.visible = false;
            this.newSearchGodEffect.stop();
         }
         this._soundBtn.gotoAndStop(SoundManager.isMusicEnable ? 1 : 2);
         this._hideBtn.gotoAndStop(DeffEquiptManager.isHideAllPlayer ? 2 : 1);
         ToolTipManager.remove(this._soundBtn);
         ToolTipManager.remove(this._hideBtn);
         if(this._soundBtn.currentFrame == 1)
         {
            ToolTipManager.add(this._soundBtn,"关闭声音");
         }
         else
         {
            ToolTipManager.add(this._soundBtn,"开启声音");
         }
         if(this._hideBtn.currentFrame == 1)
         {
            ToolTipManager.add(this._hideBtn,"隐藏其它玩家");
         }
         else
         {
            ToolTipManager.add(this._hideBtn,"显示其它玩家");
         }
         ToolTipManager.add(this._systemBtn,"设置");
         ToolTipManager.add(this._bottomBar["buttons"]["mohunButton"],"魔魂");
         ToolTipManager.add(this._bottomBar["buttons"]["turnButton"],"魔界转生");
         ToolTipManager.add(this._bottomBar["buttons"]["chuanqiBtn"],"盗墓笔记");
         ToolTipManager.add(this._bottomBar["buttons"]["shenShouGeBtn"],"神兽阁");
         ToolTipManager.add(this._bottomBar["buttons"]["youngBookBtn"],"侠士宝典");
      }
      
      public function showGloryInfo(param1:Boolean) : void
      {
         this._gloryInfo.visible = param1;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.hide();
         this._bottomBar = null;
         this._bagChildButton.destroy();
         this._heroSoulChildButton.destroy();
         this._godChildButton.destroy();
         this._changeChildButton.destroy();
      }
      
      override public function hide() : void
      {
         super.hide();
         this.removeEvent();
         DisplayUtil.removeForParent(this._bottomBar,false);
         MultiChatPanel.instance.removeEventListener(Event.CHANGE,this.onChange);
         this.hideShenShouGeTip();
      }
      
      private function checkBagTip() : void
      {
         if(ItemManager.hasShopCoin())
         {
            this._bottomBar.addChild(this._bagBtnTip);
            this._bagBtnTip.play();
         }
         else
         {
            this._bagBtnTip.stop();
            DisplayUtil.removeForParent(this._bagBtnTip,false);
         }
      }
      
      private function initView() : void
      {
         var _loc1_:SharedObject = null;
         this._cityMapBtn = this._bottomBar.cityMapBtn;
         this._coinBtn = this._bottomBar["bagMC"].coinBtn;
         this._silverCoinBtn = this._bottomBar["bagMC"].silverCoinBtn;
         this._bagBtn = this._bottomBar["bagMC"].bagBtn;
         this._bagChildButton = new ChildButton(this._bottomBar["bagMC"],Vector.<DisplayObject>([this._coinBtn,this._bottomBar["bagMC"]["bg"],this._silverCoinBtn]));
         this._bagBtnTip = this._bottomBar["bagBtnTip"];
         this._bagBtnTip.stop();
         DisplayUtil.removeForParent(this._bagBtnTip,false);
         this._strengthBtn = this._bottomBar["stengthenMC"].strengthBtn;
         this._goldCardBtn = this._bottomBar["stengthenMC"].goldCardBtn;
         this._strengthChildBtn = new ChildButton(this._bottomBar["stengthenMC"],Vector.<DisplayObject>([this._bottomBar["stengthenMC"]["bg"],this._goldCardBtn]));
         this._hufaBtn = this._bottomBar["summonMC"].hufaBtn;
         this._summonBtn = this._bottomBar["summonMC"].summonBtn;
         this._summonChildBtn = new ChildButton(this._bottomBar["summonMC"],Vector.<DisplayObject>([this._bottomBar["summonMC"]["bg"],this._hufaBtn]));
         this._heroSoulBtn = this._bottomBar["soulMC"].heroSoulBtn;
         this._strongestSoulBtn = this._bottomBar["soulMC"]["strongestSoulBtn"];
         this._heroSoulChildButton = new ChildButton(this._bottomBar["soulMC"],Vector.<DisplayObject>([this._bottomBar["soulMC"]["strongestSoulBtn"],this._bottomBar["soulMC"]["bg"]]));
         this._godBtn = this._bottomBar["godMC"].godBtn;
         this._nbGodBtn = this._bottomBar["godMC"]["nbGodBtn"];
         this._godInOneBtn = this._bottomBar["godMC"]["godInOneBtn"];
         this._godChildButton = new ChildButton(this._bottomBar["godMC"],Vector.<DisplayObject>([this._bottomBar["godMC"]["godInOneBtn"],this._bottomBar["godMC"]["nbGodBtn"],this._bottomBar["godMC"]["bg"]]));
         this._imInfoNum = this._bottomBar["imInfo"];
         this._imInfoNum.mouseChildren = false;
         this._imInfoNum.mouseEnabled = false;
         this._imInfoNum.visible = false;
         this._unlock90 = this._bottomBar.unlock90;
         this._unlock100 = this._bottomBar.unlock100;
         if(MainManager.actorInfo.lv >= 90)
         {
            this._unlock90.visible = false;
         }
         if(MainManager.actorInfo.lv >= 100)
         {
            this._unlock100.visible = false;
         }
         this._gloryInfo = this._bottomBar["gloryInfo"];
         this._gloryInfo.mouseEnabled = false;
         this._gloryInfo.mouseChildren = false;
         this._gloryInfo.visible = false;
         this._mohunInfoTip = this._bottomBar["buttons"]["mohunInfoTips"];
         this._mohunInfoTip.mouseEnabled = false;
         this._mohunInfoTip.mouseChildren = false;
         this._mohunInfoTip.visible = false;
         this._shenshougeTip = this._bottomBar["buttons"]["shenshougeTips"];
         this._shenshougeTip.stop();
         this._shenshougeTip.mouseEnabled = false;
         this._shenshougeTip.mouseChildren = false;
         this._shenshougeTip.visible = false;
         this._systemBtn = this._bottomBar.systemBtn;
         this._bottomBar.tip.mouseEnabled = this._bottomBar.tip.mouseChildren = false;
         AccountSafeManager.instance.initTip(this._bottomBar.tip);
         this._skillBtn = this._changeMc.skillBtn;
         this._skillMc = this._changeMc.skillMc;
         this._changeChildButton = new ChildButton(this._changeMc,Vector.<DisplayObject>([this._magicBtn,this._juBtn,this._changeMc["bg"]]));
         this._collectBtn = this._bottomBar["collectBtn"];
         this._friendsMC = this._bottomBar.friendsMC;
         this._friendsContainer = this._friendsMC["bg"];
         this._friendsContainer.alpha = 0;
         this._friendsContainer.visible = false;
         this._teamBtn = this._friendsMC.teamBtn;
         this._imBtn = this._friendsMC["imBtn"];
         this._imBtn.visible = false;
         this._teacherBtn = this._friendsMC["teacherBtn"];
         this._teacherBtn.visible = false;
         this._miniCityMapBtn = this._bottomBar["miniCityMapBtn"];
         ToolTipManager.add(this._miniCityMapBtn,"打开小地图");
         ToolTipManager.add(this._cityMapBtn,"打开世界地图");
         this._bottomBar["expBar"]["lock"].gotoAndStop(1);
         this._bottomBar["expBar"]["lock"].buttonMode = true;
         this._checkMohunTimer = setTimeout(this.checkFreeMohun,3000);
         this._hideBtn = this._bottomBar["hideBtn"];
         this._soundBtn = this._bottomBar["soundBtn"];
         this._hideBtn.buttonMode = this._soundBtn.buttonMode = true;
         this.refreshYountBookBtnShow();
         this.initExpBar();
         if(Boolean(TasksManager.isCompleted(519)) && MainManager.actorInfo.lv >= 60 && MainManager.actorInfo.fightTeamId == 0)
         {
            _loc1_ = SharedObject.getLocal("gf_" + MainManager.actorID + "_" + MainManager.actorInfo.createTime + "_toolbar_figtTeamTips");
            if(Boolean(_loc1_.data.cartoonPlayed) == false)
            {
               this.showMovie(this._bottomBar["fightTeamTips"]);
            }
            else
            {
               this.hideMovie(this._bottomBar["fightTeamTips"]);
            }
         }
         else
         {
            this.hideMovie(this._bottomBar["fightTeamTips"]);
         }
      }
      
      private function updateIconState() : void
      {
         if(MainManager.actorInfo.lv >= 80)
         {
            this.resetBtn(this._collectBtn,true);
            this.resetBtn(this._teamBtn,true);
            this.resetBtn(this._skillBtn,true);
            this.resetBtn(this._magicBtn,true);
            this.resetBtn(this._summonBtn,true);
            this.resetBtn(this._hufaBtn,true);
            this.resetBtn(this._godBtn,true);
            this.resetBtn(this._nbGodBtn,true);
            this.resetBtn(this._godInOneBtn,true);
            this.resetBtn(this._bottomBar["buttons"]["mohunButton"],true);
            this.resetBtn(this._strengthBtn,true);
            this.resetBtn(this._heroSoulBtn,true);
            this.resetBtn(this._strongestSoulBtn,true);
         }
         else if(MainManager.actorInfo.lv >= 79)
         {
            this.resetBtn(this._bottomBar["buttons"]["youngBookBtn"],true);
            this.resetBtn(this._bottomBar["buttons"]["shenShouGeBtn"],true);
         }
         else
         {
            this.resetBtn(this._collectBtn,TasksManager.isCompleted(519));
            if(TasksManager.isCompleted(519) == false)
            {
               this.hideMovie(this._gloryInfo as MovieClip);
            }
            this.resetBtn(this._teamBtn,TasksManager.isCompleted(519));
            this.resetBtn(this._bottomBar["buttons"]["youngBookBtn"],TasksManager.isCompleted(519));
            if(TasksManager.isCompleted(519) == false)
            {
               this.hideMovie(this._youngBookBtnEff);
            }
            this.resetBtn(this._skillBtn,TasksManager.isCompleted(522));
            this.resetBtn(this._magicBtn,ActivityExchangeTimesManager.getTimes(9763) > 0);
            this.resetBtn(this._summonBtn,ActivityExchangeTimesManager.getTimes(9761) > 0);
            this.resetBtn(this._hufaBtn,ActivityExchangeTimesManager.getTimes(9761) > 0);
            this.resetBtn(this._godBtn,MainManager.actorInfo.lv >= 100);
            this.resetBtn(this._godInOneBtn,MainManager.actorInfo.lv >= 100);
            this.resetBtn(this._nbGodBtn,MainManager.actorInfo.lv >= 100);
            this.resetBtn(this._bottomBar["buttons"]["mohunButton"],TasksManager.isCompleted(502));
            this.resetBtn(this._bottomBar["buttons"]["shenShouGeBtn"],TasksManager.isCompleted(502));
            this.resetBtn(this._strengthBtn,TasksManager.isCompleted(503));
            this.resetBtn(this._heroSoulBtn,MainManager.actorInfo.lv >= 90);
            this.resetBtn(this._strongestSoulBtn,MainManager.actorInfo.lv >= 90);
         }
         this.resetBtn(this._coinBtn,MainManager.actorInfo.lv >= 60);
         this.resetBtn(this._silverCoinBtn,MainManager.actorInfo.lv >= 60);
         this.resetBtn(this._goldCardBtn,MainManager.actorInfo.lv >= 60);
      }
      
      private function resetBtn(param1:InteractiveObject, param2:Boolean) : void
      {
         param1.filters = param2 ? [] : FilterUtil.GRAY_FILTER;
         param1.mouseEnabled = param2;
         if(param1 is Sprite)
         {
            (param1 as Sprite).mouseChildren = param2;
         }
      }
      
      private function refreshYountBookBtnShow() : void
      {
         this._bottomBar["buttons"]["youngBookBtn"].visible = false;
         if(MainManager.actorInfo.lv >= 20)
         {
            this._bottomBar["buttons"]["youngBookBtn"].visible = true;
         }
      }
      
      private function bookPlayEnd() : void
      {
         this.refreshYountBookBtnShow();
      }
      
      private function quickUpPlayEnd() : void
      {
      }
      
      private function onExchangeComplete(param1:ExchangeEvent) : void
      {
         var _loc2_:int = int(param1.info.id);
         if(_loc2_ == 9761 || _loc2_ == 9763)
         {
            this.updateIconState();
         }
      }
      
      private function onTurnBack(param1:Event) : void
      {
      }
      
      private function initExpBar() : void
      {
         this._expTxt = this._bottomBar["expBar"]["expTxt"];
         this._expTxt.mouseEnabled = false;
         this._expTxt.mouseWheelEnabled = false;
         this._expBar = this._bottomBar["expBar"]["expBar"];
      }
      
      private function checkFreeMohun() : void
      {
         clearTimeout(this._checkMohunTimer);
         this.requestFreeCountData();
      }
      
      private function requestFreeCountData() : void
      {
         this.onFreeCountBack(null);
      }
      
      private function initEvent() : void
      {
         this._miniCityMapBtn.addEventListener(MouseEvent.CLICK,this.onMinMapClick);
         this._cityMapBtn.addEventListener(MouseEvent.CLICK,this.onCityMapBtnClick);
         this._coinBtn.addEventListener(MouseEvent.CLICK,this.coinHandle);
         this._silverCoinBtn.addEventListener(MouseEvent.CLICK,this.silverCoin);
         this._bagBtn.addEventListener(MouseEvent.CLICK,this.onBagBtnClick);
         this._strengthBtn.addEventListener(MouseEvent.CLICK,this.onStrengthBtnClick);
         this._goldCardBtn.addEventListener(MouseEvent.CLICK,this.goldCardHandle);
         this._hufaBtn.addEventListener(MouseEvent.CLICK,this.hufaHandle);
         this._summonBtn.addEventListener(MouseEvent.CLICK,this.onSummonBtnClick);
         this._heroSoulBtn.addEventListener(MouseEvent.CLICK,this.onHeroSoulClick);
         this._strongestSoulBtn.addEventListener(MouseEvent.CLICK,this.strongestSoulHandle);
         this._godBtn.addEventListener(MouseEvent.CLICK,this.godHandle);
         this._nbGodBtn.addEventListener(MouseEvent.CLICK,this.nbGodHandle);
         this._godInOneBtn.addEventListener(MouseEvent.CLICK,this.godInOneHandle);
         this._teamBtn.addEventListener(MouseEvent.CLICK,this.onTeamBtnClick);
         MessageManager.addEventListener(ChatEvent.CHAT_CHANGE,this.onChatInfoChange);
         this._imBtn.addEventListener(MouseEvent.CLICK,this.onImBtnClick);
         this._systemBtn.addEventListener(MouseEvent.CLICK,this.onSystemBtnClick);
         this._skillBtn.addEventListener(MouseEvent.CLICK,this.onSkillBtnClick);
         this._magicBtn.addEventListener(MouseEvent.CLICK,this.onMagicBtnClick);
         this._juBtn.addEventListener(MouseEvent.CLICK,this.onJuBtnClick);
         this._friendsMC.addEventListener(MouseEvent.MOUSE_OVER,this.onFriendsBtnOver);
         this._friendsMC.addEventListener(MouseEvent.CLICK,this.onImBtnClick);
         this._friendsMC.addEventListener(MouseEvent.MOUSE_OUT,this.onFriendsBtnOut);
         this._collectBtn.addEventListener(MouseEvent.CLICK,this.onCollectBtnClick);
         this._teacherBtn.addEventListener(MouseEvent.CLICK,this.onTeacherBtnClick);
         ItemManager.addListener(PickItemEvent.PICK_UP_ITEM,this.onPickItemHandle);
         ItemManager.addListener(ItemManager.EVENT_ITEM_READY,this.onItemReadyHandle);
         UserInfoManager.ed.addEventListener(UserEvent.LVL_CHANGE,this.onLevelChange);
         ModuleManager.event.addEventListener(UIEvent.CLOSE_MODULE,this.onCloseModule);
         this._hideBtn.addEventListener(MouseEvent.CLICK,this.onHideClick);
         this._soundBtn.addEventListener(MouseEvent.CLICK,this.onSoundClick);
         SoundManager.event.addEventListener(Event.CHANGE,this.updateView);
         SearchGodManager.addEventListener(SearchGodManager.CHANGE_EVENT,this.updateView);
         DeffEquiptManager.event.addEventListener(Event.CHANGE,this.updateView);
         MainManager.actorModel.addEventListener(UserEvent.GROW_CHANGE,this.refreshExpBar);
         UserManager.addEventListener(UserEvent.TURN_BACK,this.refreshExpBar);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwich);
         this._bottomBar["buttons"]["turnButton"].addEventListener(MouseEvent.CLICK,this.onTurnDayClick);
         this._bottomBar["buttons"]["chuanqiBtn"].addEventListener(MouseEvent.CLICK,this.onChuanqiClick);
         this._bottomBar["buttons"]["shenShouGeBtn"].addEventListener(MouseEvent.CLICK,this.shenShouGeHandle);
         this._bottomBar["buttons"]["mohunButton"].addEventListener(MouseEvent.CLICK,this.onMoHunDayClick);
         this._bottomBar["buttons"]["youngBookBtn"].addEventListener(MouseEvent.CLICK,this.onYoungBookBtnClick);
         MainManager.actorModel.addEventListener(UserEvent.ACTIVE_NEW_LV,this.onActivedNewLevel);
         this._bottomBar["expBar"]["lock"].addEventListener(MouseEvent.CLICK,this.onExpLockClick);
         ItemManager.addListener(UserItemEvent.ITEM_ADD,this.onItemUpdate);
         ItemManager.addListener(UserItemEvent.ITEM_REMOVE,this.onItemUpdate);
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
         SkillManager.addEventListener(SkillManager.UPGRADE,this.showSkillPointNum);
         SkillManager.addEventListener(SkillManager.LEARN,this.showSkillPointNum);
         SocketConnection.addCmdListener(CommandID.SECOND_TURN_BACK,this.responseTurnback);
         this._autoYaBiao.addEventListener(MouseEvent.CLICK,this.onAutoYaBiao);
         SocketConnection.addCmdListener(CommandID.ESCORT_START,this.onEscortStart);
         SocketConnection.addCmdListener(CommandID.ESCORT_END,this.onEscortEnd);
      }
      
      protected function onQuickLvUpClick(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("QuickLvUpPanel");
      }
      
      protected function onCloseModule(param1:UIEvent) : void
      {
         var _loc2_:String = param1.data as String;
         if(_loc2_.indexOf("MoHunSystemPanel") != -1)
         {
            this.requestFreeCountData();
         }
         if(_loc2_.indexOf("SkillBookPanel") != -1)
         {
            this.showSkillPointNum();
         }
      }
      
      private function showSkillPointNum(param1:Event = null) : void
      {
         var _loc2_:int = int(MainManager.actorInfo.skillPoint);
         this._skillMc.txt.text = String(_loc2_);
         if(_loc2_ == 0 || Boolean(MainManager.actorInfo.isTurnBack))
         {
            this._skillMc.visible = false;
         }
         else
         {
            this._skillMc.visible = false;
         }
      }
      
      private function onMapSwich(param1:Event) : void
      {
      }
      
      private function onLevelChange(param1:UserEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:SharedObject = null;
         this._levelTxt.text = "Lv" + MainManager.actorInfo.lv.toString();
         this.refreshExpBarLock();
         this.refreshExpBar();
         if(MainManager.actorInfo.lv >= 50)
         {
            SumGuidTaskManager.getInstance().checkIsAutoAcceptTask();
         }
         if(this._effUserLv < 20 && MainManager.actorInfo.lv >= 20)
         {
            this._effUserLv = MainManager.actorInfo.lv;
            this._bottomBar.addChild(this._youngBookBtnEff);
         }
         if(param1)
         {
            _loc2_ = int(param1.data);
            if(_loc2_ > 0 && MainManager.actorInfo.lv >= 15)
            {
               if(MainManager.actorInfo.lv >= 60 && MainManager.actorInfo.fightTeamId == 0 && Boolean(TasksManager.isCompleted(519)))
               {
                  _loc3_ = SharedObject.getLocal("gf_" + MainManager.actorID + "_" + MainManager.actorInfo.createTime + "_toolbar_figtTeamTips");
                  if(Boolean(_loc3_.data.cartoonPlayed) == false)
                  {
                     this.showMovie(this._bottomBar["fightTeamTips"]);
                  }
               }
               this.updateIconState();
            }
         }
      }
      
      private function onTurnDayClick(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("TurnBackPanel");
      }
      
      private function onChuanqiClick(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("DaoMuBiJiPanel");
      }
      
      private function shenShouGeHandle(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("ShenShouGePanel");
      }
      
      private function onMoHunDayClick(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("MoHunSystemPanel","正在加载...",{"modalType":ModalType.DARK});
      }
      
      public function update() : void
      {
         this._bottomBar["buttons"]["turnButton"].visible = !(Boolean(MainManager.actorInfo.isTurnBack) || MainManager.actorInfo.lv < 80);
         this._bottomBar["buttons"]["chuanqiBtn"].visible = MainManager.actorInfo.isTurnBack && MainManager.actorInfo.lv >= 100;
      }
      
      private function refreshExpBar(... rest) : void
      {
         var _loc2_:UserInfo = MainManager.actorInfo;
         var _loc3_:Number = _loc2_.exp - AttributeConfig.calcTotalLvExp(_loc2_.roleType,_loc2_.lv,_loc2_.isTurnBack);
         var _loc4_:Number = Number(AttributeConfig.calcCurrentLvExp(_loc2_.roleType,_loc2_.lv + 1,_loc2_.isTurnBack));
         var _loc5_:Number = _loc3_ / _loc4_;
         if(_loc4_ == 0)
         {
            _loc5_ = 0;
         }
         _loc5_ = _loc5_ < 0 ? 0 : _loc5_;
         _loc5_ = _loc5_ > 1 ? 1 : _loc5_;
         this._expBar.scaleX = _loc5_;
         this._expTxt.text = (_loc5_ * 100).toFixed(2) + "%";
         this._bottomBar["expBar"]["expPerTxt"].text = _loc3_ + "/" + _loc4_;
         if(this._bottomBar["expBar"]["lock"].visible)
         {
            ToolTipManager.add(this._bottomBar["expBar"],"点击锁链可开始解锁");
         }
         else
         {
            ToolTipManager.add(this._bottomBar["expBar"],_loc3_.toString() + "/" + _loc4_.toString() + "升级还需要:" + (_loc4_ - _loc3_) + "点经验值",300);
         }
         this.resetBtn(this._godBtn,MainManager.actorInfo.lv >= 100);
         this.resetBtn(this._nbGodBtn,MainManager.actorInfo.lv >= 100);
         this.resetBtn(this._godInOneBtn,MainManager.actorInfo.lv >= 100);
         this.resetBtn(this._heroSoulBtn,MainManager.actorInfo.lv >= 90);
         this.resetBtn(this._strongestSoulBtn,MainManager.actorInfo.lv >= 90);
         if(MainManager.actorInfo.lv >= 90)
         {
            this._unlock90.visible = false;
         }
         if(MainManager.actorInfo.lv >= 100)
         {
            this._unlock100.visible = false;
         }
      }
      
      private function onActivedNewLevel(param1:Event) : void
      {
         var event:Event = param1;
         this._bottomBar["expBar"]["lock"].gotoAndPlay(1);
         this._bottomBar["expBar"]["lock"].visible = true;
         this._bottomBar["expBar"]["lock"].addFrameScript(this._bottomBar["expBar"]["lock"].totalFrames - 1,function():void
         {
            _bottomBar["expBar"]["lock"].gotoAndStop(1);
            refreshExpBarLock();
            refreshExpBar();
         });
      }
      
      private function refreshExpBarLock(param1:Event = null) : void
      {
         var _loc2_:int = int(MainManager.activedMaxLevel());
         this._bottomBar["expBar"]["lock"].visible = MainManager.actorInfo.isTurnBack && MainManager.actorInfo.lv == _loc2_ && MainManager.actorInfo.lv < MainManager.openedMaxLevel();
      }
      
      private function onExpLockClick(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = int(MainManager.actorInfo.lv);
         if(_loc2_ == 85)
         {
            ModuleManager.turnAppModule("PowerLadderPanel");
         }
         else if(_loc2_ == 90)
         {
            ModuleManager.turnAppModule("PowerLadderPanel");
         }
         else if(_loc2_ == 95)
         {
            ModuleManager.turnAppModule("PowerLadderPanel");
         }
         else if(_loc2_ == 100 || _loc2_ == 105 || _loc2_ == 110)
         {
            ModuleManager.turnAppModule("PowerLadderPanel");
         }
         else if(_loc2_ == 110)
         {
            ModuleManager.turnAppModule("UnlockLevel111Panel");
         }
         else if(_loc2_ == 111)
         {
            ModuleManager.turnAppModule("UnlockLevel112Panel");
         }
         else if(_loc2_ == 112)
         {
            ModuleManager.turnAppModule("UnlockLevel113Panel");
         }
         else if(_loc2_ == 113)
         {
            ModuleManager.turnAppModule("UnlockLevel114Panel");
         }
         else if(_loc2_ == 114)
         {
            ModuleManager.turnAppModule("UnlockLevel115Panel");
         }
         else if(_loc2_ == 115)
         {
            if(MainManager.roleType == 1 || MainManager.roleType == 3 || MainManager.roleType == 4 || MainManager.roleType == 3)
            {
               _loc3_ = int(ActivityExchangeTimesManager.getTimes(12180));
               if(_loc3_ == 2 || _loc3_ == 3)
               {
                  ModuleManager.turnAppModule("SecondTurnbackPanel");
               }
               else
               {
                  ModuleManager.turnAppModule("SecondTurnbackSelectRolePanel");
               }
            }
            else
            {
               AlertManager.showSimpleAlarm("敬请期待！");
            }
         }
      }
      
      protected function onSoundClick(param1:MouseEvent) : void
      {
         SoundManager.setMusicEnable(!SoundManager.isMusicEnable);
         ServerBuffManager.instance.setMusicEnable(SoundManager.isMusicEnable);
      }
      
      protected function onHideClick(param1:MouseEvent) : void
      {
         DeffEquiptManager.hideAllPlayer(!DeffEquiptManager.isHideAllPlayer);
      }
      
      private function onFreeCountBack(param1:DataEvent) : void
      {
         ActivityExchangeTimesManager.removeEventListener(3610,this.onFreeCountBack);
         if(MainManager.actorInfo.lv >= 80 && (ActivityExchangeTimesManager.getTimes(11203) > 0 || ActivityExchangeTimesManager.getTimes(11212) == 0))
         {
            this._mohunInfoTip.visible = true;
         }
         else
         {
            this._mohunInfoTip.visible = false;
         }
      }
      
      protected function onTransClick(param1:MouseEvent) : void
      {
         if(MainManager.actorInfo.lv < 30)
         {
            AlertManager.showSimpleAlarm("小侠士，等级达到30级以上可开启变身大师");
         }
         else
         {
            ModuleManager.turnAppModule("TransfigurationPanel");
         }
      }
      
      private function onPickItemHandle(param1:PickItemEvent) : void
      {
      }
      
      private function onItemReadyHandle(param1:Event) : void
      {
         this.checkBagTip();
      }
      
      private function onCityMapBtnMouseOver(param1:MouseEvent) : void
      {
         this._miniCityMapBtn.visible = true;
      }
      
      private function onCityMapBtnMouseOut(param1:MouseEvent) : void
      {
         this._miniCityMapBtn.visible = false;
      }
      
      private function removeEvent() : void
      {
         ModuleManager.event.removeEventListener(UIEvent.CLOSE_MODULE,this.onCloseModule);
         this._miniCityMapBtn.removeEventListener(MouseEvent.CLICK,this.onMinMapClick);
         this._cityMapBtn.removeEventListener(MouseEvent.CLICK,this.onCityMapBtnClick);
         this._coinBtn.removeEventListener(MouseEvent.CLICK,this.coinHandle);
         this._silverCoinBtn.removeEventListener(MouseEvent.CLICK,this.silverCoin);
         this._bagBtn.removeEventListener(MouseEvent.CLICK,this.onBagBtnClick);
         this._strengthBtn.removeEventListener(MouseEvent.CLICK,this.onStrengthBtnClick);
         this._goldCardBtn.removeEventListener(MouseEvent.CLICK,this.goldCardHandle);
         this._hufaBtn.removeEventListener(MouseEvent.CLICK,this.hufaHandle);
         this._summonBtn.removeEventListener(MouseEvent.CLICK,this.onSummonBtnClick);
         this._heroSoulBtn.removeEventListener(MouseEvent.CLICK,this.onHeroSoulClick);
         this._strongestSoulBtn.removeEventListener(MouseEvent.CLICK,this.strongestSoulHandle);
         this._godBtn.removeEventListener(MouseEvent.CLICK,this.godHandle);
         this._nbGodBtn.removeEventListener(MouseEvent.CLICK,this.nbGodHandle);
         this._godInOneBtn.removeEventListener(MouseEvent.CLICK,this.godInOneHandle);
         this._teamBtn.removeEventListener(MouseEvent.CLICK,this.onTeamBtnClick);
         MessageManager.removeEventListener(ChatEvent.CHAT_CHANGE,this.onChatInfoChange);
         this._imBtn.removeEventListener(MouseEvent.CLICK,this.onImBtnClick);
         this._friendsMC.removeEventListener(MouseEvent.CLICK,this.onImBtnClick);
         this._systemBtn.removeEventListener(MouseEvent.CLICK,this.onSystemBtnClick);
         this._skillBtn.removeEventListener(MouseEvent.CLICK,this.onSkillBtnClick);
         this._magicBtn.removeEventListener(MouseEvent.CLICK,this.onMagicBtnClick);
         this._juBtn.removeEventListener(MouseEvent.CLICK,this.onJuBtnClick);
         this._friendsMC.removeEventListener(MouseEvent.MOUSE_OVER,this.onFriendsBtnOver);
         this._friendsMC.removeEventListener(MouseEvent.MOUSE_OUT,this.onFriendsBtnOut);
         this._collectBtn.removeEventListener(MouseEvent.CLICK,this.onCollectBtnClick);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwich);
         this._teacherBtn.removeEventListener(MouseEvent.CLICK,this.onTeacherBtnClick);
         this._hideBtn.removeEventListener(MouseEvent.CLICK,this.onHideClick);
         this._soundBtn.removeEventListener(MouseEvent.CLICK,this.onSoundClick);
         SoundManager.event.removeEventListener(Event.CHANGE,this.updateView);
         DeffEquiptManager.event.removeEventListener(Event.CHANGE,this.updateView);
         this._bottomBar["buttons"]["turnButton"].removeEventListener(MouseEvent.CLICK,this.onTurnDayClick);
         this._bottomBar["buttons"]["chuanqiBtn"].removeEventListener(MouseEvent.CLICK,this.onChuanqiClick);
         this._bottomBar["buttons"]["mohunButton"].removeEventListener(MouseEvent.CLICK,this.onMoHunDayClick);
         this._bottomBar["buttons"]["youngBookBtn"].removeEventListener(MouseEvent.CLICK,this.onYoungBookBtnClick);
         UserInfoManager.ed.removeEventListener(UserEvent.LVL_CHANGE,this.onLevelChange);
         MainManager.actorModel.removeEventListener(UserEvent.GROW_CHANGE,this.refreshExpBar);
         UserManager.removeEventListener(UserEvent.TURN_BACK,this.refreshExpBar);
         MainManager.actorModel.removeEventListener(UserEvent.ACTIVE_NEW_LV,this.onActivedNewLevel);
         this._bottomBar["expBar"]["lock"].removeEventListener(MouseEvent.CLICK,this.onExpLockClick);
         SearchGodManager.removeEventListener(SearchGodManager.CHANGE_EVENT,this.updateView);
         ItemManager.removeListener(UserItemEvent.ITEM_ADD,this.onItemUpdate);
         ItemManager.removeListener(UserItemEvent.ITEM_REMOVE,this.onItemUpdate);
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
         SkillManager.removeEventListener(SkillManager.UPGRADE,this.showSkillPointNum);
         SkillManager.removeEventListener(SkillManager.LEARN,this.showSkillPointNum);
         SocketConnection.removeCmdListener(CommandID.SECOND_TURN_BACK,this.responseTurnback);
         this._autoYaBiao.removeEventListener(MouseEvent.CLICK,this.onAutoYaBiao);
         SocketConnection.removeCmdListener(CommandID.ESCORT_START,this.onEscortStart);
         SocketConnection.removeCmdListener(CommandID.ESCORT_END,this.onEscortEnd);
      }
      
      private function onEscortEnd(param1:SocketEvent) : void
      {
         this._autoYaBiao.visible = false;
      }
      
      private function onEscortStart(param1:SocketEvent) : void
      {
         this._autoYaBiao.visible = true;
      }
      
      private function onAutoYaBiao(param1:MouseEvent) : void
      {
         EscortPluginManager.instance.setup();
      }
      
      private function responseTurnback(param1:SocketEvent) : void
      {
         this.refreshExpBarLock(null);
      }
      
      private function onTaskComplete(param1:Event) : void
      {
         this.updateIconState();
      }
      
      private function onJuBtnClick(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("JuDianMainPanel");
      }
      
      private function onItemUpdate(param1:UserItemEvent) : void
      {
         var _loc2_:int = int(param1.param[0]);
         if(ItemManager.isShopCoin(_loc2_))
         {
            this.checkBagTip();
         }
      }
      
      private function onYoungBookBtnClick(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("GrowBookNewPanel");
      }
      
      public function updateYoungBookBtnShow() : void
      {
         var _loc1_:int = 0;
         for each(_loc1_ in this._showYoungBookSwapIdList)
         {
            if(ActivityExchangeTimesManager.getTimes(_loc1_) <= 0 && MainManager.actorInfo.lv >= 60)
            {
               this._bottomBar["buttons"]["bookTips"].visible = true;
               return;
            }
         }
         this._bottomBar["buttons"]["bookTips"].visible = false;
      }
      
      private function getShareBookObj() : SharedObject
      {
         var _loc1_:Date = TimeUtil.severDate;
         var _loc2_:String = _loc1_.fullYear.toString() + _loc1_.month.toString() + _loc1_.date.toString();
         return SOManager.getActorSO("_youngBookBtnEff" + _loc2_);
      }
      
      private function onTeacherBtnClick(param1:MouseEvent) : void
      {
         MasterManager.instance.openMasterPanel();
      }
      
      private function onMinMapClick(param1:MouseEvent) : void
      {
         MiniCityMap.instance.show();
      }
      
      private function onCityMapBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:AlignInfo = null;
         if(param1.target.name == "miniCityMapBtn")
         {
            MiniCityMap.instance.show();
         }
         else
         {
            if(MapManager.currentMap.info.mapType == MapType.TRADE)
            {
               if(MainManager.actorModel.visible == false)
               {
                  AlertManager.showSimpleAlarm(AppLanguageDefine.CITYTOOLBAR_CHARACTER_COLLECTION[1]);
                  return;
               }
            }
            if(TasksManager.isProcess(33,5))
            {
               AlertManager.showSimpleAlarm(AppLanguageDefine.CITYTOOLBAR_CHARACTER_COLLECTION[2]);
               return;
            }
            _loc2_ = new AlignInfo();
            _loc2_.x = this._bottomBar.x + 505;
            _loc2_.bottom = 67;
            ModuleManager.turnAppModule("WorldMapPanel",AppLanguageDefine.LOAD_MATTER_COLLECTION[19],{
               "triggerPosition":_loc2_,
               "modalType":ModalType.DARK
            });
         }
      }
      
      private function onInfoBtnClick(param1:MouseEvent) : void
      {
         this._mohunInfoTip.visible = false;
         if(MoreUserInfoController.getStatus == true)
         {
            ModuleManager.hideModule(ClientConfig.getAppModule("UserInfoPanel"));
            MoreUserInfoController.setStatus = false;
         }
         else
         {
            MoreUserInfoController.show(MainManager.actorInfo);
            MoreUserInfoController.setStatus = true;
         }
      }
      
      private function onBagBtnClick(param1:MouseEvent) : void
      {
         if(MapManager.currentMap.info.mapType == MapType.TRADE)
         {
            if(MainManager.actorModel.visible == false)
            {
               AlertManager.showSimpleAlarm(AppLanguageDefine.CITYTOOLBAR_CHARACTER_COLLECTION[3]);
               return;
            }
         }
         param1.stopImmediatePropagation();
         var _loc2_:AlignInfo = new AlignInfo();
         _loc2_.x = this._bottomBar.x + 600;
         _loc2_.bottom = 30;
         ModuleManager.turnAppModule("BagPanel",AppLanguageDefine.LOAD_MATTER_COLLECTION[21],{"triggerPosition":_loc2_});
      }
      
      private function coinHandle(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("IWantGFDPanel");
      }
      
      private function silverCoin(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("GoForSilverCoinPanel");
      }
      
      private function onStrengthBtnClick(param1:MouseEvent) : void
      {
         if(this._strengthBtnTip)
         {
            DisplayUtil.removeForParent(this._strengthBtnTip);
            this._strengthBtnTip = null;
         }
         if(TasksManager.isAccepted(511))
         {
            ModuleManager.turnAppModule("EquipCastingPanel","正在加载...",{
               "index":7,
               "modalType":ModalType.DARK
            });
         }
         else
         {
            ModuleManager.turnAppModule("EquipCastingPanel","正在加载...",{
               "index":(Boolean(MainManager.actorInfo.isTurnBack) && MainManager.actorInfo.lv >= 100 ? 9 : 7),
               "modalType":ModalType.DARK
            });
         }
      }
      
      private function goldCardHandle(param1:Event) : void
      {
         ModuleManager.turnAppModule("GoldCardPanel");
      }
      
      private function onStrengthBtnOver(param1:MouseEvent) : void
      {
      }
      
      private function onStrengthBtnOut(param1:MouseEvent) : void
      {
      }
      
      private function onSummonBtnClick(param1:MouseEvent) : void
      {
         DisplayObjectFlashUtil.instance.remove(this._summonBtn);
         if(MapManager.currentMap.info.mapType == MapType.TRADE)
         {
            if(MainManager.actorModel.visible == false)
            {
               AlertManager.showSimpleAlarm(AppLanguageDefine.CITYTOOLBAR_CHARACTER_COLLECTION[3]);
               return;
            }
         }
         this.turnSummonInfoPanel();
      }
      
      private function hufaHandle(param1:MouseEvent) : void
      {
         ModuleManager.turnModule(ClientConfig.getAppModule("NewSummonInfoPanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[22],{"label":1});
      }
      
      public function turnSummonInfoPanel(param1:String = null) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:SummonInfo = null;
         var _loc2_:UserSummonInfos = SummonManager.getActorSummonInfo();
         if(_loc2_.selectedSummonInfo == null)
         {
            _loc3_ = int(SummonManager.getCanHatchID());
            if(_loc3_ > 0)
            {
               _loc4_ = int(SummonXMLInfo.getHatchSummon(_loc3_));
               _loc5_ = SummonXMLInfo.getName(_loc4_);
               AlertManager.showSimpleAlert("小侠士，你当前没有可用仙兽！" + _loc5_ + "已可以孵化，是否孵化",this.toHatch);
            }
            else
            {
               _loc6_ = uint(_loc2_.summonBagList.length);
               if(_loc6_ > 0)
               {
                  _loc7_ = 0;
                  while(_loc7_ < _loc6_)
                  {
                     _loc8_ = _loc2_.summonBagList[_loc7_];
                     if(_loc8_.state == SummonStateType.STATE_BAG)
                     {
                        break;
                     }
                     _loc8_ = null;
                     _loc7_++;
                  }
                  if(_loc8_)
                  {
                     SummonManager.changeSelected(_loc8_.uniqueID);
                  }
                  this.getSummonPropInfo();
                  return;
               }
               if(_loc2_.summonStorageList.length > 0)
               {
                  SummonManager.addEventListener(SummonEvent.SUMMON_STORAGE,this.onSummonStorage);
                  SummonManager.summonStorage(SummonInfo(_loc2_.summonStorageList[0]).uniqueID,2);
                  return;
               }
               AlertManager.showSimpleAlarm(AppLanguageDefine.CITYTOOLBAR_CHARACTER_COLLECTION[6]);
               MultiChatPanel.instance.showSystemNotice("在功夫派里可不能缺少仙兽，赶快升到5级去" + TextUtil.getCodeByNpcId(10006) + "那里领取相关任务。");
            }
            return;
         }
         this._summonParams = param1;
         this.getSummonPropInfo();
      }
      
      private function getSummonPropInfo() : void
      {
         SummonManager.addEventListener(SummonEvent.SUMMON_PRO_UPDATE,this.onSummonProUpdate);
         SummonManager.requestListProp();
      }
      
      private function onSummonStorage(param1:SummonEvent) : void
      {
         var _loc2_:SummonInfo = param1.data as SummonInfo;
         SummonManager.changeSelected(_loc2_.uniqueID);
         this.getSummonPropInfo();
      }
      
      private function toHatch() : void
      {
         var _loc1_:int = int(SummonManager.getCanHatchID());
         SummonManager.hatchSummon(_loc1_);
      }
      
      private function onSummonProUpdate(param1:SummonEvent) : void
      {
         SummonManager.removeEventListener(SummonEvent.SUMMON_PRO_UPDATE,this.onSummonProUpdate);
         var _loc2_:AlignInfo = new AlignInfo();
         _loc2_.x = this._bottomBar.x + 660;
         _loc2_.bottom = 30;
         ModuleManager.turnModule(ClientConfig.getAppModule("NewSummonInfoPanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[22],{
            "secondPanelName":this._summonParams,
            "triggerPosition":_loc2_,
            "modalType":ModalType.DARK
         });
      }
      
      private function onCollectBtnClick(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("NewChengJiuPanel","正在加载...",{"modalType":ModalType.DARK});
         this.showGloryInfo(false);
      }
      
      private function onTeamBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:SharedObject = null;
         if(MapManager.currentMap.info.mapType == MapType.TRADE)
         {
            AlertManager.showSimpleAlarm("小侠士，万博会无法使用侠士团功能哦，请退出万博会再试。");
            return;
         }
         if(MainManager.actorInfo.lv >= 60 && MainManager.actorInfo.fightTeamId == 0)
         {
            _loc2_ = SharedObject.getLocal("gf_" + MainManager.actorID + "_" + MainManager.actorInfo.createTime + "_toolbar_figtTeamTips");
            if(Boolean(_loc2_.data.cartoonPlayed) == false)
            {
               this.hideMovie(this._bottomBar["fightTeamTips"]);
               _loc2_.data.cartoonPlayed = true;
               _loc2_.flush();
            }
         }
         if(MainManager.actorInfo.fightTeamId <= 0)
         {
            ModuleManager.turnAppModule("FightTeamListPanel","");
         }
         else
         {
            ModuleManager.turnAppModule("FightTeamsMemberListPanel","正在加载....",MainManager.actorInfo.fightTeamId);
         }
      }
      
      private function onChatInfoChange(param1:ChatEvent = null) : void
      {
         var _loc2_:uint = uint(MessageManager.getChatNum());
         if(_loc2_ > 0)
         {
            this._imInfoNum.visible = true;
            this._imInfoNum["numTxt"].text = _loc2_.toString();
         }
         else
         {
            this._imInfoNum.visible = false;
         }
      }
      
      private function onHeroSoulClick(param1:MouseEvent) : void
      {
         this.turnHeroSoulModule();
      }
      
      private function strongestSoulHandle(param1:Event) : void
      {
         ModuleManager.turnAppModule("TheStrongestHeroSoulPanel");
      }
      
      private function godHandle(param1:MouseEvent) : void
      {
         var _loc2_:GodInstanceInfo = null;
         if(GodManager.instance.godArr.length == 0 && GodManager.instance.getCanHatchItems().length == 0)
         {
            ModuleManager.turnAppModule("GoForGodGuardPanel");
         }
         else
         {
            _loc2_ = GodManager.instance.getFightingGod();
            if(_loc2_)
            {
               GodManager.instance.godArr.splice(GodManager.instance.godArr.indexOf(_loc2_),1);
               GodManager.instance.godArr.unshift(_loc2_);
            }
            ModuleManager.turnAppModule("GodPanel");
         }
      }
      
      private function nbGodHandle(param1:Event) : void
      {
         ModuleManager.turnAppModule("BestGodRecommendPanel");
      }
      
      private function godInOneHandle(param1:Event) : void
      {
         ModuleManager.turnAppModule("GodGuardWakeUpInOnePanel");
      }
      
      public function turnHeroSoulModule() : void
      {
         if(MapManager.currentMap.info.mapType == MapType.TRADE)
         {
            if(MainManager.actorModel.visible == false)
            {
               AlertManager.showSimpleAlarm(AppLanguageDefine.CITYTOOLBAR_CHARACTER_COLLECTION[3]);
               return;
            }
         }
         HeroSoulManager.addEventListener(HeroSoulEvent.UPDATE_ALL,this.responseHeroSoul);
         HeroSoulManager.requestList();
      }
      
      private function responseHeroSoul(param1:Event) : void
      {
         var _loc3_:int = 0;
         HeroSoulManager.removeEventListener(HeroSoulEvent.UPDATE_ALL,this.responseHeroSoul);
         var _loc2_:UserHeroSoulInfos = HeroSoulManager.getActorHeroSoulInfo();
         if(_loc2_.soulList.length == 0)
         {
            _loc3_ = int(HeroSoulManager.getCanHatchID());
            if(_loc3_ == 0)
            {
               ModuleManager.turnAppModule("GoForHeroSoulPanel");
               return;
            }
         }
         ModuleManager.turnAppModule("HeroSoulPanel");
      }
      
      private function onImBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         if(this._imInfoNum.visible)
         {
            _loc2_ = uint(MessageManager.getFirstTalk());
            TalkManager.showTalkPanel(_loc2_,0);
            this.onChatInfoChange();
         }
         else if(param1.currentTarget != this._friendsMC)
         {
            IMController.show();
         }
      }
      
      private function onSystemBtnClick(param1:MouseEvent) : void
      {
         SystemPanel.show(param1.currentTarget as DisplayObject);
      }
      
      private function onSkillBtnClick(param1:MouseEvent) : void
      {
         if(MapManager.isFightMap)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.BATTERY_CHARACTER_COLLECTION[10]);
         }
         else
         {
            this.openSkillBook();
         }
      }
      
      private function onMagicBtnClick(param1:MouseEvent) : void
      {
         if(ActivityExchangeTimesManager.getTimes(7915) == 0)
         {
            ActivityExchangeCommander.exchange(7915);
         }
         MagicChangeManager.instance.openMagicPanel();
      }
      
      private function onExpandBtnOver(param1:MouseEvent) : void
      {
      }
      
      private function onExpandBtnOut(param1:MouseEvent) : void
      {
      }
      
      private function onFriendsBtnOver(param1:MouseEvent) : void
      {
         this._teacherBtn.visible = true;
         this._imBtn.visible = true;
         this._friendsContainer.visible = true;
         this._imInfoNum.x = 273;
         this._imInfoNum.y = -2;
      }
      
      private function onFriendsBtnOut(param1:MouseEvent) : void
      {
         this._teacherBtn.visible = false;
         this._imBtn.visible = false;
         this._friendsContainer.visible = false;
         this._imInfoNum.x = 354;
         this._imInfoNum.y = 51;
      }
      
      private function onCardBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:Array = CardManager.instance.getAllCards();
         if(_loc2_.length > 0)
         {
            ModuleManager.turnAppModule("CardHandbookSelfPanel","正在加卡牌。。。");
         }
         else
         {
            ModuleManager.turnAppModule("CardHandbookPanel","正在加卡牌。。。");
         }
      }
      
      public function setBagBtnFlash(param1:Boolean) : void
      {
         if(param1)
         {
            DisplayObjectFlashUtil.remove(this._bagBtn);
         }
         else
         {
            DisplayObjectFlashUtil.add(this._bagBtn);
         }
      }
      
      public function get bagBtn() : SimpleButton
      {
         return this._bagBtn;
      }
      
      public function setSkillBtnFlash(param1:Boolean) : void
      {
         if(param1)
         {
            DisplayObjectFlashUtil.remove(this._skillBtn);
         }
         else
         {
            DisplayObjectFlashUtil.add(this._skillBtn);
         }
      }
      
      public function updateSummonEvolveState() : void
      {
         if(SummonEvolveManager.isCurrentSummonEvolveAble())
         {
            DisplayObjectFlashUtil.add(this._summonBtn);
         }
         else
         {
            DisplayObjectFlashUtil.remove(this._summonBtn);
         }
         this.setDragonIcons();
      }
      
      public function setDragonIcons() : void
      {
         if(RoleDisplayUtil.isRoleGraduate())
         {
            this._summonBtn.enabled = true;
            this._summonBtn.filters = null;
            this._summonBtn.mouseEnabled = true;
         }
      }
      
      public function showSkillBtn() : void
      {
         var _loc1_:Boolean = false;
         if(Boolean(TasksManager.isCompleted(3)) || Boolean(TasksManager.isCompleted(202)) || Boolean(TasksManager.isCompleted(300)))
         {
            _loc1_ = true;
         }
         else if(Boolean(TasksManager.isProcess(3,0)) || Boolean(TasksManager.isProcess(301,0)) || Boolean(TasksManager.isProcess(301,1)) || Boolean(TasksManager.isProcess(3,1)) || Boolean(TasksManager.isReady(3)) || Boolean(TasksManager.isReady(301)))
         {
            _loc1_ = true;
         }
         if(MainManager.actorInfo.roleType == Constant.ROLE_TYPE_DARGON)
         {
            if(TasksManager.isCompleted(46))
            {
               _loc1_ = true;
            }
         }
         this.setSkillBtnVis(_loc1_);
      }
      
      private function setSkillBtnVis(param1:Boolean) : void
      {
         if(param1 == false)
         {
            if(this._skillBtn)
            {
               this._skillBtn.filters = [ColorFilter.setBrightness(-70)];
               this._skillBtn.removeEventListener(MouseEvent.CLICK,this.onSkillBtnClick);
               ToolTipManager.add(this._skillBtn,AppLanguageDefine.BATTERY_CHARACTER_COLLECTION[13]);
            }
         }
         else if(this._skillBtn)
         {
            this._skillBtn.filters = [];
            this._skillBtn.addEventListener(MouseEvent.CLICK,this.onSkillBtnClick);
         }
      }
      
      public function get skillBtn() : SimpleButton
      {
         return this._skillBtn;
      }
      
      public function get summonBtn() : SimpleButton
      {
         return this._summonBtn;
      }
      
      public function get strengthBtn() : SimpleButton
      {
         return this._strengthBtn;
      }
      
      private function openSkillBook() : void
      {
         var noUserStoneID:uint = 0;
         var aInfo:AlertInfo = null;
         noUserStoneID = uint(this.getSkillStoneId());
         if(noUserStoneID != 0 && MainManager.actorInfo.isTurnBack == false)
         {
            aInfo = new AlertInfo();
            aInfo.type = AlertType.ALERT;
            aInfo.str = AppLanguageDefine.BATTERY_CHARACTER_COLLECTION[11];
            aInfo.applyFun = function():void
            {
               ItemManager.useItem(noUserStoneID);
               isBatteryUse = true;
               showSkillBtn();
            };
            aInfo.cancelFun = function():void
            {
               turnSkillBook();
               showSkillBtn();
            };
            AlertManager.closeCurrentAlert();
            AlertManager.showForInfo(aInfo);
         }
         else
         {
            this.turnSkillBook();
         }
      }
      
      private function getSkillStoneId() : int
      {
         var _loc4_:SingleItemInfo = null;
         var _loc1_:Array = ItemManager.itemList;
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _loc1_[_loc3_];
            if(ItemXMLInfo.getCatID(_loc4_.itemID) == 12 && MainManager.actorInfo.lv >= ItemXMLInfo.getUserLevel(_loc4_.itemID))
            {
               return _loc4_.itemID;
            }
            _loc3_++;
         }
         return 0;
      }
      
      private function turnSkillBook() : void
      {
         if(MapManager.currentMap.info.mapType == MapType.TRADE)
         {
            AlertManager.showTradeMapUnavailableAlarm();
            return;
         }
         if(MainManager.actorInfo.isTurnBack)
         {
            ModuleManager.turnModule(ClientConfig.getAppModule("SkillBookForNewPlayerPanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[18]);
         }
         else
         {
            ModuleManager.turnModule(ClientConfig.getAppModule("SkillBookPanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[18]);
         }
      }
      
      override protected function needToReponseNew() : Boolean
      {
         return false;
      }
      
      private function hideMovie(param1:MovieClip) : void
      {
         if(param1)
         {
            param1.visible = false;
            param1.stop();
         }
      }
      
      private function showMovie(param1:MovieClip) : void
      {
         if(param1)
         {
            param1.visible = true;
            param1.play();
         }
      }
   }
}

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.MouseEvent;

class ChildButton
{
   
   private var _ui:Sprite;
   
   private var _overHideChilds:Vector.<DisplayObject>;
   
   public function ChildButton(param1:Sprite, param2:Vector.<DisplayObject>)
   {
      super();
      this._ui = param1;
      this._overHideChilds = param2;
      this._ui.addEventListener(MouseEvent.ROLL_OVER,this.overHandle);
      this._ui.addEventListener(MouseEvent.ROLL_OUT,this.outHandle);
      this.outHandle(null);
   }
   
   private function overHandle(param1:MouseEvent) : void
   {
      var _loc2_:DisplayObject = null;
      for each(_loc2_ in this._overHideChilds)
      {
         _loc2_.visible = true;
      }
   }
   
   private function outHandle(param1:MouseEvent) : void
   {
      var _loc2_:DisplayObject = null;
      for each(_loc2_ in this._overHideChilds)
      {
         _loc2_.visible = false;
      }
   }
   
   public function destroy() : void
   {
      this._ui.addEventListener(MouseEvent.ROLL_OVER,this.overHandle);
      this._ui.addEventListener(MouseEvent.ROLL_OUT,this.outHandle);
   }
}
