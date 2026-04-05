package com.gfp.app.fight
{
   import flash.events.Event;
   
   public class CustomDataEvent extends Event
   {
      
      public static const ROOM_CREATE_COMPLETE:String = "roomCreateComplete";
      
      public static const ROOM_USER_ADD:String = "roomUserAdd";
      
      public static const ROOM_USER_REMOVE:String = "roomUserRemove";
      
      public static const ROOM_LEADER_LEAVE:String = "roomLeaderLeave";
      
      public static const ROOM_PVP_USER_ADD:String = "roomPvpUserAdd";
      
      public static const ROOM_MULTI_PVP_USER_ADD:String = "roomMultiPvpUserAdd";
      
      public static const ROOM_PVP_USER_REMOVE:String = "roomPvpUserRemove";
      
      public static const ROOM_PVP_START:String = "roomPvpStart";
      
      public static const FIGHT_TEAM_THREE_INVITE:String = "fightTeamThreeInvite";
      
      public static const FIGHT_TEAM_THREE_START:String = "fightTeamThreeStart";
      
      public var data:Object;
      
      public function CustomDataEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Object = null)
      {
         super(param1,param2,param3);
         this.data = param4;
      }
   }
}

