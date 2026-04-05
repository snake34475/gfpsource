package com.gfp.app.feature
{
   import com.gfp.app.cartoon.AnimationHelper;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.info.BlackDragonInfo;
   import com.gfp.app.info.dialog.DialogInfoMultiple;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.app.ui.model.BlackDragon;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.ServerUniqDataEvent;
   import com.gfp.core.info.ServerUniqDataInfo;
   import com.gfp.core.info.SwapActionLimitInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.ServerUniqDataManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.TimeUtil;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import org.taomee.net.SocketEvent;
   
   public class BreakWeddingFeather
   {
      
      private static var firstSelectId:int = -1;
      
      private var npc1:BlackDragon;
      
      private var npc2:BlackDragon;
      
      private var npc3:BlackDragon;
      
      private var selectNpcId:int = 0;
      
      private var dragons:Dictionary;
      
      private var dragonSprite:Dictionary;
      
      private var isEnding:Boolean;
      
      private var dragonCount:int = 0;
      
      public function BreakWeddingFeather()
      {
         super();
         this.dragons = new Dictionary();
         this.dragonSprite = new Dictionary();
      }
      
      public static function hasSelectId() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(firstSelectId == -1)
         {
            _loc1_ = int(ActivityExchangeTimesManager.getTimes(1932));
            if(_loc1_ != 0)
            {
               return 1;
            }
            _loc2_ = int(ActivityExchangeTimesManager.getTimes(1933));
            if(_loc2_ != 0)
            {
               return 2;
            }
            _loc3_ = int(ActivityExchangeTimesManager.getTimes(1934));
            if(_loc3_ != 0)
            {
               return 3;
            }
            return 0;
         }
         return firstSelectId;
      }
      
      public function setup() : void
      {
         this.initUI();
         this.addEvent();
         this.initData();
      }
      
      private function initData() : void
      {
         ServerUniqDataManager.addListener(ServerUniqDataEvent.EVENT_GAOCHAN_ICE,this.onServerData);
         ServerUniqDataManager.requestDateByType(ServerUniqDataManager.TYPE_ICE_NUM);
      }
      
      private function onServerData(param1:ServerUniqDataEvent) : void
      {
         var _loc6_:SwapActionLimitInfo = null;
         ServerUniqDataManager.removeListener(ServerUniqDataEvent.EVENT_GAOCHAN_ICE,this.onServerData);
         var _loc2_:ServerUniqDataInfo = param1.serverUniqDataInfo;
         var _loc3_:Vector.<SwapActionLimitInfo> = _loc2_.infoArr;
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            if(_loc6_.dailyID == 100545)
            {
               if(this.isEnding && _loc6_.limitCount != 0)
               {
                  if(this.npc1.parent)
                  {
                     this.npc1.parent.removeChild(this.npc1);
                  }
               }
               else
               {
                  this.npc1.setBlood(_loc6_.limitCount);
               }
            }
            if(_loc6_.dailyID == 100546)
            {
               if(this.isEnding && _loc6_.limitCount != 0)
               {
                  if(this.npc2.parent)
                  {
                     this.npc2.parent.removeChild(this.npc2);
                  }
               }
               else
               {
                  this.npc2.setBlood(_loc6_.limitCount);
               }
            }
            if(_loc6_.dailyID == 100547)
            {
               if(this.isEnding && _loc6_.limitCount != 0)
               {
                  if(this.npc3.parent)
                  {
                     this.npc3.parent.removeChild(this.npc3);
                  }
               }
               else
               {
                  this.npc3.setBlood(_loc6_.limitCount);
               }
            }
            _loc5_++;
         }
      }
      
      public function endWedding(param1:Boolean = false) : void
      {
         if(this.isEnding == false)
         {
            this.isEnding = true;
            if(param1)
            {
               this.initData();
            }
         }
      }
      
      public function destory() : void
      {
         this.removeEvent();
         if(this.npc1)
         {
            this.npc1.destory();
            this.npc1 = null;
         }
         if(this.npc2)
         {
            this.npc2.destory();
            this.npc2 = null;
         }
         if(this.npc3)
         {
            this.npc3.destory();
            this.npc3 = null;
         }
         this.dragons = null;
         this.dragonSprite = null;
      }
      
      protected function addEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.GET_WEDDING_LIFE,this.onGetNpcLifeHandler);
         this.npc1.addEventListener(MouseEvent.CLICK,this.onNpc1Click);
         this.npc2.addEventListener(MouseEvent.CLICK,this.onNpc1Click);
         this.npc3.addEventListener(MouseEvent.CLICK,this.onNpc1Click);
      }
      
      protected function removeEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.GET_WEDDING_LIFE,this.onGetNpcLifeHandler);
         this.npc1.removeEventListener(MouseEvent.CLICK,this.onNpc1Click);
         this.npc2.removeEventListener(MouseEvent.CLICK,this.onNpc1Click);
         this.npc3.removeEventListener(MouseEvent.CLICK,this.onNpc1Click);
      }
      
      private function onGetNpcLifeHandler(param1:SocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:BlackDragonInfo = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         if(_loc3_ == 13)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = int(_loc2_.readUnsignedInt());
               _loc7_ = int(_loc2_.readUnsignedInt());
               if(this.dragons[_loc6_])
               {
                  this.dragons[_loc6_].life = _loc7_;
               }
               else
               {
                  _loc8_ = new BlackDragonInfo();
                  _loc8_.id = _loc6_;
                  _loc8_.life = _loc7_;
                  this.dragons[_loc6_] = _loc8_;
                  if(_loc6_ == 100545)
                  {
                     this.dragonSprite[_loc8_.id] = this.npc1;
                     this.npc1.info = _loc8_;
                  }
                  else if(_loc6_ == 100546)
                  {
                     this.dragonSprite[_loc8_.id] = this.npc2;
                     this.npc2.info = _loc8_;
                  }
                  else if(_loc6_ == 100547)
                  {
                     this.dragonSprite[_loc8_.id] = this.npc3;
                     this.npc3.info = _loc8_;
                  }
               }
               this.checkInfo(this.dragons[_loc6_] as BlackDragonInfo);
               _loc5_++;
            }
         }
      }
      
      private function checkInfo(param1:BlackDragonInfo) : void
      {
         if(Boolean(this.dragonSprite) && Boolean(this.dragonSprite[param1.id]))
         {
            (this.dragonSprite[param1.id] as BlackDragon).setBlood(param1.life);
         }
      }
      
      private function onNpc1Click(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:AnimationHelper = null;
         var _loc9_:Function = null;
         if(param1.currentTarget == this.npc1)
         {
            this.selectNpcId = 1;
         }
         else if(param1.currentTarget == this.npc2)
         {
            this.selectNpcId = 2;
         }
         else if(param1.currentTarget == this.npc3)
         {
            this.selectNpcId = 3;
         }
         var _loc2_:BlackDragon = param1.currentTarget as BlackDragon;
         if(!_loc2_.isBeated)
         {
            _loc3_ = hasSelectId();
            if(_loc3_ == 0)
            {
               AlertManager.showSimpleAlert("选择挑战本大圣，你就别想更改了",this.onFirstChallenge);
            }
            else if(_loc3_ != this.selectNpcId)
            {
               AlertManager.showSimpleAlarm("大侠，每次只能挑战一个我。");
            }
            else
            {
               this.startChallenge();
            }
         }
         else
         {
            _loc3_ = hasSelectId();
            if(_loc3_ != this.selectNpcId)
            {
               AlertManager.showSimpleAlarm("大侠，你没出半分力气救我，人家的花容月貌可不想给你看。");
               return;
            }
            _loc4_ = int(TimeUtil.getSeverDayIndex());
            _loc5_ = _loc4_ % 3 + 1;
            _loc6_ = 0;
            if(_loc5_ == 3)
            {
               _loc6_ = 2;
            }
            else if(_loc5_ == 2)
            {
               _loc6_ = 3;
            }
            else
            {
               _loc6_ = 1;
            }
            _loc7_ = (_loc6_ + this.selectNpcId - 2) % 3 + 1;
            _loc8_ = new AnimationHelper();
            if(_loc7_ == 1)
            {
               _loc9_ = this.playCallBack1;
            }
            else if(_loc7_ == 2)
            {
               _loc9_ = this.playCallBack2;
            }
            else
            {
               _loc9_ = this.playCallBack3;
            }
            _loc8_.play("wedding" + _loc7_.toString(),_loc9_,"mc");
         }
      }
      
      private function saveWife1() : void
      {
         ModuleManager.turnAppModule("BreakWeddingTurnPanel","正在加载...",1);
      }
      
      private function saveWife2() : void
      {
         ModuleManager.turnAppModule("BreakWeddingTurnPanel","正在加载...",2);
      }
      
      private function saveWife3() : void
      {
         ModuleManager.turnAppModule("BreakWeddingTurnPanel","正在加载...",3);
      }
      
      private function playCallBack1() : void
      {
         var _loc1_:String = "xxx，我一直等待着心爱的人乘着七彩祥云来解救我，可是为什么来的是你！虽然你是这么英俊潇洒，但我早已心有所属。小女子不能以身相许，只能奉献些宝物。";
         var _loc2_:Array = ["解救美女大抽奖"];
         var _loc3_:DialogInfoMultiple = new DialogInfoMultiple([_loc1_],_loc2_);
         NpcDialogController.showForMultiple(_loc3_,10158,this.saveWife1);
      }
      
      private function playCallBack2() : void
      {
         var _loc1_:String = "你那英俊的外表，飘逸的身法，绝世的武艺深深地印在我脑海里。我期待已久的英雄终于降临，我要以身相许！让我们一起回宝石楼，过上幸福快乐的日子吧！";
         var _loc2_:Array = ["(忍着逃走的冲动)赶紧抽奖"];
         var _loc3_:DialogInfoMultiple = new DialogInfoMultiple([_loc1_],_loc2_);
         NpcDialogController.showForMultiple(_loc3_,10013,this.saveWife2);
      }
      
      private function playCallBack3() : void
      {
         var _loc1_:String = "一直手掀开花轿，轿中吉娜捂嘴抛媚眼，然后画面转到派派一个囧的表情，说着“这么丑跑出来吓人啊！”";
         var _loc2_:Array = ["(老妖怪自作多情)抽完奖就开溜"];
         var _loc3_:DialogInfoMultiple = new DialogInfoMultiple([_loc1_],_loc2_);
         NpcDialogController.showForMultiple(_loc3_,10502,this.saveWife3);
      }
      
      private function onFirstChallenge() : void
      {
         firstSelectId = this.selectNpcId;
         this.startChallenge();
      }
      
      private function startChallenge() : void
      {
         if(this.selectNpcId == 1)
         {
            PveEntry.enterTollgate(545);
         }
         else if(this.selectNpcId == 2)
         {
            PveEntry.enterTollgate(546);
         }
         else if(this.selectNpcId == 3)
         {
            PveEntry.enterTollgate(547);
         }
      }
      
      protected function initUI() : void
      {
         this.npc1 = new BlackDragon();
         this.npc1.x = 650;
         this.npc1.y = 550;
         MapManager.currentMap.contentLevel.addChild(this.npc1);
         this.npc2 = new BlackDragon();
         this.npc2.x = 950;
         this.npc2.y = 350;
         MapManager.currentMap.contentLevel.addChild(this.npc2);
         this.npc3 = new BlackDragon();
         this.npc3.x = 1250;
         this.npc3.y = 550;
         MapManager.currentMap.contentLevel.addChild(this.npc3);
      }
   }
}

