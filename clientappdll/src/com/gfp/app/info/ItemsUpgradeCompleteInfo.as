package com.gfp.app.info
{
   import com.gfp.core.info.itemsUpgrade.ItemsLineInfo;
   import flash.utils.IDataInput;
   
   public class ItemsUpgradeCompleteInfo
   {
      
      public var succFlg:Boolean;
      
      public var delCnt:uint;
      
      public var addCnt:uint;
      
      public var delItemsVec:Vector.<ItemsLineInfo>;
      
      public var addItemsVec:Vector.<ItemsLineInfo>;
      
      public function ItemsUpgradeCompleteInfo(param1:IDataInput)
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:ItemsLineInfo = null;
         super();
         if(param1)
         {
            this.succFlg = Boolean(param1.readUnsignedInt());
            this.delCnt = param1.readUnsignedInt();
            this.addCnt = param1.readUnsignedInt();
            this.delItemsVec = new Vector.<ItemsLineInfo>();
            this.addItemsVec = new Vector.<ItemsLineInfo>();
            _loc2_ = 0;
            while(_loc2_ < this.delCnt)
            {
               _loc6_ = new ItemsLineInfo();
               _loc6_.type = param1.readUnsignedInt();
               _loc6_.id = param1.readUnsignedInt().toString();
               _loc6_.count = param1.readUnsignedInt();
               this.delItemsVec.push(_loc6_);
               _loc2_++;
            }
            _loc2_ = 0;
            while(_loc2_ < this.addCnt)
            {
               _loc6_ = new ItemsLineInfo();
               _loc6_.type = param1.readUnsignedInt();
               _loc6_.id = param1.readUnsignedInt().toString();
               _loc6_.count = param1.readUnsignedInt();
               this.addItemsVec.push(_loc6_);
               _loc2_++;
            }
         }
      }
   }
}

