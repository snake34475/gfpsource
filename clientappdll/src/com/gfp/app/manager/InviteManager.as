package com.gfp.app.manager
{
   import com.gfp.app.info.InvitedUserInfo;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.info.dailyActivity.SwapTimesInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.TimeUtil;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class InviteManager
   {
      
      private static var _instance:InviteManager;
      
      private var _lotteryTotalTimes:int;
      
      private var _invitedUsers:Vector.<InvitedUserInfo>;
      
      private var _oldUserLoginDaysInfo:SwapTimesInfo;
      
      public function InviteManager()
      {
         super();
      }
      
      public static function get instance() : InviteManager
      {
         return _instance = _instance || new InviteManager();
      }
      
      public function init() : void
      {
         SocketConnection.send(CommandID.INVITE_RELATION,0);
         SocketConnection.addCmdListener(CommandID.INVITE_RELATION,this.responseHandle);
         if(MainManager.lastLoginTime != 0 && TimeUtil.getServerSecond() - MainManager.lastLoginTime > 30 * 24 * 60 * 60)
         {
            ActivityExchangeCommander.exchange(3922);
            ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
         }
         else if(ActivityExchangeTimesManager.getTimes(3922) > 0)
         {
            ActivityExchangeTimesManager.getActiviteTimeInfo(3921);
            ActivityExchangeTimesManager.addEventListener(3921,this.onOldUserLoginDaysInfoHandle);
         }
      }
      
      private function onOldUserLoginDaysInfoHandle(param1:DataEvent) : void
      {
         var _loc2_:Date = null;
         var _loc3_:Date = null;
         this._oldUserLoginDaysInfo = param1.data as SwapTimesInfo;
         ActivityExchangeTimesManager.removeEventListener(3921,this.onOldUserLoginDaysInfoHandle);
         if(ActivityExchangeTimesManager.getTimes(3921) > 0)
         {
            _loc2_ = new Date();
            _loc2_.time = this._oldUserLoginDaysInfo.senconds * 1000;
            _loc3_ = TimeUtil.getSeverDateObject();
            if(_loc2_.fullYear != _loc3_.fullYear || _loc2_.month != _loc3_.month || _loc2_.date != _loc3_.date)
            {
               ActivityExchangeCommander.exchange(3921);
            }
         }
      }
      
      private function onExchangeComplete(param1:ExchangeEvent) : void
      {
         if(param1.info.id == 3922)
         {
            MainManager.lastLoginTime = TimeUtil.getServerSecond();
            ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
            ActivityExchangeCommander.exchange(3921);
         }
      }
      
      private function responseHandle(param1:SocketEvent) : void
      {
         var _loc5_:InvitedUserInfo = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         SocketConnection.removeCmdListener(CommandID.INVITE_RELATION,this.responseHandle);
         this._invitedUsers = new Vector.<InvitedUserInfo>();
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new InvitedUserInfo();
            _loc5_.userID = _loc2_.readUnsignedInt();
            _loc5_.createTime = _loc2_.readUnsignedInt();
            _loc6_ = int(_loc2_.readUnsignedInt());
            _loc5_.level = _loc2_.readUnsignedInt();
            _loc7_ = int(_loc2_.readUnsignedInt());
            _loc2_.readUnsignedInt();
            if(_loc6_ == 4)
            {
               _loc5_.isTurnBack = (_loc7_ & 1) == 1;
               _loc5_.isSpended = (_loc7_ & 2) == 2;
               if(_loc5_.isTurnBack || _loc5_.level >= 65)
               {
                  this._invitedUsers.push(_loc5_);
               }
            }
            _loc4_++;
         }
         this.calculateLotteryTotalTime();
      }
      
      private function calculateLotteryTotalTime() : void
      {
         var _loc2_:InvitedUserInfo = null;
         this._lotteryTotalTimes = 0;
         var _loc1_:int = int(this._invitedUsers.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = this._invitedUsers[_loc3_];
            if(_loc2_.isTurnBack)
            {
               this._lotteryTotalTimes += 5;
            }
            else if(_loc2_.level >= 75)
            {
               this._lotteryTotalTimes += 2;
            }
            else if(_loc2_.level >= 70)
            {
               ++this._lotteryTotalTimes;
            }
            if(_loc2_.isSpended)
            {
               this._lotteryTotalTimes += 5;
            }
            _loc3_++;
         }
         if(_loc1_ >= 2)
         {
            this._lotteryTotalTimes += 1;
         }
         if(_loc1_ >= 4)
         {
            this._lotteryTotalTimes += 2;
         }
         if(_loc1_ >= 15)
         {
            this._lotteryTotalTimes += 3;
         }
         if(_loc1_ >= 30)
         {
            this._lotteryTotalTimes += 5;
         }
      }
      
      public function get invitedUsers() : Vector.<InvitedUserInfo>
      {
         return this._invitedUsers.concat();
      }
      
      public function get lotteryTotalTimes() : int
      {
         return this._lotteryTotalTimes;
      }
   }
}

