package com.gfp.app.cmdl
{
   import flash.utils.IDataInput;
   
   public class SystemNoticeRedInfo
   {
      
      public var remain:uint;
      
      public var typeID:uint;
      
      public var userID:uint;
      
      public var createTime:uint;
      
      public var redTime:uint;
      
      public var redNum:uint;
      
      public var content:String = "";
      
      public function SystemNoticeRedInfo(param1:IDataInput = null)
      {
         super();
         if(param1)
         {
            this.remain = param1.readUnsignedInt();
            this.typeID = param1.readUnsignedInt();
            this.userID = param1.readUnsignedInt();
            this.createTime = param1.readUnsignedInt();
            this.redTime = param1.readUnsignedInt();
            this.redNum = param1.readUnsignedInt();
            this.content = param1.readUTFBytes(500);
         }
      }
   }
}

