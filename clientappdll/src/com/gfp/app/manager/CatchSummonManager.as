package com.gfp.app.manager
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.behavior.ChatBehavior;
   import com.gfp.core.config.xml.SummonXMLInfo;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.SummonEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.PeopleModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.MathUtil;
   
   public class CatchSummonManager
   {
      
      private static var _instance:CatchSummonManager;
      
      public static var summonModel:UserModel;
      
      private var _autoInvTimeID:int = 5;
      
      private var _otherModel:PeopleModel;
      
      private var _stageID:uint;
      
      private var captureAnimalAnimatOther:CaptureAnimalAnimat;
      
      private var captureAnimalAnimatSelf:CaptureAnimalAnimat;
      
      private var isTalkAtuo:Boolean = false;
      
      public function CatchSummonManager()
      {
         super();
      }
      
      public static function get instance() : CatchSummonManager
      {
         if(_instance == null)
         {
            _instance = new CatchSummonManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketConnection.addCmdListener(CommandID.SUMMON_BORN,this.onSummonBorn);
      }
      
      private function onSummonBorn(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         var _loc7_:int = int(_loc2_.readUnsignedInt());
         var _loc8_:int = int(_loc2_.readUnsignedInt());
         if(this._stageID != _loc5_)
         {
            this._stageID = _loc5_;
            summonModel = UserManager.getModel(_loc5_) as UserModel;
            if(summonModel)
            {
               this.setCatchableSummon(_loc5_,_loc6_);
            }
            else
            {
               UserManager.addEventListener(UserEvent.BORN,this.onSummonAddToStage);
            }
         }
      }
      
      private function onSummonAddToStage(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.userID == this._stageID)
         {
            UserManager.removeEventListener(UserEvent.BORN,this.onSummonAddToStage);
            this.setCatchableSummon(this.stageID,_loc2_.info.roleType);
         }
      }
      
      public function setCatchableSummon(param1:uint, param2:uint) : void
      {
         this._stageID = param1;
         var _loc3_:Object = {
            "one":param1,
            "two":param2
         };
         SummonManager.getBornSummonInfo();
         SummonManager.dispatchEvent(new SummonEvent(SummonEvent.SUMMON_BORN,_loc3_));
         var _loc4_:uint = new Date().getTime() / 1000;
         summonModel = UserManager.getModel(param1) as UserModel;
         SummonManager.catchtable = true;
         summonModel.setNickText("可捕获的" + SummonXMLInfo.getName(param2 - 1));
         summonModel.execBehavior(new ChatBehavior(0,"小样，来抓我啊，你抓不着",0,false));
         if(ItemManager.getItemCount(1702000) < 1)
         {
            TextAlert.show("亲爱的小侠士，你还没有驯化符哦。");
         }
         this.initAutoSpeak();
         if(summonModel.pos == null)
         {
         }
         if(SummonTalkInTollgate.TOLLGAGE_ID.indexOf(MainManager.pveTollgateId) != -1)
         {
            SummonTalkInTollgate.instance;
         }
         this.captureAnimalAnimatSelf = new CaptureAnimalAnimat(MainManager.actorModel,summonModel,false,false);
         FightManager.instance.addEventListener(FightEvent.QUITE,this.onQuitTollgate);
         SocketConnection.addCmdListener(CommandID.SUMMON_CATCHED,this.onSummonCathed);
         SocketConnection.addCmdListener(CommandID.SUMMON_CATCH_MISSED,this.onSummonCatchMissed);
         MapManager.addEventListener(MapEvent.MAP_DESTROY,this.onMapDestroy);
      }
      
      private function onQuitTollgate(param1:FightEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.SUMMON_CATCHED,this.onSummonCathed);
         SocketConnection.removeCmdListener(CommandID.SUMMON_CATCH_MISSED,this.onSummonCatchMissed);
         FightManager.instance.removeEventListener(FightEvent.QUITE,this.onQuitTollgate);
         if(this.captureAnimalAnimatOther != null)
         {
            this.captureAnimalAnimatOther.destory();
            this.captureAnimalAnimatOther = null;
         }
         if(this.captureAnimalAnimatSelf != null)
         {
            this.captureAnimalAnimatSelf.destory();
            this.captureAnimalAnimatSelf = null;
         }
         if(this._otherModel != null)
         {
            this._otherModel.destroy();
            this._otherModel = null;
         }
         if(SummonTalkInTollgate.TOLLGAGE_ID.indexOf(MainManager.pveTollgateId) != -1)
         {
            SummonTalkInTollgate.instance.destroy();
         }
      }
      
      private function initAutoSpeak() : void
      {
         this.starAutoWalk(this._autoInvTimeID);
      }
      
      private function starAutoWalk(param1:uint) : void
      {
         if(param1 > 0)
         {
            clearInterval(this._autoInvTimeID);
            this._autoInvTimeID = setInterval(this.onAutoSpeak,MathUtil.randomHalfAdd(param1 * 1000));
         }
      }
      
      private function onAutoSpeak() : void
      {
         summonModel.execBehavior(new ChatBehavior(0,"小样，来抓我啊，你抓不着",0,false));
         if(this.isTalkAtuo == true)
         {
            summonModel.execBehavior(new ChatBehavior(0,"小样，最后一次机会陪你玩玩，本仙兽玩腻不奉陪了",0,false));
         }
      }
      
      private function onMapDestroy(param1:MapEvent) : void
      {
         clearInterval(this._autoInvTimeID);
         SummonManager.catchtable = false;
         this._stageID = 0;
      }
      
      private function onSummonCatchMissed(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:int = int(_loc2_.readUnsignedInt());
         var _loc6_:int = int(_loc2_.readUnsignedInt());
         var _loc7_:int = int(_loc2_.readUnsignedInt());
         if(SummonTalkInTollgate.TOLLGAGE_ID.indexOf(MainManager.pveTollgateId) != -1 && _loc3_ == MainManager.actorInfo.userID)
         {
            SummonTalkInTollgate.instance.showTalk(_loc7_);
         }
         var _loc8_:int = Math.round(summonModel.info.roleType / 10) * 10 + 1;
         if(SummonXMLInfo.getEscapeTimes(_loc8_) == _loc7_ + 1)
         {
            this.isTalkAtuo = true;
         }
         else if(SummonXMLInfo.getEscapeTimes(_loc8_) == _loc7_)
         {
            SummonManager.dispatchEvent(new SummonEvent(SummonEvent.SUMMON_CANNOT_CATCH,null));
            this.isTalkAtuo = false;
         }
         this.playOtherMc(false,_loc3_);
      }
      
      private function onSummonCathed(param1:SocketEvent) : void
      {
         TextAlert.show("仙兽已经被对方玩家捕获！");
         SummonManager.catchtable = false;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         this.playOtherMc(true,_loc4_);
      }
      
      private function getOtherModel() : void
      {
         var userList:Array = UserManager.getModels();
         userList.some(function(param1:UserModel, param2:int, param3:Array):Boolean
         {
            if(param1 is PeopleModel && param1.info.userID != MainManager.actorID)
            {
               _otherModel = PeopleModel(param1);
               return true;
            }
            return false;
         });
      }
      
      private function playOtherMc(param1:Boolean, param2:int) : void
      {
         if(this._otherModel == null)
         {
            this.getOtherModel();
         }
         if(this._otherModel == null || param2 == MainManager.actorID)
         {
            return;
         }
         if(summonModel.pos == null)
         {
         }
         this.captureAnimalAnimatOther = new CaptureAnimalAnimat(this._otherModel,summonModel,true,true);
         this.captureAnimalAnimatOther.isdomesticatedSuccessed = param1;
         if(summonModel.pos == null)
         {
         }
         this.captureAnimalAnimatOther.flyFromFixedToMoved();
      }
      
      public function get stageID() : uint
      {
         return this._stageID;
      }
   }
}

