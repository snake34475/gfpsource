package com.gfp.app.info
{
   import flash.utils.IDataInput;
   
   public class WatchFightListItemInfo
   {
      
      public var fightType:uint;
      
      public var fightSvrId:uint;
      
      public var fightRoomId:uint;
      
      public var fightStartTime:uint;
      
      public var userId0:uint;
      
      public var roleId0:uint;
      
      public var roleType0:uint;
      
      public var nick0:String;
      
      public var userLv0:uint;
      
      public var userId1:uint;
      
      public var roleId1:uint;
      
      public var roleType1:uint;
      
      public var nick1:String;
      
      public var userLv1:uint;
      
      public function WatchFightListItemInfo(param1:IDataInput = null)
      {
         super();
         if(param1)
         {
            this.fightType = param1.readUnsignedInt();
            this.fightSvrId = param1.readUnsignedInt();
            this.fightRoomId = param1.readUnsignedInt();
            this.fightStartTime = param1.readUnsignedInt();
            this.userId0 = param1.readUnsignedInt();
            this.roleId0 = param1.readUnsignedInt();
            this.roleType0 = param1.readUnsignedInt();
            this.nick0 = param1.readUTFBytes(16);
            this.userLv0 = param1.readUnsignedInt();
            this.userId1 = param1.readUnsignedInt();
            this.roleId1 = param1.readUnsignedInt();
            this.roleType1 = param1.readUnsignedInt();
            this.nick1 = param1.readUTFBytes(16);
            this.userLv1 = param1.readUnsignedInt();
         }
      }
   }
}

