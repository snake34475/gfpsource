package com.gfp.app.info
{
   public class ActivityMultiNodeInfo extends ActivityNodeInfo
   {
      
      public const children:Vector.<ActivityNodeInfo> = new Vector.<ActivityNodeInfo>();
      
      private var _childNum:int = 0;
      
      public function ActivityMultiNodeInfo(param1:XML)
      {
         super(param1);
      }
      
      override protected function configXml(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:ActivityNodeInfo = null;
         super.configXml(param1);
         if(param1.childNode.length() > 0)
         {
            for each(_loc2_ in param1.childNode)
            {
               _loc3_ = new ActivityNodeInfo(_loc2_);
               _loc3_.parentNode = this;
               this.children.push(_loc3_);
               ++this._childNum;
            }
            this.children.sort(this.sortHandle);
         }
      }
      
      private function sortHandle(param1:ActivityNodeInfo, param2:ActivityNodeInfo) : int
      {
         return param1.priority > param2.priority ? 1 : -1;
      }
      
      public function get childNum() : int
      {
         return this._childNum;
      }
   }
}

