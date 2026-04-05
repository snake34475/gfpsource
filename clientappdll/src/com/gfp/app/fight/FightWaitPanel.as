package com.gfp.app.fight
{
   import com.gfp.app.config.xml.SystemTimeXMLInfo;
   import com.gfp.app.control.RedBlueMasterControl;
   import com.gfp.app.control.SystemTimeController;
   import com.gfp.app.manager.FightGroupManager;
   import com.gfp.app.manager.TeamAutoFightManager;
   import com.gfp.app.user.UserInfoController;
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.SocketSendController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.CustomEventMananger;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.FightWaitUI;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.FightMode;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import com.gfp.core.utils.TimeUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class FightWaitPanel
   {
      
      private static var _waitPanel:FightWaitUI;
      
      private static var _dragBtn:SimpleButton;
      
      private static var _selectPanel:MovieClip;
      
      private static var _userInfo:UserInfo;
      
      private static var seletctCloseBtn:SimpleButton;
      
      private static var singleBtn:SimpleButton;
      
      private static var multiBtn:SimpleButton;
      
      private static var closeRefreshMap:Boolean;
      
      private static var dragonTigerTimer:int;
      
      private static var _bawangTimer:int;
      
      private static var _pvpType:int;
      
      setup();
      
      public function FightWaitPanel()
      {
         super();
      }
      
      private static function setup() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,onMapSwitch);
         FightManager.instance.addEventListener(FightEvent.CLOSE_FIGHT_WAIT,onCloseWaitPanel);
      }
      
      public static function hideSelectPanel() : void
      {
         SocketConnection.removeCmdListener(CommandID.FIGHT_LAUNCH_INVITE,onLaunchInvite);
         SocketConnection.removeCmdListener(CommandID.FIGHT_ENTER,onEnterInvite);
         SocketConnection.removeCmdListener(CommandID.FIGHT_SELECT_USER_ENTER,onEnterInvite);
         if(_selectPanel)
         {
            seletctCloseBtn.removeEventListener(MouseEvent.CLICK,onCloseSelectPanel);
            singleBtn.removeEventListener(MouseEvent.CLICK,onSelectMode);
            multiBtn.removeEventListener(MouseEvent.CLICK,onSelectMode);
            DisplayUtil.removeForParent(_selectPanel);
         }
      }
      
      private static function onCloseSelectPanel(param1:MouseEvent) : void
      {
         hideSelectPanel();
      }
      
      private static function onSelectMode(param1:MouseEvent) : void
      {
         var _loc2_:SimpleButton = param1.currentTarget as SimpleButton;
         FightManager.enemyName = _userInfo.nick;
         FightManager.fightMode = FightMode.PVP;
         SocketConnection.addCmdListener(CommandID.FIGHT_LAUNCH_INVITE,onLaunchInvite);
         SocketConnection.send(CommandID.FIGHT_LAUNCH_INVITE,_userInfo.userID);
      }
      
      private static function onLaunchInvite(param1:SocketEvent) : void
      {
         hideSelectPanel();
         showWaitPanel();
      }
      
      public static function showWaitFight(param1:UserInfo) : void
      {
         _userInfo = param1;
         FightManager.enemyName = _userInfo.nick;
         FightManager.fightMode = FightMode.PVP;
         SocketConnection.addCmdListener(CommandID.FIGHT_LAUNCH_INVITE,onLaunchInvite);
         SocketConnection.send(CommandID.FIGHT_LAUNCH_INVITE,_userInfo.userID);
      }
      
      public static function showWaitPanel(param1:Boolean = false, param2:uint = 0) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Date = null;
         MainManager.actorModel.actionManager.clear();
         MainManager.closeOperate();
         MainManager.actorModel.execStandAction();
         closeRefreshMap = param1;
         if(_waitPanel == null)
         {
            _waitPanel = new FightWaitUI(param2,0);
         }
         LayerManager.root.addChild(_waitPanel);
         MainManager.closeOperate();
         _waitPanel.addEventListener(CustomEventMananger.FIGHT_WAIT_CLOSE,onCloseWaitPanel);
         if((param2 == PvpTypeConstantUtil.DRAGON_TIGER_PVP || param2 == PvpTypeConstantUtil.FIRST_STUDENT || param2 == PvpTypeConstantUtil.PVP_RANDOM_FIGHT || param2 == PvpTypeConstantUtil.PVP_WU_LING_FENG_YUN_FIGHT) && dragonTigerTimer == 0)
         {
            _pvpType = param2;
            dragonTigerTimer = setTimeout(onDragonTimeOut,15 * 1000);
         }
         if(param2 == PvpTypeConstantUtil.PVP_BA_WANG_QUARTER || param2 == PvpTypeConstantUtil.PVP_BA_WANG_SEMI || param2 == PvpTypeConstantUtil.PVP_BA_WANG_FINAL)
         {
            _pvpType = param2;
            if(SystemTimeController.instance.checkSysTimeAchieve(199))
            {
               _loc4_ = SystemTimeXMLInfo.getSystemTimeInfoById(199).endTime;
               _loc5_ = new Date(_loc4_[0][0],_loc4_[0][1] - 1,_loc4_[0][2],_loc4_[0][3],_loc4_[0][4],_loc4_[0][5]);
               _loc3_ = _loc5_.time - TimeUtil.getSeverDateObject().time;
            }
            if(SystemTimeController.instance.checkSysTimeAchieve(201))
            {
               _loc4_ = SystemTimeXMLInfo.getSystemTimeInfoById(201).endTime;
               _loc5_ = new Date(_loc4_[0][0],_loc4_[0][1] - 1,_loc4_[0][2],_loc4_[0][3],_loc4_[0][4],_loc4_[0][5]);
               _loc3_ = _loc5_.time - TimeUtil.getSeverDateObject().time;
            }
            if(SystemTimeController.instance.checkSysTimeAchieve(203))
            {
               _loc4_ = SystemTimeXMLInfo.getSystemTimeInfoById(203).endTime;
               _loc5_ = new Date(_loc4_[0][0],_loc4_[0][1] - 1,_loc4_[0][2],_loc4_[0][3],_loc4_[0][4],_loc4_[0][5]);
               _loc3_ = _loc5_.time - TimeUtil.getSeverDateObject().time;
            }
            if(_loc3_)
            {
               _bawangTimer = setTimeout(onBawangTimeOut,_loc3_);
               _waitPanel.leftTime = _loc3_;
            }
         }
      }
      
      public static function isFightWaitPanelShow() : Boolean
      {
         if(Boolean(_waitPanel) && Boolean(_waitPanel.stage))
         {
            return true;
         }
         return false;
      }
      
      private static function onDragonTimeOut() : void
      {
         clearTimeout(dragonTigerTimer);
         dragonTigerTimer = 0;
         SocketConnection.addCmdListener(CommandID.FIGHT_CANCEL,onFightCancel);
         SocketConnection.send(CommandID.FIGHT_CANCEL);
      }
      
      private static function onBawangTimeOut() : void
      {
         AlertManager.showSimpleAlarm("由于你的对手并未准时出现，恭喜你获胜。");
         clearTimeout(_bawangTimer);
         _bawangTimer = 0;
         onCloseWaitPanel();
      }
      
      private static function onFightCancel(param1:Event) : void
      {
         SocketConnection.removeCmdListener(CommandID.FIGHT_CANCEL,onFightCancel);
         SocketSendController.sendPvpInviteCMD(false,_pvpType,0,0);
         if(dragonTigerTimer == 0)
         {
            dragonTigerTimer = setTimeout(onDragonTimeOut,15 * 1000);
         }
      }
      
      public static function hideWaitPanel() : void
      {
         MainManager.openOperate();
         if(_waitPanel)
         {
            _waitPanel.destory();
            _waitPanel.removeEventListener(CustomEventMananger.FIGHT_WAIT_CLOSE,onCloseWaitPanel);
            DisplayUtil.removeForParent(_waitPanel,false);
            _waitPanel = null;
            MainManager.openOperate();
         }
         if(dragonTigerTimer != 0)
         {
            clearTimeout(dragonTigerTimer);
            dragonTigerTimer = 0;
         }
         if(_bawangTimer != 0)
         {
            clearTimeout(_bawangTimer);
            _bawangTimer = 0;
         }
      }
      
      public static function onCloseWaitPanel(param1:Event = null) : void
      {
         SocketConnection.removeCmdListener(CommandID.FIGHT_CANCEL,onFightCancel);
         SocketConnection.send(CommandID.FIGHT_CANCEL);
         TeamAutoFightManager.instance.pvpAutoType = 0;
         hideWaitPanel();
         FightGroupManager.instance.groupFightOver();
         PvpEntry.againEntry = false;
         if(SinglePkManager.instance.roomID != 0)
         {
            SinglePkManager.instance.fightType = 0;
            SinglePkManager.instance.roomID = 0;
            UserInfoController.hasBeenInvitePK(false);
            SinglePkManager.instance.isApplyPvP = false;
         }
         MapManager.clearMapEndAction();
         if(closeRefreshMap)
         {
            SocketConnection.send(CommandID.MAP_PLAYERLIST);
         }
      }
      
      private static function onMapSwitch(param1:MapEvent) : void
      {
         hideSelectPanel();
         hideWaitPanel();
      }
      
      public static function enterWaitPanel(param1:uint, param2:int = 0, param3:int = 0, param4:Array = null) : void
      {
         var _loc6_:ByteArray = null;
         var _loc7_:int = 0;
         _userInfo = new UserInfo();
         FightManager.enemyName = _userInfo.nick;
         FightManager.fightMode = FightMode.PVP;
         FightManager.pvpLevel = param1;
         FightManager.targetId = param2;
         FightManager.targetCreateTime = param3;
         SocketConnection.addCmdListener(CommandID.FIGHT_SELECT_USER_ENTER,onEnterInvite);
         SocketConnection.addCmdListener(CommandID.FIGHT_ENTER,onEnterInvite);
         SocketConnection.addCmdListener(CommandID.FIGHT_END,onFightWaitTimeOut);
         var _loc5_:Boolean = false;
         if(PvpEntry.againEntry)
         {
            _loc5_ = true;
         }
         if(FightEntry.rebotFightTypes.indexOf(param1) != -1)
         {
            _loc6_ = new ByteArray();
            _loc6_.writeUnsignedInt(param1);
            _loc6_.writeUnsignedInt(param2);
            _loc6_.writeUnsignedInt(param3);
            if(param4)
            {
               _loc7_ = 0;
               while(_loc7_ < param4.length)
               {
                  _loc6_.writeUnsignedInt(param4[_loc7_]);
                  _loc7_++;
               }
            }
            else
            {
               _loc6_.writeUnsignedInt(1);
            }
            SocketConnection.send(CommandID.FIGHT_SELECT_USER_ENTER,_loc6_);
         }
         else if(param4)
         {
            SocketSendController.sendPvpInviteCMD(_loc5_,param1,SinglePkManager.instance.fightType,SinglePkManager.instance.roomID,param4);
         }
         else
         {
            SocketSendController.sendPvpInviteCMD(_loc5_,param1,SinglePkManager.instance.fightType,SinglePkManager.instance.roomID);
         }
      }
      
      private static function onEnterInvite(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         if(checkShowWaitPanel())
         {
            hideSelectPanel();
            if(FightManager.pvpLevel != PvpTypeConstantUtil.BOX_HUNT_PVP)
            {
               showWaitPanel(false,FightManager.pvpLevel);
            }
         }
         else
         {
            TextAlert.show("小侠士，你已加入等待队列...");
         }
      }
      
      private static function checkShowWaitPanel() : Boolean
      {
         if(RedBlueMasterControl.instance.isOnFlag)
         {
            return false;
         }
         return true;
      }
      
      private static function onFightWaitTimeOut(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         if(FightManager.fightMode == FightMode.PVP && _loc4_ == 7)
         {
            SocketConnection.send(CommandID.FIGHT_CANCEL);
            hideWaitPanel();
            PvpEntry.againEntry = false;
         }
      }
   }
}

