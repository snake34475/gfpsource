package com.gfp.app.info
{
   import flash.utils.IDataInput;
   
   public class HeroTeamInfo
   {
      
      public var teamID:uint;
      
      public var leaderUserID:uint;
      
      public var leaderRoleType:uint;
      
      public var leaderNick:String = "";
      
      public var teamNum:uint;
      
      public var reviveGrassNum:uint;
      
      public function HeroTeamInfo(param1:IDataInput)
      {
         super();
         if(param1)
         {
            this.teamID = param1.readUnsignedInt();
            this.leaderUserID = param1.readUnsignedInt();
            this.leaderRoleType = param1.readUnsignedInt();
            this.leaderNick = param1.readUTFBytes(16);
            this.teamNum = param1.readUnsignedInt();
            this.reviveGrassNum = param1.readUnsignedInt();
         }
      }
   }
}

