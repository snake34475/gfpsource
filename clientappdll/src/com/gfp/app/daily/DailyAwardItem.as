package com.gfp.app.daily
{
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.DailyActivityXMLInfo;
   import com.gfp.core.info.DailyActiveAwardInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.ClientType;
   import com.gfp.core.utils.TimeUtil;
   import org.taomee.net.SocketEvent;
   
   public class DailyAwardItem
   {
      
      public static var HALF_HOURS_MINUTE:uint = 1800;
      
      public static var START_AWARD_ID:uint = 436;
      
      public static var FIVE_HOURS_SECOND:uint = 18000;
      
      public static var TWO_HOURS_SECOND:uint = 7200;
      
      private var _canGetTime:uint;
      
      private var _getIndex:uint;
      
      private var _cutDownTime:uint;
      
      private var _maxTimes:uint;
      
      private var _getable:Boolean;
      
      public function DailyAwardItem(param1:int, param2:uint, param3:uint)
      {
         super();
         this._getIndex = param1;
         this._canGetTime = param2;
         if(this._getIndex == 2)
         {
            this._cutDownTime = param3 * 0.5;
         }
         else
         {
            this._cutDownTime = param3;
         }
         this._maxTimes = MainManager.battleTimeLimit == FIVE_HOURS_SECOND ? 6 : 3;
         if(ClientConfig.clientType == ClientType.KAIXIN)
         {
            if(TimeUtil.isWeekend())
            {
               this._maxTimes = 6;
            }
            else
            {
               this._maxTimes = 3;
            }
         }
         this.initView();
         SocketConnection.addCmdListener(CommandID.DAILY_ACTIVITY,this.onAward);
      }
      
      public function set getable(param1:Boolean) : void
      {
         this._getable = param1;
      }
      
      public function get getable() : Boolean
      {
         return this._getable;
      }
      
      private function initView() : void
      {
         if(this._getIndex == 0)
         {
         }
         if(this._getIndex > this._maxTimes)
         {
         }
      }
      
      private function initEvent() : void
      {
      }
      
      private function onAward(param1:SocketEvent) : void
      {
         var _loc2_:DailyActiveAwardInfo = param1.data as DailyActiveAwardInfo;
         var _loc3_:uint = uint(_loc2_.type);
         if(_loc3_ != DailyActivityXMLInfo.TYPE_ONLINE_ACTIVITY)
         {
            return;
         }
         this.setAlreadyGet();
      }
      
      private function setCanGet() : void
      {
         this.getable = true;
      }
      
      private function setAlreadyGet() : void
      {
         this.getable = false;
      }
      
      public function updateView(param1:uint) : void
      {
         var _loc2_:int = this._canGetTime - param1;
         if(this._getIndex <= this._maxTimes)
         {
            if(_loc2_ <= 0)
            {
               if(MainManager.onlineAwaedCurrent > this._getIndex)
               {
                  this.setAlreadyGet();
               }
               else if(MainManager.onlineAwaedCurrent == this._getIndex)
               {
                  this.setCanGet();
               }
               else if(MainManager.onlineAwaedCurrent < this._getIndex)
               {
               }
            }
            else if(-_loc2_ < this._canGetTime)
            {
               this.updateTime(param1);
            }
         }
      }
      
      private function updateTime(param1:uint) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc2_:int = this._canGetTime - param1;
         if(_loc2_ <= this._cutDownTime)
         {
            _loc3_ = this._getIndex > 2 ? 3600 : 1800;
            if(_loc2_ > _loc3_ || _loc2_ < 0)
            {
               return;
            }
            _loc4_ = _loc2_ / 60;
            _loc5_ = _loc2_ % 60;
         }
      }
      
      private function getTimeText(param1:int, param2:int) : String
      {
         var _loc3_:String = "";
         _loc3_ += param1 < 10 ? "0" + param1 : param1.toString();
         _loc3_ += ":";
         return _loc3_ + (param2 < 10 ? "0" + param2 : param2.toString());
      }
   }
}

