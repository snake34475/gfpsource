package com.gfp.app.manager
{
   import com.gfp.app.control.SystemTimeController;
   import com.gfp.app.fight.FightWaitPanel;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.fight.SinglePkManager;
   import com.gfp.app.info.dialog.DialogInfoSimple;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.app.toolBar.VipFightRankEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.SocketSendController;
   import com.gfp.core.events.InviteEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.TimeEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.FriendInviteInfo;
   import com.gfp.core.info.FriendInviteReplyInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.language.CoreLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MessageManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.CustomSightModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.FightBloodBar;
   import com.gfp.core.utils.LineType;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import com.gfp.core.utils.TimerManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class VipFightManager
   {
      
      private static var _instance:VipFightManager;
      
      private const BOSS_ID:uint = 13681;
      
      private const APPLY_ID:uint = 100562;
      
      private var _totalBlood:uint = 10;
      
      private var _arrow:MovieClip;
      
      private var _pkUserInfo:UserInfo;
      
      private var _bloodBar:FightBloodBar;
      
      private var _bloodCurrent:uint;
      
      private var _bossNpc:CustomSightModel;
      
      public function VipFightManager()
      {
         super();
      }
      
      public static function get instance() : VipFightManager
      {
         if(_instance == null)
         {
            _instance = new VipFightManager();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
         }
         _instance = null;
      }
      
      public function setUp() : void
      {
         this.initMouse();
         this.addEvent();
         this.egoisticLimit(true);
         DynamicActivityEntry.instance.hide();
         VipFightRankEntry.instance.show();
         switch(MainManager.loginInfo.lineType)
         {
            case LineType.LINE_TYPE_CT:
               this._totalBlood = 20000;
               break;
            case LineType.LINE_TYPE_CT2:
               this._totalBlood = 2000;
               break;
            case LineType.LINE_TYPE_CNC:
               this._totalBlood = 10000;
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
         LayerManager.topLevel.addChildAt(this._arrow,LayerManager.topLevel.numChildren - 1);
         this._arrow.startDrag();
         this._pkUserInfo = null;
      }
      
      private function resetMouse() : void
      {
         if(this._arrow)
         {
            DisplayUtil.removeForParent(this._arrow);
            this._arrow.stopDrag();
            this._arrow = null;
         }
         Mouse.show();
      }
      
      private function addEvent() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         TimerManager.ed.addEventListener(TimeEvent.TIMER_EVERY_MINUTE,this.onEveryMinute);
         LayerManager.stage.addEventListener(Event.ACTIVATE,this.onActivate);
         UserManager.addEventListener(UserEvent.CLICK,this.onUserClick);
         MessageManager.addEventListener(InviteEvent.AUTO_PK_INVITE,this.onPkInvited);
         SocketConnection.addCmdListener(CommandID.APPLY_COUNT,this.onBossBlood);
         SocketConnection.addCmdListener(CommandID.GET_WEDDING_LIFE,this.onReBossBlood);
         LayerManager.stage.addEventListener(MouseEvent.CLICK,this.onStageClick);
      }
      
      private function removeEvent() : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         TimerManager.ed.removeEventListener(TimeEvent.TIMER_EVERY_MINUTE,this.onEveryMinute);
         LayerManager.stage.removeEventListener(Event.ACTIVATE,this.onActivate);
         UserManager.removeEventListener(UserEvent.CLICK,this.onUserClick);
         MessageManager.removeEventListener(InviteEvent.AUTO_PK_INVITE,this.onPkInvited);
         SocketConnection.removeCmdListener(CommandID.APPLY_COUNT,this.onBossBlood);
         SocketConnection.removeCmdListener(CommandID.GET_WEDDING_LIFE,this.onReBossBlood);
         LayerManager.stage.removeEventListener(MouseEvent.CLICK,this.onStageClick);
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         this.checkTime();
      }
      
      private function checkTime() : void
      {
         if(!SystemTimeController.instance.checkSysTimeAchieve(144))
         {
            CityMap.instance.changeMap(7);
            return;
         }
         if(SystemTimeController.instance.checkSysTimeAchieve(145))
         {
            SocketConnection.send(CommandID.APPLY_COUNT,this.APPLY_ID);
         }
      }
      
      private function onEveryMinute(param1:TimeEvent) : void
      {
         this.checkTime();
      }
      
      private function onActivate(param1:Event) : void
      {
         this.initMouse();
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
            SocketSendController.sendPvpInviteCMD(false,PvpTypeConstantUtil.VIP_FIGHT_PVP,PvpTypeConstantUtil.PVP_TYPE_INVITE,0);
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
            SocketConnection.send(CommandID.TEAM_INVITE_FRIEND,FriendInviteInfo.VIP_FIGHT_PVP,this._pkUserInfo.userID,_loc2_,0,0);
         }
      }
      
      private function onPkInvited(param1:InviteEvent) : void
      {
         var _loc2_:FriendInviteInfo = FriendInviteInfo(param1.data);
         if(_loc2_ == null || _loc2_.type != FriendInviteInfo.VIP_FIGHT_PVP)
         {
            return;
         }
         SocketSendController.sendPvpInviteCMD(false,PvpTypeConstantUtil.VIP_FIGHT_PVP,PvpTypeConstantUtil.PVP_TYPE_REPLY,_loc2_.roomId);
         SocketConnection.send(CommandID.TEAM_REPLY_INVITE,2,_loc2_.inviterId,FriendInviteReplyInfo.ACCEPT);
         MainManager.actorModel.execStandAction();
      }
      
      private function onBossBlood(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = _loc2_.readInt();
         if(_loc3_ == this.APPLY_ID)
         {
            this.bloodCurrent = _loc2_.readInt();
         }
      }
      
      private function onReBossBlood(param1:SocketEvent) : void
      {
         var _loc6_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc2_.readUnsignedInt();
            if(_loc6_ == this.APPLY_ID)
            {
               this.bloodCurrent = _loc2_.readUnsignedInt();
               return;
            }
            _loc5_++;
         }
      }
      
      private function set bloodCurrent(param1:uint) : void
      {
         this._bloodCurrent = param1;
         if(this._bloodCurrent == 0)
         {
            if(this._bossNpc)
            {
               this._bossNpc.destroy();
               this._bossNpc = null;
            }
            return;
         }
         this.updateNpc();
      }
      
      private function updateNpc() : void
      {
         if(this._bloodBar == null)
         {
            this.creatBloodBar();
         }
         this._bloodBar.bloodCurrent = this._bloodCurrent;
         if(this._bossNpc == null)
         {
            this._bossNpc = new CustomSightModel(this.enterPve);
            this._bossNpc.roleType = this.BOSS_ID;
            this._bossNpc.pos = new Point(1469,742);
            this._bossNpc.show();
            this._bossNpc.addBloodBar(this._bloodBar);
         }
      }
      
      private function enterPve() : void
      {
         var dialog:DialogInfoSimple = new DialogInfoSimple(["我就是天上地下唯我独尊的魔神蚩尤，你敢挑战我吗？"],"看我的厉害！");
         NpcDialogController.showForSimple(dialog,10434,function():void
         {
            PveEntry.enterTollgate(562);
         });
      }
      
      private function creatBloodBar() : void
      {
         this._bloodBar = new FightBloodBar(1);
         this._bloodBar.init(this._totalBlood);
      }
      
      private function onStageClick(param1:MouseEvent) : void
      {
         LayerManager.topLevel.setChildIndex(this._arrow,LayerManager.topLevel.numChildren - 1);
      }
      
      private function egoisticLimit(param1:Boolean) : void
      {
         FunctionManager.disabledDemonreCorded = param1;
         FunctionManager.disabledFightTeam = param1;
         FunctionManager.disabledMsg = param1;
         FunctionManager.disabledNewspaper = param1;
         FunctionManager.disabledTask = param1;
         FunctionManager.disabledStorehouse = param1;
         FunctionManager.disabledTradeHouse = param1;
         FunctionManager.disabledMail = param1;
         FunctionManager.disabledGuaranteeTrade = param1;
      }
      
      public function destroy() : void
      {
         DynamicActivityEntry.instance.show();
         this.egoisticLimit(false);
         this.removeEvent();
         this.resetMouse();
         if(this._bloodBar)
         {
            this._bloodBar.destroy();
            this._bloodBar = null;
         }
         VipFightRankEntry.destroy();
         this._arrow = null;
      }
   }
}

