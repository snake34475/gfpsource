package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class FirstChargeButton extends BaseActivitySprite
   {
      
      private var _swapIdList:Array = [13824,13825,13828,13827,13826];
      
      private var _swapIdList2:Array = [5789];
      
      private var _vipMonths:int = 0;
      
      public function FirstChargeButton(param1:ActivityNodeInfo)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.sendToCoin();
      }
      
      private function sendToCoin() : void
      {
         SocketConnection.addCmdListener(CommandID.VIP_MONTH_NUM,this.onVipMonth);
         SocketConnection.send(CommandID.VIP_MONTH_NUM);
      }
      
      private function onVipMonth(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.VIP_MONTH_NUM,this.onVipMonth);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 65;
         this._vipMonths = _loc2_.readByte();
         DynamicActivityEntry.instance.updateAlign();
      }
      
      override public function addEvent() : void
      {
         super.addEvent();
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeHandle);
      }
      
      override public function removeEvent() : void
      {
         super.removeEvent();
         SocketConnection.removeCmdListener(CommandID.VIP_MONTH_NUM,this.onVipMonth);
      }
      
      private function exchangeHandle(param1:ExchangeEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc2_:int = int(param1.info.id);
         if(this._swapIdList.indexOf(_loc2_) != -1 || this._swapIdList2.indexOf(_loc2_) != -1)
         {
            _loc3_ = false;
            _loc4_ = 0;
            while(_loc4_ < this._swapIdList.length)
            {
               if(ActivityExchangeTimesManager.getTimes(this._swapIdList[_loc4_]) > 0)
               {
                  _loc3_ = true;
                  break;
               }
               _loc4_++;
            }
            _loc5_ = false;
            _loc4_ = 0;
            while(_loc4_ < this._swapIdList2.length)
            {
               if(ActivityExchangeTimesManager.getTimes(this._swapIdList2[_loc4_]) > 0)
               {
                  _loc5_ = true;
                  break;
               }
               _loc4_++;
            }
            if(_loc3_ && _loc5_)
            {
               DynamicActivityEntry.instance.updateAlign();
            }
         }
      }
      
      override public function executeShow() : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc1_:Boolean = super.executeShow();
         if(_loc1_)
         {
            if(ActivityExchangeTimesManager.getTimes(13829) > 0)
            {
               _loc2_ = false;
               _loc3_ = 0;
               while(_loc3_ < this._swapIdList.length)
               {
                  if(ActivityExchangeTimesManager.getTimes(this._swapIdList[_loc3_]) > 0)
                  {
                     _loc2_ = true;
                     break;
                  }
                  _loc3_++;
               }
               _loc4_ = false;
               _loc3_ = 0;
               while(_loc3_ < this._swapIdList2.length)
               {
                  if(ActivityExchangeTimesManager.getTimes(this._swapIdList2[_loc3_]) > 0)
                  {
                     _loc4_ = true;
                     break;
                  }
                  _loc3_++;
               }
               return _loc2_ == false || _loc4_ == false;
            }
            return MainManager.actorInfo.isVip == false;
         }
         return false;
      }
   }
}

