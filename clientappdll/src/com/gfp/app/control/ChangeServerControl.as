package com.gfp.app.control
{
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.ServerSessionControl;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.TMGameID;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import org.taomee.net.SocketEvent;
   
   public class ChangeServerControl extends EventDispatcher
   {
      
      private static var _instance:ChangeServerControl;
      
      public static const EVENT_CHANGE_LINE_SUCCESS:String = "event_change_line_success";
      
      public var session:String = "";
      
      public var isChangeLineIng:Boolean = false;
      
      private var _serverId:int;
      
      private var _serverIP:String;
      
      private var _serverPot:int;
      
      public function ChangeServerControl()
      {
         super();
      }
      
      public static function get instance() : ChangeServerControl
      {
         if(_instance == null)
         {
            _instance = new ChangeServerControl();
         }
         return _instance;
      }
      
      public function changeServer(param1:int, param2:String, param3:int) : void
      {
         if(!this.isChangeLineIng)
         {
            this._serverId = param1;
            this._serverIP = param2;
            this._serverPot = param3;
            this.isChangeLineIng = true;
            ServerSessionControl.addSessionTypeListener(ServerSessionControl.SESSION_TYPE_CHANGE_LINE,this.onSessionReady);
            ServerSessionControl.instance.sendSessionReq(ServerSessionControl.SESSION_TYPE_CHANGE_LINE,TMGameID.GF_GAMEID);
         }
      }
      
      private function onSessionReady(param1:DataEvent) : void
      {
         ServerSessionControl.removeSessionTypeListener(ServerSessionControl.SESSION_TYPE_CHANGE_LINE,this.onSessionReady);
         this.session = param1.data.toString();
         SocketConnection.addCmdListener(CommandID.CHANGE_ONLINE,this.onChangeOnline);
         SocketConnection.send(CommandID.CHANGE_ONLINE,this._serverId);
      }
      
      private function onChangeOnline(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.CHANGE_ONLINE,this.onChangeOnline);
         SocketConnection.mainSocket.close();
         SocketConnection.mainSocket.addEventListener(Event.CONNECT,this.onSeocketConnect);
         SocketConnection.mainSocket.connect(this._serverIP,this._serverPot);
      }
      
      private function onSeocketConnect(param1:Event) : void
      {
         var _loc2_:int = ClientConfig.isAdult ? 1 : 0;
         SocketConnection.addCmdListener(CommandID.LOGIN_CHANGE_ONLINE,this.onChangeLineLoginSuccess);
         SocketConnection.send(CommandID.LOGIN_CHANGE_ONLINE,this.session,MainManager.loginInfo.roleTime);
      }
      
      private function onChangeLineLoginSuccess(param1:SocketEvent) : void
      {
         this.isChangeLineIng = false;
         dispatchEvent(new Event(EVENT_CHANGE_LINE_SUCCESS));
      }
   }
}

