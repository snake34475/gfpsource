package com.gfp.app.manager
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.FightWaitPanel;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.fight.PvpEntry;
   import com.gfp.app.fight.SinglePkManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.HiddenEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.ScenceItemAddEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.HiddenManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.HiddenModel;
   import com.gfp.core.model.KeyboardModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   
   public class TreasureBoxHuntManager
   {
      
      private static var _instance:TreasureBoxHuntManager;
      
      public static const BOX_ID:uint = 30029;
      
      public static const PVE_TOLLGATES:Array = [539,540,541];
      
      private var _eventType:uint;
      
      private var _awardItem:uint;
      
      private var _awardCount:uint;
      
      private var _timeID:uint;
      
      private var _ed:EventDispatcher;
      
      public function TreasureBoxHuntManager()
      {
         super();
      }
      
      public static function get instance() : TreasureBoxHuntManager
      {
         if(_instance == null)
         {
            _instance = new TreasureBoxHuntManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         this.ed.addEventListener(ScenceItemAddEvent.TRASURE_BOX_APPEARED,this.onTrasureBoxAppeared);
         HiddenManager.addEventListener(HiddenEvent.OPEN,this.onBoxOpen);
         MapManager.addEventListener(MapEvent.MAP_DESTROY,this.onMapDestroy);
         SocketConnection.addCmdListener(CommandID.ADD_TREASURE_BOX,this.onAddBox);
      }
      
      private function removeEvent() : void
      {
         this.ed.removeEventListener(ScenceItemAddEvent.TRASURE_BOX_APPEARED,this.onTrasureBoxAppeared);
         HiddenManager.removeEventListener(HiddenEvent.OPEN,this.onBoxOpen);
         MapManager.removeEventListener(MapEvent.MAP_DESTROY,this.onMapDestroy);
         SocketConnection.removeCmdListener(CommandID.ADD_TREASURE_BOX,this.onAddBox);
      }
      
      private function onAddBox(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:Point = new Point(_loc2_.readUnsignedInt(),_loc2_.readUnsignedInt());
         var _loc6_:uint = _loc2_.readUnsignedInt();
         if(_loc4_ == MapManager.currentMap.info.id)
         {
            if(_loc6_ == 1)
            {
               this.creatBox(_loc3_,_loc5_);
            }
            else
            {
               this.deleteBox(_loc4_,_loc3_);
            }
         }
      }
      
      private function onTrasureBoxAppeared(param1:ScenceItemAddEvent) : void
      {
         this.creatBox(param1.itemID,param1.position);
      }
      
      private function onBoxOpen(param1:HiddenEvent) : void
      {
         var _loc2_:HiddenModel = param1.model;
         var _loc3_:uint = uint(_loc2_.info.roleType);
         if(_loc3_ == BOX_ID)
         {
            HiddenManager.removeMoveEventForStandMap();
            UserManager.remove(_loc2_.info.userID);
            HiddenManager.remove(_loc2_.info.userID);
            _loc2_.destroy();
            SocketConnection.addCmdListener(CommandID.TRIGGER_BOX,this.onTriggerBox);
            SocketConnection.send(CommandID.TRIGGER_BOX);
         }
      }
      
      private function onAnimatEnd(param1:AnimatEvent) : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
         var _loc2_:String = param1.data as String;
         if(_loc2_ == "boxHunt_1")
         {
            ItemManager.addItem(this._awardItem,this._awardCount);
            AlertManager.showSimpleItemAlarmFly("获得" + this._awardCount + "个" + ItemXMLInfo.getName(this._awardItem),ClientConfig.getItemIcon(this._awardItem));
            TextAlert.show("太棒了！小侠士及时找到宝物，这是给你的奖励！");
         }
         if(_loc2_ == "boxHunt_2")
         {
            TextAlert.show("不好，遭到黑暗军团的埋伏，快去抢回宝箱！");
            this.enterPVE();
         }
      }
      
      private function enterPVE() : void
      {
         FightManager.instance.removeEventListener(FightEvent.FIGHT_MATCHED,this.onFightMatched);
         var _loc1_:uint = uint(Math.random() * 3);
         PveEntry.enterTollgate(PVE_TOLLGATES[_loc1_]);
      }
      
      private function onTriggerBox(param1:SocketEvent) : void
      {
         var data:ByteArray;
         var itemID:uint;
         var count:uint;
         var event:SocketEvent = param1;
         SocketConnection.removeCmdListener(CommandID.TRIGGER_BOX,this.onTriggerBox);
         data = event.data as ByteArray;
         this._eventType = data.readUnsignedInt();
         itemID = data.readUnsignedInt();
         count = data.readUnsignedInt();
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
         switch(this._eventType)
         {
            case 1:
               this._awardItem = itemID;
               this._awardCount = count;
               AnimatPlay.startAnimat("boxHunt_",1);
               return;
            case 2:
               break;
            case 3:
               this._timeID = setTimeout(function():void
               {
                  FightWaitPanel.onCloseWaitPanel();
                  AnimatPlay.instance.stopAnimat();
               },10000);
               SinglePkManager.instance.isApplyPvP = true;
               FightManager.instance.addEventListener(FightEvent.FIGHT_MATCHED,this.onFightMatched);
               PvpEntry.instance.fightWithEnter(PvpTypeConstantUtil.BOX_HUNT_PVP);
         }
         AnimatPlay.startAnimat("boxHunt_",2);
      }
      
      private function onFightMatched(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.FIGHT_MATCHED,this.onFightMatched);
         TextAlert.show("对方来路不明，很可能是黑暗军团假扮的，准备战斗！");
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
         AnimatPlay.instance.stopAnimat();
         clearTimeout(this._timeID);
      }
      
      private function onMapDestroy(param1:MapEvent) : void
      {
         HiddenManager.removeMoveEventForStandMap();
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
      }
      
      private function creatBox(param1:uint, param2:Point) : void
      {
         var _loc5_:UserInfo = null;
         var _loc6_:KeyboardModel = null;
         var _loc3_:uint = uint(MapManager.currentMap.info.id);
         var _loc4_:uint = _loc3_ * 100000 + param1;
         if(!UserManager.contains(_loc4_))
         {
            _loc5_ = new UserInfo();
            _loc5_.roleType = param1;
            _loc5_.userID = _loc4_;
            _loc5_.pos = param2;
            _loc5_.nick = RoleXMLInfo.getName(30029);
            _loc6_ = new KeyboardModel(_loc5_);
            UserManager.add(_loc4_,_loc6_);
            HiddenManager.addMoveEventForStandMap();
            HiddenManager.add(_loc4_,_loc6_);
            MapManager.currentMap.contentLevel.addChild(_loc6_);
         }
      }
      
      private function deleteBox(param1:uint, param2:uint) : void
      {
         var _loc3_:uint = param1 * 100000 + param2;
         var _loc4_:UserModel = UserManager.remove(_loc3_);
         if(_loc4_)
         {
            HiddenManager.removeMoveEventForStandMap();
            HiddenManager.remove(_loc3_);
            _loc4_.destroy();
         }
      }
      
      public function dispatchEvent(param1:Event) : void
      {
         this.ed.dispatchEvent(param1);
      }
      
      private function get ed() : EventDispatcher
      {
         if(this._ed == null)
         {
            this._ed = new EventDispatcher();
         }
         return this._ed;
      }
   }
}

