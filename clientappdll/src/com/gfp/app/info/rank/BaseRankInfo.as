package com.gfp.app.info.rank
{
   import flash.utils.IDataInput;
   
   public class BaseRankInfo
   {
      
      public var index:uint;
      
      public var userID:uint;
      
      public var creatTime:uint;
      
      public var roleType:uint;
      
      public var nick:String = "";
      
      public var element:int;
      
      public function BaseRankInfo()
      {
         super();
      }
      
      public function read(param1:IDataInput = null) : void
      {
         if(param1)
         {
            this.userID = param1.readUnsignedInt();
            this.creatTime = param1.readUnsignedInt();
            this.roleType = param1.readUnsignedInt();
            this.nick = param1.readUTFBytes(16);
            this.element = param1.readUnsignedInt();
         }
      }
   }
}

