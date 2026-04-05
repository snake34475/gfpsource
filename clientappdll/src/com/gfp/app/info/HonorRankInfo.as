package com.gfp.app.info
{
   import flash.utils.IDataInput;
   
   public class HonorRankInfo
   {
      
      public var userID:uint;
      
      public var roleID:uint;
      
      public var nick:String = "";
      
      public var point:uint;
      
      public var index:uint;
      
      public var lastTime:uint;
      
      public function HonorRankInfo(param1:IDataInput = null)
      {
         super();
         if(param1)
         {
            this.userID = param1.readUnsignedInt();
            this.roleID = param1.readUnsignedInt();
            this.nick = param1.readUTFBytes(16);
            this.point = param1.readUnsignedInt();
            this.lastTime = param1.readUnsignedInt();
         }
      }
   }
}

