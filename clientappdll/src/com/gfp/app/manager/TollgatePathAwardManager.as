package com.gfp.app.manager
{
   import com.gfp.core.CommandID;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.info.ActivityExchangeAwardInfo;
   import com.gfp.core.info.TollgateAwardPointInfo;
   import com.gfp.core.info.dailyActivity.ActivityExchangeAward;
   import com.gfp.core.net.SocketConnection;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import org.taomee.net.SocketEvent;
   
   public class TollgatePathAwardManager extends EventDispatcher
   {
      
      private static var _instance:TollgatePathAwardManager;
      
      public static const EVENT_TOLLGATE_POINT_READY:String = "event_tollgate_point_ready";
      
      public static const EVENT_TOLLGATE_AWARD:String = "event_tollgate_award";
      
      public function TollgatePathAwardManager()
      {
         super();
      }
      
      public static function get instance() : TollgatePathAwardManager
      {
         if(_instance == null)
         {
            _instance = new TollgatePathAwardManager();
         }
         return _instance;
      }
      
      public function getTollgatePoint(param1:int) : void
      {
         SocketConnection.addCmdListener(CommandID.TOLLGATE_AWARD_POINT,this.onAwardPoint);
         SocketConnection.send(CommandID.TOLLGATE_AWARD_POINT,param1);
      }
      
      private function onAwardPoint(param1:SocketEvent) : void
      {
         var _loc2_:TollgateAwardPointInfo = param1.data as TollgateAwardPointInfo;
         dispatchEvent(new DataEvent(EVENT_TOLLGATE_POINT_READY,_loc2_));
      }
      
      public function getTollgateAward(param1:int, param2:int, param3:int) : void
      {
         SocketConnection.addCmdListener(CommandID.GET_TOLLGATE_AWARD,this.onGetSward);
         SocketConnection.send(CommandID.GET_TOLLGATE_AWARD,param1,param2,param3);
      }
      
      private function onGetSward(param1:SocketEvent) : void
      {
         var _loc2_:ActivityExchangeAwardInfo = param1.data as ActivityExchangeAwardInfo;
         ActivityExchangeAward.addAward(_loc2_);
         dispatchEvent(new Event(EVENT_TOLLGATE_AWARD));
      }
   }
}

