package com.gfp.app.cmdl
{
   import com.gfp.app.cityWar.CityWarPkController;
   import com.gfp.app.control.GloryFightControl;
   import com.gfp.app.control.InformBroadCastControl;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.FightWaitPanel;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.fight.SinglePkManager;
   import com.gfp.app.manager.CityWarManager;
   import com.gfp.app.manager.EliminationFightManager;
   import com.gfp.app.manager.EscortManager;
   import com.gfp.app.manager.GuaranteeTradeManager;
   import com.gfp.app.manager.TeamAutoFightManager;
   import com.gfp.app.manager.TeamFightManager;
   import com.gfp.app.user.UserInfoController;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.SocketSendController;
   import com.gfp.core.events.CommEvent;
   import com.gfp.core.events.InviteEvent;
   import com.gfp.core.info.FriendInviteInfo;
   import com.gfp.core.info.FriendInviteReplyInfo;
   import com.gfp.core.info.InformInfo;
   import com.gfp.core.info.master.MasterInfo;
   import com.gfp.core.language.ModuleLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MasterManager;
   import com.gfp.core.manager.MessageManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.FightMode;
   import com.gfp.core.utils.PvpIDConstantUtil;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import com.gfp.core.utils.RoleDisplayUtil;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class InformCmdListener
   {
      
      public function InformCmdListener()
      {
         super();
      }
      
      private static function onInform(param1:SocketEvent) : void
      {
         if(GloryFightControl.instance.isGloryFightMap())
         {
            return;
         }
         var _loc2_:InformInfo = param1.data as InformInfo;
         MessageManager.addInformInfo(_loc2_);
      }
      
      private static function onFriendInviteInform(param1:SocketEvent) : void
      {
         if(MainManager.actorModel.isZhengGued)
         {
            return;
         }
         var _loc2_:FriendInviteInfo = param1.data as FriendInviteInfo;
         if(!MapManager.currentMap.info.isAcceptLaba)
         {
            return;
         }
         if(MapManager.currentMap != null)
         {
            if(GloryFightControl.instance.isGloryFightMap() && _loc2_.type != FriendInviteInfo.GLORY_PVP)
            {
               return;
            }
         }
         if(_loc2_.type == FriendInviteInfo.GUARANTEE_TRADE)
         {
            if(MainManager.actorInfo.lv < 40)
            {
               SocketConnection.send(CommandID.GUARANTEE_TRADE_APPLY_RESPONSE,FriendInviteInfo.GUARANTEE_TRADE,_loc2_.inviterId,_loc2_.roomId,0);
               return;
            }
            if(!MapManager.curMapIsFightMap())
            {
               MessageManager.addFriendInviteInform(_loc2_);
               return;
            }
         }
         if(_loc2_.type == FriendInviteInfo.GLORY_PVP)
         {
            SocketSendController.sendPvpInviteCMD(false,PvpIDConstantUtil.TEAM_GLORY_PVP_ID,PvpTypeConstantUtil.PVP_TYPE_REPLY,_loc2_.roomId);
            SocketConnection.send(CommandID.TEAM_REPLY_INVITE,2,_loc2_.inviterId,FriendInviteReplyInfo.ACCEPT);
            return;
         }
         if(_loc2_.type == FriendInviteInfo.CITY_WAR_PVP)
         {
            SocketSendController.sendPvpInviteCMD(false,PvpIDConstantUtil.CITY_WAR_PVP_ID,PvpTypeConstantUtil.PVP_TYPE_REPLY,_loc2_.roomId);
            SocketConnection.send(CommandID.TEAM_REPLY_INVITE,2,_loc2_.inviterId,FriendInviteReplyInfo.ACCEPT);
            MainManager.actorModel.execStandAction();
            return;
         }
         if(_loc2_.type == FriendInviteInfo.EGOISTIC_PVP)
         {
            SocketSendController.sendPvpInviteCMD(false,PvpIDConstantUtil.EGOISTIC_PVP_ID,PvpTypeConstantUtil.PVP_TYPE_REPLY,_loc2_.roomId);
            SocketConnection.send(CommandID.TEAM_REPLY_INVITE,2,_loc2_.inviterId,FriendInviteReplyInfo.ACCEPT);
            MainManager.actorModel.execStandAction();
            return;
         }
         if(_loc2_.type == FriendInviteInfo.FIGHT_FOR_PET)
         {
            SocketSendController.sendPvpInviteCMD(false,PvpIDConstantUtil.FIGHT_FOR_PET_PVP,PvpTypeConstantUtil.PVP_TYPE_REPLY,_loc2_.roomId);
            SocketConnection.send(CommandID.TEAM_REPLY_INVITE,2,_loc2_.inviterId,FriendInviteReplyInfo.ACCEPT);
            MainManager.actorModel.execStandAction();
            return;
         }
         if(_loc2_.type == PvpTypeConstantUtil.PVP_SIDE_YABIAO)
         {
            if(MainManager.isCloseOprate)
            {
               return;
            }
            SocketSendController.sendPvpInviteCMD(false,PvpTypeConstantUtil.PVP_SIDE_YABIAO,PvpTypeConstantUtil.PVP_TYPE_REPLY,_loc2_.roomId);
            SocketConnection.send(CommandID.TEAM_REPLY_INVITE,2,_loc2_.inviterId,FriendInviteReplyInfo.ACCEPT);
            MainManager.actorModel.execStandAction();
            return;
         }
         if(_loc2_.type == PvpTypeConstantUtil.PVP_JIE_BIAO)
         {
            if(MainManager.isCloseOprate)
            {
               return;
            }
            EscortManager.instance.hasFighted = true;
            EscortManager.instance.isAttacked = true;
            TextAlert.show("小侠士您在押镖途中被其他玩家突然袭击。");
            SocketSendController.sendPvpInviteCMD(false,PvpTypeConstantUtil.PVP_JIE_BIAO,PvpTypeConstantUtil.PVP_TYPE_REPLY,_loc2_.roomId);
            SocketConnection.send(CommandID.TEAM_REPLY_INVITE,2,_loc2_.inviterId,FriendInviteReplyInfo.ACCEPT);
            MainManager.actorModel.execStandAction();
            return;
         }
         if(_loc2_.type == PvpTypeConstantUtil.PVP_WAN_SHEN_DIAN)
         {
            if(MainManager.isCloseOprate)
            {
               return;
            }
            TextAlert.show("小侠士您在万神殿非安全区被其他玩家突然袭击。");
            SocketSendController.sendPvpInviteCMD(false,_loc2_.type,PvpTypeConstantUtil.PVP_TYPE_REPLY,_loc2_.roomId);
            SocketConnection.send(CommandID.TEAM_REPLY_INVITE,2,_loc2_.inviterId,FriendInviteReplyInfo.ACCEPT);
            MainManager.actorModel.execStandAction();
            return;
         }
         if(_loc2_.type == PvpTypeConstantUtil.PVP_KILL_POINT)
         {
            if(MainManager.isCloseOprate)
            {
               return;
            }
            TextAlert.show("小侠士，由于您杀气值过高，被其他玩家强制PK。");
            SocketSendController.sendPvpInviteCMD(false,PvpTypeConstantUtil.PVP_KILL_POINT,PvpTypeConstantUtil.PVP_TYPE_REPLY,_loc2_.roomId);
            SocketConnection.send(CommandID.TEAM_REPLY_INVITE,2,_loc2_.inviterId,FriendInviteReplyInfo.ACCEPT);
            MainManager.actorModel.execStandAction();
            return;
         }
         if(_loc2_.type == EliminationFightManager.instance.firendInviteID)
         {
            SocketSendController.sendPvpInviteCMD(false,EliminationFightManager.instance.quickPvpID,PvpTypeConstantUtil.PVP_TYPE_REPLY,_loc2_.roomId);
            SocketConnection.send(CommandID.TEAM_REPLY_INVITE,2,_loc2_.inviterId,FriendInviteReplyInfo.ACCEPT);
            MainManager.actorModel.execStandAction();
            return;
         }
         if(MessageManager.isAutoReply(_loc2_.type))
         {
            MessageManager.dispatchEvent(new InviteEvent(InviteEvent.AUTO_PK_INVITE,_loc2_));
            return;
         }
         if(MainManager.actorInfo.wulinID != 0)
         {
            replayInWulin(_loc2_);
            return;
         }
         if(EscortManager.instance.escortPathId != 0)
         {
            replayInEscort(_loc2_);
            return;
         }
         if(MapManager.currentMap.info.mapType == MapType.STAND)
         {
            if(MapManager.currentMap.info.id == 31 && !RoleDisplayUtil.isRoleGraduate())
            {
               replayInRookie(_loc2_);
            }
            else if(SinglePkManager.instance.roomID == 0)
            {
               if(_loc2_.type == FriendInviteInfo.GROUP_QUICK_PVE)
               {
                  ModuleManager.closeAllModule();
                  SocketConnection.send(CommandID.TEAM_JOIN_ROOM,_loc2_.roomId,_loc2_.inviterId,_loc2_.stageId,_loc2_.difficulty);
               }
               else
               {
                  MessageManager.addFriendInviteInform(_loc2_);
               }
            }
            else
            {
               replyInFight(_loc2_);
            }
         }
         else if(MapManager.currentMap.info.mapType == MapType.TRADE)
         {
            replayInTrade(_loc2_);
         }
         else
         {
            replyInFight(_loc2_);
         }
      }
      
      private static function replyAccept(param1:FriendInviteInfo) : void
      {
         SocketConnection.send(CommandID.TEAM_REPLY_INVITE,1,param1.inviterId,FriendInviteReplyInfo.ACCEPT);
      }
      
      private static function replyInFight(param1:FriendInviteInfo) : void
      {
         SocketConnection.send(CommandID.TEAM_REPLY_INVITE,1,param1.inviterId,FriendInviteReplyInfo.IN_FIGHT);
      }
      
      private static function replayInTrade(param1:FriendInviteInfo) : void
      {
         SocketConnection.send(CommandID.TEAM_REPLY_INVITE,1,param1.inviterId,FriendInviteReplyInfo.IN_TRADE);
      }
      
      private static function replayInRookie(param1:FriendInviteInfo) : void
      {
         SocketConnection.send(CommandID.TEAM_REPLY_INVITE,1,param1.inviterId,FriendInviteReplyInfo.IN_ROOKIE);
      }
      
      private static function replayInWulin(param1:FriendInviteInfo) : void
      {
         SocketConnection.send(CommandID.TEAM_REPLY_INVITE,1,param1.inviterId,FriendInviteReplyInfo.REFUSE);
      }
      
      private static function replayInEscort(param1:FriendInviteInfo) : void
      {
         SocketConnection.send(CommandID.TEAM_REPLY_INVITE,1,param1.inviterId,FriendInviteReplyInfo.ESCORT_RESPONSE);
      }
      
      private static function replayInEscortFighted(param1:FriendInviteInfo) : void
      {
         SocketConnection.send(CommandID.TEAM_REPLY_INVITE,1,param1.inviterId,FriendInviteReplyInfo.ESCORT_FIGHTED);
      }
      
      private static function onFriendInviteCancel(param1:SocketEvent) : void
      {
         var e:SocketEvent = param1;
         var failInvite:Function = function():void
         {
            if(SinglePkManager.instance.roomID != 0)
            {
               SinglePkManager.instance.clear();
               FightWaitPanel.hideWaitPanel();
               SocketConnection.send(CommandID.FIGHT_CANCEL);
            }
            TeamAutoFightManager.instance.roomID = 0;
         };
         var replyInfo:FriendInviteReplyInfo = e.data as FriendInviteReplyInfo;
         switch(replyInfo.replyResult)
         {
            case FriendInviteReplyInfo.ACCEPT:
               if(replyInfo.type == FriendInviteReplyInfo.GUARANTEE_TRADE_RESPONSE)
               {
                  GuaranteeTradeManager.instance.init(replyInfo.replierId,replyInfo.roomId,replyInfo.stageId);
               }
               break;
            case FriendInviteReplyInfo.REFUSE:
               if(replyInfo.type == FriendInviteReplyInfo.GUARANTEE_TRADE_RESPONSE)
               {
                  GuaranteeTradeManager.instance.ed.dispatchEvent(new CommEvent(GuaranteeTradeManager.GUARATEE_TRADE_CANCEL_WAIT));
                  AlertManager.showSimpleAlarm(ModuleLanguageDefine.GUARANTEE_TRADE_MSG[2]);
               }
               failInvite();
               if(replyInfo.type == 2)
               {
                  TextAlert.show("对方拒绝了你的切磋邀请。");
               }
               break;
            case FriendInviteReplyInfo.IN_FIGHT:
               failInvite();
               TextAlert.show("对不起，你的好友正处于战斗状态中，再找别的好友吧。");
               ModuleManager.destroy(ClientConfig.getAppModule("UserInfoPanel"));
               break;
            case FriendInviteReplyInfo.IN_TRADE:
               failInvite();
               TextAlert.show("对不起，你的好友正处于交易状态中，再找别的好友切磋吧。");
               break;
            case FriendInviteReplyInfo.IN_ROOKIE:
               failInvite();
               TextAlert.show("对不起，你的好友还太弱小了，再找别的好友切磋吧。");
               break;
            case FriendInviteReplyInfo.REPLAY_SUCCESS:
               if(replyInfo.type == 2)
               {
                  TextAlert.show("你已邀请" + replyInfo.replierName + "进行切磋，对方如未响应，该邀请三分钟后将取消");
               }
               break;
            case FriendInviteReplyInfo.REFUSE_ALL_PVP:
               failInvite();
               TextAlert.show("小侠士，" + TextFormatUtil.getRedText(replyInfo.replierName) + ",设置了拒绝非好友的请求，先加为好友再试试吧");
               break;
            case FriendInviteReplyInfo.ESCORT_RESPONSE:
               failInvite();
               TextAlert.show("小侠士，" + TextFormatUtil.getRedText(replyInfo.replierName) + "正在押镖，请勿打扰。");
               break;
            case FriendInviteReplyInfo.ESCORT_FIGHTED:
               failInvite();
               TextAlert.show("小侠士，" + TextFormatUtil.getRedText(replyInfo.replierName) + "已经被别人挑战了，请另寻目标吧。");
               break;
            case FriendInviteReplyInfo.SD:
               failInvite();
               TextAlert.show("小侠士，" + TextFormatUtil.getRedText(replyInfo.replierName) + "正在扫荡，请勿打扰。");
         }
      }
      
      private static function onJoinRoom(param1:SocketEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param1.data == null)
         {
            return;
         }
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         if(_loc3_ == 0)
         {
            return;
         }
         _loc4_ = int(_loc2_.readUnsignedInt());
         _loc5_ = int(_loc2_.readUnsignedInt());
         _loc6_ = int(_loc2_.readUnsignedInt());
         if(_loc4_ != 1017 || _loc6_ == 2)
         {
            MainManager.leaderID = _loc2_.readUnsignedInt();
            FightManager.isTeamFight = true;
            PveEntry.enterTollgateTeam(_loc4_,_loc5_);
            SocketConnection.send(CommandID.TEAM_READY);
         }
         else if(_loc4_ == 1017)
         {
            FightManager.isTeamFight = true;
            _loc2_.position = 0;
            SocketConnection.send(CommandID.TEAM_READY);
            TeamFightManager.getInstance().join(_loc2_);
            ModuleManager.turnAppModule("TeamFightThreePanel","正在加载...","invite");
         }
      }
      
      private static function onInitPvRoom(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = uint(_loc2_.readByte());
         var _loc4_:uint = _loc2_.readUnsignedInt();
         SinglePkManager.instance.fightType = _loc3_;
         SinglePkManager.instance.roomID = _loc4_;
         FightManager.fightMode = FightMode.PVP;
         if(_loc3_ == 1)
         {
            if(GloryFightControl.instance.isMatched)
            {
               UserInfoController.initGloryFightTeamPvp(_loc4_,GloryFightControl.instance.enemyUserID);
               GloryFightControl.instance.isMatched = false;
            }
            else if(CityWarManager.isInCityWar())
            {
               UserInfoController.initCityWarPvp(_loc4_,CityWarPkController.instance.enemyUserID);
            }
            else
            {
               UserInfoController.initPvPState(_loc4_);
            }
         }
         else if(_loc3_ == 2)
         {
            SinglePkManager.instance.initPvPState();
         }
         else if(_loc3_ == 3)
         {
            if(GloryFightControl.instance.isMatched)
            {
               UserInfoController.initGloryFightTeamPvp(_loc4_,GloryFightControl.instance.enemyUserID);
               GloryFightControl.instance.isMatched = false;
            }
            else
            {
               UserInfoController.initPvPState(_loc4_);
            }
         }
      }
      
      private static function onRecReleationRequestHandler(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         if(!MapManager.isFightMap)
         {
            MessageManager.addMasterRelationRequest({
               "inviteUId":_loc2_.readUnsignedInt(),
               "inviteRoleId":_loc2_.readUnsignedInt(),
               "inviteNickName":_loc2_.readUTFBytes(16)
            });
         }
      }
      
      private static function onRecReleationResponseHandler(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:String = _loc2_.readUTFBytes(16);
         var _loc6_:int = int(_loc2_.readUnsignedInt());
         if(_loc6_ == 1)
         {
            MasterManager.instance.dispatchAddApprenticeSuccess();
         }
         MessageManager.addMasterRelationResponse({
            "invitedUId":_loc3_,
            "invitedRoleId":_loc4_,
            "invitedNick":_loc5_,
            "accept":_loc6_
         });
      }
      
      private static function onStudentRecReleationRequestHandler(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         if(!MapManager.isFightMap)
         {
            MessageManager.addStudentRelationRequest({
               "inviteUId":_loc2_.readUnsignedInt(),
               "inviteRoleId":_loc2_.readUnsignedInt(),
               "inviteLv":_loc2_.readUnsignedShort(),
               "inviteNickName":_loc2_.readUTFBytes(16)
            });
         }
      }
      
      private static function onStudentRecReleationResponseHandler(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:String = _loc2_.readUTFBytes(16);
         var _loc6_:int = int(_loc2_.readUnsignedInt());
         if(_loc6_ == 1)
         {
            MasterManager.instance.masterInfo = new MasterInfo();
            MasterManager.instance.masterInfo.masterId = _loc3_;
            MasterManager.instance.masterInfo.masterRoleId = _loc4_;
            MasterManager.instance.masterInfo.masterNick = _loc5_;
            MasterManager.instance.dispatchAddApprenticeSuccess();
         }
         MessageManager.addStudentRelationResponse({
            "invitedUId":_loc3_,
            "invitedRoleId":_loc4_,
            "invitedNick":_loc5_,
            "accept":_loc6_
         });
      }
      
      private static function onSimplyBroadCast(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         InformBroadCastControl.parseInfo(_loc2_);
      }
      
      public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.INFORM,onInform);
         SocketConnection.addCmdListener(CommandID.DISCONNECT_TEATHER_SHIP,onInform);
         SocketConnection.addCmdListener(CommandID.INFORM_FRIEND_INVITE,onFriendInviteInform);
         SocketConnection.addCmdListener(CommandID.INFORM_REPLY_INVITE,onFriendInviteCancel);
         SocketConnection.addCmdListener(CommandID.TEAM_JOIN_ROOM,onJoinRoom);
         SocketConnection.addCmdListener(CommandID.FIGHT_ENTER,onInitPvRoom);
         SocketConnection.addCmdListener(CommandID.MASTER_REC_RELATION_REQUEST,onRecReleationRequestHandler);
         SocketConnection.addCmdListener(CommandID.MASTER_REC_RELATION_REPONSE,onRecReleationResponseHandler);
         SocketConnection.addCmdListener(CommandID.STUDENT_REC_RELATION_REQUEST,onStudentRecReleationRequestHandler);
         SocketConnection.addCmdListener(CommandID.STUDENT_REC_RELATION_REPONSE,onStudentRecReleationResponseHandler);
         SocketConnection.addCmdListener(CommandID.INFORM_SIMPLY_BROADCAST,onSimplyBroadCast);
      }
   }
}

