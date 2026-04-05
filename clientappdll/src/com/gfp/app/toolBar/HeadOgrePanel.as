package com.gfp.app.toolBar
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.Constant;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.utils.FightMode;
   import com.gfp.core.utils.SpriteType;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class HeadOgrePanel
   {
      
      private static var _instance:HeadOgrePanel;
      
      public var isShow:Boolean;
      
      private var _mainUI:Sprite;
      
      private var _general:Sprite;
      
      private var _elite:Sprite;
      
      private var _generalLvTxt:TextField;
      
      private var _generalNameTxt:TextField;
      
      private var _eliteLvTxt:TextField;
      
      private var _eliteNameTxt:TextField;
      
      private var _generalHpBar:MovieClip;
      
      private var _eliteHpBar:MovieClip;
      
      private var _generalBlood:BloodComponents;
      
      private var _eliteBlood:BloodComponents;
      
      private var _hpTotal:int;
      
      private var _timeID:uint;
      
      private var _headIcon:Sprite;
      
      private var _headIconArray:Array = [];
      
      private var _roleType:int = 0;
      
      private var _initMain:Boolean;
      
      private var _bossArray:Array = [];
      
      private var _bossIDArray:Array = [];
      
      private var _bossBloodArray:Array = [];
      
      private var _bossIconNum:int = 0;
      
      private var _bossBarFilterList:Array = [14625,14626,14627,14628,14629,14630,14631,14617,13054,14645,14646,14647,14648,14649,14650,14651,14652];
      
      public function HeadOgrePanel()
      {
         super();
         this._mainUI = UIManager.getSprite("Head_OgreInfoPanel");
         this._general = this._mainUI["GeneralOgreInfoPanel"];
         this._elite = this._mainUI["EliteOgreInfoPanel"];
         this._generalLvTxt = this._general["lvTxt"];
         this._generalNameTxt = this._general["nameTxt"];
         this._generalHpBar = this._general["hp_mc"];
         this._eliteLvTxt = this._elite["lvTxt"];
         this._eliteNameTxt = this._elite["nameTxt"];
         this._eliteHpBar = this._elite["hp_mc"];
         this._generalBlood = new BloodComponents(this._generalHpBar,5);
         this._eliteBlood = new BloodComponents(this._eliteHpBar,6);
      }
      
      public static function get instance() : HeadOgrePanel
      {
         if(_instance == null)
         {
            _instance = new HeadOgrePanel();
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
      
      public function destroy() : void
      {
         StageResizeController.instance.unregister(this.layout);
         UserManager.removeEventListener(UserEvent.HP_CHANGE,this.onUserHP);
         if(this._generalBlood)
         {
            this._generalBlood.closeBlood();
         }
         this._generalBlood = null;
         if(this._eliteBlood)
         {
            this._eliteBlood.closeBlood();
         }
         this._eliteBlood = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._bossBloodArray.length)
         {
            this._bossBloodArray[_loc1_].closeBlood();
            this._bossBloodArray[_loc1_] = null;
            _loc1_++;
         }
         this._bossBloodArray = [];
         clearInterval(this._timeID);
         this.clearHeadIcon();
         this.hide();
         this._headIcon = null;
         this._generalLvTxt = null;
         this._generalNameTxt = null;
         this._generalHpBar = null;
         this._eliteLvTxt = null;
         this._eliteNameTxt = null;
         this._eliteHpBar = null;
         this._general = null;
         this._elite = null;
         this._mainUI = null;
         this._headIcon = null;
         this._bossIconNum = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._bossArray.length)
         {
            if(this._bossArray[_loc2_])
            {
               DisplayUtil.removeForParent(this._bossArray[_loc2_],false);
               this._bossArray[_loc2_] = null;
            }
            _loc2_++;
         }
         this._bossArray = [];
      }
      
      public function destroyBoss(param1:uint = 0, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < this._bossArray.length)
         {
            if(param2 == false)
            {
               if(this._bossIDArray[_loc3_] == param1)
               {
                  if(this._bossArray[_loc3_])
                  {
                     DisplayUtil.removeForParent(this._bossArray[_loc3_],false);
                  }
               }
            }
            else if(this._bossArray[_loc3_])
            {
               DisplayUtil.removeForParent(this._bossArray[_loc3_],false);
            }
            _loc3_++;
         }
      }
      
      public function changeMapHideUI(param1:Boolean) : void
      {
         this._initMain = param1;
      }
      
      public function start() : void
      {
         UserManager.addEventListener(UserEvent.HP_CHANGE,this.onUserHP);
      }
      
      public function bossSetup(param1:UserModel) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TextField = null;
         var _loc5_:MovieClip = null;
         var _loc6_:BloodComponents = null;
         if(this._bossBarFilterList.indexOf(param1.info.roleType) == -1)
         {
            _loc2_ = uint(param1.info.roleType);
            _loc3_ = UIManager.getSprite("Boss_OgreInfoPanel");
            _loc4_ = _loc3_["nameTxt"];
            _loc5_ = _loc3_["hp_mc"];
            _loc6_ = new BloodComponents(_loc5_,1);
            this._bossBloodArray.push(_loc6_);
            _loc4_.text = "LV." + param1.info.lv + " " + param1.info.nick;
            LayerManager.toolsLevel.addChild(_loc3_);
            this._bossArray.push(_loc3_);
            this._bossIDArray.push(_loc2_);
            SwfCache.getSwfInfo(ClientConfig.getRoleIcon(RoleXMLInfo.getResID(param1.info.roleType)),this.bossOnLoad);
            this.layout();
            StageResizeController.instance.register(this.layout);
         }
      }
      
      private function layout() : void
      {
         var _loc4_:Sprite = null;
         var _loc1_:uint = this._bossArray.length;
         var _loc2_:Number = LayerManager.stageWidth / 960;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc4_ = this._bossArray[_loc3_];
            if((Boolean(_loc4_)) && Boolean(_loc4_.parent))
            {
               DisplayUtil.align(_loc4_,null,AlignType.BOTTOM_LEFT,new Point(320 * _loc2_,-52 * _loc2_ - 66));
            }
            _loc3_++;
         }
      }
      
      public function show() : void
      {
         clearInterval(this._timeID);
         this._timeID = setInterval(this.onInterval,3000);
         if(this.isShow)
         {
            return;
         }
         this.isShow = true;
         LayerManager.toolsLevel.addChild(this._mainUI);
      }
      
      public function init(param1:UserModel) : void
      {
         var _loc3_:int = 0;
         if(param1 == null)
         {
            return;
         }
         this.clearHeadIcon();
         var _loc2_:UserInfo = param1.info;
         this._roleType = RoleXMLInfo.getFlag(_loc2_.roleType);
         this._mainUI.y = 20;
         if(this._roleType == 1)
         {
            _loc3_ = 0;
            while(_loc3_ < this._bossArray.length)
            {
               if(_loc2_.roleType == this._bossIDArray[_loc3_])
               {
                  this._bossArray[_loc3_].visible = true;
                  this._bossBloodArray[_loc3_].hit(param1);
               }
               _loc3_++;
            }
            this._mainUI.visible = false;
            this._elite.visible = false;
            this._general.visible = false;
         }
         if(this._roleType == 2)
         {
            this._mainUI.x = 445;
            this._mainUI.visible = true;
            this._elite.visible = true;
            this._general.visible = false;
            this._eliteLvTxt.text = _loc2_.lv.toString();
            this._eliteNameTxt.text = _loc2_.nick;
            this._eliteBlood.hit(param1);
         }
         if(this._roleType == 3 || this._roleType == 0)
         {
            this._mainUI.x = 645;
            this._mainUI.visible = true;
            this._elite.visible = false;
            this._general.visible = true;
            this._generalLvTxt.text = _loc2_.lv.toString();
            this._generalNameTxt.text = _loc2_.nick;
            this._generalBlood.hit(param1);
            if(_loc2_.roleType == 30002 || _loc2_.roleType == 30003 || _loc2_.roleType == 30004)
            {
               this._mainUI.visible = false;
            }
         }
         if(this._roleType != 1)
         {
            SwfCache.getSwfInfo(ClientConfig.getRoleIcon(_loc2_.roleType),this.onLoad);
         }
      }
      
      public function hide() : void
      {
         this.isShow = false;
         DisplayUtil.removeForParent(this._mainUI,false);
      }
      
      private function clearHeadIcon() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._headIconArray.length)
         {
            DisplayUtil.removeForParent(this._headIconArray[_loc1_]);
            this._headIconArray[_loc1_] = null;
            _loc1_++;
         }
         this._headIconArray = [];
      }
      
      private function onInterval() : void
      {
         this.hide();
      }
      
      private function onLoad(param1:SwfInfo) : void
      {
         if(this._mainUI == null)
         {
            return;
         }
         var _loc2_:Sprite = param1.content as Sprite;
         _loc2_.mouseChildren = false;
         _loc2_.mouseEnabled = false;
         _loc2_.cacheAsBitmap = true;
         if(this._roleType == 2)
         {
            _loc2_.y = 5;
            _loc2_.x = 392;
         }
         else if(this._roleType == 3 || this._roleType == 0)
         {
            _loc2_.y = 3;
            _loc2_.x = 204;
         }
         if(this._roleType != 1)
         {
            DisplayUtil.uniformScale(_loc2_,35);
            this._mainUI.addChild(_loc2_);
            this._headIconArray.push(_loc2_);
         }
      }
      
      private function bossOnLoad(param1:SwfInfo) : void
      {
         var _loc2_:Sprite = null;
         _loc2_ = param1.content as Sprite;
         _loc2_.mouseChildren = false;
         _loc2_.mouseEnabled = false;
         _loc2_.cacheAsBitmap = true;
         _loc2_.y = 38;
         _loc2_.x = 430;
         DisplayUtil.uniformScale(_loc2_,50);
         if(this._bossArray[this._bossIconNum])
         {
            this._bossArray[this._bossIconNum].addChild(_loc2_);
            ++this._bossIconNum;
         }
      }
      
      private function onUserHP(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_ == null || _loc2_.info == null)
         {
            return;
         }
         var _loc3_:int = int(_loc2_.info.roleType);
         var _loc4_:int = int(MainManager.actorInfo.troop);
         var _loc5_:int = int(_loc2_.spriteType);
         if(_loc3_ <= Constant.MAX_ROLE_TYPE && _loc5_ == SpriteType.PEOPLE || _loc5_ == SpriteType.SUMMON || _loc2_.info.troop == MainManager.actorInfo.troop || FightManager.fightMode == FightMode.PVAI)
         {
            return;
         }
         if(this._initMain)
         {
            this.init(_loc2_);
            this.show();
         }
      }
   }
}

