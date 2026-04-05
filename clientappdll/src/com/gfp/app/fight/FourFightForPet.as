package com.gfp.app.fight
{
   import com.gfp.app.miniMap.MiniMap;
   import com.gfp.app.time.CutDownTimePanel;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.app.toolBar.EgoisticDetailEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.MapXMLInfo;
   import com.gfp.core.controller.SocketSendController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.MoveEvent;
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
   import com.gfp.core.model.CustomUserModel;
   import com.gfp.core.model.MapModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.ui.tips.ArrowTip;
   import com.gfp.core.utils.PvpIDConstantUtil;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class FourFightForPet
   {
      
      private var _arrow:Sprite;
      
      private var _startFlag:Boolean;
      
      private var _pkUserInfo:UserInfo;
      
      private var door:CustomUserModel;
      
      private var arrow:ArrowTip;
      
      private var startMovie:MovieClip;
      
      public function FourFightForPet()
      {
         super();
      }
      
      protected function get roomMap() : int
      {
         return 1042;
      }
      
      protected function get outMap() : int
      {
         return 38;
      }
      
      protected function get cutDownMinute() : int
      {
         return 3;
      }
      
      protected function get pvpId() : int
      {
         return PvpIDConstantUtil.FIGHT_FOR_PET_PVP;
      }
      
      protected function get invitePvpId() : int
      {
         return FriendInviteInfo.FIGHT_FOR_PET;
      }
      
      public function setup() : void
      {
         this.addEvent();
         CityMap.instance.changeMap(this.roomMap);
      }
      
      protected function addEvent() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         SocketConnection.addCmdListener(CommandID.EGOISTIC_FIGHT_BEGIN,this.onFightBegin);
      }
      
      protected function removeEvent() : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         SocketConnection.removeCmdListener(CommandID.EGOISTIC_FIGHT_BEGIN,this.onFightBegin);
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onFightReason);
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onFightWinner);
         LayerManager.stage.removeEventListener(Event.ACTIVATE,this.onActivate);
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE_ENTER,this.onActorMove);
      }
      
      private function onFightBegin(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == 1)
         {
            this._startFlag = true;
            if(MapManager.currentMap.info.id == this.roomMap)
            {
               this.startMovie = new UI_FightStartMovie();
               this.startMovie.addEventListener(Event.ENTER_FRAME,this.onStartMovieEnterFrame);
               this.startMovie.x = 300;
               this.startMovie.y = 200;
               LayerManager.topLevel.addChild(this.startMovie);
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
            SocketConnection.removeCmdListener(CommandID.EGOISTIC_FIGHT_BEGIN,this.onFightBegin);
            this.gameWin();
         }
      }
      
      private function onStartMovieEnterFrame(param1:Event) : void
      {
         if(this.startMovie.currentFrame == this.startMovie.totalFrames)
         {
            this.startMovie.removeEventListener(Event.ENTER_FRAME,this.onStartMovieEnterFrame);
            DisplayUtil.removeForParent(this.startMovie);
            this.startMovie = null;
         }
      }
      
      protected function gameWin() : void
      {
         this.resetMouse();
         TextAlert.show("比赛结束！恭喜你获得本场冠军！进入传送门去收集仙兽吧。");
         this.door = new CustomUserModel(101);
         this.door.show(new Point(978,408));
         this.arrow = new ArrowTip();
         this.arrow.show(90,978,350,MapManager.currentMap.upLevel);
         MainManager.actorModel.addEventListener(MoveEvent.MOVE_ENTER,this.onActorMove);
      }
      
      protected function onActorMove(param1:MoveEvent) : void
      {
         if(Point.distance(MainManager.actorModel.pos,this.door.pos) <= 50)
         {
            this.destroy();
            PveEntry.enterTollgate(807);
         }
      }
      
      private function onFightReason(param1:FightEvent) : void
      {
         FightManager.quit();
      }
      
      private function onFightWinner(param1:FightEvent) : void
      {
         var timer:uint = 0;
         var event:FightEvent = param1;
         timer = setTimeout(function():void
         {
            FightManager.quit();
            clearTimeout(timer);
         },2000);
      }
      
      private function onActivate(param1:Event) : void
      {
         if(MapManager.currentMap.info.id == this.roomMap && Boolean(this._arrow))
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
                  CutDownTimePanel.initDetailTime(this.cutDownMinute * 60,0,true,true);
                  CutDownTimePanel.instance.setPos(110,0);
               }
               this.hideDetailEntry();
               MiniMap.destroy();
               this.resetMouse();
            }
         }
         else if(_loc2_.info.id == this.roomMap)
         {
            DynamicActivityEntry.instance.hide();
            this.showDetailEntry();
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
         else if(_loc2_.info.id == this.outMap)
         {
            DynamicActivityEntry.instance.show();
            this.hideDetailEntry();
            this.egoisticLimit(false);
         }
         else
         {
            this.destroy();
         }
      }
      
      protected function showDetailEntry() : void
      {
         EgoisticDetailEntry.instance.show();
      }
      
      protected function hideDetailEntry() : void
      {
         EgoisticDetailEntry.instance.hide();
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
         LayerManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         this._pkUserInfo = null;
         UserManager.addEventListener(UserEvent.CLICK,this.onUserClick);
      }
      
      protected function onMouseMove(param1:MouseEvent) : void
      {
         this._arrow.x = LayerManager.stage.mouseX;
         this._arrow.y = LayerManager.stage.mouseY;
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
            SocketSendController.sendPvpInviteCMD(false,this.pvpId,PvpTypeConstantUtil.PVP_TYPE_INVITE,0);
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
            SocketConnection.send(CommandID.TEAM_INVITE_FRIEND,this.invitePvpId,this._pkUserInfo.userID,_loc2_,0,0);
         }
      }
      
      protected function resetMouse() : void
      {
         UserManager.removeEventListener(UserEvent.CLICK,this.onUserClick);
         if(this._arrow)
         {
            DisplayUtil.removeForParent(this._arrow);
            LayerManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            this._arrow = null;
         }
         Mouse.show();
      }
      
      protected function egoisticLimit(param1:Boolean) : void
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
      }
      
      public function backHome() : void
      {
         FightManager.outToMapID = this.outMap;
         FightManager.outToMapPos = MapXMLInfo.getDefaultPos(this.outMap);
         this.destroy();
      }
      
      public function destroy() : void
      {
         this._startFlag = false;
         CutDownTimePanel.destroy();
         this.hideDetailEntry();
         DynamicActivityEntry.instance.show();
         this.egoisticLimit(false);
         this.removeEvent();
         this.resetMouse();
         if(this.door)
         {
            this.door.destroy();
         }
         if(this.arrow)
         {
            this.arrow.destory();
         }
         if(this.startMovie)
         {
            this.startMovie.removeEventListener(Event.ENTER_FRAME,this.onStartMovieEnterFrame);
         }
         this.door = null;
         this.arrow = null;
         this.startMovie = null;
      }
      
      public function get startFlag() : Boolean
      {
         return this._startFlag;
      }
   }
}

