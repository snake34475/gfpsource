package com.gfp.app.manager
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.info.WatchFightListItemInfo;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.CommEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.net.SocketItemInfo;
   import com.gfp.core.net.SocketListPackage;
   import com.gfp.core.utils.FightMode;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.FileReference;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.net.tmf.HeadInfo;
   
   public class WatchFightManager
   {
      
      private static var _instance:WatchFightManager;
      
      private static var _ed:EventDispatcher;
      
      public static const WATCH_FIGHT_BACK_EVENT:String = "WATCH_FIGHT_BACK_EVENT";
      
      public static const WATCH_FIGHT_LEAVE_EVENT:String = "WATCH_FIGHT_LEAVE_EVENT";
      
      public static const WATCH_FIGHT_ENTER_FAIL_EVENT:String = "WATCH_FIGHT_ENTER_FAIL_EVENT";
      
      public static const WATCH_FIGHT_HIDE_PANEL_EVENT:String = "WATCH_FIGHT_HIDE_PANEL_EVENT";
      
      public static const GET_WATCH_FIGHT_LIST_EVENT:String = "GET_WATCH_FIGHT_LIST_EVENT";
      
      public var watchingFight:Boolean;
      
      public var watchRealTime:Boolean;
      
      public var curFightItemInfo:WatchFightListItemInfo;
      
      public var videoPackageList:Vector.<SocketItemInfo>;
      
      private var curGetPackage:Boolean;
      
      public var videoPackageEnd:Boolean;
      
      private var firstRequest:Boolean;
      
      private var _saveFile:Boolean;
      
      private var fileRef:FileReference;
      
      public function WatchFightManager()
      {
         super();
      }
      
      public static function get instance() : WatchFightManager
      {
         if(!_instance)
         {
            _instance = new WatchFightManager();
         }
         return _instance;
      }
      
      public static function get ed() : EventDispatcher
      {
         if(!_ed)
         {
            _ed = new EventDispatcher();
         }
         return _ed;
      }
      
      public function watchFightByPvpType(param1:uint, param2:Boolean = true) : void
      {
         this.watchRealTime = param2;
         this.applyWatchFight(param1);
      }
      
      public function watchFightByPvpId(param1:uint) : void
      {
      }
      
      private function applyWatchFight(param1:uint, param2:uint = 0, param3:uint = 0) : void
      {
         SocketConnection.addCmdListener(CommandID.WATCH_FIGHT,this.watchFightBackHandler);
         SocketConnection.send(CommandID.WATCH_FIGHT,param1,param2,param3);
      }
      
      private function watchFightBackHandler(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.WATCH_FIGHT,this.watchFightBackHandler);
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         switch(_loc3_)
         {
            case 0:
               FightManager.fightMode = FightMode.WATCH;
               ed.dispatchEvent(new CommEvent(WATCH_FIGHT_BACK_EVENT));
               break;
            case 1:
               AlertManager.showSimpleAlarm(AppLanguageDefine.WATCH_FIGHT_MSG[2]);
               ed.dispatchEvent(new CommEvent(WATCH_FIGHT_ENTER_FAIL_EVENT));
               break;
            case 2:
               AlertManager.showSimpleAlarm(AppLanguageDefine.WATCH_FIGHT_MSG[3]);
               ed.dispatchEvent(new CommEvent(WATCH_FIGHT_ENTER_FAIL_EVENT));
         }
      }
      
      public function leaveWatchFight() : void
      {
         if(this.watchRealTime)
         {
            SocketConnection.addCmdListener(CommandID.WATCH_FIGHT_LEAVE,this.leaveWatchHandler);
            SocketConnection.send(CommandID.WATCH_FIGHT_LEAVE);
         }
         else
         {
            SocketConnection.send(CommandID.ENTER_OR_LEAVE_WATCH_FIGHT,1);
            this.leaveWatchHandler();
         }
      }
      
      public function leaveWatchHandler(param1:SocketEvent = null) : void
      {
         SocketConnection.removeCmdListener(CommandID.WATCH_FIGHT_LEAVE,this.leaveWatchHandler);
         ed.dispatchEvent(new CommEvent(WATCH_FIGHT_LEAVE_EVENT));
         WatchFightTimerManager.instance.destroy();
         this.curFightItemInfo = null;
      }
      
      public function hidePanel() : void
      {
         ed.dispatchEvent(new CommEvent(WATCH_FIGHT_HIDE_PANEL_EVENT));
      }
      
      public function watchFightBySocketList(param1:SocketListPackage) : void
      {
         FightManager.fightMode = FightMode.WATCH;
         WatchFightTimerManager.instance.socketListPackage = param1;
         WatchFightTimerManager.instance.start();
      }
      
      public function set saveFile(param1:Boolean) : void
      {
         this._saveFile = param1;
      }
      
      public function saveFightData() : void
      {
      }
      
      private function saveCompleteHandler(param1:Event) : void
      {
         this.fileRef.removeEventListener(Event.COMPLETE,this.saveCompleteHandler);
      }
      
      public function loadWatchFightFile() : void
      {
         this.fileRef = new FileReference();
         this.fileRef.addEventListener(Event.SELECT,this.selectFileHandler);
         this.fileRef.browse();
      }
      
      private function selectFileHandler(param1:Event) : void
      {
         this.fileRef.removeEventListener(Event.SELECT,this.selectFileHandler);
         this.fileRef.addEventListener(Event.COMPLETE,this.loaderCompleteHandler);
         this.fileRef.load();
      }
      
      private function loaderCompleteHandler(param1:Event) : void
      {
         this.fileRef.removeEventListener(Event.COMPLETE,this.loaderCompleteHandler);
         var _loc2_:Vector.<SocketItemInfo> = this.resolveWatchFightFile(this.fileRef.data);
         var _loc3_:SocketListPackage = new SocketListPackage("");
         _loc3_.packageList = _loc2_;
         this.watchFightBySocketList(_loc3_);
      }
      
      public function resolveWatchFightFile(param1:ByteArray) : Vector.<SocketItemInfo>
      {
         var _loc3_:SocketItemInfo = null;
         var _loc4_:HeadInfo = null;
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc10_:ByteArray = null;
         var _loc2_:Vector.<SocketItemInfo> = new Vector.<SocketItemInfo>();
         var _loc9_:uint = param1.bytesAvailable;
         while(param1.position < _loc9_)
         {
            _loc6_ = param1.readUnsignedInt();
            _loc7_ = param1.readUnsignedInt();
            _loc8_ = param1.readUnsignedInt();
            _loc4_ = new HeadInfo(param1);
            if(_loc6_ > 22)
            {
               _loc10_ = new ByteArray();
               param1.readBytes(_loc10_,0,_loc6_ - 22);
            }
            _loc3_ = new SocketItemInfo(_loc7_,_loc8_,_loc4_,_loc10_);
            _loc2_.push(_loc3_);
         }
         return _loc2_;
      }
      
      public function getWatchFightList(param1:uint, param2:int = 0, param3:int = 20) : void
      {
         SocketConnection.addCmdListener(CommandID.GET_WATCH_FIGHT_LIST,this.getWatchFightListHandler);
         SocketConnection.send(CommandID.GET_WATCH_FIGHT_LIST,param1,param2,param3);
      }
      
      private function getWatchFightListHandler(param1:SocketEvent) : void
      {
         var _loc5_:WatchFightListItemInfo = null;
         SocketConnection.removeCmdListener(CommandID.GET_WATCH_FIGHT_LIST,this.getWatchFightListHandler);
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:Vector.<WatchFightListItemInfo> = new Vector.<WatchFightListItemInfo>();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = new WatchFightListItemInfo(_loc2_);
            _loc3_.push(_loc5_);
            _loc6_++;
         }
         ed.dispatchEvent(new CommEvent(GET_WATCH_FIGHT_LIST_EVENT,_loc3_));
      }
      
      public function watchFightByUniqId(param1:WatchFightListItemInfo) : void
      {
         this.curFightItemInfo = param1;
         this.firstRequest = true;
         this.videoPackageList = new Vector.<SocketItemInfo>();
         this.getVideoPackage(this.curFightItemInfo.fightSvrId,this.curFightItemInfo.fightRoomId,this.curFightItemInfo.fightStartTime,0);
      }
      
      public function getVideoPackage(param1:uint, param2:uint, param3:uint, param4:uint) : void
      {
         if(!this.curGetPackage)
         {
            this.curGetPackage = true;
            SocketConnection.addCmdListener(CommandID.GET_WATCH_FIGHT_PACKAGE,this.getWatchFightPackageHandler);
            SocketConnection.send(CommandID.GET_WATCH_FIGHT_PACKAGE,param1,param2,param3,param4);
         }
      }
      
      private function getWatchFightPackageHandler(param1:SocketEvent) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:HeadInfo = null;
         var _loc6_:uint = 0;
         var _loc7_:ByteArray = null;
         var _loc8_:SocketItemInfo = null;
         var _loc10_:SocketListPackage = null;
         this.curGetPackage = false;
         SocketConnection.removeCmdListener(CommandID.GET_WATCH_FIGHT_PACKAGE,this.getWatchFightPackageHandler);
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == 0)
         {
            WatchFightTimerManager.instance.getPackageError();
         }
         else
         {
            WatchFightTimerManager.instance.getPackageSuc();
         }
         this.videoPackageEnd = _loc2_.readUnsignedInt() == 1;
         var _loc9_:int = 0;
         while(_loc9_ < _loc3_)
         {
            _loc6_ = _loc2_.readUnsignedInt();
            _loc4_ = _loc2_.readUnsignedInt();
            _loc5_ = new HeadInfo(_loc2_);
            if(_loc4_ > 18)
            {
               _loc7_ = new ByteArray();
               _loc2_.readBytes(_loc7_,0,_loc4_ - 18);
            }
            else
            {
               _loc7_ = null;
            }
            _loc8_ = new SocketItemInfo(_loc5_.commandID,_loc6_,_loc5_,_loc7_);
            this.videoPackageList.push(_loc8_);
            _loc9_++;
         }
         if(this.firstRequest)
         {
            this.firstRequest = false;
            _loc10_ = new SocketListPackage("");
            _loc10_.packageList = this.videoPackageList;
            this.watchFightBySocketList(_loc10_);
            SocketConnection.send(CommandID.ENTER_OR_LEAVE_WATCH_FIGHT,0);
         }
      }
      
      public function getFollowPackage() : void
      {
         if(this.curFightItemInfo)
         {
            this.getVideoPackage(this.curFightItemInfo.fightSvrId,this.curFightItemInfo.fightRoomId,this.curFightItemInfo.fightStartTime,this.videoPackageList.length - 1);
         }
      }
   }
}

