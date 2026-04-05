package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatHeadString;
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.info.dialog.DialogInfoMultiple;
   import com.gfp.app.info.dialog.DialogInfoSimple;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.BaseAction;
   import com.gfp.core.buff.BuffInfo;
   import com.gfp.core.buff.movie.MovieBuff;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.events.TimeEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.language.CoreLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.SolidModel;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.TimeUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import org.taomee.ds.HashSet;
   import org.taomee.motion.TTween;
   import org.taomee.motion.TweenEvent;
   import org.taomee.motion.easing.Expo;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_6 extends MapProcessAnimat
   {
      
      private var craneMC:MovieClip;
      
      private var wellMC:MovieClip;
      
      private var _injuredVillagerLeft:SightModel;
      
      private var _injuredVillagerRight:SightModel;
      
      private var _mcMasterHat:MovieClip;
      
      private var _jewelry0:MovieClip;
      
      private var _jewelryOutput0:int = 0;
      
      private var _jewelry1:MovieClip;
      
      private var _jewelryOutput1:int = 0;
      
      private var _jewelryNum:int = 0;
      
      private var _jewelryTweenSet:HashSet = new HashSet();
      
      private const JEWELRY_NEED_NUM:int = 10;
      
      private var _MiLuModel:SolidModel;
      
      private var _sighModel10801:SightModel;
      
      private var _itemAID:uint;
      
      private var _itemBID:uint;
      
      public function MapProcess_6()
      {
         _mangoType = 1;
         super();
      }
      
      override protected function init() : void
      {
         _mangoType = 1;
         this._injuredVillagerLeft = SightManager.getSightModel(10050);
         this._injuredVillagerLeft.hide();
         this._injuredVillagerRight = SightManager.getSightModel(10051);
         this._injuredVillagerRight.hide();
         if(TasksManager.isAccepted(5))
         {
            this._injuredVillagerLeft.show();
            this._injuredVillagerRight.show();
         }
         this._mcMasterHat = _mapModel.upLevel["animationMasterHat"];
         this._mcMasterHat.visible = false;
         this._jewelry0 = _mapModel.contentLevel["jewelry0"];
         this._jewelry1 = _mapModel.contentLevel["jewelry1"];
         this._sighModel10801 = SightManager.getSightModel(10801);
         this._sighModel10801.hide();
         this.addTaskListener();
         this.initTask1101();
      }
      
      private function addTaskListener() : void
      {
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onProComplete);
         SocketConnection.addCmdListener(CommandID.MILU_SUBMIT_BOX,this.onSubmitBox);
         this._sighModel10801.addEventListener(MouseEvent.CLICK,this.onShowGiftDesc);
      }
      
      private function removeTaskListener() : void
      {
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onProComplete);
         SocketConnection.removeCmdListener(CommandID.MILU_SUBMIT_BOX,this.onSubmitBox);
         this._sighModel10801.removeEventListener(MouseEvent.CLICK,this.onShowGiftDesc);
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         var _loc2_:uint = uint(param1.taskID);
      }
      
      private function onProComplete(param1:TaskEvent) : void
      {
         var _loc2_:uint = uint(param1.taskID);
         var _loc3_:uint = uint(param1.proID);
      }
      
      private function initTask1101() : void
      {
         if(Boolean(TasksManager.isAccepted(1101)) && ItemManager.getItemCount(1400014) < this.JEWELRY_NEED_NUM)
         {
            this._jewelry0.gotoAndStop(2);
            this._jewelry1.gotoAndStop(2);
            this.initJewelryEventListener();
         }
      }
      
      private function initJewelryEventListener() : void
      {
         this._jewelry0.buttonMode = true;
         this._jewelry1.buttonMode = true;
         this._jewelry0.addEventListener(MouseEvent.CLICK,this.onJewelryClick0);
         this._jewelry1.addEventListener(MouseEvent.CLICK,this.onJewelryClick1);
      }
      
      private function onJewelryClick0(param1:MouseEvent) : void
      {
         if(this._jewelryOutput0 >= 5)
         {
            return;
         }
         this.obtainJewelry();
         ++this._jewelryOutput0;
      }
      
      private function onJewelryClick1(param1:MouseEvent) : void
      {
         if(this._jewelryOutput1 >= 5)
         {
            return;
         }
         this.obtainJewelry();
         ++this._jewelryOutput1;
      }
      
      private function obtainJewelry() : void
      {
         if(ItemManager.getItemCount(1400014) >= this.JEWELRY_NEED_NUM)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.NPC_DIALOG_MAP6[0]);
            return;
         }
         if(this._jewelryNum < this.JEWELRY_NEED_NUM)
         {
            ++this._jewelryNum;
            this.playJewelryEffect();
         }
      }
      
      private function playJewelryEffect() : void
      {
         var _loc1_:MovieClip = _mapModel.libManager.getMovieClip("JewelryEffectMC");
         _loc1_.x = LayerManager.toolsLevel.mouseX;
         _loc1_.y = LayerManager.toolsLevel.mouseY;
         LayerManager.toolsLevel.addChild(_loc1_);
         var _loc2_:TTween = new TTween(_loc1_);
         this._jewelryTweenSet.add(_loc2_);
         _loc2_.init({
            "x":690,
            "y":530
         },{
            "x":Expo.easeIn,
            "y":Expo.easeIn
         },1000);
         _loc2_.addEventListener(TweenEvent.MOTION_FINISH,this.onTweenEnd);
         _loc2_.start();
      }
      
      private function onTweenEnd(param1:TweenEvent) : void
      {
         (param1.target as TTween).removeEventListener(TweenEvent.MOTION_FINISH,this.onTweenEnd);
         ItemManager.buyItem(1400014,false,1);
      }
      
      private function onCraneClick(param1:MouseEvent) : void
      {
         this.craneMC.play();
      }
      
      private function onWellClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this.wellMC.currentFrame + 1;
         _loc2_ = _loc2_ > this.wellMC.totalFrames ? 1 : _loc2_;
         this.wellMC.gotoAndStop(_loc2_);
      }
      
      private function onGetMiLuInfo(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         MainManager.actorInfo.overHeadState = _loc3_;
         MainManager.actorModel.updateOverHeadSprite();
         this._itemAID = _loc2_.readUnsignedInt();
         this._itemBID = _loc2_.readUnsignedInt();
         if(_loc3_ == 0)
         {
            this.initDialogStep_1();
         }
         else if(_loc3_ == 1)
         {
            this.initDialogStep_9();
         }
      }
      
      private function onSubmitBox(param1:SocketEvent) : void
      {
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:BuffInfo = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         ItemManager.removeItem(_loc3_,_loc4_);
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         var _loc7_:uint = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = _loc2_.readUnsignedInt();
            _loc9_ = _loc2_.readUnsignedInt();
            ItemManager.addItem(_loc8_,_loc9_);
            _loc10_ = ItemXMLInfo.getName(_loc8_);
            _loc11_ = CoreLanguageDefine.GET_AWARD + _loc9_ + CoreLanguageDefine.SPECIAL_CHARACTER_SPACE[0] + _loc10_;
            AlertManager.showSimpleItemAlarm(_loc11_,ClientConfig.getItemIcon(_loc8_));
            _loc7_++;
         }
         MainManager.actorInfo.overHeadState = _loc5_;
         MainManager.actorModel.updateOverHeadSprite();
         if(_loc5_ == 1)
         {
            this.execCircleAction();
            _loc12_ = new BuffInfo();
            _loc12_.id = 9005;
            _loc12_.duration = 1600;
            _loc12_.layer = 999;
            MainManager.actorModel.execBuff(new MovieBuff(_loc12_,false));
            setTimeout(this.initDialogStep_6,2000);
         }
      }
      
      private function requestMiLuInfo() : void
      {
         SocketConnection.send(CommandID.MILU_INFO);
      }
      
      private function submitBox(param1:uint) : void
      {
         SocketConnection.send(CommandID.MILU_SUBMIT_BOX,param1);
      }
      
      private function onMiLuClick(param1:Event) : void
      {
         this.requestMiLuInfo();
      }
      
      private function onShowGiftDesc(param1:Event) : void
      {
         ModuleManager.turnAppModule("ChristmasGiftDescPanel","");
      }
      
      private function onMinuteTick(param1:TimeEvent) : void
      {
         var _loc2_:uint = 0;
         if(this._MiLuModel)
         {
            _loc2_ = uint(TimeUtil.getSeverHours());
            if(_loc2_ >= 13 && _loc2_ < 15)
            {
               this._MiLuModel.show();
            }
            else
            {
               this._MiLuModel.hide();
            }
         }
      }
      
      private function initDialogStep_1() : void
      {
         var _loc1_:String = "我是来自远方的麋鹿，圣蛋老人在给全世界的小英雄们派发礼物，我需要帮他回收派发出去的空礼物盒，你愿意帮我收集30个空的礼物盒吗？我会在每天的13:00—15:00准时来回收。";
         var _loc2_:Array = ["已经收集完30个空礼物盒","去哪里收集空礼物盒"];
         var _loc3_:DialogInfoMultiple = new DialogInfoMultiple([_loc1_],_loc2_);
         NpcDialogController.showForMultiple(_loc3_,10800,this.collectComplete,this.collectWhere);
      }
      
      private function initDialogStep_2() : void
      {
         var _loc1_:String = "空的礼物盒散落在全世界的关卡中，小侠士快去找找吧，收集完后我会有丰厚的大礼送给你哦！";
         var _loc2_:Array = ["知道了"];
         var _loc3_:DialogInfoMultiple = new DialogInfoMultiple([_loc1_],_loc2_);
         NpcDialogController.showForMultiple(_loc3_,10800);
      }
      
      private function initDialogStep_3() : void
      {
         var _loc1_:String = "你身上还没有足够的礼物盒哦……空的礼物盒散落在全世界的关卡中，小侠士快去找找吧，收集完后我会有丰厚的大礼送给你哦！";
         var _loc2_:Array = ["知道了"];
         var _loc3_:DialogInfoMultiple = new DialogInfoMultiple([_loc1_],_loc2_);
         NpcDialogController.showForMultiple(_loc3_,10800);
      }
      
      private function initDialogStep_4() : void
      {
         var _loc1_:String = "小侠士的速度真是雷厉风行啊，万分感谢！";
         var _loc2_:Array = ["不用客气！"];
         var _loc3_:DialogInfoMultiple = new DialogInfoMultiple([_loc1_],_loc2_);
         NpcDialogController.showForMultiple(_loc3_,10800,this.playCheckLieAnimat);
      }
      
      private function initDialogStep_5() : void
      {
         var _loc1_:String = ItemXMLInfo.getName(this._itemAID);
         var _loc2_:String = ItemXMLInfo.getName(this._itemBID);
         var _loc3_:String = "嗯？刚刚你给我收集来的空礼物盒里，似乎有其他的东西。快看……是<font color=\'#FF0000\'>" + _loc1_ + "</font>和<font color=\'#FF0000\'>" + _loc2_ + "</font>！这……是小侠士放进去的吗？";
         var _loc4_:Array = ["恩，是我的是我的，是我放进去的！","不，我没有放进去过哦！"];
         var _loc5_:DialogInfoMultiple = new DialogInfoMultiple([_loc3_],_loc4_);
         NpcDialogController.showForMultiple(_loc5_,10800,this.onYesSelected,this.onNoSelected);
      }
      
      private function initDialogStep_6() : void
      {
         var _loc1_:String = ItemXMLInfo.getName(this._itemAID);
         var _loc2_:String = ItemXMLInfo.getName(this._itemBID);
         var _loc3_:String = "人在江湖，武学必定重要，但品德才是行走江湖的必要条件！这个<font color=\'#FF0000\'>" + _loc1_ + "</font>和<font color=\'#FF0000\'>" + _loc2_ + "</font>根本不是你的，就算你帮了我的忙，我也得给你一个小小的惩罚，侠士必须得为自己的不诚实买单！";
         var _loc4_:String = "啊……我知道错了！";
         var _loc5_:DialogInfoSimple = new DialogInfoSimple([_loc3_],_loc4_);
         NpcDialogController.showForSimple(_loc5_,10800,this.onLieProcess,this.onLieProcess);
      }
      
      private function initDialogStep_7() : void
      {
         var _loc1_:String = ItemXMLInfo.getName(this._itemAID);
         var _loc2_:String = ItemXMLInfo.getName(this._itemBID);
         var _loc3_:String = "很好，你不仅是一个武林高手，更是一个品德高尚并且诚实的侠士！作为报酬，这个<font color=\'#FF0000\'>" + _loc1_ + "</font>和<font color=\'#FF0000\'>" + _loc2_ + "</font>就送给你吧！记住：人在江湖，武学必定重要，但品德才是行走江湖的必要条件！";
         var _loc4_:Array = ["谢谢你！有空我还会帮你找空的礼物盒的！"];
         var _loc5_:DialogInfoMultiple = new DialogInfoMultiple([_loc3_],_loc4_);
         NpcDialogController.showForMultiple(_loc5_,10800);
      }
      
      private function initDialogStep_8() : void
      {
         var _loc1_:String = "这是给你的小小惩罚，这个“说谎者”的BUFF是不会消失的，直到你再次帮我收集20个空礼物盒，回来找我消除。记住，DEBUFF存在时，你的命中会降低许多。";
         var _loc2_:Array = ["我这就去找20个空礼物盒"];
         var _loc3_:DialogInfoMultiple = new DialogInfoMultiple([_loc1_],_loc2_);
         NpcDialogController.showForMultiple(_loc3_,10800);
      }
      
      private function initDialogStep_9() : void
      {
         var _loc1_:String = "我是来自远方的麋鹿，圣蛋老人在给全世界的小英雄们派发礼物，我需要帮他挥手派发出去的空礼物盒，你愿意帮我手机30个空的礼物盒吗？我会在每天的13:00—15:00准时来回收。";
         var _loc2_:Array = ["我来消除“说谎者”DEBUFF的","去哪里收集空礼物盒"];
         var _loc3_:DialogInfoMultiple = new DialogInfoMultiple([_loc1_],_loc2_);
         NpcDialogController.showForMultiple(_loc3_,10800,this.clearDebuff,this.collectWhere);
      }
      
      private function initDialogStep_10() : void
      {
         var _loc1_:String = "很好，既然你有悔改之心，那我就让时间倒转，请侠士重新选择吧！";
         var _loc2_:String = "恩，恩！";
         var _loc3_:DialogInfoSimple = new DialogInfoSimple([_loc1_],_loc2_);
         NpcDialogController.showForSimple(_loc3_,10800,this.playCheckLieAnimat);
      }
      
      private function collectComplete() : void
      {
         if(ItemManager.getItemCount(1500576) < 30)
         {
            this.initDialogStep_3();
         }
         else
         {
            this.initDialogStep_4();
         }
      }
      
      private function collectWhere() : void
      {
         this.initDialogStep_2();
      }
      
      private function onYesSelected() : void
      {
         this.submitBox(1);
      }
      
      private function onNoSelected() : void
      {
         this.submitBox(0);
         this.initDialogStep_7();
      }
      
      private function onLieProcess() : void
      {
         this.initDialogStep_8();
      }
      
      private function clearDebuff() : void
      {
         if(ItemManager.getItemCount(1500576) < 20)
         {
            this.initDialogStep_3();
         }
         else
         {
            this.initDialogStep_10();
         }
      }
      
      private function creatMiLuModel() : void
      {
         var _loc1_:UserInfo = UserInfoManager.creatInfo(10800);
         _loc1_.roleType = 10800;
         _loc1_.nick = "麋鹿";
         _loc1_.pos = new Point(882,871);
         this._MiLuModel = new SolidModel(_loc1_);
         this._MiLuModel.clickEnabled = false;
         this._MiLuModel.mouseEnabled = true;
         this._MiLuModel.buttonMode = true;
         this._MiLuModel.addEventListener(Event.ADDED_TO_STAGE,this.onAddtoStage);
         MapManager.currentMap.addUser(_loc1_.userID,this._MiLuModel);
      }
      
      private function onAddtoStage(param1:Event) : void
      {
         this._MiLuModel.removeEventListener(Event.ADDED_TO_STAGE,this.onAddtoStage);
         var _loc2_:uint = uint(TimeUtil.getSeverHours());
         if(_loc2_ >= 13 && _loc2_ < 15)
         {
            this._MiLuModel.show();
         }
         else
         {
            this._MiLuModel.hide();
         }
      }
      
      private function execCircleAction() : void
      {
         if(this._MiLuModel)
         {
            this._MiLuModel.execStandAction(false);
            this._MiLuModel.execAction(new BaseAction(ActionXMLInfo.getInfo(10010),false));
         }
      }
      
      private function playCheckLieAnimat() : void
      {
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onPlayCheckLieAnimat);
         AnimatPlay.startAnimat(AnimatHeadString.SCENCE,57);
      }
      
      private function onPlayCheckLieAnimat(param1:AnimatEvent) : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onPlayCheckLieAnimat);
         this.initDialogStep_5();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.removeTaskListener();
         this._jewelry0.removeEventListener(MouseEvent.CLICK,this.onJewelryClick0);
         this._jewelry1.removeEventListener(MouseEvent.CLICK,this.onJewelryClick1);
         this._jewelryTweenSet.clear();
         this._sighModel10801 = null;
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onPlayCheckLieAnimat);
      }
   }
}

