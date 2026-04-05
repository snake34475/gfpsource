package com.gfp.app
{
   import com.gfp.app.info.EquiptRepairInfo;
   import com.gfp.app.info.EquiptSaleInfo;
   import com.gfp.app.info.ItemSaleInfo;
   import com.gfp.app.info.ItemsUpgradeCompleteInfo;
   import com.gfp.core.CommandID;
   import com.gfp.core.info.ActivityExchangeAwardInfo;
   import com.gfp.core.info.AmbassadorInfo;
   import com.gfp.core.info.ChatInfo;
   import com.gfp.core.info.DailyActiveAwardInfo;
   import com.gfp.core.info.EquipBuyInfo;
   import com.gfp.core.info.EquipComposeInfo;
   import com.gfp.core.info.EquipDecomposeInfo;
   import com.gfp.core.info.EquipNewComposeInfo;
   import com.gfp.core.info.FightTeamBeInviteInfo;
   import com.gfp.core.info.FightTeamInfo;
   import com.gfp.core.info.FriendInviteInfo;
   import com.gfp.core.info.FriendInviteReplyInfo;
   import com.gfp.core.info.GrowInfo;
   import com.gfp.core.info.HeroMeetBloodInfo;
   import com.gfp.core.info.HpMpInfo;
   import com.gfp.core.info.InformInfo;
   import com.gfp.core.info.ItemBuyInfo;
   import com.gfp.core.info.ItemFallListInfo;
   import com.gfp.core.info.LuckyBoxAwardInfo;
   import com.gfp.core.info.NicknameChangeInfo;
   import com.gfp.core.info.OnHookInfo;
   import com.gfp.core.info.ReceiveHornInfo;
   import com.gfp.core.info.RollInfo;
   import com.gfp.core.info.ServerUniqDataInfo;
   import com.gfp.core.info.SkillUpgradeInfo;
   import com.gfp.core.info.SysMsgInfo;
   import com.gfp.core.info.TeamMemberOnlineChangeInfo;
   import com.gfp.core.info.TeamMemberUpdateInfo;
   import com.gfp.core.info.TollgateAwardPointInfo;
   import com.gfp.core.info.VipInfo;
   import com.gfp.core.info.ZhengGuInfo;
   import com.gfp.core.info.fight.BruiseInfo;
   import com.gfp.core.info.fight.FightAnswerInfo;
   import com.gfp.core.info.fight.FightAwardInfo;
   import com.gfp.core.info.fight.FightInviteInfo;
   import com.gfp.core.info.fight.FightReadyInfo;
   import com.gfp.core.info.item.ChangeClothInfo;
   import com.gfp.core.info.item.EquipListInfo;
   import com.gfp.core.info.item.ItemListInfo;
   import com.gfp.core.info.item.MaterialsListInfo;
   import com.gfp.core.info.task.TaskBufInfoList;
   import com.gfp.core.info.task.TaskCompleteInfo;
   import org.taomee.net.tmf.TMF;
   
   public class ClassRegister
   {
      
      public function ClassRegister()
      {
         super();
      }
      
      public static function setup() : void
      {
         TMF.registerClass(CommandID.INFORM,InformInfo);
         TMF.registerClass(CommandID.DISCONNECT_TEATHER_SHIP,InformInfo);
         TMF.registerClass(CommandID.INFORM_FRIEND_INVITE,FriendInviteInfo);
         TMF.registerClass(CommandID.INFORM_REPLY_INVITE,FriendInviteReplyInfo);
         TMF.registerClass(CommandID.CHAT,ChatInfo);
         TMF.registerClass(CommandID.CHANGE_CLOTH,ChangeClothInfo);
         TMF.registerClass(CommandID.BAG_BUYITEM,ItemBuyInfo);
         TMF.registerClass(CommandID.BAG_BUYEQUIP,EquipBuyInfo);
         TMF.registerClass(CommandID.STAGE_TOWER_REWARD,EquipBuyInfo);
         TMF.registerClass(CommandID.BUY_DISCOUNT_TREASURE,EquipBuyInfo);
         TMF.registerClass(CommandID.BAG_GETITEM,ItemListInfo);
         TMF.registerClass(CommandID.BAG_GETEQUIP,EquipListInfo);
         TMF.registerClass(CommandID.BAG_MATERIALS,MaterialsListInfo);
         TMF.registerClass(CommandID.CHANGE_NICK,NicknameChangeInfo);
         TMF.registerClass(CommandID.TASK_GET_BUF,TaskBufInfoList);
         TMF.registerClass(CommandID.TASK_COMPLETE,TaskCompleteInfo);
         TMF.registerClass(CommandID.TASK_ACTIVITY_COMPLETE,TaskCompleteInfo);
         TMF.registerClass(CommandID.SKILL_UPDATE,SkillUpgradeInfo);
         TMF.registerClass(CommandID.EQUIP_SERVICE,EquiptRepairInfo);
         TMF.registerClass(CommandID.BAG_SELLITEM,ItemSaleInfo);
         TMF.registerClass(CommandID.BAG_SELLEQUIP,EquiptSaleInfo);
         TMF.registerClass(CommandID.EQUIP_DECOMPOSE,EquipDecomposeInfo);
         TMF.registerClass(CommandID.EQUIP_COMPOSE,EquipComposeInfo);
         TMF.registerClass(CommandID.EQUIP_NEW_COMPOSE,EquipNewComposeInfo);
         TMF.registerClass(CommandID.EQUIP_CHANGE_PRIVILEGE,EquipComposeInfo);
         TMF.registerClass(CommandID.GET_ANBASSADOR_AWARD,AmbassadorInfo);
         TMF.registerClass(CommandID.LUCKY_BOX_AWARD,LuckyBoxAwardInfo);
         TMF.registerClass(CommandID.DAILY_ACTIVITY,DailyActiveAwardInfo);
         TMF.registerClass(CommandID.ACTIVITY_EXCHANGE,ActivityExchangeAwardInfo);
         TMF.registerClass(CommandID.RECEIVE_HORN,ReceiveHornInfo);
         TMF.registerClass(CommandID.ZHENG_GU_CMD,ZhengGuInfo);
         TMF.registerClass(CommandID.FIGHT_INVITE_INFORM,FightInviteInfo);
         TMF.registerClass(CommandID.FIGHT_INVITE_ANSWER,FightAnswerInfo);
         TMF.registerClass(CommandID.FIGHT_READY,FightReadyInfo);
         TMF.registerClass(CommandID.MONSTER_DROP,ItemFallListInfo);
         TMF.registerClass(CommandID.ACTION_BRUISE,BruiseInfo);
         TMF.registerClass(CommandID.FIGHT_AWARD,FightAwardInfo);
         TMF.registerClass(CommandID.TEAM_HAVE_ROLL_ITEM,RollInfo);
         TMF.registerClass(CommandID.INFORM_USER_EXP,GrowInfo);
         TMF.registerClass(CommandID.INFORM_USER_HPMP,HpMpInfo);
         TMF.registerClass(CommandID.SYSTEM_MESSAGE,SysMsgInfo);
         TMF.registerClass(CommandID.VIP_INFO,VipInfo);
         TMF.registerClass(CommandID.ITEMS_UPGRADE,ItemsUpgradeCompleteInfo);
         TMF.registerClass(CommandID.HEROMEET_KING_WATCH_BLOOD,HeroMeetBloodInfo);
         TMF.registerClass(CommandID.HEROMEET_KING_WATCH_INFO,BruiseInfo);
         TMF.registerClass(CommandID.ACTIVITY_EXCHANGES_LIMITCOUNT,ServerUniqDataInfo);
         TMF.registerClass(CommandID.GET_ON_HOOK_INFO,OnHookInfo);
         TMF.registerClass(CommandID.TEAM_MEMBER_INFO,FightTeamInfo);
         TMF.registerClass(CommandID.TEAM_BE_INVITE,FightTeamBeInviteInfo);
         TMF.registerClass(CommandID.TEAM_MEMEBER_ONLINE_INFP,TeamMemberOnlineChangeInfo);
         TMF.registerClass(CommandID.TEAM_MEMEBER_UPDATE,TeamMemberUpdateInfo);
         TMF.registerClass(CommandID.TOLLGATE_AWARD_POINT,TollgateAwardPointInfo);
         TMF.registerClass(CommandID.GET_TOLLGATE_AWARD,ActivityExchangeAwardInfo);
         TMF.registerClass(CommandID.PROM_CODE_CHECKOUT,ActivityExchangeAwardInfo);
      }
   }
}

