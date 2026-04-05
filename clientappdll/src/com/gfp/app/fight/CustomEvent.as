package com.gfp.app.fight
{
   import flash.events.Event;
   
   public class CustomEvent extends Event
   {
      
      public static const ROOM_CREATE_COMPLETE:String = "roomCreateComplete";
      
      public static const ROOM_USER_ADD:String = "roomUserAdd";
      
      public static const ROOM_USER_REMOVE:String = "roomUserRemove";
      
      public static const NUM_CHANGED:String = "numChanged";
      
      public static const FIGHT_TEAM_THREE_INVITE:String = "fightTeamThreeInvite";
      
      public static const SAN_GUO_CITY_LOAD_COMPLETE:String = "sanGuoCityLoadComplete";
      
      public static const SAN_GUO_CITY_RANK_LOAD_COMPLETE:String = "sanGuoCityRankLoadComplete";
      
      public static const MODEL_NEXT_PAGE:String = "userModelNextPage";
      
      public static const MODEL_PREVIOUS_PAGE:String = "userModelpReviousPage";
      
      public static const SUMMON_EQUIP_UPDATE:String = "summonEquipUpdate";
      
      public static const REPAIR_COMPLETE:String = "repairComplete";
      
      public static const SUMMON_EQUIP_SELECT:String = "summonEquipSelect";
      
      public static const NO_TASKS_HANDLE:String = "";
      
      public static const SET_SUMMON_SHEN_TONG:String = "setSummonShenTong";
      
      public static const STOP_SUMMON_SHEN_TONG:String = "stopSummonShenTong";
      
      public static const SELECT_GOD_ITEM:String = "selectGodItem";
      
      public static const JU_DIAN_GOD_CHANGED:String = "juDianGodChanged";
      
      public static const JU_DIAN_ATTACK_START:String = "juDianAttackStart";
      
      public static const JU_DIAN_DATA_REFRESH_COMPLETE:String = "juDianDataRefreshComplete";
      
      public static const QHJX_PICK_EQUIP:String = "QHJX_PICK_EQUIP";
      
      public static const QHJX_PICK_MATERIAL:String = "QHJX_PICK_MATERIAL";
      
      public static const EQUIP_FU_MO:String = "equipFuMo";
      
      public static const EQUIP_RONG_LIAN:String = "equipRongLian";
      
      public var data:Object;
      
      public function CustomEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Object = null)
      {
         super(param1,param2,param3);
         this.data = param4;
      }
   }
}

