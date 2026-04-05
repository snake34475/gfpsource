package com.gfp.app.toolBar
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.manager.ChallengeSummonManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.keyboard.KeyItemProcess;
   import com.gfp.core.action.keyboard.KeySkillProcess;
   import com.gfp.core.buff.ActorOperateBuffManager;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.config.xml.SkillXMLInfo;
   import com.gfp.core.controller.FightInteractiveController;
   import com.gfp.core.controller.KeyController;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.controller.keyProcess.KeyProcessManager;
   import com.gfp.core.controller.keyProcess.core.IKeyProcess;
   import com.gfp.core.events.CDEvent;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.FightInteractiveEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.SkillEvent;
   import com.gfp.core.events.SummonEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.CDInfo;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.info.SkillUpgradeInfo;
   import com.gfp.core.info.SummonShenTongInfo;
   import com.gfp.core.info.SummonShenTongStepInfo;
   import com.gfp.core.info.fight.SkillInfo;
   import com.gfp.core.info.fight.SkillLevelInfo;
   import com.gfp.core.info.item.SingleItemInfo;
   import com.gfp.core.language.CoreLanguageDefine;
   import com.gfp.core.manager.CDManager;
   import com.gfp.core.manager.FocusManager;
   import com.gfp.core.manager.HeroSoulManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ServerBuffManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.SummonShenTongManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.manager.WeaponGildManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.ActorModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.ExtenalUIPanel;
   import com.gfp.core.ui.ItemInfoTip;
   import com.gfp.core.ui.QuickBarButton;
   import com.gfp.core.ui.QuickButton;
   import com.gfp.core.ui.SkillIcon;
   import com.gfp.core.ui.SkillInfoTip;
   import com.gfp.core.ui.TipsManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.FightMode;
   import com.gfp.core.utils.FilterUtil;
   import com.gfp.core.utils.ItemSubType;
   import com.gfp.core.utils.KeyCodeType;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class QuickBarComponent extends Sprite
   {
      
      private static var _instance:QuickBarComponent;
      
      public static const FUNCTION_BTN_CLICK:String = "function_btn_click";
      
      private static var disableSetQuickSkills:Array = [800701,800702,800703,800704,800705,800706,800707,800708,800709,800801,800802,800803,800804,800805,800806,800807,800808,800809,800901,800902,800903,800904,800905,800906,800907,800908,800909,801001,801002,801003,801004,801005,801006,801007,801008,801009];
      
      private const ITEM_START_INDEX:int = 0;
      
      private const SKILL_START_INDEX:int = 4;
      
      private const CATCH_SUMMON_INDEX:int = 11;
      
      public const SUMRACE_START_INDEX:int = 15;
      
      private var _mainUI:Sprite;
      
      private var _mapType:int;
      
      private var _stageID:uint;
      
      private var _qBtnList:Vector.<QuickButton>;
      
      public var sumRaceList:Vector.<QuickButton>;
      
      private var _shenTongList:Array;
      
      private var _shenTongBack:ExtenalUIPanel;
      
      private var _gildSkillBtn:QuickBarButton;
      
      private var _heroSoulBtn:QuickBarButton;
      
      private var _heroSoulBtnEffect:MovieClip;
      
      private var _summonBtn:QuickBarButton;
      
      private var _summonBtnEffect:MovieClip;
      
      private var _atFightScene:Boolean;
      
      private var _icon:Sprite;
      
      private var _quickBtn:QuickButton;
      
      private var _startDrag:Boolean = false;
      
      public function QuickBarComponent(param1:Boolean = false)
      {
         var _loc2_:KeyInfo = null;
         var _loc3_:Sprite = null;
         var _loc4_:Sprite = null;
         this._qBtnList = new Vector.<QuickButton>();
         this.sumRaceList = new Vector.<QuickButton>();
         this._shenTongList = new Array();
         super();
         this._atFightScene = param1;
         this._mainUI = new Sprite();
         addChild(this._mainUI);
         if(param1 && Boolean(SummonManager.getActorSummonInfo().currentSummonInfo))
         {
            _loc2_ = new KeyInfo();
            _loc2_.dataID = SummonManager.CALL_SUMMON_SKILL_ID;
            _loc2_.lv = 1;
            _loc2_.type = KeyCodeType.SKILL;
            _loc2_.name = "5";
            this._summonBtn = new QuickBarButton(_loc2_);
            this._mainUI.addChild(this._summonBtn);
            this._summonBtn.addEventListener(MouseEvent.CLICK,this.onSummonClick);
            this._summonBtn.buttonMode = true;
            this._summonBtn.mouseChildren = false;
            this._summonBtn.setBackground(UIManager.getSprite("ToolBar_QuickButton"));
            this._summonBtn.init(_loc2_.dataID,_loc2_.type,_loc2_.lv);
            this._summonBtn.x = 362;
            this._summonBtn.addEventListener(MouseEvent.ROLL_OVER,this.onSkillOver,false,0,true);
            this._summonBtn.addEventListener(MouseEvent.ROLL_OUT,this.onSkillOut,false,0,true);
            this._summonBtnEffect = UIManager.getMovieClip("ToolBar_QuickButton_Effect");
            this._mainUI.addChild(this._summonBtnEffect);
            this._summonBtnEffect.x = this._summonBtn.x;
            this._summonBtnEffect.y = this._summonBtn.y;
            this._summonBtnEffect.mouseChildren = false;
            this._summonBtnEffect.mouseEnabled = false;
            _loc3_ = UIManager.getSprite("ToolBar_SummonBtnGuide");
            this._summonBtnEffect.addChild(_loc3_);
            _loc3_.y = -55;
            if(Boolean(SummonManager.autoCallFight) || FightManager.summonCallEnabled == false)
            {
               this.setSummonBtnEnabled(false);
               DisplayUtil.removeForParent(this._summonBtnEffect);
            }
         }
         if(MainManager.actorInfo.heroSoulType > 0)
         {
            _loc2_ = new KeyInfo();
            _loc2_.dataID = HeroSoulManager.CALL_SOUL_SKILL_ID;
            _loc2_.lv = 1;
            _loc2_.type = KeyCodeType.SKILL;
            _loc2_.name = "6";
            this._heroSoulBtn = new QuickBarButton(_loc2_);
            this._mainUI.addChild(this._heroSoulBtn);
            this._heroSoulBtn.addEventListener(MouseEvent.CLICK,this.onHeroSoulClick);
            this._heroSoulBtn.buttonMode = true;
            this._heroSoulBtn.setBackground(UIManager.getSprite("ToolBar_QuickButton"));
            this._heroSoulBtn.init(_loc2_.dataID,_loc2_.type,_loc2_.lv);
            this._heroSoulBtn.x = 400;
            this._heroSoulBtn.mouseChildren = false;
            this._heroSoulBtn.addEventListener(MouseEvent.ROLL_OVER,this.onSkillOver,false,0,true);
            this._heroSoulBtn.addEventListener(MouseEvent.ROLL_OUT,this.onSkillOut,false,0,true);
            this._heroSoulBtnEffect = UIManager.getMovieClip("ToolBar_QuickButton_Effect");
            this._mainUI.addChild(this._heroSoulBtnEffect);
            this._heroSoulBtnEffect.x = this._heroSoulBtn.x;
            this._heroSoulBtnEffect.y = this._heroSoulBtn.y;
            this._heroSoulBtnEffect.mouseChildren = false;
            this._heroSoulBtnEffect.mouseEnabled = false;
            _loc4_ = UIManager.getSprite("ToolBar_HeroSoulBtnGuide");
            this._heroSoulBtnEffect.addChild(_loc4_);
            _loc4_.y = -55;
            if(HeroSoulManager.getActorHeroSoulInfo().currentHeroSoulInfo == null || HeroSoulManager.getActorHeroSoulInfo().currentHeroSoulInfo.state == 3)
            {
               this.setHeroSoulBtnEnabled(false);
               DisplayUtil.removeForParent(this._heroSoulBtnEffect);
            }
         }
         this.initItemQuickKeys();
         this.initSkillQuickKeys();
         this.initShenTongKeys();
         if(param1)
         {
            SocketConnection.addCmdListener(CommandID.STAGE_AFRESH,this.onStageAfresh);
            FightManager.instance.addEventListener(FightEvent.SUMMON_CALL_ENABLED,this.summonCallEnabled);
         }
         CDManager.skillCD.addEventListener(CDEvent.START,this.onSkillCD);
         CDManager.skillCD.addEventListener(CDEvent.RUNING,this.onSkillCD);
         CDManager.skillCD.addEventListener(CDEvent.RUNED,this.onSkillCD);
         CDManager.skillCD.addEventListener(CDEvent.CDING,this.onSkillCD);
         CDManager.skillCD.addEventListener(CDEvent.CDED,this.onSkillCD);
         CDManager.itemCD.addEventListener(CDEvent.START,this.onItemCD);
         CDManager.itemCD.addEventListener(CDEvent.RUNING,this.onItemCD);
         CDManager.itemCD.addEventListener(CDEvent.RUNED,this.onItemCD);
         CDManager.itemCD.addEventListener(CDEvent.CDING,this.onItemCD);
         CDManager.itemCD.addEventListener(CDEvent.CDED,this.onItemCD);
         UserManager.addEventListener(SkillEvent.SKILL_ACTION,this.onCallSoulSkill);
         ChallengeSummonManager.addEventListner(SummonEvent.SUMMON_CATCH_COMPLETE,this.clearCatchSummonKeys);
         MapManager.addEventListener(MapEvent.MAP_DESTROY,this.onMapDestroy);
         ItemManager.addListener(ItemManager.EVENT_ITEMREFLASH,this.itemReflash);
         MainManager.actorModel.addEventListener(UserEvent.GROW_CHANGE,this.onUserInfoChange);
         MainManager.actorModel.addEventListener(UserEvent.SKILL_CHANGE,this.onSkillChange);
         MainManager.actorModel.addEventListener(UserEvent.ADD_ITEM_QUICK,this.onAddItemChange);
         KeyManager.addEventListener(KeyManager.QUICK_KEY_CHANGE,this.onQuickKeyChange);
         UserManager.addEventListener(UserEvent.MP_CHANGE,this.onUserHpMpChange);
         UserManager.addEventListener(UserEvent.HP_CHANGE,this.onUserHpMpChange);
         this.resetGildSkill();
      }
      
      public static function get instance() : QuickBarComponent
      {
         if(_instance == null)
         {
            _instance = new QuickBarComponent();
         }
         return _instance;
      }
      
      public static function addEventListener(param1:String, param2:Function) : void
      {
         instance.addEventListener(param1,param2);
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void
      {
         instance.removeEventListener(param1,param2);
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      public function showCallBtns() : void
      {
         if(this._summonBtn)
         {
            this._summonBtn.visible = true;
         }
         if(this._heroSoulBtn)
         {
            this._heroSoulBtn.visible = true;
         }
         if(this._summonBtnEffect)
         {
            this._summonBtnEffect.visible = true;
         }
         if(this._heroSoulBtnEffect)
         {
            this._heroSoulBtnEffect.visible = true;
         }
      }
      
      public function hideCallBtns() : void
      {
         if(this._summonBtn)
         {
            this._summonBtn.visible = false;
         }
         if(this._heroSoulBtn)
         {
            this._heroSoulBtn.visible = false;
         }
         if(this._summonBtnEffect)
         {
            this._summonBtnEffect.visible = false;
         }
         if(this._heroSoulBtnEffect)
         {
            this._heroSoulBtnEffect.visible = false;
         }
      }
      
      private function summonCallEnabled(param1:Event) : void
      {
         if(this._summonBtn)
         {
            this.setSummonBtnEnabled(SummonManager.autoCallFight == false && FightManager.summonCallEnabled);
         }
      }
      
      private function setSummonBtnEnabled(param1:Boolean) : void
      {
         if(this._summonBtn)
         {
            this._summonBtn.mouseEnabled = param1;
            this._summonBtn.filters = param1 ? [] : FilterUtil.GRAY_FILTER;
         }
      }
      
      private function setHeroSoulBtnEnabled(param1:Boolean) : void
      {
         if(this._heroSoulBtn)
         {
            this._heroSoulBtn.mouseEnabled = param1;
            this._heroSoulBtn.filters = param1 ? [] : FilterUtil.GRAY_FILTER;
         }
      }
      
      public function resetGildSkill() : void
      {
         var _loc2_:KeyInfo = null;
         this.destroyGildBtn();
         var _loc1_:int = int(WeaponGildManager.getActorGildSkillID());
         if(_loc1_ > 0)
         {
            _loc2_ = new KeyInfo();
            _loc2_.dataID = _loc1_;
            _loc2_.lv = 1;
            _loc2_.type = KeyCodeType.SKILL;
            _loc2_.name = "G";
            this._gildSkillBtn = new QuickBarButton(_loc2_);
            this._mainUI.addChild(this._gildSkillBtn);
            this._gildSkillBtn.addEventListener(MouseEvent.CLICK,this.onGildSkillBtnClick);
            this._gildSkillBtn.buttonMode = true;
            this._gildSkillBtn.setBackground(UIManager.getSprite("ToolBar_QuickButton"));
            this._gildSkillBtn.init(_loc2_.dataID,_loc2_.type,_loc2_.lv);
            this._gildSkillBtn.y = -41;
            this._gildSkillBtn.x = 208;
            this._gildSkillBtn.addEventListener(MouseEvent.ROLL_OVER,this.onSkillOver,false,0,true);
            this._gildSkillBtn.addEventListener(MouseEvent.ROLL_OUT,this.onSkillOut,false,0,true);
         }
      }
      
      private function destroyGildBtn() : void
      {
         if(this._gildSkillBtn)
         {
            this._gildSkillBtn.removeEventListener(MouseEvent.ROLL_OVER,this.onSkillOver,false);
            this._gildSkillBtn.removeEventListener(MouseEvent.ROLL_OUT,this.onSkillOut,false);
            this._gildSkillBtn.removeEventListener(MouseEvent.CLICK,this.onGildSkillBtnClick);
            DisplayUtil.removeForParent(this._gildSkillBtn);
            this._gildSkillBtn.destroy();
            this._gildSkillBtn = null;
         }
      }
      
      protected function onStageAfresh(param1:SocketEvent) : void
      {
         if(this._heroSoulBtn)
         {
            if(HeroSoulManager.getActorHeroSoulInfo().currentHeroSoulInfo == null || HeroSoulManager.getActorHeroSoulInfo().currentHeroSoulInfo.state == 3)
            {
               this.setHeroSoulBtnEnabled(false);
               DisplayUtil.removeForParent(this._heroSoulBtnEffect);
            }
            else
            {
               this.setHeroSoulBtnEnabled(true);
            }
         }
         if(this._summonBtn)
         {
            if(Boolean(SummonManager.getActorSummonInfo().currentSummonInfo) && Boolean(FightManager.summonCallEnabled) && SummonManager.autoCallFight == false)
            {
               this.setSummonBtnEnabled(true);
            }
            else
            {
               this.setSummonBtnEnabled(false);
               DisplayUtil.removeForParent(this._summonBtnEffect);
            }
         }
      }
      
      private function onCallSoulSkill(param1:SkillEvent) : void
      {
         if(Boolean(param1.skillID == HeroSoulManager.CALL_SOUL_SKILL_ID) && Boolean(param1.model) && param1.model.info.userID == MainManager.actorID)
         {
            if(this._heroSoulBtn)
            {
               this.setHeroSoulBtnEnabled(false);
               DisplayUtil.removeForParent(this._heroSoulBtnEffect);
            }
         }
         if(Boolean(param1.skillID == SummonManager.CALL_SUMMON_SKILL_ID) && Boolean(param1.model) && param1.model.info.userID == MainManager.actorID)
         {
            this.setSummonBtnEnabled(false);
            DisplayUtil.removeForParent(this._summonBtnEffect);
         }
      }
      
      private function onHeroSoulClick(param1:MouseEvent) : void
      {
         if(MapManager.mapInfo.mapType == MapType.PVE)
         {
            HeroSoulManager.callSoulForPVE();
         }
      }
      
      private function onSummonClick(param1:MouseEvent) : void
      {
         if(MapManager.mapInfo.mapType == MapType.PVE || MapManager.mapInfo.mapType == MapType.PVP)
         {
            SummonManager.callSummonFight();
         }
      }
      
      private function onGildSkillBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:KeyInfo = null;
         if(MapManager.isFightMap)
         {
            _loc2_ = new KeyInfo();
            _loc2_.dataID = WeaponGildManager.getActorGildSkillID();
            _loc2_.lv = 1;
            KeySkillProcess.exec(MainManager.actorModel,_loc2_);
         }
      }
      
      private function onCatchSummonItemUse(param1:MouseEvent) : void
      {
         var _loc2_:QuickButton = param1.currentTarget as QuickButton;
         var _loc3_:KeyInfo = _loc2_.keyInfo;
         if(_loc3_)
         {
            KeyItemProcess.exec(MainManager.actorModel,_loc3_);
         }
      }
      
      private function clearCatchSummonKeys(param1:Event = null) : void
      {
         var _loc4_:QuickButton = null;
         var _loc2_:int = 4;
         var _loc3_:int = this.CATCH_SUMMON_INDEX;
         while(_loc3_ < this.CATCH_SUMMON_INDEX + _loc2_)
         {
            _loc4_ = this._qBtnList[_loc3_];
            if(_loc4_)
            {
               this._qBtnList[_loc3_] = null;
               TipsManager.removeTip(_loc4_);
               DisplayUtil.removeForParent(_loc4_);
               _loc4_.destroy();
               _loc4_ = null;
            }
            _loc3_++;
         }
      }
      
      private function onMapDestroy(param1:MapEvent) : void
      {
         if(SummonManager.catchtable)
         {
            SummonManager.catchtable = false;
         }
      }
      
      private function onUserHpMpChange(param1:UserEvent) : void
      {
         var _loc2_:QuickButton = null;
         if(param1.data is ActorModel)
         {
            for each(_loc2_ in this._qBtnList)
            {
               if(Boolean(_loc2_) && Boolean(_loc2_.keyType == KeyCodeType.SKILL) && !_loc2_.keyInfo.isVisual)
               {
                  _loc2_.checkUserHpMp();
               }
            }
         }
      }
      
      private function onQuickKeyChange(param1:Event) : void
      {
         this.clearItemQuickKeys();
         this.initItemQuickKeys();
         this.clearSkillQuickKeys();
         this.initSkillQuickKeys();
      }
      
      private function initItemQuickKeys() : void
      {
         var cdArr:Array = null;
         var info:CDInfo = null;
         var i:int = 0;
         var btn:QuickButton = null;
         KeyManager.itemQuickKeys.forEach(function(param1:uint, param2:int, param3:Vector.<uint>):void
         {
            var _loc4_:KeyInfo = KeyManager.getSingleInfoForFuncID(param1);
            var _loc5_:QuickButton = new QuickBarButton(_loc4_);
            _loc5_.buttonMode = true;
            _loc5_.setBackground(UIManager.getSprite("ToolBar_QuickButton"));
            _loc5_.init(_loc4_.dataID,_loc4_.type,_loc4_.lv);
            if(_loc4_.type == KeyCodeType.ITEM)
            {
               _loc5_.count = ItemManager.getItemCount(_loc4_.dataID);
            }
            _loc5_.x = param2 * (_loc5_.width + 2) + (_atFightScene ? 208 : 328);
            _qBtnList[ITEM_START_INDEX + param2] = _loc5_;
            _mainUI.addChild(_loc5_);
            _loc5_.addEventListener(MouseEvent.MOUSE_DOWN,onBtnDrag,false,0,true);
            if(_loc4_.type == KeyCodeType.ITEM)
            {
               _loc5_.addEventListener(MouseEvent.ROLL_OVER,onItemOver,false,0,true);
               _loc5_.addEventListener(MouseEvent.ROLL_OUT,onItemOut,false,0,true);
            }
            else if(_loc4_.type == KeyCodeType.SKILL)
            {
               _loc5_.addEventListener(MouseEvent.ROLL_OVER,onSkillOver,false,0,true);
               _loc5_.addEventListener(MouseEvent.ROLL_OUT,onSkillOut,false,0,true);
            }
         });
         LayerManager.stage.addEventListener(MouseEvent.MOUSE_UP,this.onBtnDragEnd,false,0,true);
         if(Boolean(MapManager.mapInfo) && (MapManager.mapInfo.mapType == MapType.PVE || MapManager.mapInfo.mapType == MapType.PVP || MapManager.mapInfo.mapType == MapType.PVAI))
         {
            cdArr = CDManager.itemCD.getAllCDInfos();
            for each(info in cdArr)
            {
               i = this.ITEM_START_INDEX;
               while(i < this.ITEM_START_INDEX + 5)
               {
                  btn = this._qBtnList[i];
                  if(btn.dataID == info.id)
                  {
                     btn.startCD(info.cdTime,info.id);
                  }
                  else
                  {
                     btn.startCD(info.runTime,info.id);
                  }
                  i++;
               }
            }
         }
      }
      
      private function clearItemQuickKeys() : void
      {
         var _loc3_:QuickButton = null;
         var _loc1_:int = 4;
         var _loc2_:int = this.ITEM_START_INDEX;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._qBtnList[_loc2_];
            this._qBtnList[_loc2_] = null;
            DisplayUtil.removeForParent(_loc3_);
            _loc3_.destroy();
            _loc3_ = null;
            _loc2_++;
         }
         LayerManager.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onBtnDragEnd,false);
      }
      
      public function initSumRaceSkillQuickKeys() : void
      {
         var cdArr:Array;
         var cinfo:CDInfo = null;
         var i:int = 0;
         var btn:QuickButton = null;
         KeyManager.catchSummonRaceSkill.forEach(function(param1:uint, param2:int, param3:Vector.<uint>):void
         {
            var _loc4_:KeyInfo = KeyManager.getSingleInfoForFuncID(param1);
            var _loc5_:QuickButton = new QuickBarButton(_loc4_,_loc4_.code - 8);
            _loc5_.buttonMode = true;
            _loc5_.setBackground(UIManager.getSprite("ToolBar_QuickButton"));
            _loc5_.init(_loc4_.dataID,_loc4_.type,_loc4_.lv);
            sumRaceList[SUMRACE_START_INDEX + param2] = _loc5_;
            _loc5_.addEventListener(MouseEvent.ROLL_OVER,onSkillOver,false,0,true);
            _loc5_.addEventListener(MouseEvent.CLICK,onSumRaceClick,false,0,true);
            _loc5_.addEventListener(MouseEvent.ROLL_OUT,onSkillOut,false,0,true);
         });
         cdArr = CDManager.skillCD.getAllCDInfos();
         for each(cinfo in cdArr)
         {
            i = this.SUMRACE_START_INDEX;
            while(i < this.SUMRACE_START_INDEX + 3)
            {
               btn = this.sumRaceList[i];
               if(btn.dataID == cinfo.id)
               {
                  btn.startCD(cinfo.cdTime,cinfo.id);
               }
               else
               {
                  btn.startCD(cinfo.runTime,cinfo.id);
               }
               i++;
            }
         }
      }
      
      private function initShenTongKeys() : void
      {
         var _loc2_:Vector.<KeyInfo> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:SummonShenTongStepInfo = null;
         var _loc7_:int = 0;
         var _loc8_:KeyInfo = null;
         var _loc9_:QuickBarButton = null;
         var _loc1_:Vector.<SummonShenTongInfo> = SummonShenTongManager.getData();
         if(_loc1_)
         {
            _loc2_ = SummonShenTongManager.getActiveSkill();
            _loc3_ = int(_loc1_.length);
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               if(Boolean(_loc1_[_loc5_]) && Boolean(_loc1_[_loc5_].getMatchShenTong()))
               {
                  _loc6_ = _loc1_[_loc5_].getMatchShenTong();
                  _loc7_ = this.getShentongActitySkillIndex(_loc6_.skillId,_loc2_);
                  _loc8_ = new KeyInfo();
                  if(_loc7_ != -1)
                  {
                     _loc8_.dataID = _loc6_.skillId;
                     _loc8_.lv = _loc6_.skillLevel;
                     _loc8_.name = _loc7_ == 0 ? "B" : (ServerBuffManager.instance.keyBoardControlType == KeyController.CONTROL_WASD ? "V" : "M");
                     _loc8_.type = KeyCodeType.SKILL;
                  }
                  else
                  {
                     _loc8_.dataID = _loc6_.skillId;
                     _loc8_.lv = _loc6_.skillLevel;
                     _loc8_.name = "nothing";
                     _loc8_.type = KeyCodeType.SKILL;
                  }
                  _loc9_ = new QuickBarButton(_loc8_);
                  _loc9_.buttonMode = true;
                  _loc9_.setBackground(UIManager.getSprite("ToolBar_QuickButton"));
                  _loc9_.init(_loc8_.dataID,_loc8_.type,_loc8_.lv);
                  _loc9_.x = 114 + _loc4_ * (36 + 2);
                  _loc9_.y = -40;
                  this._mainUI.addChild(_loc9_);
                  this._shenTongList.push(_loc9_);
                  _loc9_.addEventListener(MouseEvent.ROLL_OVER,this.onSkillOver,false,0,true);
                  _loc9_.addEventListener(MouseEvent.ROLL_OUT,this.onSkillOut,false,0,true);
                  if(_loc7_ != -1)
                  {
                     _loc9_.addEventListener(MouseEvent.MOUSE_DOWN,this.onBtnDrag,false,0,true);
                     _loc9_.addEventListener(MouseEvent.MOUSE_UP,this.onBtnDragEnd,false,0,true);
                  }
                  _loc4_++;
               }
               _loc5_++;
            }
            if(_loc9_)
            {
               this._shenTongBack = new ExtenalUIPanel("shen_tong_back");
               this._shenTongBack.x = 114;
               this._shenTongBack.y = -40;
               this._mainUI.addChildAt(this._shenTongBack,0);
            }
         }
      }
      
      public function removeShentong() : void
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this._shenTongList)
         {
            if(_loc1_ is SkillIcon)
            {
               (_loc1_ as SkillIcon).destroy();
            }
            else if(_loc1_ is QuickButton)
            {
               (_loc1_ as QuickButton).destroy();
            }
         }
         this._shenTongList = [];
         if(this._shenTongBack)
         {
            this._shenTongBack.destory();
            this._shenTongBack = null;
         }
      }
      
      private function getShentongActitySkillIndex(param1:int, param2:Vector.<KeyInfo>) : int
      {
         var _loc3_:int = 0;
         if(param2)
         {
            _loc3_ = 0;
            while(_loc3_ < param2.length)
            {
               if(param2[_loc3_].dataID == param1)
               {
                  return _loc3_;
               }
               _loc3_++;
            }
         }
         return -1;
      }
      
      private function initSkillQuickKeys() : void
      {
         var cdArr:Array = null;
         var info:CDInfo = null;
         var i:int = 0;
         var btn:QuickButton = null;
         KeyManager.skillQuickKeys.forEach(function(param1:uint, param2:int, param3:Vector.<uint>):void
         {
            var _loc4_:KeyInfo = KeyManager.getSingleInfoForFuncID(param1);
            var _loc5_:QuickButton = new QuickBarButton(_loc4_,-1,_atFightScene);
            _loc5_.buttonMode = true;
            _loc5_.setBackground(UIManager.getSprite("ToolBar_QuickButton"));
            _loc5_.init(_loc4_.dataID,_loc4_.type,_loc4_.lv);
            if(_atFightScene)
            {
               _loc5_.x = param2 % 5 * (_loc5_.width + 2);
               _loc5_.y = int(param2 / 5) * -(_loc5_.height + 5);
            }
            else
            {
               _loc5_.x = param2 * (_loc5_.width + 2);
            }
            _qBtnList[SKILL_START_INDEX + param2] = _loc5_;
            _mainUI.addChild(_loc5_);
            _loc5_.addEventListener(MouseEvent.ROLL_OVER,onSkillOver,false,0,true);
            _loc5_.addEventListener(MouseEvent.ROLL_OUT,onSkillOut,false,0,true);
            _loc5_.addEventListener(MouseEvent.MOUSE_DOWN,onBtnDrag,false,0,true);
            _loc5_.addEventListener(MouseEvent.MOUSE_UP,onBtnDragEnd,false,0,true);
         });
         if(Boolean(MapManager.mapInfo) && (MapManager.mapInfo.mapType == MapType.PVE || MapManager.mapInfo.mapType == MapType.PVP))
         {
            cdArr = CDManager.skillCD.getAllCDInfos();
            for each(info in cdArr)
            {
               i = this.SKILL_START_INDEX;
               while(i < this.SKILL_START_INDEX + 6)
               {
                  btn = this._qBtnList[i];
                  if(btn.dataID == info.id)
                  {
                     btn.startCD(info.cdTime,info.id);
                  }
                  else
                  {
                     btn.startCD(info.runTime,info.id);
                  }
                  i++;
               }
               if(this._gildSkillBtn)
               {
                  if(this._gildSkillBtn.dataID == info.id)
                  {
                     this._gildSkillBtn.startCD(info.cdTime,info.id);
                  }
                  else
                  {
                     this._gildSkillBtn.startCD(info.runTime,info.id);
                  }
               }
            }
         }
         if(this._heroSoulBtn)
         {
            if(FightManager.fightMode != FightMode.PVE)
            {
               this._heroSoulBtn.visible = false;
               this._heroSoulBtnEffect.visible = false;
               this._heroSoulBtnEffect.stop();
            }
         }
      }
      
      public function getQuickBarBtn(param1:int) : QuickButton
      {
         return this._qBtnList[param1];
      }
      
      public function initCD() : void
      {
         var _loc2_:QuickButton = null;
         var _loc3_:KeyInfo = null;
         var _loc4_:SkillLevelInfo = null;
         var _loc5_:CDInfo = null;
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = this._qBtnList[this.SKILL_START_INDEX + _loc1_];
            _loc3_ = _loc2_.keyInfo;
            if(Boolean(_loc2_.keyInfo) && _loc3_.dataID != 0)
            {
               _loc4_ = SkillXMLInfo.getLevelInfo(_loc3_.dataID,_loc3_.lv);
               _loc5_ = new CDInfo();
               _loc5_.id = _loc3_.dataID;
               _loc5_.runTime = _loc4_.duration;
               _loc5_.cdTime = _loc4_.cd;
               CDManager.skillCD.add(_loc5_);
            }
            _loc1_++;
         }
         if(this._gildSkillBtn)
         {
            _loc3_ = this._gildSkillBtn.keyInfo;
            _loc4_ = SkillXMLInfo.getLevelInfo(_loc3_.dataID,_loc3_.lv);
            _loc5_ = new CDInfo();
            _loc5_.id = _loc3_.dataID;
            _loc5_.runTime = _loc4_.duration;
            _loc5_.cdTime = _loc4_.cd;
            CDManager.skillCD.add(_loc5_);
         }
      }
      
      public function clearSkillQuickKeys() : void
      {
         var _loc2_:QuickButton = null;
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = this._qBtnList[this.SKILL_START_INDEX + _loc1_];
            _loc2_.clear();
            _loc2_.destroy();
            DisplayUtil.removeForParent(_loc2_);
            _loc1_++;
         }
      }
      
      public function clearSumRaceQuickKeys() : void
      {
         var _loc2_:QuickButton = null;
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = this.sumRaceList[this.SUMRACE_START_INDEX + _loc1_];
            _loc2_.clear();
            _loc2_.destroy();
            DisplayUtil.removeForParent(_loc2_);
            _loc1_++;
         }
         this.sumRaceList = null;
      }
      
      public function disabledSkillQuickKeys() : void
      {
         var _loc2_:QuickButton = null;
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = this._qBtnList[this.SKILL_START_INDEX + _loc1_];
            _loc2_.mouseEnabled = false;
            _loc2_.mouseChildren = false;
            _loc1_++;
         }
         if(this._gildSkillBtn)
         {
            this._gildSkillBtn.mouseEnabled = false;
            this._gildSkillBtn.mouseChildren = false;
         }
      }
      
      public function enabledSkillQuickKeys() : void
      {
         var _loc2_:QuickButton = null;
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = this._qBtnList[this.SKILL_START_INDEX + _loc1_];
            _loc2_.mouseEnabled = true;
            _loc2_.mouseChildren = true;
            _loc1_++;
         }
         if(this._gildSkillBtn)
         {
            this._gildSkillBtn.mouseEnabled = true;
            this._gildSkillBtn.mouseChildren = true;
         }
      }
      
      public function show(param1:int, param2:uint = 0) : void
      {
         this.layout();
         StageResizeController.instance.register(this.layout);
         LayerManager.toolUiLevel.addChildAt(this._mainUI,0);
         this._mapType = param1;
         this._stageID = param2;
         MainManager.actorModel.addEventListener(UserEvent.MP_CHANGE,this.onMpChange);
         this.checkMapType();
      }
      
      public function hide() : void
      {
         MainManager.actorModel.removeEventListener(UserEvent.MP_CHANGE,this.onMpChange);
         DisplayUtil.removeForParent(this._mainUI,false);
         StageResizeController.instance.unregister(this.layout);
      }
      
      private function layout() : void
      {
         this._mainUI.y = LayerManager.stageHeight;
      }
      
      private function checkMapType() : void
      {
         var _loc1_:QuickButton = null;
         for each(_loc1_ in this._qBtnList)
         {
            if(Boolean(_loc1_) && _loc1_.keyType == KeyCodeType.ITEM)
            {
               _loc1_.checkMapType(this._mapType,this._stageID);
            }
         }
      }
      
      public function clearCD() : void
      {
         var _loc3_:QuickButton = null;
         var _loc1_:uint = this._qBtnList.length;
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._qBtnList[_loc2_];
            if(Boolean(_loc3_) && _loc3_.dataID != 0)
            {
               _loc3_.endCD(_loc3_.cdTargetID);
            }
            _loc2_++;
         }
      }
      
      public function clearSumRaceCd() : void
      {
         var _loc3_:QuickButton = null;
         var _loc1_:uint = this.sumRaceList.length;
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.sumRaceList[_loc2_];
            if(Boolean(_loc3_) && _loc3_.dataID != 0)
            {
               _loc3_.endCD(_loc3_.cdTargetID);
            }
            _loc2_++;
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:QuickButton = null;
         var _loc2_:Object = null;
         this.hide();
         SocketConnection.removeCmdListener(CommandID.STAGE_AFRESH,this.onStageAfresh);
         FightManager.instance.removeEventListener(FightEvent.SUMMON_CALL_ENABLED,this.summonCallEnabled);
         CDManager.skillCD.removeEventListener(CDEvent.START,this.onSkillCD);
         CDManager.skillCD.removeEventListener(CDEvent.RUNING,this.onSkillCD);
         CDManager.skillCD.removeEventListener(CDEvent.RUNED,this.onSkillCD);
         CDManager.skillCD.removeEventListener(CDEvent.CDING,this.onSkillCD);
         CDManager.skillCD.removeEventListener(CDEvent.CDED,this.onSkillCD);
         CDManager.itemCD.removeEventListener(CDEvent.START,this.onItemCD);
         CDManager.itemCD.removeEventListener(CDEvent.RUNING,this.onItemCD);
         CDManager.itemCD.removeEventListener(CDEvent.RUNED,this.onItemCD);
         CDManager.itemCD.removeEventListener(CDEvent.CDING,this.onItemCD);
         CDManager.itemCD.removeEventListener(CDEvent.CDED,this.onItemCD);
         UserManager.removeEventListener(SkillEvent.SKILL_ACTION,this.onCallSoulSkill);
         ChallengeSummonManager.removeEventListener(SummonEvent.SUMMON_CATCH_COMPLETE,this.clearCatchSummonKeys);
         MapManager.removeEventListener(MapEvent.MAP_DESTROY,this.onMapDestroy);
         KeyManager.removeEventListener(KeyManager.QUICK_KEY_CHANGE,this.onQuickKeyChange);
         MainManager.actorModel.removeEventListener(UserEvent.ADD_ITEM_QUICK,this.onAddItemChange);
         MainManager.actorModel.removeEventListener(UserEvent.SKILL_CHANGE,this.onSkillChange);
         ItemManager.removeListener(ItemManager.EVENT_ITEMREFLASH,this.itemReflash);
         MainManager.actorModel.removeEventListener(UserEvent.GROW_CHANGE,this.onUserInfoChange);
         UserManager.removeEventListener(UserEvent.MP_CHANGE,this.onUserHpMpChange);
         UserManager.removeEventListener(UserEvent.HP_CHANGE,this.onUserHpMpChange);
         for each(_loc1_ in this._qBtnList)
         {
            if(_loc1_)
            {
               _loc1_.destroy();
            }
         }
         for each(_loc1_ in this.sumRaceList)
         {
            if(_loc1_)
            {
               _loc1_.destroy();
            }
         }
         for each(_loc2_ in this._shenTongList)
         {
            if(_loc2_ is SkillIcon)
            {
               (_loc2_ as SkillIcon).destroy();
            }
            else if(_loc2_ is QuickButton)
            {
               (_loc2_ as QuickButton).destroy();
            }
         }
         if(this._shenTongBack)
         {
            this._shenTongBack.destory();
            this._shenTongBack = null;
         }
         this.destroyGildBtn();
         this._qBtnList = null;
         this.sumRaceList = null;
         this._mainUI = null;
         LayerManager.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onBtnDragEnd,false);
      }
      
      private function onSkillCD(param1:CDEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:uint = 0;
         var _loc6_:QuickButton = null;
         var _loc2_:Vector.<QuickButton> = this._qBtnList.concat(this.sumRaceList);
         for each(_loc3_ in this._shenTongList)
         {
            if(_loc3_ is QuickButton)
            {
               _loc2_.push(_loc3_);
            }
         }
         _loc4_ = _loc2_.length;
         if(this._gildSkillBtn)
         {
            _loc4_++;
         }
         var _loc5_:uint = 0;
         for(; _loc5_ < _loc4_; _loc5_++)
         {
            _loc6_ = _loc5_ == _loc2_.length ? this._gildSkillBtn : _loc2_[_loc5_];
            if(!((Boolean(_loc6_)) && Boolean(_loc6_.keyType == KeyCodeType.SKILL) && _loc6_.dataID != 0))
            {
               continue;
            }
            switch(param1.type)
            {
               case CDEvent.START:
                  if(param1.targetID == _loc6_.dataID)
                  {
                     _loc6_.startCD(param1.cdTime,param1.targetID);
                  }
                  else
                  {
                     _loc6_.startCD(param1.runTime,param1.targetID);
                  }
                  break;
               case CDEvent.RUNING:
                  if(param1.targetID != _loc6_.dataID)
                  {
                     _loc6_.updateCD(param1.time,param1.targetID);
                  }
                  break;
               case CDEvent.RUNED:
                  if(param1.targetID != _loc6_.dataID)
                  {
                     _loc6_.endCD(param1.targetID);
                  }
                  break;
               case CDEvent.CDING:
                  if(param1.targetID == _loc6_.dataID)
                  {
                     _loc6_.updateCD(param1.time,param1.targetID);
                  }
                  break;
               case CDEvent.CDED:
                  if(param1.targetID == _loc6_.dataID)
                  {
                     _loc6_.endCD(param1.targetID);
                  }
            }
         }
      }
      
      private function onItemCD(param1:CDEvent) : void
      {
         var _loc5_:QuickButton = null;
         var _loc6_:int = 0;
         var _loc2_:uint = this._qBtnList.length;
         var _loc3_:int = int(CDManager.itemCD.getCDType(param1.targetID));
         var _loc4_:uint = 0;
         for(; _loc4_ < _loc2_; _loc4_++)
         {
            _loc5_ = this._qBtnList[_loc4_];
            if(!((Boolean(_loc5_)) && Boolean(_loc5_.keyType == KeyCodeType.ITEM) && _loc5_.dataID != 0))
            {
               continue;
            }
            switch(param1.type)
            {
               case CDEvent.START:
                  if(param1.targetID == _loc5_.dataID)
                  {
                     _loc5_.startCD(param1.cdTime,param1.targetID);
                  }
                  else
                  {
                     _loc6_ = int(CDManager.itemCD.getCDType(_loc5_.dataID));
                     if(_loc6_ == _loc3_)
                     {
                        _loc5_.startCD(param1.runTime,param1.targetID);
                     }
                  }
                  break;
               case CDEvent.RUNING:
                  if(param1.targetID != _loc5_.dataID)
                  {
                     _loc5_.updateCD(param1.time,param1.targetID);
                  }
                  break;
               case CDEvent.RUNED:
                  if(param1.targetID != _loc5_.dataID)
                  {
                     _loc5_.endCD(param1.targetID);
                  }
                  break;
               case CDEvent.CDING:
                  if(param1.targetID == _loc5_.dataID)
                  {
                     _loc5_.updateCD(param1.time,param1.targetID);
                  }
                  break;
               case CDEvent.CDED:
                  if(param1.targetID == _loc5_.dataID)
                  {
                     _loc5_.endCD(param1.targetID);
                  }
            }
         }
      }
      
      private function onSumRaceClick(param1:MouseEvent) : void
      {
         var _loc4_:SkillLevelInfo = null;
         var _loc5_:CDInfo = null;
         var _loc2_:QuickButton = param1.currentTarget as QuickButton;
         var _loc3_:KeyInfo = _loc2_.keyInfo;
         if(CDManager.skillCD.cdContains(_loc3_.dataID))
         {
            TextAlert.show(CoreLanguageDefine.TEXTALERT_MSG_ARR[0]);
            return;
         }
         if(Boolean(_loc2_.keyInfo) && _loc3_.dataID != 0)
         {
            _loc4_ = SkillXMLInfo.getLevelInfo(_loc3_.dataID,1);
            _loc5_ = new CDInfo();
            _loc5_.id = _loc3_.dataID;
            _loc5_.runTime = _loc4_.duration;
            _loc5_.cdTime = _loc4_.cd;
            CDManager.skillCD.add(_loc5_);
         }
         SocketConnection.send(CommandID.FIGHT_ACTIVITY_EFFECT,5,this.sumRaceList.indexOf(_loc2_) - 15,0);
      }
      
      private function onSkillOver(param1:MouseEvent) : void
      {
         var _loc2_:QuickButton = param1.currentTarget as QuickButton;
         var _loc3_:SkillInfo = new SkillInfo();
         _loc3_.id = _loc2_.dataID;
         _loc3_.lv = _loc2_.lv;
         if(_loc3_.id)
         {
            SkillInfoTip.show(_loc3_);
         }
      }
      
      private function onSkillOut(param1:MouseEvent) : void
      {
         SkillInfoTip.hide();
      }
      
      private function onSkillToolBarUse(param1:QuickButton) : void
      {
         if(MapManager.isFightMap)
         {
            if(!ActorOperateBuffManager.instance.checkFaint())
            {
               KeySkillProcess.exec(MainManager.actorModel,param1.keyInfo);
            }
         }
      }
      
      private function onBtnDrag(param1:MouseEvent) : void
      {
         var _loc2_:IKeyProcess = null;
         this._quickBtn = param1.currentTarget as QuickButton;
         this._icon = this._quickBtn.icon as Sprite;
         if(this._quickBtn.keyInfo)
         {
            FightInteractiveController.instance.mouseDownDataID = this._quickBtn.keyInfo.dataID;
            FightInteractiveController.instance.dispatchEvent(new FightInteractiveEvent(FightInteractiveEvent.PRESS,this._quickBtn.keyInfo));
            if(MapManager.isFightMap)
            {
               _loc2_ = KeyProcessManager.instance.processKeyDown(this._quickBtn.keyInfo);
            }
            if(!_loc2_)
            {
               this.onSkillToolBarUse(this._quickBtn);
               return;
            }
            if(_loc2_.processKeyDown(this._quickBtn.keyInfo))
            {
               return;
            }
            this.onSkillToolBarUse(this._quickBtn);
         }
      }
      
      private function onBtnDragEnd(param1:MouseEvent) : void
      {
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:QuickButton = null;
         var _loc9_:KeyInfo = null;
         var _loc10_:KeyInfo = null;
         if(this._icon == null)
         {
            return;
         }
         this._icon.stopDrag();
         this._icon = null;
         this._startDrag = false;
         var _loc2_:Boolean = false;
         var _loc3_:uint = this._qBtnList.length;
         var _loc4_:int = -1;
         var _loc5_:int = 5;
         switch(this._quickBtn.keyType)
         {
            case KeyCodeType.SKILL:
               _loc4_ = this.SKILL_START_INDEX;
               _loc5_ = 6;
               break;
            case KeyCodeType.ITEM:
               _loc4_ = this.ITEM_START_INDEX;
         }
         if(_loc4_ == -1)
         {
            return;
         }
         if(Boolean(this._quickBtn.keyInfo.dataID) && disableSetQuickSkills.indexOf(this._quickBtn.keyInfo.dataID) == -1)
         {
            _loc6_ = [];
            _loc7_ = _loc4_;
            while(_loc7_ < _loc4_ + _loc5_)
            {
               _loc8_ = this._qBtnList[_loc7_];
               if(_loc8_ != this._quickBtn)
               {
                  if(_loc8_.hitTestPoint(LayerManager.stage.mouseX,LayerManager.stage.mouseY))
                  {
                     _loc2_ = true;
                     _loc9_ = _loc8_.keyInfo.clone();
                     _loc10_ = this._quickBtn.keyInfo.clone();
                     _loc9_.funcID = _loc10_.funcID;
                     _loc10_.funcID = _loc8_.keyInfo.funcID;
                     _loc6_.push(_loc9_);
                     _loc6_.push(_loc10_);
                  }
                  else
                  {
                     _loc6_.push(_loc8_.keyInfo);
                  }
               }
               _loc7_++;
            }
         }
         if(!_loc2_)
         {
            this._quickBtn.resetIconPos();
            switch(this._quickBtn.keyType)
            {
               case KeyCodeType.SKILL:
                  this.onSkillToolBarUse(this._quickBtn);
                  break;
               case KeyCodeType.ITEM:
                  this.onItemToolBarUse(this._quickBtn);
            }
            dispatchEvent(new Event(FUNCTION_BTN_CLICK));
         }
         FocusManager.setDefaultFocus();
         FightInteractiveController.instance.mouseDownDataID = 0;
         if(this._quickBtn.keyInfo)
         {
            FightInteractiveController.instance.dispatchEvent(new FightInteractiveEvent(FightInteractiveEvent.RELEASE,this._quickBtn.keyInfo));
         }
      }
      
      private function onItemOver(param1:MouseEvent) : void
      {
         var _loc2_:QuickButton = param1.currentTarget as QuickButton;
         var _loc3_:SingleItemInfo = new SingleItemInfo();
         _loc3_.itemID = _loc2_.dataID;
         _loc3_.itemNum = _loc2_.itemNum;
         if(_loc3_.itemID)
         {
            ItemInfoTip.showItem(_loc3_);
         }
      }
      
      private function onItemOut(param1:MouseEvent) : void
      {
         ItemInfoTip.hide();
      }
      
      private function onItemToolBarUse(param1:QuickButton) : void
      {
         if(MapManager.isFightMap)
         {
            if(ItemXMLInfo.isSubTypeItem(param1.keyInfo.dataID,ItemSubType.ITEM_CHANGE_VIEW))
            {
               return;
            }
            if(ItemXMLInfo.isSubTypeItem(param1.keyInfo.dataID,ItemSubType.ITEM_CITY_USE))
            {
               return;
            }
            KeyItemProcess.exec(MainManager.actorModel,param1.keyInfo);
         }
         else if(ItemXMLInfo.isSubTypeItem(param1.keyInfo.dataID,ItemSubType.ITEM_CHANGE_VIEW))
         {
            KeyItemProcess.exec(MainManager.actorModel,param1.keyInfo);
         }
         else if(ItemXMLInfo.isSubTypeItem(param1.keyInfo.dataID,ItemSubType.ITEM_CITY_USE))
         {
            KeyItemProcess.exec(MainManager.actorModel,param1.keyInfo);
         }
      }
      
      private function itemReflash(param1:Event) : void
      {
         var _loc2_:QuickButton = null;
         for each(_loc2_ in this._qBtnList)
         {
            if(Boolean(_loc2_) && _loc2_.keyType == KeyCodeType.ITEM)
            {
               _loc2_.count = ItemManager.getItemCount(_loc2_.dataID);
            }
         }
      }
      
      private function onUserInfoChange(param1:UserEvent) : void
      {
         var _loc2_:QuickButton = null;
         for each(_loc2_ in this._qBtnList)
         {
            if(Boolean(_loc2_) && _loc2_.keyType == KeyCodeType.ITEM)
            {
               _loc2_.checkUserLevel();
            }
         }
      }
      
      private function onMpChange(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_)
         {
            this.checkMp(_loc2_.getMP());
         }
      }
      
      private function checkMp(param1:int) : void
      {
         var mp:int = param1;
         this._qBtnList.forEach(function(param1:QuickButton, param2:int, param3:Vector.<QuickButton>):Boolean
         {
            var _loc4_:uint = 0;
            if(param2 >= 5 && param2 < 10)
            {
               _loc4_ = uint(SkillXMLInfo.caculateMP(param1.dataID,param1.lv));
               if(_loc4_ > mp)
               {
                  param1.enabled = false;
               }
               else
               {
                  param1.enabled = true;
               }
               return false;
            }
            return true;
         });
      }
      
      private function onSkillChange(param1:UserEvent) : void
      {
         var _loc3_:QuickButton = null;
         var _loc2_:SkillUpgradeInfo = param1.data;
         if(_loc2_)
         {
            for each(_loc3_ in this._qBtnList)
            {
               if(Boolean(_loc3_) && _loc3_.keyType == KeyCodeType.SKILL)
               {
                  if(_loc3_.dataID == _loc2_.skillID)
                  {
                     _loc3_.lv = _loc2_.skillLv;
                     return;
                  }
               }
            }
         }
      }
      
      private function onAddItemChange(param1:UserEvent) : void
      {
         var _loc3_:QuickButton = null;
         var _loc2_:KeyInfo = param1.data;
         if(_loc2_)
         {
            for each(_loc3_ in this._qBtnList)
            {
               if(_loc3_.funcID == _loc2_.funcID)
               {
                  _loc3_.init(_loc2_.dataID,_loc2_.type,_loc2_.lv);
                  _loc3_.count = ItemManager.getItemCount(_loc2_.dataID);
               }
            }
         }
      }
   }
}

