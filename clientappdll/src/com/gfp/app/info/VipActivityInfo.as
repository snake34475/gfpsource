package com.gfp.app.info
{
   public class VipActivityInfo
   {
      
      public static const FUNC_NONE:uint = 0;
      
      public static const FUNC_TURNPANEL:uint = 1;
      
      public var name:String;
      
      public var timeStr:String;
      
      public var desc:String;
      
      public var icon:uint;
      
      public var func:uint;
      
      public var params:String;
      
      public function VipActivityInfo(param1:XML)
      {
         super();
         this.name = param1.@name;
         this.timeStr = param1.elements("time")[0].toString();
         this.desc = param1.elements("desc")[0].toString();
         this.icon = uint(param1.@icon);
         var _loc2_:String = String(param1.@func);
         this.func = this.getType(String(param1.@func));
         this.params = String(param1.@params);
      }
      
      private function getType(param1:String) : uint
      {
         if(param1 == "turnPanel")
         {
            return FUNC_TURNPANEL;
         }
         return FUNC_NONE;
      }
   }
}

