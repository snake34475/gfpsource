package com.gfp.app.toolBar
{
   import com.gfp.core.CommandID;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.AttributeConfig;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.SummonXMLInfo;
   import com.gfp.core.controller.KeyController;
   import com.gfp.core.controller.SocketSendController;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.HpMpInfo;
   import com.gfp.core.info.SummonInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.fight.BruiseInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.SummonModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.filter.ColorFilter;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class HeadSummonPanel
   {
      
      private static var _instance:HeadSummonPanel;
      
      private var _mainUI:Sprite;
      
      private var _lvTxt:TextField;
      
      private var _nameTxt:TextField;
      
      private var _mpTxt:TextField;
      
      private var _expTxt:TextField;
      
      private var _mpBar:Sprite;
      
      private var _expBar:Sprite;
      
      private var _expRect:Rectangle;
      
      private var _mpRect:Rectangle;
      
      private var _hpWidth:Number;
      
      private var _mpWidth:Number;
      
      private var _expWidth:Number;
      
      private var _headIcon:Sprite;
      
      private var _model:SummonModel;
      
      private var _rageMC:MovieClip;
      
      private var _rageMC_V:MovieClip;
      
      private var _rageMC_M:MovieClip;
      
      private var _HPText:TextField;
      
      private var _HPBar:Sprite;
      
      private var _HPWidth:Number;
      
      private var _HPRect:Rectangle;
      
      private var _followAI:MovieClip;
      
      private var _deadAI:MovieClip;
      
      private var _crazyAI:MovieClip;
      
      private var _listAIUI:Array;
      
      private var _cutDownHolder:Sprite;
      
      private var _isRaceStatus:Boolean;
      
      private const _totalFightValue:uint = 100;
      
      private const _totalBunous:uint = 100;
      
      private const _lowValue:uint = 10;
      
      private var _reviveTime:uint;
      
      private var _reviveTimeID:uint;
      
      private var _reviveCount:uint;
      
      public function HeadSummonPanel()
      {
         super();
         this._mainUI = UIManager.getSprite("Head_SummonInfoPanel");
         this._lvTxt = this._mainUI["lvTxt"];
         this._nameTxt = this._mainUI["nameTxt"];
         this._HPText = this._mainUI["HP_txt"];
         this._mpTxt = this._mainUI["mpTxt"];
         this._expTxt = this._mainUI["expTxt"];
         this._HPBar = this._mainUI["HP_mc"];
         this._mpBar = this._mainUI["mp_mc"];
         this._expBar = this._mainUI["exp_mc"];
         this._rageMC_V = this._mainUI["mc_rage_V"];
         this._rageMC_M = this._mainUI["mc_rage_M"];
         this._followAI = this._mainUI["followAI"];
         this._crazyAI = this._mainUI["crazyAI"];
         this._deadAI = this._mainUI["deadAI"];
         this._listAIUI = [this._followAI,this._crazyAI,this._deadAI];
         this.initAIState();
         this.addAITips();
         this._HPWidth = this._HPBar.width;
         this._HPRect = new Rectangle(0,0,0,this._HPBar.height);
         this._HPBar.scrollRect = this._HPRect;
         this._mpWidth = this._mpBar.width;
         this._mpRect = new Rectangle(0,0,0,this._mpBar.height);
         this._mpBar.scrollRect = this._mpRect;
         this._expWidth = this._expBar.width;
         this._expRect = new Rectangle(0,0,0,this._expBar.height);
         this._expBar.scrollRect = this._expRect;
         this._mpTxt.text = "0/" + this._totalBunous.toString();
         DisplayUtil.removeForParent(this._rageMC_V,false);
         DisplayUtil.removeForParent(this._rageMC_M,false);
         if(KeyController.currentControlType == 1)
         {
            this._rageMC = this._rageMC_V;
         }
         else
         {
            this._rageMC = this._rageMC_M;
         }
         DisplayUtil.removeForParent(this._rageMC);
         this._cutDownHolder = new Sprite();
         this._cutDownHolder.x = this._cutDownHolder.y = 9;
      }
      
      public static function get instance() : HeadSummonPanel
      {
         if(_instance == null)
         {
            _instance = new HeadSummonPanel();
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
      
      public function initAIState() : void
      {
         var _loc1_:MovieClip = null;
         for each(_loc1_ in this._listAIUI)
         {
            _loc1_.gotoAndStop(1);
            _loc1_.addEventListener(MouseEvent.CLICK,this.onuiAIClick);
         }
         this.setAI(this._listAIUI[0]);
      }
      
      public function setAI(param1:MovieClip) : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         while(_loc4_ < this._listAIUI.length)
         {
            _loc3_ = this._listAIUI[_loc4_];
            if(_loc3_ == param1)
            {
               _loc3_.gotoAndStop(2);
               param1.mouseEnabled = false;
               _loc2_ = _loc4_;
            }
            else
            {
               _loc3_.gotoAndStop(1);
               param1.mouseEnabled = true;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function setRaceStatus() : void
      {
         this._isRaceStatus = true;
         ToolTipManager.add(this._followAI,"【奔跑】仙兽专心向前，速度增加20%。\n快捷键【7】");
         ToolTipManager.add(this._crazyAI,"【1技能】1技能只要不在冷却中，仙兽就会立即使用它。\n快捷键【8】");
         ToolTipManager.add(this._deadAI,"【2技能】2技能只要不在冷却中，仙兽就会立即使用它。\n快捷键【9】");
      }
      
      public function recoverStatus() : void
      {
         this._isRaceStatus = false;
      }
      
      private function addAITips() : void
      {
         ToolTipManager.add(this._followAI,"【跟随】跟随主人，增加攻击力和防御力。\n快捷键【7】");
         ToolTipManager.add(this._crazyAI,"【狂暴】不停的攻击目标，大幅增强攻击力。\n快捷键【8】");
         ToolTipManager.add(this._deadAI,"【防御】呆在原地不动，大幅增强防御力。\n快捷键【9】");
      }
      
      private function onuiAIClick(param1:Event) : void
      {
         if(this._model.getHP() != 0)
         {
            if(this._isRaceStatus)
            {
               SocketSendController.sendSummAIChangeCMD(this.setAI(param1.currentTarget as MovieClip) + 3);
            }
            else
            {
               SocketSendController.sendSummAIChangeCMD(this.setAI(param1.currentTarget as MovieClip));
            }
         }
      }
      
      private function onAIChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         SummonManager.AI_State = _loc3_;
         if(_loc3_ < 3)
         {
            this.setAI(this._listAIUI[_loc3_]);
         }
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(this._model.getHP() != 0)
         {
            _loc2_ = param1.keyCode;
            _loc3_ = this._isRaceStatus ? 3 : 0;
            if(_loc2_ == 55)
            {
               SocketSendController.sendSummAIChangeCMD(_loc3_);
               this.setAI(this._listAIUI[0]);
            }
            else if(_loc2_ == 56)
            {
               SocketSendController.sendSummAIChangeCMD(_loc3_ + 1);
               this.setAI(this._listAIUI[1]);
            }
            else if(_loc2_ == 57)
            {
               SocketSendController.sendSummAIChangeCMD(_loc3_ + 2);
               this.setAI(this._listAIUI[2]);
            }
         }
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         this.setAI(this._listAIUI[SummonManager.AI_State]);
      }
      
      public function init(param1:SummonModel) : void
      {
         this._model = param1;
         this._lvTxt.text = this._model.info.lv.toString();
         this._nameTxt.text = this._model.info.nick;
         var _loc2_:UserInfo = this._model.info;
         this.initBars(_loc2_);
      }
      
      public function show() : void
      {
         this._mainUI.x = 260;
         this._mainUI.y = 5;
         LayerManager.toolsLevel.addChild(this._mainUI);
         this._mainUI.visible = true;
         this._model.addEventListener(UserEvent.HP_CHANGE,this.onHPChange);
         this._model.addEventListener(UserEvent.DIE,this.onSummonDie);
         SocketConnection.addCmdListener(CommandID.SUMMON_AI_CHANGE,this.onAIChange);
         LayerManager.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         this.clearHeadIcon();
         SwfCache.getSwfInfo(ClientConfig.getRoleIcon(this._model.info.roleType),this.onLoad);
         this.initActorSummon();
      }
      
      public function hide() : void
      {
         var _loc1_:MovieClip = null;
         if(this._model)
         {
            this._model.removeEventListener(UserEvent.HP_CHANGE,this.onHPChange);
            this._model.removeEventListener(UserEvent.DIE,this.onSummonDie);
         }
         SocketConnection.removeCmdListener(CommandID.SUMMON_AI_CHANGE,this.onAIChange);
         LayerManager.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         DisplayUtil.removeForParent(this._mainUI,false);
         for each(_loc1_ in this._listAIUI)
         {
            _loc1_.gotoAndStop(1);
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onuiAIClick);
         }
         this._listAIUI.length = 0;
      }
      
      public function initActorSummon() : void
      {
         var _loc1_:SummonModel = MainManager.actorModel.fightSummonModel;
         if(_loc1_)
         {
            this.init(_loc1_);
            this.clearHeadIcon();
            SwfCache.getSwfInfo(ClientConfig.getRoleIcon(this._model.info.roleType),this.onLoad);
            this._model.addEventListener(UserEvent.SUMMONE_INFO,this.onInfoChange);
            this._mainUI.visible = true;
         }
         else
         {
            this._mainUI.visible = false;
            this._model.removeEventListener(UserEvent.SUMMONE_INFO,this.onInfoChange);
         }
      }
      
      public function destroy() : void
      {
         if(Boolean(this._model) && Boolean(this._model.info))
         {
            SwfCache.cancel(ClientConfig.getRoleIcon(this._model.info.roleType),this.onLoad);
         }
         this.hide();
         this.clearHeadIcon();
         this._HPRect = null;
         this._mpRect = null;
         this._lvTxt = null;
         this._nameTxt = null;
         this._HPText = null;
         this._expTxt = null;
         this._mpTxt = null;
         this._expBar = null;
         this._expRect = null;
         this._mpBar = null;
         this._mainUI = null;
         this._model = null;
      }
      
      private function initBars(param1:UserInfo) : void
      {
         this._lvTxt.text = param1.lv.toString();
         this._HPRect.width = param1.hp / param1.maxHp * this._HPWidth;
         this._HPBar.scrollRect = this._HPRect;
         this._HPText.text = param1.hp.toString() + "/" + param1.maxHp.toString();
         var _loc2_:int = param1.exp - AttributeConfig.calcSummonTotalLvExp(param1.lv,param1.isTurnBack);
         var _loc3_:int = int(AttributeConfig.caleSummonCurrentLvExp(param1.lv + 1,param1.isTurnBack));
         this._expRect.width = Math.max(0,_loc2_ / _loc3_ * this._expWidth);
         this._expBar.scrollRect = this._expRect;
         this._expTxt.text = _loc2_.toString() + "/" + _loc3_.toString();
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
      
      private function onInfoChange(param1:UserEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:UserInfo = param1.data;
         if(_loc2_)
         {
            _loc3_ = _loc2_.exp - AttributeConfig.calcSummonTotalLvExp(_loc2_.lv,_loc2_.isTurnBack);
            _loc4_ = int(AttributeConfig.caleSummonCurrentLvExp(_loc2_.lv + 1,_loc2_.isTurnBack));
            this._expRect.width = Math.max(0,_loc3_ / _loc4_ * this._expWidth);
            this._expBar.scrollRect = this._expRect;
            this._expTxt.text = _loc3_.toString() + "/" + _loc4_.toString();
            this._lvTxt.text = _loc2_.lv.toString();
         }
      }
      
      private function onHPChange(param1:UserEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_)
         {
            _loc3_ = int(_loc2_.getDecHP());
            _loc4_ = int(_loc2_.getHP());
            _loc5_ = int(_loc2_.info.maxHp);
            if(_loc4_ > _loc3_ && _loc3_ != 0)
            {
               this._HPRect.width = _loc4_ / _loc5_ * this._HPWidth;
               this._HPBar.scrollRect = this._HPRect;
               this._HPText.text = _loc4_.toString() + "/" + _loc5_.toString();
            }
         }
      }
      
      private function onSummonDie(param1:UserEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_)
         {
            _loc3_ = int(_loc2_.info.maxMp);
            this._HPRect.width = 0;
            this._HPBar.scrollRect = this._HPRect;
            this._HPText.text = "0/" + _loc3_.toString();
         }
         this.clearCutDown();
         if(this._headIcon)
         {
            this._headIcon.filters = [ColorFilter.setBrightness(-60)];
         }
         if(_loc2_.info.roleType < 3254 || _loc2_.info.roleType > 3256)
         {
            this._reviveTime = SummonXMLInfo.getReviveTime(this._model.info.roleType);
            this._reviveTime = MainManager.actorInfo.isVip ? uint(this._reviveTime / 2) : this._reviveTime;
            this._reviveTimeID = setInterval(this.updateTime,1000);
            this._model.destroyAIwords();
         }
         else
         {
            SocketConnection.addCmdListener(CommandID.ACTION_BRUISE,this.onEvent);
         }
      }
      
      private function onEvent(param1:SocketEvent) : void
      {
         var _loc2_:BruiseInfo = param1.data as BruiseInfo;
         if(_loc2_.roleID < 3284 || _loc2_.roleID > 3286)
         {
            return;
         }
         if(_loc2_.hp <= 0)
         {
            SocketConnection.removeCmdListener(CommandID.ACTION_BRUISE,this.onEvent);
            this._reviveTime = SummonXMLInfo.getReviveTime(this._model.info.roleType);
            if(_loc2_.roleID == 3286)
            {
               this._reviveTime = MainManager.actorInfo.isVip ? uint(this._reviveTime / 2) : this._reviveTime;
            }
            this._reviveTimeID = setInterval(this.updateTime,1000);
            this._model.destroyAIwords();
         }
      }
      
      private function updateTime() : void
      {
         var _loc3_:Sprite = null;
         if(Boolean(this._model) && this._model.getHP() > 0)
         {
            this.clearCutDown();
            return;
         }
         this.clearCutDownHolder();
         ++this._reviveCount;
         var _loc1_:String = Math.max(0,this._reviveTime - this._reviveCount).toString();
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = UIManager.getSprite("Number_Get_" + _loc1_.charAt(_loc2_));
            _loc3_.x = _loc2_ * 15;
            this._cutDownHolder.addChild(_loc3_);
            _loc2_++;
         }
      }
      
      public function clearCutDown() : void
      {
         clearInterval(this._reviveTimeID);
         this._reviveCount = 0;
         this.clearCutDownHolder();
         if(this._headIcon)
         {
            this._headIcon.filters = [];
         }
      }
      
      private function clearCutDownHolder() : void
      {
         while(this._cutDownHolder.numChildren)
         {
            this._cutDownHolder.removeChildAt(0);
         }
      }
      
      public function revive(param1:HpMpInfo) : void
      {
         this._model.initHP(param1.hpMax);
         this._model.initMP(param1.mpMax);
         this._model.setHP(param1.hp);
         this._model.setMP(param1.mp);
         this._HPRect.width = param1.hp / param1.hpMax * this._HPWidth;
         this._HPBar.scrollRect = this._HPRect;
         this._HPText.text = param1.hp.toString() + "/" + param1.hpMax.toString();
      }
      
      public function setRage(param1:uint) : void
      {
         this._mpRect.width = param1 / SummonInfo.MAX_RAGE * this._mpWidth;
         this._mpBar.scrollRect = this._mpRect;
         this._mpTxt.text = param1.toString() + "/" + SummonInfo.MAX_RAGE.toString();
         if(param1 == SummonInfo.MAX_RAGE)
         {
            this._mainUI.addChild(this._rageMC);
            this._rageMC.play();
         }
         else
         {
            DisplayUtil.removeForParent(this._rageMC,false);
         }
      }
      
      private function onLoad(param1:SwfInfo) : void
      {
         this._headIcon = param1.content as Sprite;
         this._headIcon.mouseChildren = false;
         this._headIcon.mouseEnabled = false;
         this._headIcon.cacheAsBitmap = true;
         this._headIcon.y = 4;
         this._headIcon.x = 4;
         DisplayUtil.uniformScale(this._headIcon,30);
         this._mainUI.addChild(this._headIcon);
         this._mainUI.addChild(this._cutDownHolder);
      }
   }
}

