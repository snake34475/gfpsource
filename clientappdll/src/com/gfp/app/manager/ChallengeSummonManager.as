package com.gfp.app.manager
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.info.dialog.DialogInfoSimple;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.config.xml.SummonXMLInfo;
   import com.gfp.core.config.xml.TollgateXMLInfo;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.ScenceItemAddEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.CustomSightModel;
   import com.gfp.core.model.SpriteModel;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.SpriteType;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.Delegate;
   
   public class ChallengeSummonManager
   {
      
      private static var _instance:ChallengeSummonManager;
      
      public static const CHALLENGE_NPC_APPEAR:String = "challenge_npc_appear";
      
      private var _ed:EventDispatcher;
      
      private var npcSummonModel:CustomSightModel;
      
      public function ChallengeSummonManager()
      {
         super();
      }
      
      public static function get instance() : ChallengeSummonManager
      {
         if(_instance == null)
         {
            _instance = new ChallengeSummonManager();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
         }
         _instance = null;
      }
      
      public static function addEventListner(param1:String, param2:Function) : void
      {
         instance.addEventListner(param1,param2);
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void
      {
         instance.removeEvenListner(param1,param2);
      }
      
      public static function dispatchEvent(param1:Event) : void
      {
         instance.dispatchEvent(param1);
      }
      
      public function setup() : void
      {
         this._ed = new EventDispatcher();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         this._ed.addEventListener(ScenceItemAddEvent.SUMMON_NPC_APPEARED,this.onSummonAdd);
         SocketConnection.addCmdListener(CommandID.SUMMON_NPC_STATUS,this.onSummonPosition);
      }
      
      private function removeEvent() : void
      {
         this._ed.removeEventListener(ScenceItemAddEvent.SUMMON_NPC_APPEARED,this.onSummonAdd);
         SocketConnection.removeCmdListener(CommandID.SUMMON_NPC_STATUS,this.onSummonPosition);
         MapManager.removeEventListener(MapEvent.MAP_DESTROY,this.onMapDestroy);
      }
      
      private function onSummonAdd(param1:ScenceItemAddEvent) : void
      {
         this.initSummonNPC(param1.itemID,param1.position);
      }
      
      private function initSummonNPC(param1:uint, param2:Point) : void
      {
         this.buildModel(param1,param2);
      }
      
      private function buildModel(param1:uint, param2:Point) : void
      {
         var _loc3_:uint = 0;
         this.npcSummonModel = new CustomSightModel(Delegate.create(this.testAAA,param1));
         this.npcSummonModel.roleType = param1;
         this.npcSummonModel.pos = param2;
         if(SpriteModel.getSpriteType(param1) == SpriteType.SUMMON)
         {
            _loc3_ = uint(SummonXMLInfo.getSummonType(param1));
            if(_loc3_ == 1081)
            {
               this.npcSummonModel.modelName = "魔火之灵";
            }
            if(_loc3_ == 1216)
            {
               this.npcSummonModel.modelName = "淘气的燃眉小鬼";
            }
            else
            {
               this.npcSummonModel.modelName = "变坏的" + SummonXMLInfo.getName(_loc3_);
            }
         }
         else if(param1 == 13660)
         {
            this.npcSummonModel.modelName = "上古魔兽";
         }
         else if(param1 == 10519)
         {
            this.npcSummonModel.modelName = "菊花小妖";
         }
         else
         {
            this.npcSummonModel.modelName = RoleXMLInfo.getName(param1);
         }
         this.npcSummonModel.show();
         MapManager.addEventListener(MapEvent.MAP_DESTROY,this.onMapDestroy);
         this.dispatchEvent(new DataEvent(CHALLENGE_NPC_APPEAR,param1));
      }
      
      private function testAAA(param1:uint) : void
      {
         var _loc2_:DialogInfoSimple = null;
         if(param1 == 10452)
         {
            _loc2_ = new DialogInfoSimple(["吾乃三界主宰，留一分身足矣摧毁尔等蝼蚁！想要苟活，还不快逃！"],"大言不惭，今天我要降妖除魔，纳命来吧！");
            NpcDialogController.showForSimple(_loc2_,10434,this.entryTollgateID533);
         }
         else if(param1 == 1216)
         {
            _loc2_ = new DialogInfoSimple(["好不容易溜出来玩玩，我可不会让你抓走！"],"乖乖跟我回去，不会让你捣乱的！");
            NpcDialogController.showForSimple(_loc2_,10434,this.entryTollgateID714);
         }
         else if(param1 == 11918)
         {
            _loc2_ = new DialogInfoSimple(["居然被你找到了，那就不要怪我了啊，凭你就能够战胜我么？哈哈哈！"],"看我的！");
            NpcDialogController.showForSimple(_loc2_,10434,this.entryTollgateID446);
         }
         else if(param1 == 11919)
         {
            _loc2_ = new DialogInfoSimple(["居然被你找到了，那就不要怪我了啊，凭你就能够战胜我么？哈哈哈！"],"看我的！");
            NpcDialogController.showForSimple(_loc2_,10434,this.entryTollgateID447);
         }
         else if(param1 == 11920)
         {
            _loc2_ = new DialogInfoSimple(["居然被你找到了，那就不要怪我了啊，凭你就能够战胜我么？哈哈哈！"],"看我的！");
            NpcDialogController.showForSimple(_loc2_,10434,this.entryTollgateID448);
         }
         else if(param1 == 11921)
         {
            _loc2_ = new DialogInfoSimple(["居然被你找到了，那就不要怪我了啊，凭你就能够战胜我么？哈哈哈！"],"看我的！");
            NpcDialogController.showForSimple(_loc2_,10434,this.entryTollgateID449);
         }
         else if(param1 == 13660)
         {
            _loc2_ = new DialogInfoSimple(["艾尔大陆上的小侠士们呢？是不是看到我害怕的都溜走了啊~哈哈哈哈！"],"看我怎么收拾你！");
            NpcDialogController.showForSimple(_loc2_,10434,this.entryTollgateID714);
         }
         else if(param1 == 10519)
         {
            _loc2_ = new DialogInfoSimple(["我是这儿的守卫，闲杂人等速速退去！否则休怪我不客气了。"],"妖精，还不快快现形！");
            NpcDialogController.showForSimple(_loc2_,10434,this.entryTollgateID588);
         }
         else if(param1 == 13768)
         {
            _loc2_ = new DialogInfoSimple(["以后艾尔大陆就是我们魔界的天下了，哈哈哈哈哈！"],"看我怎么收拾你！");
            NpcDialogController.showForSimple(_loc2_,10434,this.entryTollgateID417);
         }
         else if(param1 == 13797)
         {
            PveEntry.instance.enterTollgate(431);
         }
         else if(param1 == 13876)
         {
            _loc2_ = new DialogInfoSimple(["大胆！你是如何进入这万神殿的？"],"哎呀！被发现了！");
            NpcDialogController.showForSimple(_loc2_,10434,this.entryTollgateID476);
         }
         else if(param1 == 13877)
         {
            _loc2_ = new DialogInfoSimple(["大胆！你是如何进入这万神殿的？"],"哎呀！被发现了！");
            NpcDialogController.showForSimple(_loc2_,10434,this.entryTollgateID477);
         }
         else if(param1 == 11990 || param1 == 11991)
         {
            if(this.getLeftFlowerCount() > 0)
            {
               ModuleManager.turnAppModule("BoxProcessPanel","正在加载...",{
                  "callBack":this.flowerComplete,
                  "id":param1
               });
            }
            else
            {
               AlertManager.showSimpleAlarm("小侠士，您今天的采集次数已完。");
            }
         }
         else
         {
            _loc2_ = new DialogInfoSimple(["居然被你找到了，那就不要怪我了啊，凭你就能够战胜我么？哈哈哈！"],"看我的！");
            NpcDialogController.showForSimple(_loc2_,10434,Delegate.create(this.onConfirm,param1));
         }
      }
      
      private function flowerComplete(param1:int) : void
      {
         switch(param1)
         {
            case 11990:
               ActivityExchangeCommander.exchange(4520);
               break;
            case 11991:
               ActivityExchangeCommander.exchange(4521);
         }
      }
      
      private function getLeftFlowerCount() : int
      {
         var _loc1_:int = 20 - (ActivityExchangeTimesManager.getTimes(4520) + ActivityExchangeTimesManager.getTimes(4521));
         return _loc1_ < 0 ? 0 : _loc1_;
      }
      
      private function entryTollgateID588() : void
      {
         PveEntry.enterTollgate(588);
      }
      
      private function entryTollgateID476() : void
      {
         PveEntry.enterTollgate(476);
      }
      
      private function entryTollgateID477() : void
      {
         PveEntry.enterTollgate(477);
      }
      
      private function entryTollgateID417() : void
      {
         PveEntry.enterTollgate(417);
      }
      
      private function entryTollgateID714() : void
      {
         PveEntry.enterTollgate(714);
      }
      
      private function entryTollgateID446() : void
      {
         PveEntry.enterTollgate(446);
      }
      
      private function entryTollgateID447() : void
      {
         PveEntry.enterTollgate(447);
      }
      
      private function entryTollgateID448() : void
      {
         PveEntry.enterTollgate(448);
      }
      
      private function entryTollgateID449() : void
      {
         PveEntry.enterTollgate(449);
      }
      
      private function entryTollgateID533() : void
      {
         PveEntry.enterTollgate(533);
      }
      
      private function onConfirm(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(SightManager.getSightModel(param1))
         {
            _loc2_ = uint(SummonXMLInfo.getSummonType(param1));
            _loc3_ = uint(TollgateXMLInfo.getTollgateByMonster(_loc2_.toString()));
            PveEntry.enterTollgate(_loc3_);
         }
         else
         {
            NpcDialogController.hide();
         }
      }
      
      private function onSummonPosition(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         if(RoleXMLInfo.getInfo(_loc3_) == null && RoleXMLInfo.getInfo(_loc3_ + 5) != null)
         {
            _loc3_ += 5;
         }
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:Point = new Point();
         _loc5_.x = _loc2_.readUnsignedInt();
         _loc5_.y = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         if(MapManager.mapInfo == null || _loc4_ != MapManager.mapInfo.id)
         {
            return;
         }
         var _loc7_:int = int(SpriteModel.getSpriteType(_loc3_));
         if(_loc7_ != SpriteType.SUMMON && _loc7_ != SpriteType.NPC && _loc7_ != SpriteType.OGRE)
         {
            return;
         }
         if(_loc6_ == 0)
         {
            this.removeSummon(_loc3_);
            if(NpcDialogController.panel.targetNpc == 10434)
            {
               NpcDialogController.hide();
            }
         }
         else if(_loc6_ == 1)
         {
            this.initSummonNPC(_loc3_,_loc5_);
         }
      }
      
      private function removeSummon(param1:uint = 0) : void
      {
         var _loc2_:SightModel = null;
         if(Boolean(this.npcSummonModel) && (param1 == 0 || this.npcSummonModel.roleType == param1))
         {
            this.npcSummonModel.destroy();
            this.npcSummonModel = null;
         }
         else
         {
            _loc2_ = SightManager.getSightModel(param1);
            if(_loc2_)
            {
               SightManager.remove(_loc2_);
               _loc2_.destroy();
            }
         }
      }
      
      private function onMapDestroy(param1:MapEvent) : void
      {
         this.removeSummon();
      }
      
      public function addEventListner(param1:String, param2:Function) : void
      {
         this._ed.addEventListener(param1,param2);
      }
      
      public function removeEvenListner(param1:String, param2:Function) : void
      {
         this._ed.removeEventListener(param1,param2);
      }
      
      public function dispatchEvent(param1:Event) : void
      {
         this._ed.dispatchEvent(param1);
      }
      
      public function destroy() : void
      {
         this.removeEvent();
      }
   }
}

