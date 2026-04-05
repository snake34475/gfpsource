package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightEntry;
   import com.gfp.app.manager.PanelGValueManager;
   import com.gfp.app.toolBar.HeadSelfPanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.behavior.ClothBehavior;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MagicChangeManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.ActorModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.player.FashionPlayer;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.EquipPart;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1117701 extends BaseMapProcess
   {
      
      private var _originalRoleType:int;
      
      private var _originalTurnBack:Boolean;
      
      private var _originalModel:ActorModel;
      
      private var _originalClothes:Vector.<SingleEquipInfo>;
      
      private var _originalNick:String;
      
      private var _preTitleId:int;
      
      private var _preLv:int;
      
      private var _preTitle:String;
      
      private var _isPlayKoMo:Boolean;
      
      private var _keyInfoList:Vector.<KeyInfo>;
      
      private var _nickList:Array = ["","派派","伊尔","大竹","敖天","大奔","雪灵","天策"];
      
      protected var _background:Shape;
      
      private var _roundMc:MovieClip;
      
      private var _cntMc:MovieClip;
      
      private var _skillList:Array = [[],[100801,100802,100803,100804,100805,100806],[200801,200802,200803,200804,200805,200806],[300801,300802,300803,300804,300805,300806],[400801,400802,400803,400804,400805,400806],[500801,500802,500803,500804,500805,500806],[600801,600802,600803,600804,600805,600806],[700801,700802,700803,700804,700805,700806]];
      
      private var _powerShow:int = 999999;
      
      private var _prePower:int;
      
      private var _preExp:Number;
      
      private var _preActorInfo:UserInfo;
      
      public function MapProcess_1117701()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(!this._originalModel)
         {
            this._originalModel = MainManager.actorModel;
            this._preActorInfo = MainManager.actorInfo;
            this._originalTurnBack = MainManager.actorInfo.isTurnBack;
            this._originalRoleType = MainManager.actorInfo.roleType;
            this._originalClothes = MainManager.actorInfo.clothes.concat(MainManager.actorInfo.fashionClothes);
            this._originalNick = MainManager.actorInfo.nick;
            this._preTitleId = MainManager.actorInfo.titleID;
            this._preLv = MainManager.actorInfo.lv;
            this._prePower = MainManager.actorInfo.fightPower;
            this._preTitle = MainManager.actorInfo.title;
            this._isPlayKoMo = FightEntry.isPlayKOMovie;
         }
         this._preExp = MainManager.actorInfo.exp;
         this._keyInfoList = new Vector.<KeyInfo>();
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            this._keyInfoList.push(new KeyInfo());
            _loc1_++;
         }
         this._roundMc = _mapModel.libManager.getMovieClip("UI_AnYingRoundMc");
         this._cntMc = _mapModel.libManager.getMovieClip("UI_AYTLExpBornTxtMc");
         if(MainManager.isLvFull())
         {
            this._cntMc.expTxtMc.visible = false;
         }
         else
         {
            this._cntMc.warnMc.visible = false;
         }
         StageResizeController.instance.register(this.resizePos);
         MagicChangeManager.instance.installBlockFilter(this.magicFilter);
         this.resizePos();
         MainManager.actorModel.addEventListener(UserEvent.GROW_CHANGE,this.growChangeHandler);
         LayerManager.topLevel.addChild(this._cntMc);
         this.onStageProChange(null,true);
         SocketConnection.addCmdListener(CommandID.FIGHT_COMMON_NOTIFY,this.onStageProChange);
      }
      
      private function resizePos() : void
      {
         this._cntMc.x = LayerManager.stageWidth - this._cntMc.width - 50;
         this._cntMc.y = 200;
      }
      
      protected function growChangeHandler(param1:UserEvent) : void
      {
         this._cntMc.expTxtMc.expTxt.text = (MainManager.actorInfo.exp - this._preExp).toString();
      }
      
      private function onStageProChange(param1:SocketEvent, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc9_:ByteArray = null;
         var _loc10_:uint = 0;
         var _loc11_:int = 0;
         var _loc12_:KeyInfo = null;
         var _loc13_:SingleEquipInfo = null;
         if(param2)
         {
            _loc3_ = 0;
         }
         else
         {
            _loc9_ = param1.data as ByteArray;
            _loc9_.position = 0;
            _loc10_ = _loc9_.readUnsignedInt();
            _loc3_ = _loc9_.readUnsignedInt() - 1;
            if(_loc3_ == 0)
            {
               return;
            }
         }
         if(_loc3_ != 0)
         {
            this._background = new Shape();
            this._background.graphics.beginFill(0);
            this._background.graphics.drawRect(0,0,5000,5000);
            this._background.graphics.endFill();
            LayerManager.topLevel.addChild(this._background);
            LayerManager.topLevel.addChild(this._roundMc);
            this._roundMc.gotoAndStop(_loc3_ + 1);
            this._roundMc.x = LayerManager.stageWidth - 1150 >> 1;
            this._roundMc.y = -100;
            this._roundMc.alpha = 0.5;
            _loc11_ = LayerManager.stageHeight - this._roundMc.height >> 1;
            TweenLite.to(this._roundMc,2,{
               "alpha":1,
               "y":_loc11_,
               "onComplete":this.removeEff
            });
         }
         _loc4_ = int(PanelGValueManager.anyingRoleType[_loc3_]);
         var _loc5_:int = 0;
         while(_loc5_ < 6)
         {
            _loc12_ = this._keyInfoList[_loc5_];
            _loc12_.funcID = KeyManager.skillQuickKeys[_loc5_];
            if(param2)
            {
               _loc12_.dataID = this._skillList[_loc4_][_loc5_];
            }
            else
            {
               _loc12_.dataID = _loc9_.readUnsignedInt();
            }
            _loc12_.lv = 1;
            _loc5_++;
         }
         KeyManager.reset();
         KeyManager.upDateSkillQuickKeys(this._keyInfoList);
         FightEntry.isPlayKOMovie = false;
         MainManager.actorInfo.isTurnBack = true;
         MainManager.actorInfo.titleID = 0;
         MainManager.actorInfo.lv = 115;
         MainManager.actorModel.setNickText(this._nickList[_loc4_]);
         MainManager.actorInfo.title = "";
         MainManager.actorInfo.roleType = _loc4_;
         (_mapModel.contentLevel as Sprite).addChild(MainManager.actorModel);
         MainManager.actorModel.spriteID = _loc4_;
         var _loc6_:Vector.<SingleEquipInfo> = new Vector.<SingleEquipInfo>();
         var _loc7_:Array = EquipPart.getDefItems(_loc4_,MainManager.actorInfo.defEquipType).getValues();
         var _loc8_:uint = _loc7_.length;
         _loc5_ = 0;
         while(_loc5_ < _loc8_)
         {
            _loc13_ = new SingleEquipInfo();
            _loc13_.itemID = _loc7_[_loc5_];
            _loc6_[_loc5_] = _loc13_;
            _loc5_++;
         }
         UserManager.execBehavior(MainManager.actorID,new ClothBehavior(_loc6_,false),true);
         MainManager.actorModel.vipIconVisible = false;
         MainManager.actorInfo.lv = this._preLv;
         MainManager.actorInfo.roleType = this._originalRoleType;
         MainManager.actorInfo.fashionClothes = this._originalClothes;
         MainManager.actorInfo.isTurnBack = this._originalTurnBack;
         if(!this._originalTurnBack && this._originalRoleType != 7)
         {
            (MainManager.actorModel.player as FashionPlayer).hideMorePlayers(false);
         }
         MainManager.actorModel.updateTitle();
         HeadSelfPanel.instance.headIconEnabled = false;
         HeadSelfPanel.instance.updatePower(this._powerShow);
      }
      
      private function removeEff() : void
      {
         TweenLite.to(this._roundMc,2,{
            "alpha":0,
            "onComplete":this.removeEffEnd
         });
      }
      
      private function removeEffEnd() : void
      {
         this._background.graphics.clear();
         this._background = null;
         DisplayUtil.removeForParent(this._background);
         DisplayUtil.removeForParent(this._roundMc);
         TweenLite.killTweensOf(this._roundMc);
      }
      
      private function magicFilter() : Boolean
      {
         TextAlert.show("当前关卡不允许变身哦！",16711680);
         return true;
      }
      
      override public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.FIGHT_COMMON_NOTIFY,this.onStageProChange);
         KeyManager.reset();
         KeyManager.upDateSkillQuickKeys(MainManager.actorInfo.skills);
         KeyManager.upDateItemQuickKeys(MainManager.actorInfo.items);
         MainManager.actorModel = this._originalModel;
         MainManager.actorModel.removeEventListener(UserEvent.GROW_CHANGE,this.growChangeHandler);
         MainManager.actorModel.spriteID = this._originalRoleType;
         MainManager.actorInfo.titleID = this._preTitleId;
         MainManager.actorInfo.title = this._preTitle;
         MainManager.actorInfo.roleType = this._originalRoleType;
         MainManager.actorInfo.isTurnBack = this._originalTurnBack;
         HeadSelfPanel.instance.updatePower(this._prePower);
         FightEntry.isPlayKOMovie = this._isPlayKoMo;
         UserManager.execBehavior(MainManager.actorID,new ClothBehavior(this._originalClothes,false),true);
         HeadSelfPanel.instance.headIconEnabled = true;
         MainManager.actorModel.vipIconVisible = true;
         StageResizeController.instance.unregister(this.resizePos);
         MainManager.actorModel.info.nick = this._originalNick;
         MainManager.actorModel.setNickText(this._originalNick);
         if(!this._originalTurnBack && this._originalRoleType != 7)
         {
            (MainManager.actorModel.player as FashionPlayer).hideMorePlayers(true);
         }
         if(this._background)
         {
            this.removeEff();
         }
         if(this._roundMc)
         {
            DisplayUtil.removeForParent(this._roundMc);
         }
         if(this._cntMc)
         {
            DisplayUtil.removeForParent(this._cntMc);
         }
         this._skillList = null;
         MagicChangeManager.instance.uninstallBlockFilter(this.magicFilter);
         super.destroy();
      }
   }
}

