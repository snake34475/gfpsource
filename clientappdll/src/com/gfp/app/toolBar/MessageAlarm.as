package com.gfp.app.toolBar
{
   import com.gfp.app.catchGhost.CatchGhostWaitPanel;
   import com.gfp.app.cityWar.CityWarType;
   import com.gfp.app.im.talk.TalkManager;
   import com.gfp.app.manager.CityWarManager;
   import com.gfp.app.manager.FightGroupManager;
   import com.gfp.app.manager.GuaranteeTradeManager;
   import com.gfp.app.manager.TeamCityWarManager;
   import com.gfp.app.user.UserInfoController;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.TollgateXMLInfo;
   import com.gfp.core.controller.SocketSendController;
   import com.gfp.core.events.GfpEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.info.CustomMessageInfo;
   import com.gfp.core.info.FightTeamBeInviteInfo;
   import com.gfp.core.info.FriendInviteInfo;
   import com.gfp.core.info.FriendInviteReplyInfo;
   import com.gfp.core.info.InformInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.language.ModuleLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MasterManager;
   import com.gfp.core.manager.MessageManager;
   import com.gfp.core.manager.RelationManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.TeamsRelationManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.manager.alert.AlertInfo;
   import com.gfp.core.manager.alert.AlertType;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.PvpIDConstantUtil;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import com.gfp.core.utils.TextFormatUtil;
   import com.gfp.core.utils.TextUtil;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.TextField;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.Delegate;
   import org.taomee.utils.DisplayUtil;
   
   public class MessageAlarm extends BaseBean
   {
      
      public static const FLY_LANTERNS_MSG:Array = [];
      
      FLY_LANTERNS_MSG[0] = "元宵节到了，XXX特意放飞了孔明灯祝福你：家人团团圆圆，财运源源不断，心愿愿愿兑现，元宵节快乐~";
      FLY_LANTERNS_MSG[1] = "让满天的孔明灯来帮我送祝福，愿你在接下来的日子里心想事成，学习进步，元宵节快乐哦~ XXX送上。";
      FLY_LANTERNS_MSG[2] = "正月十五月儿圆，希望我的祝福像汤圆一样愿你事事圆满，心情甜甜美美，XXX祝你元宵节快乐~。";
      FLY_LANTERNS_MSG[3] = "在这个充满喜悦的日子里，希望我放飞的孔明灯能带给你快乐，XXX祝你元宵节快乐，学习进步~ ^__^";
      
      private var _mainUI:Sprite;
      
      private var _btn:SimpleButton;
      
      private var _txt:TextField;
      
      public function MessageAlarm()
      {
         super();
      }
      
      override public function start() : void
      {
         MessageManager.addEventListener(GfpEvent.MESSAGE,this.onMessage);
         this.setup();
         this.show();
         finish();
      }
      
      private function onMessage(param1:Event) : void
      {
         this.show();
      }
      
      public function setup() : void
      {
         this._mainUI = UIManager.getSprite("Message_Icon");
         this._mainUI.buttonMode = true;
         this._btn = this._mainUI["msgBtn"];
         this._txt = this._mainUI["txt"];
         this._txt.mouseEnabled = false;
         this._mainUI.x = 235;
         this._mainUI.y = 45;
      }
      
      public function show() : void
      {
         if(MessageManager.unReadLength() > 0)
         {
            if(!DisplayUtil.hasParent(this._mainUI))
            {
               LayerManager.toolsLevel.addChild(this._mainUI);
               this._mainUI.addEventListener(MouseEvent.CLICK,this.onClick);
            }
            this.setNum();
         }
         else if(Boolean(this._mainUI) && Boolean(DisplayUtil.hasParent(this._mainUI)))
         {
            this._mainUI.removeEventListener(MouseEvent.CLICK,this.onClick);
            DisplayUtil.removeForParent(this._mainUI,false);
         }
      }
      
      public function hide() : void
      {
         this._mainUI.removeEventListener(MouseEvent.CLICK,this.onClick);
         DisplayUtil.removeForParent(this._mainUI,false);
      }
      
      public function setNum() : void
      {
         this._txt.text = MessageManager.unReadLength().toString();
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var id:uint;
         var aInfo:AlertInfo;
         var info:InformInfo = null;
         var cInfo:CustomMessageInfo = null;
         var inviteInfo:FriendInviteInfo = null;
         var pkInviteInfo:FriendInviteInfo = null;
         var fightTeamBeInviteInfo:FightTeamBeInviteInfo = null;
         var masterInfo:Object = null;
         var response:Object = null;
         var studentInfo:Object = null;
         var responseStudent:Object = null;
         var userInfo:FriendInviteInfo = null;
         var fightInfo:InformInfo = null;
         var groupInfo:Object = null;
         var linStr:String = null;
         var clickStr:String = null;
         var data:Object = null;
         var groupId:uint = 0;
         var type:uint = 0;
         var itemID:uint = 0;
         var txtTip:String = null;
         var teamInfo:Object = null;
         var senderID:uint = 0;
         var e:MouseEvent = param1;
         if(FunctionManager.disabledMsg)
         {
            FunctionManager.dispatchDisabledEvt();
            return;
         }
         id = uint(MessageManager.getFristUnReadID());
         aInfo = new AlertInfo();
         if(id == 0)
         {
            return;
         }
         if(id == MessageManager.SYS_TYPE)
         {
            info = MessageManager.getInformInfo();
            if(info)
            {
               this.showInform(info);
            }
         }
         else if(id == MessageManager.CUSTOM_MEEAGE_INFO)
         {
            cInfo = MessageManager.getCustomMessageInfo();
            if(cInfo)
            {
               aInfo = new AlertInfo();
               aInfo.str = cInfo.alertDesc;
               aInfo.type = AlertType.SYSTEM_MESSAGE_ALERT;
               AlertManager.showForInfo(aInfo);
               MessageManager.removeUnUserID(id);
            }
         }
         else if(id == MessageManager.VIP_NOTICE_TYPE)
         {
            aInfo = new AlertInfo();
            aInfo.type = AlertType.VIP_NOTICE;
            aInfo.str = "";
            AlertManager.showForInfo(aInfo);
            MessageManager.removeUnUserID(id);
         }
         else if(id == MessageManager.BECAME_YEAR_VIP_TYPE)
         {
            aInfo = new AlertInfo();
            aInfo.type = AlertType.BECAME_YEAR_VIP;
            aInfo.str = "";
            AlertManager.showForInfo(aInfo);
            MessageManager.removeUnUserID(id);
         }
         else if(id == MessageManager.GF_CARD_NOTICE_TYPE)
         {
            aInfo = new AlertInfo();
            aInfo.type = AlertType.GF_CARD_NOTICE;
            aInfo.str = "";
            AlertManager.showForInfo(aInfo);
            MessageManager.removeUnUserID(id);
         }
         else if(id == MessageManager.SYS_FRIEND_INVITE)
         {
            inviteInfo = MessageManager.getFriendInviteInformInfo();
            this.showFriendInviteInfo(inviteInfo);
         }
         else if(id == MessageManager.SYS_PK_INVITE)
         {
            pkInviteInfo = MessageManager.getFriendPKInviteInfo();
            this.showFriendPkInviteInfo(pkInviteInfo);
         }
         else if(id == MessageManager.FIGHT_TEAM_INVITE)
         {
            fightTeamBeInviteInfo = MessageManager.getFightTeamInviteInfO();
            this.showFightTeamInviteAlert(fightTeamBeInviteInfo);
         }
         else if(id == MessageManager.FIGHT_APPLY_NOTICE)
         {
            aInfo = new AlertInfo();
            aInfo.str = "恭喜你小侠士,你的侠士团已经报名了楼兰杯挑战赛，为了你的侠士团，快去参加战斗吧！";
            aInfo.type = AlertType.SYSTEM_MESSAGE_ALERT;
            AlertManager.showForInfo(aInfo);
            MessageManager.removeUnUserID(id);
         }
         else if(id == MessageManager.MASTER_REC_RELATION_REQUEST)
         {
            masterInfo = MessageManager.popUnReadMessage().data;
            aInfo = new AlertInfo();
            aInfo.str = TextFormatUtil.substitute(ModuleLanguageDefine.MASTER_MSG[0],TextFormatUtil.getEventText(TextUtil.htmlEncode(masterInfo.inviteNickName) + "(" + masterInfo.inviteUId + ")",masterInfo.inviteUId.toString()));
            aInfo.type = AlertType.ANSWER;
            aInfo.applyFun = function():void
            {
               MasterManager.instance.responseMasterRequest(masterInfo.inviteUId,masterInfo.inviteRoleId,1);
            };
            aInfo.cancelFun = function():void
            {
               MasterManager.instance.responseMasterRequest(masterInfo.inviteUId,masterInfo.inviteRoleId,0);
            };
            aInfo.linkFun = this.userInfoLink;
            AlertManager.showForInfo(aInfo);
         }
         else if(id == MessageManager.MASTER_REC_RELATION_RESPONSE)
         {
            response = MessageManager.popUnReadMessage().data;
            aInfo = new AlertInfo();
            if(response.accept == 1)
            {
               aInfo.str = TextFormatUtil.substitute(ModuleLanguageDefine.MASTER_MSG[1],TextFormatUtil.getEventText(TextUtil.htmlEncode(response.invitedNick) + "(" + response.invitedUId + ")",response.invitedUId.toString()));
            }
            else if(response.accept == 0)
            {
               aInfo.str = TextFormatUtil.substitute(ModuleLanguageDefine.MASTER_MSG[2],TextFormatUtil.getEventText(TextUtil.htmlEncode(response.invitedNick) + "(" + response.invitedUId + ")",response.invitedUId.toString()));
            }
            else
            {
               aInfo.str = ModuleLanguageDefine.MASTER_MSG[9];
            }
            aInfo.linkFun = this.userInfoLink;
            aInfo.type = AlertType.ALARM;
            AlertManager.showForInfo(aInfo);
         }
         else if(id == MessageManager.STUDENT_REC_RELATION_REQUEST)
         {
            studentInfo = MessageManager.popUnReadMessage().data;
            aInfo = new AlertInfo();
            aInfo.str = TextFormatUtil.substitute("{0}希望拜你为师，请确认。",TextFormatUtil.getEventText(TextUtil.htmlEncode(studentInfo.inviteNickName) + "(" + studentInfo.inviteUId + ")(Lv." + studentInfo.inviteLv + ")",studentInfo.inviteUId.toString()));
            aInfo.type = AlertType.ANSWER;
            aInfo.applyFun = function():void
            {
               MasterManager.instance.responseStudentRequest(studentInfo.inviteUId,studentInfo.inviteRoleId,studentInfo.inviteLv,1);
            };
            aInfo.cancelFun = function():void
            {
               MasterManager.instance.responseStudentRequest(studentInfo.inviteUId,studentInfo.inviteRoleId,studentInfo.inviteLv,0);
            };
            aInfo.linkFun = this.userInfoLink;
            AlertManager.showForInfo(aInfo);
         }
         else if(id == MessageManager.STUDENT_REC_RELATION_RESPONSE)
         {
            responseStudent = MessageManager.popUnReadMessage().data;
            aInfo = new AlertInfo();
            if(responseStudent.accept == 1)
            {
               aInfo.str = TextFormatUtil.substitute("{0}经过深思熟虑，答应收你为徒，赶快去找师傅一起练级吧！师徒组队经验更丰厚哦",TextFormatUtil.getEventText(TextUtil.htmlEncode(responseStudent.invitedNick) + "(" + responseStudent.invitedUId + ")",responseStudent.invitedUId.toString()));
            }
            else if(responseStudent.accept == 0)
            {
               aInfo.str = TextFormatUtil.substitute("{0}拒绝了你的拜师请求，请再找其他师傅吧！",TextFormatUtil.getEventText(TextUtil.htmlEncode(responseStudent.invitedNick) + "(" + responseStudent.invitedUId + ")",responseStudent.invitedUId.toString()));
            }
            else
            {
               aInfo.str = "对方收徒数量已满，无法再收你为徒啦！";
            }
            aInfo.linkFun = this.userInfoLink;
            aInfo.type = AlertType.ALARM;
            AlertManager.showForInfo(aInfo);
         }
         else if(id == MessageManager.GUARANTEE_TRADE_APPLY_REQUEST)
         {
            userInfo = MessageManager.popUnReadMessage().data;
            aInfo = new AlertInfo();
            aInfo.str = TextFormatUtil.substitute(ModuleLanguageDefine.GUARANTEE_TRADE_MSG[0],TextFormatUtil.getEventText(TextUtil.htmlEncode(userInfo.inviterName) + "(" + userInfo.inviterId + ")",userInfo.inviterId.toString()));
            aInfo.type = AlertType.ANSWER;
            aInfo.applyFun = function():void
            {
               if(MainManager.actorInfo.coins >= 10000)
               {
                  GuaranteeTradeManager.instance.responseTradeRequest(userInfo.inviterId,userInfo.roomId);
               }
               else
               {
                  AlertManager.showSimpleAlarm(ModuleLanguageDefine.GUARANTEE_TRADE_MSG[9]);
               }
            };
            aInfo.cancelFun = function():void
            {
               SocketConnection.send(CommandID.GUARANTEE_TRADE_APPLY_RESPONSE,FriendInviteInfo.GUARANTEE_TRADE,userInfo.inviterId,userInfo.roomId,0);
            };
            aInfo.linkFun = this.userInfoLink;
            AlertManager.showForInfo(aInfo);
         }
         else if(id == MessageManager.APPLY_GLORY_FIGHT)
         {
            fightInfo = MessageManager.getInformInfoById(id);
            if(fightInfo)
            {
               this.showInform(fightInfo);
            }
         }
         else if(id == MessageManager.FIGHT_GROUP_APPLY_REQUEST)
         {
            groupInfo = MessageManager.popUnReadMessage().data;
            aInfo = new AlertInfo();
            linStr = TextFormatUtil.getEventText("点此查看详细",groupInfo.userId + "|" + groupInfo.roleId);
            clickStr = TextUtil.htmlEncode(groupInfo.userName) + "(" + groupInfo.userId + ") 等级:" + groupInfo.lv + linStr;
            aInfo.str = TextFormatUtil.substitute(ModuleLanguageDefine.FIGHT_GROUP_MSG[0],clickStr);
            aInfo.type = AlertType.ANSWER;
            aInfo.applyFun = function():void
            {
               FightGroupManager.instance.responseGroupInvite(groupInfo.groupId,groupInfo.userId,groupInfo.roleId,0);
            };
            aInfo.cancelFun = function():void
            {
               FightGroupManager.instance.responseGroupInvite(groupInfo.groupId,groupInfo.userId,groupInfo.roleId,1);
            };
            aInfo.linkFun = this.userInfoLink;
            AlertManager.showForInfo(aInfo);
         }
         else if(id == MessageManager.FIGHT_GROUP_WAIT_REQUEST)
         {
            data = MessageManager.popUnReadMessage().data;
            groupId = uint(data.group);
            type = uint(data.type);
            itemID = uint(data.itemID);
            if(type == PvpTypeConstantUtil.GROUP_CATCH_GHOST)
            {
               CatchGhostWaitPanel.instance.show();
            }
            else
            {
               aInfo = new AlertInfo();
               aInfo.str = ModuleLanguageDefine.FIGHT_GROUP_MSG[13];
               aInfo.type = AlertType.ANSWER;
               aInfo.applyFun = function():void
               {
                  if(MainManager.actorInfo.wulinID != 0)
                  {
                     AlertManager.showSimpleAlarm("小侠士，您当前已经报名武林盛典，不能参与组队PVP战斗！");
                  }
                  else
                  {
                     FightGroupManager.instance.pvpTypeIndex = type;
                     FightGroupManager.instance.groupFightWaitResoponse(groupId,1);
                     switch(type)
                     {
                        case PvpTypeConstantUtil.CITY_WAR_GROUP_PVP:
                           CityWarManager.instance.setup();
                     }
                  }
               };
               aInfo.cancelFun = function():void
               {
                  FightGroupManager.instance.groupFightWaitResoponse(groupId,0);
               };
               AlertManager.showForInfo(aInfo);
            }
         }
         else if(id == MessageManager.FIGHT_GROUP_KING_FIGHT_NOTIFY)
         {
            txtTip = String(MessageManager.popUnReadMessage().data);
            aInfo = new AlertInfo();
            aInfo.str = txtTip;
            aInfo.type = AlertType.ANSWER;
            aInfo.applyFun = function():void
            {
               CityMap.instance.tranToNpc(10150);
            };
            AlertManager.showForInfo(aInfo);
         }
         else if(id == MessageManager.TEAM_FIGHT_WAIT_REQUEST)
         {
            teamInfo = MessageManager.popUnReadMessage().data;
            senderID = uint(teamInfo.senderID);
            type = uint(teamInfo.type);
            itemID = uint(teamInfo.itemID);
            aInfo = new AlertInfo();
            aInfo.str = "小侠士，您的侠士团团长邀请参加团战!是否同意？";
            aInfo.type = AlertType.ANSWER;
            aInfo.applyFun = function():void
            {
               if(MainManager.actorInfo.wulinID != 0)
               {
                  AlertManager.showSimpleAlarm("小侠士，您当前已经报名武林盛典，不能参与团队战斗！");
               }
               else
               {
                  TeamCityWarManager.instance.teamFightWaitResoponse(senderID,type,itemID,1);
                  switch(type)
                  {
                     case PvpTypeConstantUtil.TEAM_CITY_WAR:
                        CityWarManager.instance.setup(CityWarType.TEAM_TYPE);
                  }
               }
            };
            aInfo.cancelFun = function():void
            {
               TeamCityWarManager.instance.teamFightWaitResoponse(senderID,type,itemID,0);
            };
            AlertManager.showForInfo(aInfo);
         }
         else
         {
            MessageManager.removeUnUserID(id);
            TalkManager.showTalkPanel(id,0);
         }
         if(MessageManager.unReadLength() == 0)
         {
            this.hide();
         }
         this.setNum();
      }
      
      private function showInform(param1:InformInfo) : void
      {
         var rel:UserInfo = null;
         var alertInfo:AlertInfo = null;
         var nickName:String = null;
         var flyIndex:int = 0;
         var flyStr:String = null;
         var tempAlertInfo:AlertInfo = null;
         var mapName:String = null;
         var msg:String = null;
         var info:InformInfo = param1;
         rel = UserInfoManager.creatInfo(info.userID);
         rel.userID = info.userID;
         rel.createTime = info.createTime;
         rel.timePoke = 0;
         rel.nick = info.nick;
         rel.mapID = info.mapID;
         rel.serverID = info.serverID;
         nickName = TextUtil.htmlEncode(info.nick);
         switch(info.type)
         {
            case CommandID.FRIEND_ANSWER:
               if(info.accept)
               {
                  RelationManager.addFriend(rel);
                  RelationManager.upDateInfo(info.userID);
                  alertInfo = new AlertInfo();
                  alertInfo.type = AlertType.SYSTEM_MESSAGE_ALERT;
                  alertInfo.iconURL = ClientConfig.getRoleHead(info.roleType);
                  alertInfo.str = "\n\n" + TextFormatUtil.getEventText("<b>Lv." + info.userLv + "</b> " + nickName + "(" + info.userID + ")",info.userID.toString()) + AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[1];
                  alertInfo.linkFun = this.userInfoLink;
                  AlertManager.showForInfo(alertInfo);
                  TasksManager.dispatchActionEvent(TaskActionEvent.TASK_FRIEND_ADD,"");
                  break;
               }
               alertInfo = new AlertInfo();
               alertInfo.type = AlertType.SYSTEM_MESSAGE_ALERT;
               alertInfo.iconURL = ClientConfig.getRoleHead(info.roleType);
               alertInfo.str = "\n\n" + nickName + AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[2];
               AlertManager.showForInfo(alertInfo);
               break;
            case CommandID.FRIEND_ADD:
               alertInfo = new AlertInfo();
               alertInfo.type = AlertType.RELATIONSHIP_ANSWER;
               alertInfo.iconURL = ClientConfig.getRoleHead(info.roleType);
               alertInfo.str = AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[3] + TextFormatUtil.getEventText("<b>Lv." + info.userLv + "</b> " + info.nick + "(" + info.userID + ")",info.userID.toString() + "|" + info.createTime) + AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[4];
               alertInfo.linkFun = this.userInfoLink;
               alertInfo.applyFun = function():void
               {
                  RelationManager.answerFriend(info.userID,true);
                  RelationManager.addFriend(rel);
                  RelationManager.upDateInfo(info.userID);
                  var _loc1_:AlertInfo = new AlertInfo();
                  _loc1_.str = AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[5] + nickName + AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[6];
                  _loc1_.type = AlertType.SYSTEM_MESSAGE_ALERT;
                  _loc1_.iconURL = ClientConfig.getRoleHead(info.roleType);
                  AlertManager.showForInfo(_loc1_);
               };
               alertInfo.cancelFun = function():void
               {
                  RelationManager.answerFriend(info.userID,false);
               };
               AlertManager.showForInfo(alertInfo);
               break;
            case CommandID.FLY_LANTERNS_BLESSING:
               alertInfo = new AlertInfo();
               flyIndex = Math.floor(Math.random() * FLY_LANTERNS_MSG.length);
               flyStr = FLY_LANTERNS_MSG[flyIndex];
               flyStr = flyStr.replace("XXX",nickName);
               alertInfo.str = flyStr;
               alertInfo.type = AlertType.SYSTEM_MESSAGE_ALERT;
               AlertManager.showForInfo(alertInfo);
               break;
            case CommandID.FLY_LANTERNS_RESULT:
               RelationManager.answerFriend(info.userID,true);
               RelationManager.addFriend(rel);
               RelationManager.upDateInfo(info.userID);
               tempAlertInfo = new AlertInfo();
               tempAlertInfo.str = AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[5] + nickName + AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[6];
               tempAlertInfo.type = AlertType.SYSTEM_MESSAGE_ALERT;
               tempAlertInfo.iconURL = ClientConfig.getRoleHead(info.roleType);
               AlertManager.showForInfo(tempAlertInfo);
               break;
            case CommandID.FLY_LANTERNS_ADDFRIEND:
               alertInfo = new AlertInfo();
               alertInfo.type = AlertType.RELATIONSHIP_ANSWER;
               alertInfo.iconURL = ClientConfig.getRoleHead(info.roleType);
               alertInfo.str = nickName + AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[21] + TextFormatUtil.getEventText("<b>Lv." + info.userLv + "</b> " + info.nick + "(" + info.userID + ")",info.userID.toString() + "|" + info.createTime) + AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[4];
               alertInfo.linkFun = this.userInfoLink;
               alertInfo.applyFun = function():void
               {
                  RelationManager.answerFriend(info.userID,true);
                  RelationManager.addFriend(rel);
                  RelationManager.upDateInfo(info.userID);
                  var _loc1_:AlertInfo = new AlertInfo();
                  _loc1_.str = AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[5] + nickName + AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[6];
                  _loc1_.type = AlertType.SYSTEM_MESSAGE_ALERT;
                  _loc1_.iconURL = ClientConfig.getRoleHead(info.roleType);
                  AlertManager.showForInfo(_loc1_);
               };
               alertInfo.cancelFun = function():void
               {
                  RelationManager.answerFriend(info.userID,false);
               };
               AlertManager.showForInfo(alertInfo);
               break;
            case CommandID.REQUEST_OUT:
               mapName = "";
               if(info.mapID > MapManager.ID_MAX)
               {
                  mapName = nickName + AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[7];
               }
               else
               {
                  mapName = info.mapName;
               }
               alertInfo = new AlertInfo();
               alertInfo.type = AlertType.ANSWER;
               alertInfo.str = TextFormatUtil.getEventText(nickName + "(" + info.userID + ")",info.userID.toString()) + AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[8] + mapName + AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[9];
               alertInfo.linkFun = this.userInfoLink;
               alertInfo.applyFun = function():void
               {
                  if(info.mapType == MapType.PVE || info.mapType == MapType.PVP)
                  {
                     AlertManager.showSimpleAlarm(AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[10]);
                  }
                  else if(MapManager.currentMap.info.mapType == MapType.TRADE)
                  {
                     AlertManager.showSimpleAlarm(AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[11]);
                  }
                  else
                  {
                     SocketConnection.addCmdListener(CommandID.REQUEST_ANSWER,function(param1:SocketEvent):void
                     {
                        SocketConnection.removeCmdListener(CommandID.REQUEST_ANSWER,arguments.callee);
                        CityMap.instance.changeMap(info.mapID);
                     });
                     SocketConnection.send(CommandID.REQUEST_ANSWER,info.userID,1);
                  }
               };
               alertInfo.cancelFun = function():void
               {
                  SocketConnection.send(CommandID.REQUEST_ANSWER,info.userID,0);
               };
               AlertManager.showForInfo(alertInfo);
               break;
            case CommandID.REQUEST_ANSWER:
               alertInfo = new AlertInfo();
               alertInfo.type = AlertType.ALARM;
               alertInfo.linkFun = this.userInfoLink;
               if(info.accept)
               {
                  alertInfo.str = "/n/n" + nickName + AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[12];
               }
               else
               {
                  alertInfo.str = "/n/n" + nickName + AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[13];
               }
               AlertManager.showForInfo(alertInfo);
               break;
            case CommandID.REQUEST_REGISTER:
               if(info.accept == 0)
               {
                  return;
               }
               alertInfo = new AlertInfo();
               alertInfo.type = AlertType.ALARM;
               alertInfo.linkFun = this.userInfoLink;
               alertInfo.str = TextFormatUtil.getEventText(nickName + "(" + info.userID + ")",info.userID.toString()) + AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[14];
               AlertManager.showForInfo(alertInfo);
               RelationManager.addFriend(rel);
               RelationManager.upDateInfo(info.userID);
               break;
            case CommandID.VIP_NOTICE:
            case CommandID.BECAME_YEAR_VIP:
               break;
            case CommandID.GLORY_FIGHT_APPLY:
               msg = "小侠士, 你所在侠士团团长 " + TextFormatUtil.getRedText(nickName) + "在" + TextFormatUtil.getRedText(info.serverID.toString()) + "号服务器参加了侠士团荣誉之战，快去" + TextFormatUtil.getRedText(info.serverID.toString()) + "号服务器支援团长吧，为荣誉而战";
               AlertManager.showSimpleAlarm(msg);
               break;
            case CommandID.DISCONNECT_TEATHER_SHIP:
               msg = "很可惜，因为某种不可抗力，" + TextFormatUtil.getRedText(info.userID + "（Lv." + info.userLv + "）") + "与你单方面解除师徒关系。";
               AlertManager.showSimpleAlarm(msg);
               break;
            case CommandID.UNLOCK_114_PRAISE:
               msg = "小侠士<a href=\'event:L_USER_INFO|" + info.userID + "|" + info.createTime + "\'><font color=\'#FF0000\'><u>" + info.nick + "</u></font>看你实力雄厚，惊为天人，忍不住给你赞了哟！";
               AlertManager.showSimpleAlarm(msg);
         }
      }
      
      private function showFriendInviteInfo(param1:FriendInviteInfo) : void
      {
         var tollgateName:String;
         var difficultyNameArr:Array;
         var difficulty:uint;
         var infoStr:String;
         var info:FriendInviteInfo = param1;
         var alertInfo:AlertInfo = new AlertInfo();
         alertInfo.type = AlertType.RELATIONSHIP_ANSWER;
         tollgateName = TollgateXMLInfo.getName(info.stageId);
         difficultyNameArr = [AppLanguageDefine.SIMPLE,AppLanguageDefine.GENERAL,AppLanguageDefine.DIFFICULT,AppLanguageDefine.ELITE,AppLanguageDefine.HERO,AppLanguageDefine.EPIC];
         difficulty = info.difficulty < 1 ? 1 : uint(info.difficulty);
         difficulty = difficulty > 6 ? 6 : difficulty;
         infoStr = TextFormatUtil.getEventText("<b>Lv." + info.inviterLv + "</b> " + info.inviterName + "(" + info.inviterId.toString() + ")",info.inviterId.toString()) + AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[15] + difficultyNameArr[difficulty - 1] + AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[16] + tollgateName + AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[17];
         alertInfo.str = infoStr;
         alertInfo.linkFun = this.userInfoLink;
         alertInfo.applyFun = function():void
         {
            sendToJoinTeam(info);
         };
         alertInfo.cancelFun = function():void
         {
            sendInviteReply(info.inviterId,FriendInviteReplyInfo.REFUSE);
         };
         AlertManager.showForInfo(alertInfo);
      }
      
      private function userInfoLink(param1:TextEvent) : void
      {
         var _loc2_:String = param1.text;
         var _loc3_:Array = _loc2_.split("|");
         if(_loc3_.length > 1)
         {
            UserInfoController.showForID(_loc3_[0],false,_loc3_[1]);
         }
         else
         {
            UserInfoController.showForID(_loc3_[0]);
         }
      }
      
      private function sendInviteReply(param1:int, param2:int) : void
      {
         SocketConnection.send(CommandID.TEAM_REPLY_INVITE,1,param1,param2);
      }
      
      private function sendToJoinTeam(param1:FriendInviteInfo) : void
      {
         SocketConnection.send(CommandID.TEAM_JOIN_ROOM,param1.roomId,param1.inviterId,param1.stageId,param1.difficulty);
      }
      
      private function showFriendPkInviteInfo(param1:FriendInviteInfo) : void
      {
         var infoStr:String;
         var info:FriendInviteInfo = param1;
         var alertInfo:AlertInfo = new AlertInfo();
         alertInfo.type = AlertType.RELATIONSHIP_ANSWER;
         infoStr = TextFormatUtil.getEventText("<b>Lv." + info.inviterLv + "</b> " + TextUtil.htmlEncode(info.inviterName) + "(" + info.inviterId.toString() + ")",info.inviterId.toString()) + AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[18];
         alertInfo.str = infoStr;
         alertInfo.linkFun = this.userInfoLink;
         alertInfo.applyFun = function():void
         {
            confirmPK(info);
         };
         alertInfo.cancelFun = function():void
         {
            cancelPK(info);
         };
         AlertManager.showForInfo(alertInfo);
      }
      
      private function confirmPK(param1:FriendInviteInfo) : void
      {
         if(MapManager.currentMap.info.mapType == MapType.TRADE)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[19]);
            SocketConnection.send(CommandID.TEAM_REPLY_INVITE,2,param1.inviterId,FriendInviteReplyInfo.REFUSE);
            return;
         }
         if(MapManager.isFightMap)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.MESSAGE_CHARACTER_COLLECTION[20]);
            SocketConnection.send(CommandID.TEAM_REPLY_INVITE,2,param1.inviterId,FriendInviteReplyInfo.REFUSE);
            return;
         }
         SocketSendController.sendPvpInviteCMD(false,PvpIDConstantUtil.INVITE_PK_PVP_ID,PvpTypeConstantUtil.PVP_TYPE_REPLY,param1.roomId);
         SocketConnection.send(CommandID.TEAM_REPLY_INVITE,2,param1.inviterId,FriendInviteReplyInfo.ACCEPT);
      }
      
      private function cancelPK(param1:FriendInviteInfo) : void
      {
         SocketConnection.send(CommandID.TEAM_REPLY_INVITE,2,param1.inviterId,FriendInviteReplyInfo.REFUSE);
      }
      
      public function showFightTeamInviteAlert(param1:FightTeamBeInviteInfo) : void
      {
         var _loc2_:Function = Delegate.create(this.onAppJoinFun,param1);
         var _loc3_:Function = Delegate.create(this.onCancleFun,param1);
         AlertManager.showSimpleAlert(TextUtil.htmlEncode(param1.inviteNick) + "邀请你加入他的侠士团，是否同意加入",_loc2_,_loc3_);
      }
      
      private function onAppJoinFun(param1:FightTeamBeInviteInfo) : void
      {
         TeamsRelationManager.instance.sendJoinResult(param1.teamID,param1.inviteID,true);
      }
      
      private function onCancleFun(param1:FightTeamBeInviteInfo) : void
      {
         TeamsRelationManager.instance.sendJoinResult(param1.teamID,param1.inviteID,false);
      }
   }
}

