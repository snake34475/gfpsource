package com.gfp.app.manager
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.catchGhost.CatchGhostWaitPanel;
   import com.gfp.app.control.SystemTimeController;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.FightWaitPanel;
   import com.gfp.app.npcDialog.NPCDialogEvent;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.UserItemEvent;
   import com.gfp.core.info.GroupUserInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MessageManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import org.taomee.ds.HashMap;
   import org.taomee.net.SocketEvent;
   
   public class CatchBigGhostManager
   {
      
      private static var _instance:CatchBigGhostManager;
      
      public static const ITEM_ID:uint = 1500715;
      
      public static const GET_ITEM_ID:uint = 2542;
      
      public static const ITEM_EXCHANGE_0:uint = 2430;
      
      public static const ITEM_EXCHANGE_1:uint = 2431;
      
      public static const LEADER_MAP_ID:int = 19;
      
      public static const MEMBER_MAP_ID:int = 103;
      
      private var _itemHash:HashMap;
      
      private var _currentItem:uint;
      
      private var _neededItem:uint;
      
      private var _isWaiting:Boolean = false;
      
      private var _isCatching:Boolean = false;
      
      private var _pveRoomID:uint;
      
      private var _stageID:uint = 552;
      
      private var _timeIndex:uint;
      
      public function CatchBigGhostManager()
      {
         super();
      }
      
      public static function get instance() : CatchBigGhostManager
      {
         if(_instance == null)
         {
            _instance = new CatchBigGhostManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.CATCH_GHOST_SIGN,this.onCatchSign);
         NpcDialogController.ed.addEventListener(NPCDialogEvent.INIT,this.onNpcDialogShow);
         SocketConnection.addCmdListener(CommandID.GROUP_FIGHT_MATCH_CANCEL,this.onMatchCancel);
         FightGroupManager.instance.ed.addEventListener(FightGroupManager.FIGHT_GROUP_QUIT,this.onFightQuit);
      }
      
      private function removeEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.GROUP_FIGHT_MATCH_CANCEL,this.onMatchCancel);
         FightGroupManager.instance.ed.removeEventListener(FightGroupManager.FIGHT_GROUP_QUIT,this.onFightQuit);
      }
      
      private function onFightQuit(param1:Event) : void
      {
         DynamicActivityEntry.instance.setBtnVisible(false);
      }
      
      private function onNpcDialogShow(param1:NPCDialogEvent) : void
      {
         var _loc2_:uint = uint(param1.npcID);
         if(_loc2_ == 10456)
         {
            NpcDialogController.ed.addEventListener(NPCDialogEvent.INIT,this.onNpcDialogShow);
            if(ActivityExchangeTimesManager.getTimes(2713) == 0)
            {
            }
         }
      }
      
      public function signUp() : void
      {
         var _loc1_:GroupUserInfo = null;
         var _loc2_:ByteArray = null;
         if(this._isCatching)
         {
            AlertManager.showSimpleAlarm("小侠士你正在进行阵营大战活动！");
            return;
         }
         if(!SystemTimeController.instance.checkSysTimeAchieve(167))
         {
            SystemTimeController.instance.showOutTimeAlert(167);
            return;
         }
         if(FightGroupManager.instance.groupId == 0)
         {
            AlertManager.showSimpleAlarm("小侠士需要2人组队才能进行阵营大战活动，快去邀请你的战友吧！");
            return;
         }
         if(FightGroupManager.instance.groupUserList.length != 2)
         {
            AlertManager.showSimpleAlarm("小侠士需要组成2人队伍才能进行阵营大战活动，快建立只有2人的队伍吧！");
            return;
         }
         if(!FightGroupManager.instance.myIsTheLeader)
         {
            AlertManager.showSimpleAlarm("小侠士需要本队伍的队长来申请领取施法的仙器！快提醒队长吧！");
            return;
         }
         if(MainManager.actorInfo.lv < 30)
         {
            AlertManager.showSimpleAlarm("小侠士需要修炼到30级才能进行阵营大战活动！加紧修炼吧！");
            return;
         }
         if(MainManager.actorInfo.coins < 300000)
         {
            AlertManager.showSimpleAlarm("你身上功夫豆不足30万！");
            return;
         }
         for each(_loc1_ in FightGroupManager.instance.groupUserList)
         {
            if(_loc1_.userInfo.lv < 30)
            {
               AlertManager.showSimpleAlarm("小侠士队伍中有人未修炼到30级，还没有大战魔界邪神的实力，请重新建立适合的队伍！");
               return;
            }
         }
         _loc2_ = new ByteArray();
         _loc2_.writeUnsignedInt(3);
         _loc2_.writeUnsignedInt(1);
         _loc2_.writeUnsignedInt(300000);
         SocketConnection.send(CommandID.CATCH_GHOST_SIGN,_loc2_);
      }
      
      private function onCatchSign(param1:SocketEvent) : void
      {
         var _loc4_:MovieClip = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == 1)
         {
            if(FightGroupManager.instance.myIsTheLeader)
            {
               AlertManager.showSimpleAlarm("队伍中有成员身上功夫豆不足，无法请来仙器！");
            }
            else
            {
               TextAlert.show("你的功夫豆不足，队长无法报名阵营大战活动！");
            }
            return;
         }
         if(_loc3_ == 2)
         {
            TextAlert.show("不满足阵营大战活动条件！");
            return;
         }
         if(_loc3_ == 0)
         {
            _loc4_ = DynamicActivityEntry.instance.getDynamicBtn();
            _loc4_.visible = true;
            if(FightGroupManager.instance.myIsTheLeader)
            {
               _loc4_.gotoAndStop(1);
            }
            else
            {
               _loc4_.gotoAndStop(2);
            }
            this._isCatching = true;
            TextAlert.show("恭喜小侠士成功领取仙器，速速点击使用施法擒敌去吧！");
            MainManager.actorInfo.coins -= 300000;
            ActivityExchangeTimesManager.updataTimesByOnce(3590);
         }
      }
      
      public function startGame() : void
      {
         var _loc4_:Object = null;
         var _loc1_:Array = MessageManager.getInformsByID(MessageManager.FIGHT_GROUP_WAIT_REQUEST);
         var _loc2_:Boolean = false;
         if(Boolean(_loc1_) && _loc1_.length > 0)
         {
            for each(_loc4_ in _loc1_)
            {
               if(_loc4_.data.type == PvpTypeConstantUtil.GROUP_CATCH_GHOST)
               {
                  _loc2_ = true;
                  break;
               }
            }
         }
         if(_loc2_)
         {
            CatchGhostWaitPanel.instance.show();
            return;
         }
         var _loc3_:uint = uint(MapManager.currentMap.info.id);
         if(FightGroupManager.instance.myIsTheLeader && _loc3_ == LEADER_MAP_ID || !FightGroupManager.instance.myIsTheLeader && _loc3_ == MEMBER_MAP_ID)
         {
            FightGroupManager.instance.groupSignUp(PvpTypeConstantUtil.GROUP_CATCH_GHOST);
            this.addGroupEvent();
         }
         else
         {
            ModuleManager.turnAppModule("CatchBigGhostEntryPanel");
         }
      }
      
      private function addGroupEvent() : void
      {
         FightGroupManager.instance.ed.addEventListener(FightGroupManager.FIGHT_GROUP_QUIT,this.groupChangeHandler);
         FightGroupManager.instance.ed.addEventListener(FightGroupManager.FIGHT_GROUP_CHANGE,this.groupChangeHandler);
      }
      
      private function removeGroupEvent() : void
      {
         FightGroupManager.instance.ed.removeEventListener(FightGroupManager.FIGHT_GROUP_QUIT,this.groupChangeHandler);
         FightGroupManager.instance.ed.removeEventListener(FightGroupManager.FIGHT_GROUP_CHANGE,this.groupChangeHandler);
      }
      
      private function groupChangeHandler(param1:Event) : void
      {
         this.endGame();
      }
      
      private function endGame() : void
      {
         this._isCatching = false;
         this.removeGroupEvent();
         CatchGhostWaitPanel.destroy();
      }
      
      private function onItemReady(param1:Event) : void
      {
         ItemManager.removeListener(ItemManager.EVENT_ITEM_READY,this.onItemReady);
      }
      
      private function onExchangeComplete(param1:ExchangeEvent) : void
      {
      }
      
      private function onItemUsed(param1:UserItemEvent) : void
      {
         var _loc2_:uint = uint(param1.param.itemID);
         if(_loc2_ != ITEM_ID)
         {
            return;
         }
         this._currentItem = _loc2_;
         if(FightGroupManager.instance.groupId == 0)
         {
            AlertManager.showSimpleAlarm("小侠士需组队才能使用雄黄酒（道具）");
            return;
         }
         if(FightGroupManager.instance.groupUserList.length != 2)
         {
            AlertManager.showSimpleAlarm("小侠士需两人组队才能使用雄黄酒（道具）");
            return;
         }
         if(!FightGroupManager.instance.myIsTheLeader)
         {
            AlertManager.showSimpleAlarm("小侠士，只有队长才能发起邀请哦！");
            return;
         }
         if(!this.isRightMap(this._currentItem))
         {
            AlertManager.showSimpleAlert("小侠士需前往特定场景才能才能使用雄黄酒（道具），现在是否前往？",this.confirm);
            return;
         }
         FightGroupManager.instance.groupSignUp(PvpTypeConstantUtil.GROUP_CATCH_TURTLE);
      }
      
      private function confirm() : void
      {
         CityMap.instance.changeMap(this.getRandomMap());
      }
      
      public function onItemRemove(param1:UserItemEvent) : void
      {
      }
      
      public function catchBegin() : void
      {
         if(!this._isCatching)
         {
            return;
         }
         this.endGame();
         FightGroupManager.instance.groupFightOver();
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
         AnimatPlay.startAnimat("catchBigGhost_",8,false,0,0,false);
      }
      
      private function onAnimatEnd(param1:AnimatEvent) : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
         if(FightGroupManager.instance.myIsTheLeader)
         {
            if(Math.random() < 0.2)
            {
               this.groupPVP();
            }
            else
            {
               this.groupPVE();
            }
         }
         DynamicActivityEntry.instance.setBtnVisible(false);
      }
      
      public function stopAnimat() : void
      {
         if(AnimatPlay.getAnimat())
         {
            AnimatPlay.instance.stopAnimat();
         }
      }
      
      private function groupPVE() : void
      {
         TextAlert.show("对方侠士听闻阁下的威名，立刻望风而逃啦！");
         TeamAutoFightManager.instance.signPVE(this._stageID);
      }
      
      private function groupPVP() : void
      {
         TeamAutoFightManager.instance.signPVP();
         this._timeIndex = setTimeout(this.cancelPVP,10000);
      }
      
      private function cancelPVP() : void
      {
         if(FightManager.isLoadingRes || Boolean(MapManager.isFightMap))
         {
            TextAlert.show("两队侠士同时发现魔界邪神，来进行一场公平的比武吧！");
            return;
         }
         FightWaitPanel.onCloseWaitPanel();
      }
      
      private function onMatchCancel(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         if(FightGroupManager.instance.pvpTypeIndex == PvpTypeConstantUtil.GROUP_QUICK_PVP && _loc3_ == FightGroupManager.instance.groupId && _loc4_ == 1)
         {
            if(FightGroupManager.instance.myIsTheSender)
            {
               this.groupPVE();
            }
            else
            {
               FightWaitPanel.onCloseWaitPanel();
            }
         }
      }
      
      public function setNeededItem(param1:uint) : void
      {
         this._neededItem = param1;
      }
      
      public function hasItemForGhost() : Boolean
      {
         if(ItemManager.getItemCount(ITEM_ID) > 0)
         {
            return true;
         }
         return false;
      }
      
      public function getItem() : void
      {
         ActivityExchangeCommander.exchange(GET_ITEM_ID);
      }
      
      public function exchangeItem() : void
      {
      }
      
      public function getRandomMap() : uint
      {
         if(FightGroupManager.instance.myIsTheLeader)
         {
            return LEADER_MAP_ID;
         }
         return MEMBER_MAP_ID;
      }
      
      public function isItemForGhost(param1:uint) : Boolean
      {
         return this._itemHash.containsKey(param1);
      }
      
      public function isRightMap(param1:uint = 0) : Boolean
      {
         if(param1 == 0)
         {
            if(!FightGroupManager.instance.myIsTheLeader)
            {
               return MapManager.mapInfo.id == MEMBER_MAP_ID;
            }
            return MapManager.mapInfo.id == LEADER_MAP_ID;
         }
         var _loc2_:Array = this._itemHash.getValue(param1);
         var _loc3_:uint = uint(MapManager.mapInfo.id);
         return _loc2_.indexOf(_loc3_) != -1;
      }
      
      public function get isWaiting() : Boolean
      {
         return this._isWaiting;
      }
      
      public function get currentItem() : uint
      {
         return this._currentItem;
      }
      
      public function get neededItem() : uint
      {
         return this._neededItem;
      }
      
      public function destroy() : void
      {
         this._itemHash.clear();
         this._itemHash = null;
      }
   }
}

