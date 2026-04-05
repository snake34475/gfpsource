package com.gfp.app.info
{
   import flash.utils.IDataInput;
   
   public class PeopleCityInfo
   {
      
      public var teamId:uint;
      
      public var friendNum:uint;
      
      public var petNum:uint;
      
      public var cardNum:uint;
      
      public var achieveNum:uint;
      
      public var huntAward:uint;
      
      public var expedition:uint;
      
      public var medal:uint;
      
      public function PeopleCityInfo(param1:IDataInput = null)
      {
         super();
         if(param1)
         {
            this.teamId = param1.readUnsignedInt();
            this.friendNum = param1.readUnsignedInt();
            this.petNum = param1.readUnsignedInt();
            this.cardNum = param1.readUnsignedInt();
            this.achieveNum = param1.readUnsignedInt();
            this.huntAward = param1.readUnsignedInt();
            this.expedition = param1.readUnsignedInt();
            this.medal = param1.readUnsignedInt();
         }
      }
   }
}

