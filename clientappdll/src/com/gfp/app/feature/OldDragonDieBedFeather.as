package com.gfp.app.feature
{
   import com.gfp.app.config.xml.DialogExXmlInfo;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.info.dialogex.DialogExInfo;
   import com.gfp.app.npcDialog.DialogAdapter;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.model.CustomUserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.events.UIEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class OldDragonDieBedFeather
   {
      
      private var _dragonModel:CustomUserModel;
      
      private var _resIds:Array = [10216,10217,10218,10219,10220];
      
      private var _dialogIds:Array = [10001,11001,12001,13001,14001];
      
      private var _dialogSelectIds:Array = [10002,11002,12002,13002,14002];
      
      private var _stageIds:Array = [106,107,108,109,110];
      
      private var _currentLevel:int = 0;
      
      private var _needItemId:int = 0;
      
      public function OldDragonDieBedFeather()
      {
         super();
      }
      
      public function setup() : void
      {
         this.initUI();
         this.requestData();
         this.addEvent();
      }
      
      public function destory() : void
      {
         this.removeEvent();
      }
      
      private function initUI() : void
      {
      }
      
      private function requestData() : void
      {
         SocketConnection.send(CommandID.ACTIVITY_SCORE_INFO);
         SocketConnection.send(CommandID.OLD_DRAGON_ITEM);
      }
      
      public function addEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.ACTIVITY_SCORE_INFO,this.onShowData);
         SocketConnection.addCmdListener(CommandID.OLD_DRAGON_ITEM,this.onNeedDataBack);
         NpcDialogController.ed.addEventListener(UIEvent.OPEN_NPC,this.onNpcOpen);
      }
      
      public function removeEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.ACTIVITY_SCORE_INFO,this.onShowData);
         SocketConnection.removeCmdListener(CommandID.OLD_DRAGON_ITEM,this.onNeedDataBack);
         if(this._dragonModel)
         {
            this._dragonModel.removeEvent(MouseEvent.CLICK,this.onNpcClick);
         }
         NpcDialogController.ed.removeEventListener(UIEvent.OPEN_NPC,this.onNpcOpen);
      }
      
      private function onNpcOpen(param1:Event) : void
      {
         this.showNpcDialog();
      }
      
      private function onNeedDataBack(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         this._needItemId = _loc3_;
      }
      
      private function onShowData(param1:SocketEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.readUnsignedInt();
            _loc6_ = _loc2_.readUnsignedInt();
            if(_loc5_ == 90)
            {
               this._currentLevel = _loc6_;
               break;
            }
            _loc4_++;
         }
         this.initModel();
      }
      
      private function initModel() : void
      {
         var _loc1_:int = 0;
         if(this._dragonModel == null)
         {
            _loc1_ = int(this._resIds[this._currentLevel]);
            this._dragonModel = new CustomUserModel(_loc1_);
            this._dragonModel.show(new Point(122,371),null,true);
            this._dragonModel.addEvent(MouseEvent.CLICK,this.onNpcClick);
            this._dragonModel.setTopNickName("远古骨龙");
         }
      }
      
      private function onNpcClick(param1:MouseEvent) : void
      {
         if(Boolean(TasksManager.isAccepted(2137)) && !TasksManager.isCompleted(2137))
         {
            NpcDialogController.showForNpc(10216);
         }
         else
         {
            this.showNpcDialog();
         }
      }
      
      private function showNpcDialog() : void
      {
         var _loc1_:int = int(this._resIds[this._currentLevel]);
         var _loc2_:int = int(this._dialogIds[this._currentLevel]);
         var _loc3_:DialogExInfo = DialogExXmlInfo.getDialogInfoById(_loc2_);
         var _loc4_:String = "<font color=\'#FF0000\'>" + ItemXMLInfo.getName(this._needItemId) + "</font>以及<font color=\'#FF0000\'>5</font>点活力值";
         _loc3_.titleDisplay = _loc3_.title.replace("%ITEM%",_loc4_);
         var _loc5_:DialogAdapter = new DialogAdapter(_loc1_,_loc3_,this.dialogCallBack);
         _loc5_.show();
      }
      
      private function dialogCallBack(param1:DialogExInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         if(this._dialogSelectIds.indexOf(param1.id) != -1)
         {
            if(ItemManager.getItemCount(this._needItemId) == 0)
            {
               _loc3_ = "<font color=\'#FF0000\'>" + ItemXMLInfo.getName(this._needItemId) + "</font>";
               AlertManager.showSimpleAlarm("进入该关卡需要一个" + _loc3_ + ",您身上的物品不足。");
               return;
            }
            _loc2_ = int(this._stageIds[this._currentLevel]);
            PveEntry.enterTollgate(_loc2_);
         }
      }
   }
}

