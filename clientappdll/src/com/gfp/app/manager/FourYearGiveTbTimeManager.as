package com.gfp.app.manager
{
   import com.gfp.app.cmdl.SystemNoticeRedInfo;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SysNoticeManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.TimeUtil;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.net.SocketEvent;
   
   public class FourYearGiveTbTimeManager extends EventDispatcher
   {
      
      private static var _instance:FourYearGiveTbTimeManager;
      
      private var _cdId:int;
      
      private var _cdS:int;
      
      private var _totalS:int;
      
      public var lastMangoMapId:int = 0;
      
      public var mangoMapId:int = 0;
      
      private var timerSecond:int = 0;
      
      public function FourYearGiveTbTimeManager()
      {
         super();
      }
      
      public static function instance() : FourYearGiveTbTimeManager
      {
         return _instance = _instance || new FourYearGiveTbTimeManager();
      }
      
      public function setup() : void
      {
         this._cdId = setInterval(this.showGiveTbCountDown,1000);
         this.showGiveTbCountDown();
         SocketConnection.addCmdListener(CommandID.FOUR_YEAR_TB_NPC_INFO,this.onGetNpcInfo);
         SocketConnection.addCmdListener(CommandID.NOTICE_SYSTEM_2,this.onSystemNotice);
      }
      
      private function onSystemNotice(param1:SocketEvent) : void
      {
         var _loc4_:SystemNoticeRedInfo = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 2)
         {
            _loc2_.position = 0;
            _loc4_ = new SystemNoticeRedInfo(_loc2_);
            SysNoticeManager.waiteNoticeArr.unshift(_loc4_);
            ModuleManager.turnModule(ClientConfig.getAppModule("SystemNoticePanel"),"...",_loc4_);
         }
      }
      
      private function showGiveTbCountDown() : void
      {
         var _loc2_:DataEvent = null;
         var _loc1_:Date = TimeUtil.getSeverDateObject();
         if(_loc1_.month == 1 && (_loc1_.date >= 7 && _loc1_.date < 10 || _loc1_.date >= 12 && _loc1_.date < 15))
         {
            if(_loc1_.hours == 13 && _loc1_.minutes < 53)
            {
               if(this.mangoMapId == 0)
               {
                  ++this.timerSecond;
                  if(this.timerSecond % 10 == 1)
                  {
                     SocketConnection.send(CommandID.FOUR_YEAR_TB_NPC_INFO);
                  }
               }
            }
            if(_loc1_.hours > 13 || _loc1_.hours == 13 && _loc1_.minutes >= 53)
            {
               clearInterval(this._cdId);
               this.mangoMapId = 0;
               _loc2_ = new DataEvent(DataEvent.DATA_UPDATE,this.mangoMapId);
               dispatchEvent(_loc2_);
               SocketConnection.removeCmdListener(CommandID.FOUR_YEAR_TB_NPC_INFO,this.onGetNpcInfo);
               SocketConnection.removeCmdListener(CommandID.NOTICE_SYSTEM_2,this.onSystemNotice);
            }
         }
         else
         {
            clearInterval(this._cdId);
            SocketConnection.removeCmdListener(CommandID.FOUR_YEAR_TB_NPC_INFO,this.onGetNpcInfo);
            SocketConnection.removeCmdListener(CommandID.NOTICE_SYSTEM_2,this.onSystemNotice);
         }
      }
      
      private function onGetNpcInfo(param1:SocketEvent) : void
      {
         var _loc4_:DataEvent = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         if(_loc3_ != this.mangoMapId)
         {
            this.mangoMapId = _loc3_;
            _loc4_ = new DataEvent(DataEvent.DATA_UPDATE,this.mangoMapId);
            dispatchEvent(_loc4_);
         }
         if(this.mangoMapId != 0)
         {
            this.lastMangoMapId = this.mangoMapId;
         }
      }
   }
}

