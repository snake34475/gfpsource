package com.gfp.app.npcDialog
{
   public class NpcAppMoudleParamsConvert
   {
      
      public function NpcAppMoudleParamsConvert()
      {
         super();
      }
      
      public static function convert(param1:String, param2:XMLList) : *
      {
         switch(param1)
         {
            case "ItemQuickBuyPanel":
               return parseXmlToObject(param2);
            default:
               return param2;
         }
      }
      
      private static function parseXmlToObject(param1:XMLList) : Object
      {
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         if(param1 == null)
         {
            return {};
         }
         var _loc2_:String = param1[0].toString();
         var _loc3_:Array = _loc2_.split(",");
         var _loc4_:Object = {};
         if(_loc3_.length > 0)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc6_ = String(_loc3_[_loc5_]).split("|");
               if(_loc6_.length > 0)
               {
                  _loc4_[_loc6_[0]] = _loc6_[1];
               }
               _loc5_++;
            }
         }
         return _loc4_;
      }
   }
}

