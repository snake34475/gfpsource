package com.gfp.app.feature
{
   import com.gfp.app.ParseSocketError;
   import com.gfp.app.toolBar.TimeCountDown;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.ActionInfo;
   import com.gfp.core.action.normal.PosMoveAction;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.events.SocketErrorCodeEvent;
   import com.gfp.core.events.UserItemEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.model.CustomUserModel;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.ui.tips.ArrowTip;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class TakeMoonRabbitFeature
   {
      
      public static var hasSucessed:Boolean = false;
      
      private var changeModel:SightModel;
      
      private var tuziModel:SightModel;
      
      private var startPoint:Point = new Point(1340,600);
      
      private var endPoint:Point = new Point(580,440);
      
      private var currentPoint:Point;
      
      private var arrow:ArrowTip;
      
      private var currentStatus:int = 0;
      
      private var tuModel:CustomUserModel;
      
      public function TakeMoonRabbitFeature(param1:SightModel, param2:SightModel)
      {
         super();
         this.changeModel = param1;
         this.tuziModel = param2;
         this.changeModel.hide();
         this.arrow = new ArrowTip();
         this.tuModel = new CustomUserModel(10518);
         this.tuModel.show(param2.pos);
         this.tuModel.visible = false;
         this.addEvent();
         this.requestData();
      }
      
      private function requestData() : void
      {
         SocketConnection.send(CommandID.ACTIVITY_SCORE_INFO);
      }
      
      private function addEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.ACTIVITY_SCORE_INFO,this.onShowData);
         SocketConnection.addCmdListener(CommandID.CATCH_RABBIT,this.onCatchRabbit);
         ItemManager.addListener(UserItemEvent.USE_ACTIVITY_ITEM,this.onChangeItemUsed);
         ParseSocketError.addErrorCodeListener(CommandID.ACTIVITY_EXCHANGE,this.tradeErrorHandler);
         SocketConnection.addCmdListener(CommandID.PLAYER_CHANGE_VIEW,this.onChangeView);
      }
      
      private function tradeErrorHandler(param1:SocketErrorCodeEvent) : void
      {
         if(this.currentStatus == 2)
         {
            this.currentStatus = 1;
         }
      }
      
      private function removeEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.ACTIVITY_SCORE_INFO,this.onShowData);
         SocketConnection.removeCmdListener(CommandID.CATCH_RABBIT,this.onCatchRabbit);
         SocketConnection.removeCmdListener(CommandID.BAG_USEMEDICINE,this.onMedicineUse);
         ItemManager.removeListener(UserItemEvent.USE_ACTIVITY_ITEM,this.onChangeItemUsed);
         ParseSocketError.removeErrorCodeListener(CommandID.ACTIVITY_EXCHANGE,this.tradeErrorHandler);
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onUseRabbit);
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE_ENTER,this.onMove);
         this.tuModel.removeEvent(MoveEvent.MOVE_END,this.onTuMoveEnd);
         SocketConnection.addCmdListener(CommandID.PLAYER_CHANGE_VIEW,this.onChangeView);
      }
      
      public function onChangeView(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(param1.headInfo.userID);
         var _loc4_:int = int((param1.data as ByteArray).readUnsignedInt());
         if(_loc3_ == MainManager.actorID)
         {
            if(_loc4_ == 0 && this.currentStatus != 0)
            {
               this.endTake();
            }
         }
      }
      
      private function onChangeItemUsed(param1:UserItemEvent) : void
      {
         if(param1.param.itemID == 2740088)
         {
            if(MainManager.actorInfo.monsterID != 0)
            {
               AlertManager.showSimpleAlarm("小侠士，您已经在变身状态中了，不需要使用兔子变身符。");
               return;
            }
            SocketConnection.addCmdListener(CommandID.BAG_USEMEDICINE,this.onMedicineUse);
            ItemManager.useMedicineItem(param1.param.itemID);
         }
      }
      
      private function onMedicineUse(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.BAG_USEMEDICINE,this.onMedicineUse);
         this.startTake();
      }
      
      private function onUseRabbit(param1:ExchangeEvent) : void
      {
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onUseRabbit);
         this.startTaking();
      }
      
      private function onCatchRabbit(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         if(_loc3_ == 0)
         {
            this.takeFail();
         }
         else if(_loc3_ == 1)
         {
            this.takeSuccess();
         }
      }
      
      private function takeSuccess() : void
      {
         this.endTake();
         if(!hasSucessed)
         {
            hasSucessed = true;
            TextAlert.show("引诱玉兔成功,嫦娥出现在玉兔旁边了哦！");
         }
         else
         {
            TextAlert.show("引诱玉兔成功！");
         }
         this.updateModelVisible();
      }
      
      private function takeFail() : void
      {
         this.endTake();
         TextAlert.show("引诱玉兔失败，再接再厉吧。");
      }
      
      private function onShowData(param1:SocketEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.readUnsignedInt();
            _loc6_ = _loc2_.readUnsignedInt();
            if(_loc5_ == 71)
            {
               hasSucessed = _loc6_ >= 10;
               break;
            }
            _loc4_++;
         }
         this.updateModelVisible();
      }
      
      private function updateModelVisible() : void
      {
         if(hasSucessed)
         {
            this.changeModel.show();
         }
         else
         {
            this.changeModel.hide();
         }
      }
      
      public function destory() : void
      {
         this.hideArrow();
         this.removeEvent();
         MainManager.actorModel.changeRoleView(0);
         this.tuModel.stopFollow();
         this.tuModel.destroy();
         this.tuModel = null;
         this.changeModel = null;
         this.tuziModel = null;
         this.setOperateDisable(false);
         TimeCountDown.instance.destroy();
      }
      
      private function startTake() : void
      {
         this.setOperateDisable(true);
         TextAlert.show("已经变成兔子，快去勾引玉兔吧！");
         this.currentPoint = this.startPoint;
         MainManager.actorModel.addEventListener(MoveEvent.MOVE_ENTER,this.onMove);
         this.currentStatus = 1;
         this.showArrow();
         TimeCountDown.instance.start(50,-140,130);
      }
      
      private function startTaking() : void
      {
         TextAlert.show("已经引诱玉兔上钩，小心翼翼把她骗走吧。");
         this.currentPoint = this.endPoint;
         this.currentStatus = 2;
         this.tuziModel.hide();
         this.tuModel.show(this.tuziModel.pos);
         this.tuModel.visible = true;
         this.tuModel.exeFollow(MainManager.actorModel);
      }
      
      private function endTake() : void
      {
         this.setOperateDisable(false);
         this.currentPoint = null;
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE_ENTER,this.onMove);
         this.currentStatus = 0;
         this.tuModel.stopFollow();
         this.tuModel.addEvent(MoveEvent.MOVE_END,this.onTuMoveEnd);
         var _loc1_:ActionInfo = ActionXMLInfo.getInfo(10002);
         var _loc2_:PosMoveAction = new PosMoveAction(_loc1_,this.tuziModel.pos,false);
         this.tuModel.exeAction(_loc2_);
         this.hideArrow();
         TimeCountDown.instance.destroy();
      }
      
      private function onTuMoveEnd(param1:MoveEvent) : void
      {
         this.tuModel.removeEvent(MoveEvent.MOVE_END,this.onTuMoveEnd);
         this.tuModel.visible = false;
         this.tuziModel.show();
      }
      
      private function showArrow() : void
      {
         this.onMove();
      }
      
      private function hideArrow() : void
      {
         if(this.arrow.parent == MainManager.actorModel)
         {
            MainManager.actorModel.removeChild(this.arrow);
         }
      }
      
      private function onMove(param1:MoveEvent = null) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Point = null;
         var _loc5_:Number = NaN;
         var _loc2_:Point = MainManager.actorModel.pos;
         if(this.currentPoint)
         {
            _loc3_ = Point.distance(_loc2_,this.currentPoint);
            _loc4_ = this.currentPoint.subtract(_loc2_);
            _loc5_ = Math.acos(_loc4_.x / _loc3_) * 180 / Math.PI;
            _loc5_ = _loc4_.y > 0 ? _loc5_ : -_loc5_;
            if(_loc3_ < 40)
            {
               MainManager.actorModel.execStandAction();
               if(this.currentStatus == 1)
               {
                  this.currentStatus = 2;
                  ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onUseRabbit);
                  ActivityExchangeCommander.exchange(3132);
               }
               else if(this.currentStatus == 2)
               {
               }
            }
            if(this.arrow.parent != MainManager.actorModel)
            {
               this.arrow.show(0,10,-100,MainManager.actorModel);
            }
            this.arrow.rotate(_loc5_);
         }
      }
      
      private function setOperateDisable(param1:Boolean) : void
      {
         FunctionManager.disabledActivityPanel = param1;
         FunctionManager.disabledDemonreCorded = param1;
         FunctionManager.disabledFightTeam = param1;
         FunctionManager.disabledMap = param1;
         FunctionManager.disabledMiniHome = param1;
         FunctionManager.disabledMsg = param1;
         FunctionManager.disabledNewspaper = param1;
         FunctionManager.disabledPickItem = param1;
         FunctionManager.disabledTask = param1;
         FunctionManager.disabledTransfiguration = param1;
         FunctionManager.disabledStorehouse = param1;
         FunctionManager.disabledPvp = param1;
         FunctionManager.disabledTradeHouse = param1;
         FunctionManager.disabledPointTran = param1;
         FunctionManager.disabledChange = param1;
         FunctionManager.disabledRide = param1;
         FunctionManager.disabledMail = param1;
         FunctionManager.disabledGuaranteeTrade = param1;
      }
   }
}

