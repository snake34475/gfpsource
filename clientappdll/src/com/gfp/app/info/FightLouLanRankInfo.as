package com.gfp.app.info
{
   import com.gfp.core.manager.FightTeamsManager;
   import flash.utils.IDataInput;
   
   public class FightLouLanRankInfo
   {
      
      public var teamID:uint;
      
      public var teamNick:String = "";
      
      public var leaderID:uint;
      
      public var leaderCreatTime:uint;
      
      public var leaderNick:String = "";
      
      public var teamNum:uint;
      
      public var teamScore:uint;
      
      public var teamLv:uint;
      
      public var teamExp:uint;
      
      public var index:uint;
      
      public function FightLouLanRankInfo(param1:IDataInput = null)
      {
         super();
         if(param1)
         {
            this.teamID = param1.readUnsignedInt();
            this.teamNick = param1.readUTFBytes(16);
            this.leaderID = param1.readUnsignedInt();
            this.leaderCreatTime = param1.readUnsignedInt();
            this.leaderNick = param1.readUTFBytes(16);
            this.teamExp = param1.readUnsignedInt();
            this.teamLv = FightTeamsManager.instance.caculateLv(this.teamExp);
            this.teamNum = param1.readUnsignedInt();
            this.teamScore = param1.readUnsignedInt();
            param1.readUnsignedInt();
         }
      }
   }
}

