package com.gfp.app.module
{
   import com.gfp.core.CommandID;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.TimeUtil;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.net.SocketEvent;
   
   public class BaseCdExModule extends BaseExchangeModule
   {
      
      private var _lastInteractiveTime:int;
      
      private var _timeId:int;
      
      protected var cdGap:int = 600;
      
      protected var timeTick:int = 1000;
      
      protected var clearCdId:int;
      
      protected var cdParam:int;
      
      protected var clearCdBtn:DisplayObject;
      
      protected var cdLabel:TextField;
      
      protected var cdAlertStr:String;
      
      public function BaseCdExModule()
      {
         super();
      }
      
      override public function show() : void
      {
         super.show();
         if(this.clearCdId != 0)
         {
            this.getActivityInfo();
         }
      }
      
      protected function setCdParams() : void
      {
         this.clearCdId = 0;
         this.cdParam = 0;
         this.clearCdBtn = _mainUI["clearCdBtn"];
         mExchange = 0;
         this.cdLabel = _mainUI["cdLabel"];
         this.cdAlertStr = "每次修行需要间隔10分钟，间隔时间还未结束，你要花费5通宝清除时间间隔吗？";
      }
      
      private function getActivityInfo() : void
      {
         SocketConnection.send(CommandID.ACTIVITY_INFO,this.cdParam);
      }
      
      protected function onTimer() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:int = this.cd;
         if(!_mainUI)
         {
            return;
         }
         if(_loc1_ <= 0)
         {
            this.cdLabel.text = "00:00";
            clearInterval(this._timeId);
         }
         else
         {
            _loc2_ = int(uint(_loc1_ / 60));
            _loc3_ = _loc1_ % 60;
            this.cdLabel.text = (_loc2_ < 10 ? "0" + _loc2_ : _loc2_) + ":" + (_loc3_ < 10 ? "0" + _loc3_ : _loc3_);
         }
      }
      
      protected function get cd() : int
      {
         return this.cdGap - TimeUtil.getServerSecond() + this._lastInteractiveTime;
      }
      
      override protected function exchangeCompleteHandler(param1:ExchangeEvent) : void
      {
         super.exchangeCompleteHandler(param1);
         if(param1.info.id == this.clearCdId)
         {
            this._lastInteractiveTime = 0;
            this.onTimer();
         }
      }
      
      protected function refreshTime() : void
      {
         this._lastInteractiveTime = TimeUtil.getServerSecond();
         this.onTimer();
         clearInterval(this._timeId);
         this._timeId = setInterval(this.onTimer,this.timeTick);
      }
      
      protected function isInCd() : Boolean
      {
         if(this.cd > 0)
         {
            AlertManager.showSimpleAlarm("小侠士，请先清除冷却时间！");
            return true;
         }
         return false;
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         if(this.clearCdBtn)
         {
            this.clearCdBtn.addEventListener(MouseEvent.CLICK,this.onClearCdBtnClick);
         }
         SocketConnection.addCmdListener(CommandID.ACTIVITY_INFO,this.onGetActivityInfo);
      }
      
      private function onClearCdBtnClick(param1:MouseEvent) : void
      {
         if(this.cd <= 0)
         {
            return;
         }
         if(mIsSend)
         {
            return;
         }
         mExchange = this.clearCdId;
         buyItem(true,this.cdAlertStr,null,false);
      }
      
      private function onGetActivityInfo(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ != this.cdParam)
         {
            _loc2_.position -= 4;
            return;
         }
         this._lastInteractiveTime = _loc2_.readUnsignedInt();
         clearInterval(this._timeId);
         if(this.cd > 0)
         {
            this._timeId = setInterval(this.onTimer,this.timeTick);
         }
         else if(_mainUI)
         {
            this.cdLabel.text = "00:00";
         }
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         if(this.clearCdBtn)
         {
            this.clearCdBtn.removeEventListener(MouseEvent.CLICK,this.onClearCdBtnClick);
         }
         SocketConnection.removeCmdListener(CommandID.ACTIVITY_INFO,this.onGetActivityInfo);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         clearInterval(this._timeId);
      }
   }
}

