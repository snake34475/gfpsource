package com.gfp.app.info.dialog
{
   public class DialogTaskInfo
   {
      
      public static const TYPE_ACCEPT:uint = 1;
      
      public static const TYPE_PROCESS:uint = 2;
      
      public static const TYPE_OVER:uint = 3;
      
      public var taskType:uint;
      
      public var taskID:uint;
      
      public var proID:uint;
      
      public var taskDesc:String;
      
      public var nodeArray:Array;
      
      public function DialogTaskInfo(param1:XML, param2:uint)
      {
         var _loc3_:XML = null;
         super();
         this.taskID = uint(param1.@id);
         this.proID = uint(param1.@pro);
         this.taskType = param2;
         this.nodeArray = new Array();
         var _loc4_:XMLList = param1.elements("node");
         for each(_loc3_ in _loc4_)
         {
            this.nodeArray[uint(_loc3_.@id)] = new DialogInfo(_loc3_);
         }
      }
   }
}

