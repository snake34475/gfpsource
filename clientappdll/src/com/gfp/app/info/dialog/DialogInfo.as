package com.gfp.app.info.dialog
{
   public class DialogInfo
   {
      
      public var selectDesc:String;
      
      public var npcDialogs:Array;
      
      public function DialogInfo(param1:XML)
      {
         var _loc2_:XML = null;
         var _loc3_:XMLList = null;
         var _loc4_:XML = null;
         super();
         if(param1 != null)
         {
            _loc2_ = param1.elements("pnode")[0];
            if(_loc2_ != null)
            {
               this.selectDesc = _loc2_.toString();
            }
            _loc3_ = param1.elements("node");
            this.npcDialogs = new Array();
            for each(_loc4_ in _loc3_)
            {
               this.npcDialogs.push(_loc4_.toString());
            }
         }
      }
   }
}

