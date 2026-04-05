package com.gfp.app.info.dialog
{
   public class DialogOptionsInfo
   {
      
      public var options:Array;
      
      public var optionId:uint;
      
      public var npcDialogs:Array;
      
      public function DialogOptionsInfo(param1:XML)
      {
         var _loc2_:XML = null;
         var _loc4_:XMLList = null;
         super();
         var _loc3_:XMLList = param1.elements("node");
         this.options = [];
         for each(_loc2_ in _loc3_)
         {
            this.options[uint(_loc2_.@id)] = _loc2_.toString();
         }
         this.npcDialogs = [];
         _loc4_ = param1.elements("desc");
         for each(_loc2_ in _loc4_)
         {
            this.npcDialogs.push(_loc2_.toString());
         }
      }
   }
}

