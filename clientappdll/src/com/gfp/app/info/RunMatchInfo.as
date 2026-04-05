package com.gfp.app.info
{
   import flash.utils.IDataInput;
   
   public class RunMatchInfo
   {
      
      public var userID:uint;
      
      public var creatTime:uint;
      
      public var roleType:uint;
      
      public var nick:String = "";
      
      public var readyFlag:uint;
      
      public function RunMatchInfo(param1:IDataInput = null)
      {
         super();
         if(param1)
         {
            this.userID = param1.readUnsignedInt();
            this.creatTime = param1.readUnsignedInt();
            this.nick = param1.readUTFBytes(16);
            this.roleType = param1.readUnsignedInt();
            this.readyFlag = param1.readUnsignedInt();
         }
      }
   }
}

