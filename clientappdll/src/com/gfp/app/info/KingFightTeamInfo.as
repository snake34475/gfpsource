package com.gfp.app.info
{
   import com.gfp.core.info.UserInfo;
   import flash.utils.IDataInput;
   
   public class KingFightTeamInfo
   {
      
      public var campIndex:uint;
      
      public var teamId:uint;
      
      public var user1Id:uint;
      
      public var user1RoleId:uint;
      
      public var user2Id:uint;
      
      public var user2RoleId:uint;
      
      public var winCount:uint;
      
      public function KingFightTeamInfo(param1:IDataInput)
      {
         super();
         if(param1)
         {
            this.campIndex = param1.readUnsignedInt();
            this.teamId = param1.readUnsignedInt();
            this.user1Id = param1.readUnsignedInt();
            this.user1RoleId = param1.readUnsignedInt();
            this.user2Id = param1.readUnsignedInt();
            this.user2RoleId = param1.readUnsignedInt();
            this.winCount = param1.readUnsignedInt();
         }
      }
      
      public function userInTeam(param1:UserInfo) : Boolean
      {
         if(param1.userID == this.user1Id && param1.createTime == this.user1RoleId || param1.userID == this.user2Id && param1.createTime == this.user2RoleId)
         {
            return true;
         }
         return false;
      }
      
      public function userInTeamWithId(param1:uint, param2:uint) : Boolean
      {
         if(param1 == this.user1Id && param2 == this.user1RoleId || param1 == this.user2Id && param2 == this.user2RoleId)
         {
            return true;
         }
         return false;
      }
   }
}

