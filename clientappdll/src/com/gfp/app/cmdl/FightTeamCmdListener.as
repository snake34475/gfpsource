package com.gfp.app.cmdl
{
   import com.gfp.app.control.BaseBuffControl;
   import com.gfp.core.CommandID;
   import com.gfp.core.info.TeamMemberOnlineChangeInfo;
   import com.gfp.core.info.TeamMemberUpdateInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.FightTeamsManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MessageManager;
   import com.gfp.core.manager.TeamsRelationManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class FightTeamCmdListener extends BaseBean
   {
      
      public function FightTeamCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_MEMEBER_UPDATE,this.onTeamMemberUpdate);
         SocketConnection.addCmdListener(CommandID.TEAM_MEMEBER_ONLINE_INFP,this.onTeamMemberOnlieChage);
         SocketConnection.addCmdListener(CommandID.TEAM_INTEGRAL,this.onIntegralUpdate);
         SocketConnection.addCmdListener(CommandID.TEAM_ANSWER_BE_INVITE,this.onAnswerBeInviteSocket);
         SocketConnection.addCmdListener(CommandID.TEAM_CREATE,this.onCreateTeamSocket);
         SocketConnection.addCmdListener(CommandID.TEAM_DELETE,this.onTeamDelete);
         SocketConnection.addCmdListener(CommandID.TEAM_MEMEBER_LEAVE,this.onLeaveTeam);
         SocketConnection.addCmdListener(CommandID.LOULAN_APPLY_NOTICE,this.onTeamApplyLouLanFight);
         TeamsRelationManager.instance.addEventListener(TeamsRelationManager.FIGHT_TEAM_MEMBER_INFO_READY,this.onFightMemberInfoReady);
         finish();
      }
      
      private function onLeaveTeam(param1:SocketEvent) : void
      {
         ActivityExchangeTimesManager.updataTimesByOnce(1440);
      }
      
      private function onFightMemberInfoReady(param1:Event) : void
      {
      }
      
      private function onTeamMemberUpdate(param1:SocketEvent) : void
      {
         var _loc2_:TeamMemberUpdateInfo = param1.data as TeamMemberUpdateInfo;
         if(_loc2_.type == 0)
         {
            TeamsRelationManager.instance.subTeamMember(_loc2_);
            if(_loc2_.userId == MainManager.actorID && _loc2_.createTime == MainManager.actorInfo.createTime)
            {
               BaseBuffControl.addBuff(1);
               TeamsRelationManager.instance.appliedTeamIDs = [];
            }
         }
         else if(_loc2_.type == 1)
         {
            TeamsRelationManager.instance.addTeamMember(_loc2_);
         }
      }
      
      private function onTeamMemberOnlieChage(param1:SocketEvent) : void
      {
         var _loc2_:TeamMemberOnlineChangeInfo = param1.data as TeamMemberOnlineChangeInfo;
         TeamsRelationManager.instance.changeMemberOnlineInfo(_loc2_);
      }
      
      private function onIntegralUpdate(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:String = _loc2_.readUTFBytes(16);
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:String = _loc3_ + "为侠士团";
         if(_loc4_ == 1)
         {
            TeamsRelationManager.instance.fightTeamsMemberInfo.teamIntegral += _loc5_;
            _loc6_ += "贡献了";
         }
         else
         {
            TeamsRelationManager.instance.fightTeamsMemberInfo.teamIntegral -= _loc5_;
            _loc6_ += "损失了";
         }
         _loc6_ += _loc5_ + "点侠士团积分";
      }
      
      private function onAnswerBeInviteSocket(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ > 0)
         {
            MainManager.actorInfo.fightTeamId = _loc3_;
            TextAlert.show("你成功加入了侠士团");
            TeamsRelationManager.instance.reqFightTeamsMemberInfo();
            TeamsRelationManager.instance.appliedTeamIDs = [];
            BaseBuffControl.addBuff(1);
            TeamsRelationManager.instance.dispatchEvent(new Event(TeamsRelationManager.APPLY_JOIN_RESPONSE));
         }
      }
      
      private function onCreateTeamSocket(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         MainManager.actorInfo.fightTeamId = _loc3_;
         AlertManager.showSimpleAlarm("恭喜你,小侠士你已成功拥有了自己的侠士团,快邀请你的好友来加入自己的侠士团吧");
         TeamsRelationManager.instance.reqFightTeamsMemberInfo();
         TeamsRelationManager.instance.appliedTeamIDs = [];
         BaseBuffControl.addBuff(1);
      }
      
      private function onTeamDelete(param1:SocketEvent) : void
      {
         TeamsRelationManager.instance.onTeamDelete();
         BaseBuffControl.addBuff(1);
         ActivityExchangeTimesManager.updataTimesByOnce(1440);
      }
      
      private function onTeamApplyLouLanFight(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:Boolean = _loc2_.readUnsignedInt() == 1;
         var _loc6_:uint = _loc2_.readUnsignedInt();
         FightTeamsManager.instance.addTeamExP(_loc3_,_loc6_);
         if(TeamsRelationManager.instance.fightTeamsMemberInfo)
         {
            TeamsRelationManager.instance.fightTeamsMemberInfo.teamIntegral = _loc4_;
         }
         if(_loc5_)
         {
            MessageManager.addFightApplyInfo();
         }
      }
   }
}

