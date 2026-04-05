package com.gfp.app.manager
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.FightWaitPanel;
   import com.gfp.app.fight.SinglePkManager;
   import com.gfp.app.miniMap.MiniMap;
   import com.gfp.app.time.CutDownTimePanel;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.app.toolBar.EgoisticDetailEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.MapXMLInfo;
   import com.gfp.core.controller.SocketSendController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.FriendInviteInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.language.CoreLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.MapModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.PvpIDConstantUtil;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.ui.Mouse;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class EgoisticManager
   {
      
      private static var _instance:EgoisticManager;
      
      public static const EGOISTIC_MAP:uint = 1040;
      
      public static const OUT_MAP:uint = 30;
      
      public static const CUT_DOWN_MINUTE:uint = 3;
      
      private var _arrow:Sprite;
      
      private var _startFlag:Boolean;
      
      private var _pkUserInfo:UserInfo;
      
      public function EgoisticManager()
      {
         super();
      }
      
      public static function get instance() : EgoisticManager
      {
         if(_instance == null)
         {
            _instance = new EgoisticManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         if(this._startFlag)
         {
            AlertManager.showSimpleAlarm("唯我独尊比武已开始，还请小侠士下次准时来战！");
            return;
         }
         this.addEvent();
         CityMap.instance.changeMap(EGOISTIC_MAP);
      }
      
      private function addEvent() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         SocketConnection.addCmdListener(CommandID.EGOISTIC_FIGHT_BEGIN,this.onFightBegin);
      }
      
      private function removeEvent() : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         SocketConnection.removeCmdListener(CommandID.EGOISTIC_FIGHT_BEGIN,this.onFightBegin);
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onFightReason);
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onFightWinner);
         LayerManager.stage.removeEventListener(Event.ACTIVATE,this.onActivate);
      }
      
      private function onFightBegin(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.EGOISTIC_FIGHT_BEGIN,this.onFightBegin);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == 1)
         {
            this._startFlag = true;
            if(MapManager.currentMap.info.id == EGOISTIC_MAP)
            {
               this.initMouse();
               this.egoisticLimit(true);
               FunctionManager.disabledPvp = false;
               FightManager.instance.addEventListener(FightEvent.REASON,this.onFightReason);
               FightManager.instance.addEventListener(FightEvent.WINNER,this.onFightWinner);
               LayerManager.stage.addEventListener(Event.ACTIVATE,this.onActivate);
            }
            else
            {
               this.destroy();
            }
         }
         else if(_loc3_ == 2)
         {
            TextAlert.show("比赛结束！恭喜你获得本场冠军！");
            this.destroy();
         }
      }
      
      private function onFightReason(param1:FightEvent) : void
      {
         var timer:uint = 0;
         var event:FightEvent = param1;
         timer = setTimeout(function():void
         {
            FightManager.quit();
            clearTimeout(timer);
         },1000);
      }
      
      private function onFightWinner(param1:FightEvent) : void
      {
         FightManager.quit();
      }
      
      private function onActivate(param1:Event) : void
      {
         if(MapManager.currentMap.info.id == EGOISTIC_MAP && Boolean(this._arrow))
         {
            this.initMouse();
         }
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         var _loc2_:MapModel = param1.mapModel;
         if(_loc2_.info.mapType != MapType.STAND)
         {
            if(this._startFlag)
            {
               if(!CutDownTimePanel.instance.isRuning)
               {
                  CutDownTimePanel.initDetailTime(CUT_DOWN_MINUTE * 60,0,true,true);
                  CutDownTimePanel.instance.setPos(110,0);
               }
               EgoisticDetailEntry.instance.hide();
               MiniMap.destroy();
               this.resetMouse();
            }
         }
         else if(_loc2_.info.id == EGOISTIC_MAP)
         {
            DynamicActivityEntry.instance.hide();
            EgoisticDetailEntry.instance.show();
            if(this._startFlag)
            {
               CutDownTimePanel.destroy();
               this.initMouse();
            }
            else
            {
               this.egoisticLimit(true);
            }
         }
         else if(this._startFlag)
         {
            this.destroy();
         }
         else if(_loc2_.info.id == OUT_MAP)
         {
            DynamicActivityEntry.instance.show();
            EgoisticDetailEntry.instance.hide();
            TextAlert.show("唯我独尊将于13:30正式开始，小侠士记得准时去白徽处参加！");
            TextAlert.show("唯我独尊将于13:30正式开始，小侠士记得准时去白徽处参加！");
            this.egoisticLimit(false);
         }
      }
      
      private function initMouse() : void
      {
         if(this._arrow == null)
         {
            this._arrow = new UI_MouseArrow();
            this._arrow.mouseChildren = false;
            this._arrow.mouseEnabled = false;
         }
         Mouse.hide();
         this._arrow.x = LayerManager.stage.mouseX;
         this._arrow.y = LayerManager.stage.mouseY;
         LayerManager.stage.addChild(this._arrow);
         this._arrow.startDrag();
         this._pkUserInfo = null;
         UserManager.addEventListener(UserEvent.CLICK,this.onUserClick);
      }
      
      private function onUserClick(param1:UserEvent) : void
      {
         var _loc2_:* = param1.data;
         if(_loc2_ is UserInfo)
         {
            if(MainManager.actorInfo.wulinID != 0)
            {
               AlertManager.showSimpleAlarm(CoreLanguageDefine.WULIN_MSG_ARR[1]);
               return;
            }
            if(MainManager.actorID == UserInfo(_loc2_).userID)
            {
               return;
            }
            this._pkUserInfo = _loc2_ as UserInfo;
            UserManager.addUserListener(UserEvent.PVP_CHANGE,this._pkUserInfo.userID,this.initPvPState);
            SocketSendController.sendPvpInviteCMD(false,PvpIDConstantUtil.EGOISTIC_PVP_ID,PvpTypeConstantUtil.PVP_TYPE_INVITE,0);
         }
      }
      
      private function initPvPState(param1:UserEvent) : void
      {
         if(this._pkUserInfo == null)
         {
            return;
         }
         UserManager.removeUserListener(UserEvent.PVP_CHANGE,this._pkUserInfo.userID,this.initPvPState);
         var _loc2_:uint = uint(int(param1.data));
         if(_loc2_ != 0)
         {
            SinglePkManager.instance.openInviteBattery();
            FightWaitPanel.showWaitPanel();
            SocketConnection.send(CommandID.TEAM_INVITE_FRIEND,FriendInviteInfo.EGOISTIC_PVP,this._pkUserInfo.userID,_loc2_,0,0);
         }
      }
      
      private function resetMouse() : void
      {
         UserManager.removeEventListener(UserEvent.CLICK,this.onUserClick);
         if(this._arrow)
         {
            DisplayUtil.removeForParent(this._arrow);
            this._arrow.stopDrag();
            this._arrow = null;
         }
         Mouse.show();
      }
      
      private function egoisticLimit(param1:Boolean) : void
      {
         FunctionManager.disabledDemonreCorded = param1;
         FunctionManager.disabledFightTeam = param1;
         FunctionManager.disabledMsg = param1;
         FunctionManager.disabledNewspaper = param1;
         FunctionManager.disabledTask = param1;
         FunctionManager.disabledStorehouse = param1;
         FunctionManager.disabledPvp = param1;
         FunctionManager.disabledTradeHouse = param1;
         FunctionManager.disabledMail = param1;
         FunctionManager.disabledGuaranteeTrade = param1;
         FunctionManager.disabledMap = param1;
      }
      
      public function backHome() : void
      {
         FightManager.outToMapID = OUT_MAP;
         FightManager.outToMapPos = MapXMLInfo.getDefaultPos(OUT_MAP);
         this.destroy();
      }
      
      public function get startFlag() : Boolean
      {
         return this._startFlag;
      }
      
      public function destroy() : void
      {
         this._startFlag = false;
         CutDownTimePanel.destroy();
         EgoisticDetailEntry.instance.hide();
         DynamicActivityEntry.instance.show();
         this.egoisticLimit(false);
         this.removeEvent();
         this.resetMouse();
      }
   }
}

