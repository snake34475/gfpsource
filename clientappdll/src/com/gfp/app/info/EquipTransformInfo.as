package com.gfp.app.info
{
   public class EquipTransformInfo
   {
      
      public var id:uint;
      
      public var part:uint;
      
      public var roleType:uint;
      
      public var equipLvRegion:Array = [];
      
      public var costItemID:uint;
      
      public var costItemCount:uint;
      
      public var outList:XMLList;
      
      public function EquipTransformInfo(param1:XML = null)
      {
         super();
         if(param1)
         {
            this.id = uint(param1.@ID);
            this.part = uint(param1.@EquipPart);
            this.roleType = uint(param1.@RoleType);
            this.equipLvRegion = String(param1.@ItemLv).split(" ");
            this.costItemID = String(param1.@Costs).split(" ")[0];
            this.costItemCount = String(param1.@Costs).split(" ")[1];
            this.outList = param1.elements("OutItem");
         }
      }
   }
}

