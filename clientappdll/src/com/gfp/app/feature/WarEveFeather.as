package com.gfp.app.feature
{
   import com.gfp.core.CommandID;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.HeroSoulXMLInfo;
   import com.gfp.core.config.xml.SummonXMLInfo;
   import com.gfp.core.config.xml.TollgateXMLInfo;
   import com.gfp.core.info.HeroSoulInfo;
   import com.gfp.core.info.SummonInfo;
   import com.gfp.core.info.TollgateInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.HeroSoulManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.model.PeopleModel;
   import com.gfp.core.model.SummonModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.SummonStateType;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class WarEveFeather
   {
      
      private var mcContainer:MovieClip;
      
      private var tollgateInfo:TollgateInfo;
      
      private var tollgatePro:int;
      
      private var changeSummon:SimpleButton;
      
      private var changeRig:SimpleButton;
      
      private var summonBed:MovieClip;
      
      private var summonHead:MovieClip;
      
      private var heroHead:MovieClip;
      
      private var goForEyes:SimpleButton;
      
      private var cancelBtn:SimpleButton;
      
      private var _sumObj:Object;
      
      private var _summonModel:SummonModel;
      
      private var params:Array;
      
      private var fightFunc_p:Function;
      
      private var summonHeadRes:MovieClip;
      
      private var heroHeadRes:MovieClip;
      
      private var _kezhi:int;
      
      private var _kezhih:int;
      
      private var _heroObj:Object;
      
      private var _userModel:PeopleModel;
      
      public function WarEveFeather(... rest)
      {
         var _loc2_:int = 0;
         this.params = new Array();
         super();
         if(int(rest[0]) <= 0)
         {
            return;
         }
         if(rest[1] is Function)
         {
            this.fightFunc_p = rest[1] as Function;
         }
         if(rest.length > 2)
         {
            _loc2_ = 2;
            while(_loc2_ < rest.length)
            {
               this.params.push(rest[_loc2_]);
               _loc2_++;
            }
         }
         this.tollgateInfo = TollgateXMLInfo.getTollgateInfoById(rest[0]);
         this.tollgatePro = turnPro(TollgateXMLInfo.getTollgateInfoById(rest[0]).tollgatePro);
         SwfCache.getSwfInfo(ClientConfig.getSubUI("warEveRes"),this.onResLoaded);
      }
      
      public static function turnPro(param1:String) : int
      {
         switch(param1)
         {
            case "guang":
               return 6;
            case "an":
               return 5;
            case "shui":
               return 2;
            case "huo":
               return 3;
            case "feng":
               return 4;
            case "di":
               return 1;
            default:
               return 0;
         }
      }
      
      public function show(param1:Sprite) : void
      {
         param1.addChild(this.mcContainer);
      }
      
      private function onResLoaded(param1:SwfInfo) : void
      {
         if(this.mcContainer == null)
         {
            this.mcContainer = param1.content as MovieClip;
         }
         this.changeSummon = this.mcContainer["changeSummon"];
         this.changeRig = this.mcContainer["changeRig"];
         this.summonBed = this.mcContainer["summonBed"];
         this.summonHead = this.mcContainer["summonHead"];
         this.goForEyes = this.mcContainer["goForEyes"];
         this.heroHead = this.mcContainer["heroHead"];
         this.cancelBtn = this.mcContainer["cancelBtn"];
         if(!this.tollgateInfo.tollgatePro)
         {
            this.mcContainer["tollgatePro"].gotoAndStop("blank");
         }
         else
         {
            this.mcContainer["tollgatePro"].gotoAndStop(this.tollgateInfo.tollgatePro);
         }
         this.addEvent();
         this.setChuZhanSum(SummonManager.getActorSummonInfo().currentSummonInfo);
         this.setChuZhanHero(HeroSoulManager.getActorHeroSoulInfo().currentHeroSoulInfo);
         var _loc2_:UserInfo = new UserInfo();
         _loc2_.roleType = MainManager.actorInfo.roleType;
         _loc2_.isAdvanced = MainManager.actorInfo.isAdvanced;
         _loc2_.isSuperAdvc = MainManager.actorInfo.isSuperAdvc;
         _loc2_.isTurnBack = MainManager.actorInfo.isTurnBack;
         _loc2_.clothes = MainManager.actorInfo.clothes.concat();
         _loc2_.fashionClothes = MainManager.actorInfo.fashionClothes.concat();
         _loc2_.isVip = true;
         this._userModel = new PeopleModel(_loc2_);
         this._userModel.vipIconVisible = false;
         this.summonBed.addChild(this._userModel);
         this._userModel.x += 120;
         this._userModel.y += 270;
      }
      
      protected function addEvent() : void
      {
         this.changeRig.addEventListener(MouseEvent.CLICK,this.onChangeRig);
         this.changeSummon.addEventListener(MouseEvent.CLICK,this.onChangeSummon);
         this.goForEyes.addEventListener(MouseEvent.CLICK,this.onFight);
         this.cancelBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         this.mcContainer["closeBtn"].addEventListener(MouseEvent.CLICK,this.onClose);
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.mcContainer);
      }
      
      protected function onFight(param1:MouseEvent) : void
      {
         this.fightFunc_p.apply(this,this.params);
      }
      
      protected function onChangeSummon(param1:MouseEvent) : void
      {
         if(!this._sumObj)
         {
            this._sumObj = new Object();
            this._sumObj.callback = this.selSumOver;
         }
         var _loc2_:Array = SummonManager.getActorSummonInfo().summonBagList.concat();
         this._sumObj.summonInfos = _loc2_;
         ModuleManager.turnAppModule("SelectSummonPanel","",this._sumObj);
      }
      
      protected function onChangeRig(param1:MouseEvent) : void
      {
         if(!this._heroObj)
         {
            this._heroObj = new Object();
            this._heroObj.callback = this.selHeroOver;
         }
         var _loc2_:Array = HeroSoulManager.getActorHeroSoulInfo().soulStorageList.concat();
         this._heroObj.heroInfos = _loc2_;
         ModuleManager.turnAppModule("SelectHeroPanel","",this._heroObj);
      }
      
      private function selSumOver(param1:SummonInfo = null) : void
      {
         SocketConnection.addCmdListener(CommandID.SUMMON_USE,this.onSummonChangeSelected);
         SummonManager.changeSelected(param1.uniqueID);
         SummonManager.getActorSummonInfo().setSummonListFollow(param1.uniqueID,true);
      }
      
      private function selHeroOver(param1:HeroSoulInfo = null) : void
      {
         SocketConnection.addCmdListener(CommandID.SOUL_CHANGE_STATE,this.onHeroChangeSelected);
         HeroSoulManager.changeState(param1,param1.state == SummonStateType.STATE_BAG ? int(SummonStateType.STATE_BATTLE_FOLLOW) : int(SummonStateType.STATE_BAG));
      }
      
      private function onHeroChangeSelected(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:HeroSoulInfo = HeroSoulManager.getActorHeroSoulInfo().getHeroSoulInfoByUniqId(_loc3_);
         this.setChuZhanHero(_loc5_);
      }
      
      private function setChuZhanHero(param1:HeroSoulInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         if(!param1)
         {
            return;
         }
         if(param1.roleID != 0)
         {
            if(param1.soulType == 60001)
            {
               this.mcContainer["heroPro"].gotoAndStop("chaofeng");
            }
            else if(param1.soulType == 60011)
            {
               this.mcContainer["heroPro"].gotoAndStop("fendan");
            }
            _loc2_ = int(param1.roleID);
            _loc3_ = int(HeroSoulXMLInfo.getSoulType(param1.roleID));
            _loc4_ = ClientConfig.getRoleIcon(_loc2_);
            SwfCache.getSwfInfo(_loc4_,this.onIconHeadLoadedH);
            this.handleHT(param1);
         }
      }
      
      private function onIconHeadLoadedH(param1:SwfInfo) : void
      {
         this.heroHeadRes = param1.content as MovieClip;
         if(this.heroHeadRes)
         {
            this.heroHeadRes.scaleX = this.heroHeadRes.scaleY = 0.8;
            DisplayUtil.removeAllChild(this.heroHead);
            this.heroHead.addChild(this.heroHeadRes);
         }
      }
      
      private function setChuZhanSum(param1:SummonInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         if(!param1)
         {
            this.mcContainer["summonPro"].gotoAndStop("blank");
            return;
         }
         if(param1.roleID != 0)
         {
            this.mcContainer["summonPro"].gotoAndStop(SummonXMLInfo.getClassID(param1.roleID));
            _loc2_ = int(param1.roleID);
            _loc3_ = int(SummonXMLInfo.getSummonType(param1.roleID));
            _loc4_ = ClientConfig.getRoleIcon(_loc2_);
            SwfCache.getSwfInfo(_loc4_,this.onIconHeadLoaded);
            this.handleST(param1);
         }
      }
      
      private function handleST(param1:SummonInfo = null) : void
      {
         var _loc4_:int = 0;
         var _loc2_:SummonInfo = SummonManager.getActorSummonInfo().currentSummonInfo;
         if(param1)
         {
            _loc2_ = param1;
            _loc4_ = int(SummonXMLInfo.getClassID(_loc2_.roleID));
         }
         var _loc3_:int = this.tollgatePro;
         if(!_loc2_)
         {
            this.kezhi = 0;
            return;
         }
         this.kezhi = 0;
         switch(_loc4_)
         {
            case 1:
               if(_loc3_ == 2)
               {
                  this.kezhi = 1;
               }
               if(_loc3_ == 4)
               {
                  this.kezhi = 2;
               }
               break;
            case 2:
               if(_loc3_ == 3)
               {
                  this.kezhi = 1;
               }
               if(_loc3_ == 1)
               {
                  this.kezhi = 2;
               }
               break;
            case 3:
               if(_loc3_ == 4 || _loc3_ == 6)
               {
                  this.kezhi = 1;
               }
               if(_loc3_ == 2 || _loc3_ == 5)
               {
                  this.kezhi = 2;
               }
               break;
            case 4:
               if(_loc3_ == 1)
               {
                  this.kezhi = 1;
               }
               if(_loc3_ == 3)
               {
                  this.kezhi = 2;
               }
               break;
            case 5:
               if(_loc3_ == 3)
               {
                  this.kezhi = 1;
               }
               if(_loc3_ == 6)
               {
                  this.kezhi = 2;
               }
               break;
            case 6:
               if(_loc3_ == 5)
               {
                  this.kezhi = 1;
               }
               if(_loc3_ == 3)
               {
                  this.kezhi = 2;
               }
            case 10:
               this.kezhi = 0;
         }
      }
      
      private function handleHT(param1:HeroSoulInfo = null) : void
      {
         var _loc3_:int = 0;
         var _loc2_:HeroSoulInfo = HeroSoulManager.getActorHeroSoulInfo().currentHeroSoulInfo;
         if(param1)
         {
            _loc2_ = param1;
            _loc3_ = int(HeroSoulXMLInfo.getAttrType(_loc2_.roleID));
         }
         else
         {
            this.mcContainer["heroPro"].gotoAndStop("blank");
         }
         this.kezhih = 0;
         if(!_loc2_)
         {
            this.kezhih = 0;
            return;
         }
         if(_loc3_ == 4)
         {
            this.kezhih = 1;
         }
         else
         {
            this.kezhih = 1;
         }
      }
      
      private function onIconHeadLoaded(param1:SwfInfo) : void
      {
         this.summonHeadRes = param1.content as MovieClip;
         if(this.summonHeadRes)
         {
            this.summonHeadRes.scaleX = this.summonHeadRes.scaleY = 0.8;
            DisplayUtil.removeAllChild(this.summonHead);
            this.summonHead.addChild(this.summonHeadRes);
         }
      }
      
      private function onSummonChangeSelected(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.SUMMON_USE,this.onSummonChangeSelected);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:SummonInfo = SummonManager.getSummonInfo(_loc3_);
         this.setChuZhanSum(_loc4_);
      }
      
      protected function removeEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.SUMMON_USE,this.onSummonChangeSelected);
         this.changeRig.removeEventListener(MouseEvent.CLICK,this.onChangeRig);
         this.changeSummon.removeEventListener(MouseEvent.CLICK,this.onChangeSummon);
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this.mcContainer);
         this.removeEvent();
         this.mcContainer = null;
      }
      
      public function get kezhi() : int
      {
         return this._kezhi;
      }
      
      public function set kezhi(param1:int) : void
      {
         this._kezhi = param1;
         if(param1 == 0)
         {
            this.mcContainer["tProAddAttValue"].text = "无影响";
         }
         else
         {
            this.mcContainer["tProAddAttValue"].text = this.tollgateInfo.tProAddAttValue + "%";
         }
         this.mcContainer["arrows"].gotoAndStop(this.kezhi + 1);
      }
      
      public function get kezhih() : int
      {
         return this._kezhih;
      }
      
      public function set kezhih(param1:int) : void
      {
         this._kezhih = param1;
         if(param1 == 0)
         {
            this.mcContainer["hProAddAttValue"].text = "无影响";
         }
         else
         {
            this.mcContainer["hProAddAttValue"].text = "50%";
         }
         this.mcContainer["arrowh"].gotoAndStop(this.kezhih + 1);
      }
   }
}

