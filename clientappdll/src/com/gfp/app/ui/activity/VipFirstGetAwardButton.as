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
   
   public class VipFirstGetAwardButton extends BaseActivitySprite
   {
      
      private var _vipMonths:int;
      
      public function VipFirstGetAwardButton(param1:ActivityNodeInfo)
      {
         super(param1);
      }
      
      override public function addEvent() : void
      {
         super.addEvent();
         if(this.executeShow())
         {
            ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
         }
         SocketConnection.addCmdListener(CommandID.VIP_MONTH_NUM,this.onVipMonth);
         SocketConnection.send(CommandID.VIP_MONTH_NUM);
      }
      
      private function onVipMonth(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.VIP_MONTH_NUM,this.onVipMonth);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 65;
         this._vipMonths = _loc2_.readByte();
      }
      
      override public function removeEvent() : void
      {
         super.removeEvent();
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
      }
      
      private function onExchangeComplete(param1:ExchangeEvent) : void
      {
         if(param1.info.id >= 5435 || param1.info.id < 5445)
         {
            if(this.executeShow() == false)
            {
               DynamicActivityEntry.instance.updateAlign();
            }
         }
      }
      
      override public function executeShow() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:Boolean = super.executeShow();
         var _loc3_:Boolean = false;
         if(this._vipMonths > 0)
         {
            _loc3_ = true;
         }
         else if(MainManager.actorInfo.vipExp < 50)
         {
            _loc3_ = true;
         }
         if(_loc2_ && _loc3_)
         {
            _loc4_ = [5787,5788];
            for each(_loc6_ in _loc4_)
            {
               _loc5_ = int(ActivityExchangeTimesManager.getTimes(_loc6_));
               if(_loc5_ > 0)
               {
                  break;
               }
               _loc1_ = true;
            }
         }
         return _loc1_;
      }
   }
}

