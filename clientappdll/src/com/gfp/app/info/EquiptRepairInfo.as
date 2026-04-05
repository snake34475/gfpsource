package com.gfp.app.info
{
   import com.gfp.core.info.item.SingleEquipInfo;
   import flash.utils.IDataInput;
   
   public class EquiptRepairInfo
   {
      
      public var coins:int;
      
      public var count:int;
      
      public var repairArr:Array;
      
      public function EquiptRepairInfo(param1:IDataInput)
      {
         var _loc2_:SingleEquipInfo = null;
         var _loc3_:int = 0;
         super();
         if(param1)
         {
            this.repairArr = new Array();
            this.coins = param1.readUnsignedInt();
            this.count = param1.readUnsignedInt();
            this.count += param1.readUnsignedInt();
            _loc3_ = 0;
            while(_loc3_ < this.count)
            {
               _loc2_ = new SingleEquipInfo();
               _loc2_.itemID = param1.readUnsignedInt();
               _loc2_.leftTime = param1.readUnsignedInt();
               _loc2_.duration = param1.readUnsignedInt();
               this.repairArr.push(_loc2_);
               _loc3_++;
            }
         }
      }
   }
}

