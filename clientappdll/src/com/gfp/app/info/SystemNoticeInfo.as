package com.gfp.app.info
{
   import flash.utils.IDataInput;
   
   public class SystemNoticeInfo
   {
      
      public var userID:uint;
      
      public var type:uint;
      
      public var createTime:uint;
      
      public var content:String = "";
      
      public function SystemNoticeInfo(param1:IDataInput = null)
      {
         super();
         if(param1)
         {
            this.userID = param1.readUnsignedInt();
            this.type = param1.readUnsignedInt();
            this.createTime = param1.readUnsignedInt();
            this.content = param1.readUTFBytes(500);
         }
      }
   }
}

